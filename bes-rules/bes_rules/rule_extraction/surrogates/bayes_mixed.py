import json
import logging
from pathlib import Path
from typing import Dict, List

import numpy as np
import pandas as pd
from bes_rules.objectives import Annuity, SCOP
from bes_rules.objectives.annuity import TechnikkatalogAssumptions

from bes_rules.plotting.utils import PlotConfig
from bes_rules.rule_extraction.surrogates import BayesSurrogate, Surrogate, LinearInterpolationSurrogate
from bes_rules.rule_extraction.surrogates.plotting import plot_surrogate_quality

logger = logging.getLogger(__name__)


class AnnuityMixedBayesSurrogate(Surrogate):
    """
    Surrogate which uses Bayes for variables which change with
    the optimization and classic linear surrogates for all other variables,
    e.g. heat demand or PV generation.
    Is based on Annuity calculation.
    """

    def __init__(self, df: pd.DataFrame, **kwargs):
        self.annuity_objective: Annuity = kwargs.get(
            "annuity_objective", TechnikkatalogAssumptions.load_with_average_typical_values()
        )
        df = self.annuity_objective.calc(df)
        super().__init__(df=df, **kwargs)
        self._bayes = BayesSurrogate(df=df, **kwargs)
        self._linear = LinearInterpolationSurrogate(df=df)
        self.scop_objective: SCOP = kwargs.get("scop_objective", SCOP())

    def predict(
            self,
            design_variables: Dict[str, np.ndarray],
            metrics: List[str],
            save_path_plot: Path = None,
            plot_config: PlotConfig = None,
            plot_kwargs: dict = None
    ) -> pd.DataFrame:
        bayes_variables = [
            "SCOP_Sys",
            self.annuity_objective.mapping.number_heat_pump_switches
        ]

        linear_variables = [
            self.annuity_objective.mapping.electric_energy_demand,
            self.annuity_objective.mapping.electric_energy_feed_in,
            self.annuity_objective.mapping.heat_pump_size,
            "costs_total",  # To compare the results later on
            self.scop_objective.mapping.building_heat_supplied,
            self.scop_objective.mapping.dhw_heat_supplied,
            self.scop_objective.mapping.heat_pump_electricity_demand,
            self.scop_objective.mapping.heating_rod_electricity_demand,
        ]
        optional_linear_variables = [
            self.annuity_objective.mapping.heating_rod_size,
            self.annuity_objective.mapping.buffer_storage_size,
            self.annuity_objective.mapping.dhw_storage_size,
            self.annuity_objective.mapping.power_pv_nominal,
            self.annuity_objective.mapping.gas_demand,
            self.annuity_objective.mapping.gas_boiler_size,
        ]
        for var in optional_linear_variables:
            if var in self.df.columns:
                linear_variables.append(var)
        if "costs_total" not in metrics:
            logger.warning("You use AnnuityMixedBayesSurrogate but don't predict the total costs. Is this wanted?")

        df_bayes_predictions = self._bayes.predict(
            design_variables=design_variables,
            metrics=bayes_variables,
            save_path_plot=None, plot_config=None
        )
        df_predictions = self._linear.predict(
            design_variables=design_variables,
            metrics=linear_variables,
            save_path_plot=None, plot_config=None
        )

        df_predictions.loc[:, "other_demands"] = (
            df_predictions.loc[:, self.annuity_objective.mapping.electric_energy_demand].values -
            df_predictions.loc[:, self.scop_objective.mapping.heat_pump_electricity_demand].values -
            df_predictions.loc[:, self.scop_objective.mapping.heating_rod_electricity_demand].values
        )
        df_predictions.loc[:, self.annuity_objective.mapping.electric_energy_demand] = (
            df_predictions.loc[:, "other_demands"] +
            (
                    df_predictions.loc[:, self.scop_objective.mapping.building_heat_supplied].values +
                    df_predictions.loc[:, self.scop_objective.mapping.dhw_heat_supplied].values
            ) / df_bayes_predictions.loc[:, "SCOP_Sys"].values
        )
        # Add other columns
        for col in bayes_variables:
            df_predictions.loc[:, col] = df_bayes_predictions.loc[:, col].values

        df_predictions_bayes_costs = self.annuity_objective.calc(df=df_predictions.copy())

        df_interpolated_linear_costs = df_predictions.loc[:, metrics]
        df_interpolated_bayes_costs = df_predictions_bayes_costs.loc[:, metrics]

        if save_path_plot is not None:
            # plot_surrogate_quality(
            #     df_simulation=self.df,
            #     df_interpolated=df_interpolated_linear_costs,
            #     save_path=save_path_plot.with_stem(save_path_plot.stem + "_linear"),
            #     plot_config=plot_config,
            #     plot_surface=True
            # )
            plot_surrogate_quality(
                df_simulation=self.df,
                df_interpolated=df_interpolated_bayes_costs,
                save_path=save_path_plot.with_stem(save_path_plot.stem + "_bayes"),
                plot_config=plot_config,
                plot_surface=True
            )
        return df_interpolated_bayes_costs


if __name__ == '__main__':
    from bes_rules import RESULTS_FOLDER
    from bes_rules.rule_extraction.innovization import mesh_arrays

    with open(RESULTS_FOLDER.joinpath(
            "BayesHyperparametersCornerPoints",
            "TRY2015_474856110632_Jahr_B1950_standard_o1w2r0g2_SingleDwelling_NoDHW_0K-Per-IntGai.xlsx",
            "best_hyperparameters.json"), "r"
    ) as file:
        PARAS = json.load(file)
    PATH = RESULTS_FOLDER.joinpath("BayesHyperparametersMixed")
    df_path = PATH.joinpath("TRY2015_474856110632_Jahr_B1950_standard_o1w2r0g2_SingleDwelling_NoDHW_0K-Per-IntGai.xlsx")
    df_path = PATH.joinpath("TRY2015_474856110632_Jahr_B1950_standard_o1w2r0g2_SingleDwelling_NoDHW_0K-Per-IntGai_reduced.xlsx")

    SURROGATE = AnnuityMixedBayesSurrogate(
        df=pd.read_excel(df_path, index_col=0),
        metric_hyperparameters=PARAS
    )
    design_variables = {
        "parameterStudy.TBiv": np.linspace(-15, 4, 100) + 273.15,
        "parameterStudy.VPerQFlow": np.linspace(5, 5, 1),
        # "parameterStudy.ShareOfPEleNominal": np.ones(100)
    }
    design_values = mesh_arrays(list(design_variables.values()))
    flat_design_variables = {var: design_values[:, idx] for idx, var in enumerate(design_variables)}

    print(SURROGATE.predict(
        metrics=[
            "costs_total",
            "SCOP_Sys"
        ],
        design_variables=flat_design_variables,
        save_path_plot=PATH.joinpath("quality.png")
    ))
