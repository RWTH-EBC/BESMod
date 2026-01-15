import logging
import numpy as np
import pandas as pd
from typing import TYPE_CHECKING

from bes_rules import DATA_PATH
from ebcpy import preprocessing, TimeSeriesData

from bes_rules.plotting import utils

if TYPE_CHECKING:
    from bes_rules.configs import StudyConfig

logger = logging.getLogger(__name__)

PRICES_PATH = DATA_PATH.joinpath("prices")


def load_dynamic_electricity_prices(
        year: int,
        init_period: float,
        time_step: int = 3600,
        only_wholesale_price: bool = False
):
    if year in [2019, 2023, 2024]:
        start_name = "energy-charts_Stromproduktion_und_Börsenstrompreise_in_Deutschland_"
        df = pd.read_csv(
            PRICES_PATH.joinpath(f"{start_name}{year}.csv"),
            skiprows=[0, 1],
            index_col=0
        )
        df.index = pd.to_datetime(df.index, utc=True).tz_convert(None) + pd.Timedelta(hours=1)

        wholesale_market_price = preprocessing.convert_datetime_index_to_float_index(
            df
        ).loc[:, "Preis (EUR/MWh, EUR/tCO2)"]
    elif year in [2025, 2030, 2037]:
        df = pd.read_excel(
            PRICES_PATH.joinpath("prices_wholesale_fcn.xlsx"),
            sheet_name="All",
            index_col=0,
            skiprows=[2],
            header=[0, 1])
        df.index *= 3600
        wholesale_market_price = df.loc[:, (year, "Wholesale Market Price [€/MWh]")]
    else:
        raise ValueError(f"Year {year} not supported")
    # Quelle: https://www.bdew.de/service/daten-und-grafiken/bdew-strompreisanalyse/
    stromsteuer = 20.05  # €/MWh
    konsessionsabgabe = 16.6  # €/MWh
    netzentgelte = 90.52  # €/MWh
    mehrwertsteuer = 1.19  # 19 %
    sonstige_umlagen = 13.7  # €/MWh
    if year > 2025:
        # https://www.bmwk.de/Redaktion/DE/Publikationen/Studien/netzentgelte-auswertung-von-referenzstudien.pdf?__blob=publicationFile&v=6
        anstieg_netzengelte = 39  # €/MWh
    else:
        anstieg_netzengelte = 0
    if not only_wholesale_price:
        wholesale_market_price += (
                stromsteuer +
                konsessionsabgabe +
                netzentgelte +
                sonstige_umlagen + anstieg_netzengelte
        )
        wholesale_market_price[wholesale_market_price < 0] = 0
        wholesale_market_price *= mehrwertsteuer
    wholesale_market_price /= 1000
    logger.info(f"Mean wholesale_market_price={wholesale_market_price.mean() * 100} ct/kWh")
    # add last hour:
    if len(wholesale_market_price) == 8760:
        # Fill last row so the last our is resampled as well
        wholesale_market_price.loc[8760 * 3600] = wholesale_market_price.loc[8759 * 3600]
    else:
        raise IndexError("This function expects data with 8759 rows, as typical in German price export")
    x = np.arange(0.0, wholesale_market_price.index[-1] + 0.1, time_step)
    values = np.interp(x, wholesale_market_price.index, wholesale_market_price.values)
    x_with_init = np.arange(0.0, wholesale_market_price.index[-1] + init_period + 0.1, time_step)
    values_with_init = np.append(values, values[:len(x_with_init) - len(x)])
    return pd.Series(
        values_with_init,
        index=x_with_init
    )


def calculate_operating_costs_with_dynamic_prices(study_config: "StudyConfig"):
    time_step = study_config.simulation.sim_setup["output_interval"]
    with_user = True
    file_ending = "hdf" if study_config.simulation.convert_to_hdf_and_delete_mat else "mat"
    dfs, input_configs = utils.get_all_results_from_config(study_config=study_config, with_user=with_user)
    for df, input_config in zip(dfs, input_configs):
        case_name = input_config.get_name(with_user=with_user)
        case_path = study_config.study_path.joinpath("DesignOptimizationResults", case_name)
        if input_config.prices.year is None:
            df.to_excel(case_path.joinpath("DesignOptimizationResultsWithDynamicCosts.xlsx"))
            continue
        c_grid = load_dynamic_electricity_prices(
            year=input_config.prices.year,
            init_period=study_config.simulation.init_period,
            time_step=time_step,
            only_wholesale_price=input_config.prices.only_wholesale_price
        )
        c_grid = c_grid.loc[study_config.simulation.init_period:]
        c_grid.index -= c_grid.index[0]

        dynamic_costs = []
        for idx, row in df.iterrows():
            try:
                tsd = pd.read_excel(case_path.joinpath(f"Design_{idx}.xlsx"), index_col=0)
                tsd = tsd.loc[study_config.simulation.init_period:]
                tsd.index -= tsd.index[0]
            except FileNotFoundError:
                tsd = TimeSeriesData(case_path.joinpath(f"iterate_{idx}.{file_ending}")).to_df()
            # In kW * €/kWh = €/3600s = €/s. Each value is time_step seconds, thus, multiply with time_step
            # dropna due to new agentlib format
            tsd = tsd.loc[~tsd.isna().any(axis=1)]
            c_grid_trimmed = c_grid.loc[:tsd.index[-1]]
            if len(c_grid_trimmed.index) != len(tsd.index):
                raise IndexError("Index does not match")
            tsd.loc[:, "dynamic_costs_operation"] = (
                    tsd.loc[:, "outputs.electrical.dis.PEleLoa.value"] / 1000 * c_grid_trimmed / 3600 * time_step
            )
            dynamic_costs.append(tsd.loc[:, "dynamic_costs_operation"].cumsum().iloc[-1])
        df.loc[:, f"dynamic_costs_operation_{input_config.prices.year}"] = dynamic_costs
        df.to_excel(case_path.joinpath("DesignOptimizationResultsWithDynamicCosts.xlsx"))
