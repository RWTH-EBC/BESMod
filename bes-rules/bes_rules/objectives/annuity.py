import json
from typing import TYPE_CHECKING, Union

import pandas as pd
from sklearn.linear_model import LinearRegression
import numpy as np

from bes_rules.objectives.objective import BaseObjective, BaseObjectiveMapping
from bes_rules.objectives.stochastic_parameter import StochasticParameter
from bes_rules import DATA_PATH

if TYPE_CHECKING:
    from bes_rules.configs.inputs import InputConfig


PARAMETER_TYPE = Union[StochasticParameter, float, int]


class AnnuityMapping(BaseObjectiveMapping):
    electric_energy_demand: str = "outputs.electrical.dis.PEleLoa.integral"
    electric_energy_feed_in: str = "outputs.electrical.dis.PEleGen.integral"
    heat_pump_size: str = "QHeaPum_flow_A2W35"
    heating_rod_size: str = "hydraulic.generation.eleHea.Q_flow_nominal"
    buffer_storage_size: str = "hydraulic.distribution.parStoBuf.V"
    dhw_storage_size: str = "hydraulic.distribution.parStoDHW.V"
    power_pv_nominal: str = "PElePVMPP"
    gas_demand: str = "outputs.hydraulic.dis.PBoi.integral"
    gas_boiler_size: str = "hydraulic.distribution.boi.Q_nom"
    number_heat_pump_switches: str = "outputs.hydraulic.gen.heaPum.numSwi"


class Annuity(BaseObjective):
    """
    Class to hold parameter and function to calculate the economic annuity
    of an investment into a heat pump system.

    Keyword-Arguments:
    -------------------------
    Note: All kwargs are constant parameters. As they are mainly assumptions,
    i introduced a class StochasticParameter. One can pass a mean, std and distribution
    to the class. As it inherits float, the values may be used in calculations as normal floats.
    This could be used in the future for two use-cases:
    - Stochastic Optimization
    - Sensitivity along the pareto-front for uncertainty in parameters.

    :keyword StochasticParameter i_pv_a:
        Investment costs of a PV system in relation to the maximum power output in [€/kWp]
        Default value: 2687.7
        Source: MA Benjamin
    :keyword StochasticParameter i_pv_exp:
        Exponent for Investment calculation
        Default value: 0.7551
        Source: MA Benjamin
    :keyword StochasticParameter k_op_pv:
        Maintenance costs of the PV system as a percentage of the investment costs
        Default value: 0.005
        Source: MA Benjamin

    """

    mapping: AnnuityMapping = AnnuityMapping()

    # general
    n_years: PARAMETER_TYPE = 18
    int_rate: PARAMETER_TYPE = 0.07
    # electricity prices
    k_el: PARAMETER_TYPE = 0.3606
    k_el_feed_in: PARAMETER_TYPE = 0.082
    # https://www.destatis.de/DE/Presse/Pressemitteilungen/2024/09/PD24_375_61243.html
    k_gas: PARAMETER_TYPE = 0.1187
    # Heat Pump
    i_hp_0: PARAMETER_TYPE = 6815.675
    i_hp_a: PARAMETER_TYPE = 28.304
    i_hp_exp: PARAMETER_TYPE = 0.557
    k_op_hp: PARAMETER_TYPE = 0.025
    # Auxilliar electric heater
    i_aeh_0: PARAMETER_TYPE = -0.037
    i_aeh_a: PARAMETER_TYPE = 5.73
    i_aeh_exp: PARAMETER_TYPE = 0.494
    k_op_aeh: PARAMETER_TYPE = 0.01
    # Thermal Energy Storage
    i_the_0: PARAMETER_TYPE = 346.064
    i_the_a: PARAMETER_TYPE = 5.332 * 10 ** (3 * 0.767)
    i_the_exp: PARAMETER_TYPE = 0.767
    k_op_the: PARAMETER_TYPE = 0.02
    # DHW Storage
    i_dhw_0: PARAMETER_TYPE = 7.19
    i_dhw_a: PARAMETER_TYPE = 16.652 * 10 ** (3 * 0.81)
    i_dhw_exp: PARAMETER_TYPE = 0.81
    k_op_dhw: PARAMETER_TYPE = 0.02
    # PV
    i_pv_a: PARAMETER_TYPE = 2687.7
    i_pv_exp: PARAMETER_TYPE = 0.7551
    k_op_pv: PARAMETER_TYPE = 0.005
    # Gas boiler Storage - source: https://www.kww-halle.de/praxis-kommunale-waermewende/bundesgesetz-zur-waermeplanung version 1.1
    i_boiler_0: PARAMETER_TYPE = 0
    i_boiler_a: PARAMETER_TYPE = 4347 * 0.001 ** (1 - 0.818)
    i_boiler_exp: PARAMETER_TYPE = 1 - 0.818
    k_op_boiler: PARAMETER_TYPE = 0.02

    max_switches_hp: PARAMETER_TYPE = 170000  # From highly compressor
    n_years_hp: PARAMETER_TYPE = 18  # VDI 2067 table A4
    n_years_aeh: PARAMETER_TYPE = 18  # VDI 2067 table A4 specifies 20, but it is typically in the heat pump
    n_years_the: PARAMETER_TYPE = 30  # VDI 4645
    n_years_dhw: PARAMETER_TYPE = 20  # VDI 2067 table A4. VDI 4645 specifies 18 years
    n_years_pv: PARAMETER_TYPE = 30  # ISBN 978-92-95111-98-1 "End-of-Life Management of Photovoltaic Panels"
    n_years_boiler: PARAMETER_TYPE = 18  # VDI 2067 table A4

    # Hybrid heat pump: 15.800	26.200	45.400

    def calc(self, df: pd.DataFrame, input_config: "InputConfig" = None):
        """Calculates cost for given simulation results"""
        if self.mapping.number_heat_pump_switches in df.columns:
            switches = self.get_values(
                df=df, name=self.mapping.number_heat_pump_switches
            )
            df.loc[:, "compressor_lifespan"] = self.max_switches_hp / switches

        # Parameters
        # Annuity factor in [1/a] ; (Source: [VDI 2067-1])
        ann = 1 / get_RBF(int_rate=self.int_rate, n_years=self.n_years)

        # Calculate costs
        # Investment costs
        # Total investment costs of heat pump in [€]
        hp_sizes = self.get_values(
            df=df, name=self.mapping.heat_pump_size
        )
        invest_hp = self.i_hp_0 + self.i_hp_a * hp_sizes ** self.i_hp_exp
        invest_hp[hp_sizes == 0] = 0

        # Total investment costs of auxilliar electric heater  in [€]
        invest_aeh = self.i_aeh_0 + self.i_aeh_a * self.get_values(
            df=df, name=self.mapping.heating_rod_size, default=0
        ) ** self.i_aeh_exp
        invest_aeh[invest_aeh < 0] = 0
        # Total investment costs of space heating storage in [€]
        the_sizes = self.get_values(
            df=df, name=self.mapping.buffer_storage_size, default=0
        )
        invest_the = self.i_the_0 + self.i_the_a * the_sizes ** self.i_the_exp
        invest_the[the_sizes == 0] = 0
        # Total investment costs of DHW storage in [€]
        dhw_sizes = self.get_values(
            df=df, name=self.mapping.dhw_storage_size, default=0
        )
        invest_dhw = self.i_dhw_0 + self.i_dhw_a * dhw_sizes ** self.i_dhw_exp
        invest_dhw[dhw_sizes == 0] = 0
        # Total investment costs of PV System in [€]
        invest_pv = self.i_pv_a * (self.get_values(
            df=df, name=self.mapping.power_pv_nominal, default=0
        ) / 1000) ** self.i_pv_exp
        # Total investment costs of gas boiler in [€]
        invest_boiler = self.i_boiler_0 + self.i_boiler_a * self.get_values(
            df=df, name=self.mapping.gas_boiler_size, default=0
        ) ** self.i_boiler_exp
        # Total investment costs [€]
        eol_kwargs = dict(n_years=self.n_years, int_rate=self.int_rate)
        if any([
            self.n_years_hp < self.n_years,
            self.n_years_aeh < self.n_years,
            self.n_years_the < self.n_years,
            self.n_years_dhw < self.n_years,
            self.n_years_pv < self.n_years,
            self.n_years_boiler < self.n_years,
        ]):
            raise ValueError("Re-invest is not implemented")
        invest_inv_tot = (
                invest_hp * (1 - get_residual_value(n_years_component=self.n_years_hp, **eol_kwargs)) +
                invest_aeh * (1 - get_residual_value(n_years_component=self.n_years_aeh, **eol_kwargs)) +
                invest_the * (1 - get_residual_value(n_years_component=self.n_years_the, **eol_kwargs)) +
                invest_dhw * (1 - get_residual_value(n_years_component=self.n_years_dhw, **eol_kwargs)) +
                invest_pv * (1 - get_residual_value(n_years_component=self.n_years_pv, **eol_kwargs)) +
                invest_boiler * (1 - get_residual_value(n_years_component=self.n_years_boiler, **eol_kwargs))
        )
        # Total investment costs annualized in [€/a]
        cost_inv_tot = ann * invest_inv_tot

        # Operating costs
        # Total electric operating costs in [€/a]
        cost_op_el = (
                self.get_values(df=df, name=self.mapping.electric_energy_demand) * self.k_el /
                1000 / 3600
        )
        cost_op_gas = (
                self.get_values(df=df, name=self.mapping.gas_demand, default=0) * self.k_gas /
                1000 / 3600
        )
        earnings_op_el = (
                self.get_values(df=df, name=self.mapping.electric_energy_feed_in) * self.k_el_feed_in /
                1000 / 3600
        )
        # Total maintenance operating costs in [€/a]
        cost_op_main = (
                invest_hp * self.k_op_hp +
                invest_aeh * self.k_op_aeh +
                invest_the * self.k_op_the +
                invest_dhw * self.k_op_dhw +
                invest_pv * self.k_op_pv +
                invest_boiler * self.k_op_boiler
        )
        # Total operating costs in [€/a]
        cost_op_tot = cost_op_el + cost_op_gas + cost_op_main - earnings_op_el

        # Total annual costs
        # Gives amount only since no revenue is used
        cost_tot_ann = cost_op_tot + cost_inv_tot

        cost_result_name = "costs"
        df.loc[:, cost_result_name + "_total"] = cost_tot_ann
        df.loc[:, cost_result_name + "_operating"] = cost_op_tot
        df.loc[:, cost_result_name + "_invest"] = cost_inv_tot
        df.loc[:, "invest_total"] = invest_inv_tot
        df.loc[:, "invest_tes"] = invest_the * (ann + self.k_op_the)

        return df

    def get_objective_names(self):
        return ["costs_total", "costs_operating", "costs_invest"]

    @classmethod
    def load_with_average_typical_values(cls):
        all_typical_values = cls.load_typical_values()
        average_item = list(all_typical_values.keys())[int(len(all_typical_values) / 2)]
        return all_typical_values[average_item]

    @classmethod
    def load_typical_values(cls):
        with open(DATA_PATH.joinpath("prices", "f_inv_biv.json"), "r") as file:
            f_inv_bivs = json.load(file)
            return {k: cls(**v) for k, v in f_inv_bivs.items()}


class AnnuityVeringEtAl(Annuity):
    """

    :keyword StochasticParameter int_rate:
        Interest rate for annuity factor; (Source: [VDI 2067-1] - in example calculation)
        Default from source: 0.07
    :keyword StochasticParameter k_el:
        Constant electic costs in [€/kWh]
        Default: 0.3606
        (0.2986 MA_cve_hkr2019),
        (0.3048 aus Monitoringbricht_Energie der Bundesnetzagentur2018 -S.310)
        (0.3606 aus Monitoringbericht 2022 der Bundesnetzagentur -S.14)
    :keyword StochasticParameter k_el_feed_in:
        Constant electric revenue from feed-in in for systems up to a size of 10 kWp [€/kWh]
        Default: 0.082
        (Source: MA Benjamin, Vebraucherzentrale)
    :keyword StochasticParameter n_years:
        Number of years used for calculation
        Default value: 0.23
        Source: -
    :keyword StochasticParameter k_op_hp:
        Heat pump in percent of investment costs
        Default value: 0.025
        Source: [VDI 2067-1])
    :keyword StochasticParameter k_op_aeh:
        Auxilliar electric heater  in percent of investment costs
        Default value: 0.01
        Source: [VDI 2067-1]
    :keyword StochasticParameter k_op_the:
        Thermal energy storge (buffer storage) in percent of investment costs
        Default value: 0.02
        Source: [VDI 2067-1]
    :keyword StochasticParameter k_op_dhw:
        Domestic hot water storage (DHW) in percent of investment costs
        Default value: 0.02
        Source: [VDI 2067-1]
    :keyword StochasticParameter i_hp_0:
        Regression analysis parameter - heat pump - constant
        Default value: 6815.675
        Source: [MA_Lma 2018]
    :keyword StochasticParameter i_hp_a:
        Regression analysis parameter - heat pump - factor
        Default value: 28.304
        Source: [MA_Lma 2018]
    :keyword StochasticParameter i_hp_exp:
        Regression analysis parameter - heat pump - exponent
        Default value: 0.557
        Source: [MA_Lma 2018]
    :keyword StochasticParameter i_aeh_0:
        Regression analysis parameter - Auxilliar electric heater  - constant
        Default value: -0.037
        Source: [MA_Lma 2018]
    :keyword StochasticParameter i_aeh_a:
        Regression analysis parameter - Auxilliar electric heater  - factor
        Default value: 5.73
        Source: [MA_Lma 2018]
    :keyword StochasticParameter i_aeh_exp:
        Regression analysis parameter - Auxilliar electric heater  - exponent
        Default value: 0.494
        Source: [MA_Lma 2018]
    :keyword StochasticParameter i_the_0:
        Regression analysis parameter - thermal storage - constant
        Default value: 346.064
        Source: [MA_Lma 2018]
    :keyword StochasticParameter i_the_a:
        Regression analysis parameter - thermal storage - factor
        Default value: 5.332 * 10 ** (3 * 0.767)
        Source: [MA_Lma 2018]
    :keyword StochasticParameter i_the_exp:
        Regression analysis parameter - thermal storage - exponent
        Default value: 0.767
        Source: [MA_Lma 2018]
    :keyword StochasticParameter i_dhw_0:
        Regression analysis parameter - DHW storage - constant
        Default value: 7.19
        Source: [MA_Lma 2018]
    :keyword StochasticParameter i_dhw_a:
        Regression analysis parameter - DHW storage - factor
        Default value: 16.652 * 10 ** (3 * 0.81)
        Source: [MA_Lma 2018]
    :keyword StochasticParameter i_dhw_exp:
        Regression analysis parameter - DHW storage - exponent
        Default value: 0.81
        Source: [MA_Lma 2018]
    """
    # Heat Pump
    i_hp_0: PARAMETER_TYPE = 6815.675
    i_hp_a: PARAMETER_TYPE = 28.304
    i_hp_exp: PARAMETER_TYPE = 0.557
    k_op_hp: PARAMETER_TYPE = 0.025
    # Auxilliar electric heater
    i_aeh_0: PARAMETER_TYPE = -0.037
    i_aeh_a: PARAMETER_TYPE = 5.73
    i_aeh_exp: PARAMETER_TYPE = 0.494
    k_op_aeh: PARAMETER_TYPE = 0.01
    # Thermal Energy Storage
    i_the_0: PARAMETER_TYPE = 346.064
    i_the_a: PARAMETER_TYPE = 5.332 * 10 ** (3 * 0.767)
    i_the_exp: PARAMETER_TYPE = 0.767
    k_op_the: PARAMETER_TYPE = 0.02
    # DHW Storage
    i_dhw_0: PARAMETER_TYPE = 7.19
    i_dhw_a: PARAMETER_TYPE = 16.652 * 10 ** (3 * 0.81)
    i_dhw_exp: PARAMETER_TYPE = 0.81
    k_op_dhw: PARAMETER_TYPE = 0.02


class TechnikkatalogAssumptions(Annuity):
    """
    Source:  - source: https://www.kww-halle.de/praxis-kommunale-waermewende/bundesgesetz-zur-waermeplanung version 1.1
    Own regressions based on data for single-family houses and only component costs.
    AH is unchanged as no costs were given.
    """
    # Heat Pump
    i_hp_0: PARAMETER_TYPE = 7109.3
    i_hp_a: PARAMETER_TYPE = 1.2091
    i_hp_exp: PARAMETER_TYPE = 1
    k_op_hp: PARAMETER_TYPE = 0.025
    # Thermal Energy Storage
    i_the_0: PARAMETER_TYPE = 296.48
    i_the_a: PARAMETER_TYPE = 1.4509 * 1000
    i_the_exp: PARAMETER_TYPE = 1
    k_op_the: PARAMETER_TYPE = 0.02
    # DHW Storage
    i_dhw_0: PARAMETER_TYPE = 296.48
    i_dhw_a: PARAMETER_TYPE = 1.4509 * 1000
    i_dhw_exp: PARAMETER_TYPE = 1
    k_op_dhw: PARAMETER_TYPE = 0.02
    # AHE
    i_aeh_0: PARAMETER_TYPE = 256.5707509012719
    i_aeh_a: PARAMETER_TYPE = 0.026753483970960015
    i_aeh_exp: PARAMETER_TYPE = 1


def get_RBF(int_rate: float, n_years: int):
    """
    Inverse of VDI 2067-2012 page 17, equation 4.
    q = 1 + int_rate, int_rate = q - 1
    """
    return (
            ((1 + int_rate) ** n_years - 1) /
            ((1 + int_rate) ** n_years * int_rate)
    )


def get_residual_value(int_rate: float, n_years: int, n_years_component: int):
    """From VDI 2067-2012 page 17, equation 3"""
    return (
            (n_years_component - n_years) /
            n_years_component /
            ((1 + int_rate) ** n_years)
    )


def create_linear_cost_regression(Q_min=2500, Q_max=20000, num_points=100):
    # Generate original cost function
    i_aeh_0 = -0.037
    i_aeh_a = 5.73
    i_aeh_exp = 0.494
    QHeaRod = np.linspace(Q_min, Q_max, num_points)
    invest_aeh = i_aeh_0 + i_aeh_a * QHeaRod ** i_aeh_exp

    # Prepare data for linear regression
    X = QHeaRod.reshape(-1, 1)  # reshape for sklearn
    y = invest_aeh

    # Create and fit linear regression
    reg = LinearRegression()
    reg.fit(X, y)

    # Get regression parameters
    slope = reg.coef_[0]
    intercept = reg.intercept_

    # Calculate R² score
    r2 = reg.score(X, y)
    print(f"i_ahe_0={intercept}")
    print(f"i_ahe_a={slope}")
    print(f"i_ahe_exp=1")
    print(f"{r2=}")
    # Create prediction function

    return {
        'slope': slope,
        'intercept': intercept,
    }
