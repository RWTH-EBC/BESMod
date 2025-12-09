from typing import TYPE_CHECKING

import pandas as pd

from .objective import BaseObjective, BaseObjectiveMapping
from .stochastic_parameter import StochasticParameter

if TYPE_CHECKING:
    from bes_rules.configs.inputs import InputConfig


class TEWIMapping(BaseObjectiveMapping):
    electric_energy_demand: str = "outputs.electrical.dis.PEleLoa.integral"
    heat_pump_size: str = "QHeaPum_flow_A2W35"
    heating_rod_size: str = "hydraulic.generation.eleHea.Q_flow_nominal"
    buffer_storage_size: str = "hydraulic.distribution.parStoBuf.V"
    dhw_storage_size: str = "hydraulic.distribution.parStoDHW.V"
    refrigerant_type: str = None
    electric_energy_produced_by_pv: str = "outputs.electrical.gen.PElePV.integral"
    power_pv_nominal: str = "PElePVMPP"


class TEWI(BaseObjective):
    """
    Calculate total equivalent warming impact (TEWI)

    Keyword-Arguments:
    -------------------------

    :keyword float e_power:
        Emissions of German power mix in 2018 [g/kWh]
        Default value: 474
        Source: 2019_EntwicklungDerSpezifischenKohlendioxidEmissionenDesDeutschenStrommix - Umwelt Bundesamt
    :keyword float ref_leak_ann:
        Annual leakage factor in [-/a]
        Default value: 0.02
        Source: s.[Greening 2012]
    :keyword float ref_leak_ad:
        Accumulated leakage percentage during assembly/production and destruction,
        Default value: 0.23
        Source: s.[Greening 2012]
    :keyword StochasticParameter ref_amount_0:
        Refrigerant regression curve - constant
        Default value: 0
        Source: CHO (Values used from dimplex homepage and reevaluated for Q_dot at 55/-2 for constant quality grade)
    :keyword StochasticParameter ref_amount_a:
        Refrigerant regression curve - factor
        Default value: 0.0059
        Source: CHO (Values used from dimplex homepage and reevaluated for Q_dot at 55/-2 for constant quality grade)
    :keyword StochasticParameter ref_amount_exp:
        Refrigerant regression curve - exponent
        Default value: 0.7851
        Source: CHO (Values used from dimplex homepage and reevaluated for Q_dot at 55/-2 for constant quality grade)
    :keyword StochasticParameter e_ng:
        Specific emissions natural gas
        Default value: 205
        Source: [MA Stefaniak2018]
    :keyword StochasticParameter e_trans:
        Specific emissions transport (Lkw)
        Default value: 104
        Source: [MA Stefaniak2018]
    """
    mapping: TEWIMapping = TEWIMapping()

    n_years: StochasticParameter = StochasticParameter(value=18)
    e_power: StochasticParameter = StochasticParameter(value=474)
    ref_amount_0: StochasticParameter = StochasticParameter(value=0)
    ref_amount_a: StochasticParameter = StochasticParameter(value=0.0059)
    ref_amount_exp: StochasticParameter = StochasticParameter(value=0.7851)
    e_ng: StochasticParameter = StochasticParameter(value=205)
    e_trans: StochasticParameter = StochasticParameter(value=104)
    ref_leak_ann: StochasticParameter = StochasticParameter(value=0.02)
    ref_leak_ad: StochasticParameter = StochasticParameter(value=0.23)
    # Based on oekobaudat and QPlusBFRG41285 module.
    # If you change this, change e_power_produced as well
    # https://oekobaudat.de/OEKOBAU.DAT/datasetdetail/process.xhtml?uuid=236ee906-0090-42ab-90ae-37bc553be0a0&version=20.23.050&stock=OBD_2023_I&lang=de
    e_pv: StochasticParameter = StochasticParameter(
        value=(
                (302.3 + 12.02) * 1000 *  # oekobaudat A-C g/m2 PV
                (1.67 / 285)  # QPlusBFRG41285 m2/Wp
        )  # in g/Wp
    )
    # Alternative to e_pv, based on median in # https://www.nrel.gov/docs/fy13osti/56487.pdf.
    # If you change this, adjust e_pv as well to not specify kg/kWp.
    # e_power_produced: StochasticParameter = StochasticParameter(value=50)
    e_power_produced: StochasticParameter = StochasticParameter(value=0)

    def calc(self, df: pd.DataFrame, input_config: "InputConfig" = None):
        """
        Calculate Emissions

        Parameters
        ----------
        :param pd.DataFrame df:
            DataFrame with results of design optimizer

        Returns
        -------
        :return fitness: (list) Fitness values regarding emissions (kg/a)
        """
        # Emission parameters
        # Dictionary with global warming potential (CO2 equivalent)
        # Source: Linde Homepage:
        # http://www.linde-gas.com/en/legacy/attachment?files=tcm:Ps17-111483,tcm:s17-111483,tcm:17-111483
        # http://www.linde-gas.com/en/products_and_supply/refrigerants/hfc_refrigerants/r152a/index.html
        gwp = {
            "R22": 1810,
            "R32": 675,
            "R123": 77,
            "R134a": 1430,
            "Propane": 3,
            "R410A": 2088,
            "R744": 1,
            "R1234yf": 4,
            "R152a": 124
        }

        # Specific emissions of heat pump [g/W] ; (Source: [Greening2012] for 10kW heat pump)
        e_hp = (504 * 1000 / 3600 * self.e_power + 1400 * 1000 / 3600 * self.e_ng) / 10000

        # Heat pump size of individuals in [W]
        heat_pump_size = self.get_values(df=df, name=self.mapping.heat_pump_size)

        # Refrigerant type
        gwp_each = [gwp[ref] for ref in self.get_values(df=df, name=self.mapping.refrigerant_type, default="Propane")]

        # Evaluate emissions
        # Refrigerant emissions
        # Calculate refrigerant amount [kg]
        ref_amount = self.ref_amount_0 + self.ref_amount_a * heat_pump_size ** self.ref_amount_exp
        # Annual refrigerant leakage emissions [g/a]
        emissions_ref_ann = self.ref_leak_ann * ref_amount * gwp_each * 1000
        # Production / Destruction equivalent emissions of refrigerant [g]
        emissions_ref_ad = self.ref_leak_ad * ref_amount * gwp_each * 1000
        # Emission of PV-produced electricity
        e_power_produced = self.e_power_produced * self.get_values(
            df=df, name=self.mapping.electric_energy_produced_by_pv,
            default=0) / 1000 / 3600

        # Calculation of total emissions of electric demand [g/a]
        emissions_el = self.e_power * self.get_values(df=df, name=self.mapping.electric_energy_demand) / 1000 / 3600
        # Emission during assembly and production of components
        emissions_hp = e_hp * heat_pump_size
        emissions_hr = 0
        emissions_tes = 0
        emissions_dhw = 0
        emissions_pv = self.e_pv * self.get_values(df=df, name=self.mapping.power_pv_nominal, default=0)

        emissions_tot = (emissions_el + emissions_ref_ann + e_power_produced + emissions_pv +
                         (emissions_dhw + emissions_tes + emissions_hr + emissions_hp + emissions_ref_ad) /
                         self.n_years) / 1000

        # Total annual emissions in [kg/a]
        df.loc[:, "emissions"] = emissions_tot

        return df

    def get_objective_names(self):
        return ["emissions"]
