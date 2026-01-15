import logging
import casadi as ca
from typing import List
from pydantic import ConfigDict

from agentlib_mpc.models.casadi_model import (
    CasadiModel,
    CasadiInput,
    CasadiState,
    CasadiParameter,
    CasadiOutput,
    CasadiModelConfig,
)
from bes_rules.simulation_based_optimization.agentlib_mpc import component_models
logger = logging.getLogger(__name__)


N_LAYER = 4


class MPCModelConfig(CasadiModelConfig):
    model_config = ConfigDict(validate_assignment=True, extra="allow")
    bes_parameters: dict
    zone_parameters: dict

    nLayer: int = N_LAYER

    inputs: List[CasadiInput] = [
        # controls
        CasadiInput(name="THeaPumSet", value=323.15, unit="K",
                    description="Set temperature of heat pump supply temperature"),
        #CasadiInput(name="TBufSet", value=323.15, unit="K",
        #            description="Set temperature of buffer storage, sink temperature of heat pump"),
        CasadiInput(name="yValSet", value=1, unit="-",
                    description="valve control for mass flow through heater", lb=0, ub=1),
        CasadiInput(name="yEleHeaSet", value=1, unit="-",
                    description="valve control for mass flow through heater", lb=0, ub=1
                    ),

        # disturbances
        CasadiInput(name="P_el_pv", value=0, unit="W",
                    description="electricity produced by photovoltaic unit"),
        CasadiInput(name="Q_demand", value=0, unit="W",
                    description="Heat demand"),
        CasadiInput(name="P_el_demand", value=0, unit="W",
                    description="Electricity demand household"),
        CasadiInput(name="T_amb", value=273.15, unit="K",
                    description="Ambient temperature on the outside"),
        CasadiInput(name="THeaCur", value=293.15, unit="K",
                    description="Heat curve temperature"),
        CasadiInput(name="T_Air", value=293.15, unit="K",
                    description="Assumption of room temperature"),
        # costs
        CasadiInput(name="c_feed_in", value=0.082, unit="€/kWh",
                    description="Power Price"),
        CasadiInput(name="c_grid", value=0.3606, unit="€/kWh",
                    description="Power Price"),

    ]


    states: List[CasadiState] = [
        # slack variables
        #CasadiState(name="TTraSup_slack", value=0, unit="K",
        #            description="Slack variable for heater temperature"),

        CasadiState(name="THeaPumSup_slack", value=0, unit="K",
                    description="Slack variable for heat pump sink temperature"),
        #CasadiState(name="QHeaPum_flow_slack", value=0, unit="W",
        #            description="Slack variable for heat pump"),
        #CasadiState(name="PEleHeaPum_slack", value=0, unit="W",
        #            description="Slack variable for heat pump power"),
        CasadiState(name="QTra_flow_slack", value=0, unit="W",
                    description="Slack variable for heat transfer flow rate"),
        CasadiState(name="P_el_feed_into_grid", value=0, unit="W",
                    description="electricity feed-in"),
        CasadiState(name="P_el_feed_from_grid", value=0, unit="W",
                    description="electricity feed_out"),
    ] + [
        # differential
        CasadiState(name=f'T_TES_{n}', value=310, unit="K") for n in range(1, N_LAYER + 1)
    ]
    parameters: List[CasadiParameter] = [
        CasadiParameter(name="mTra_flow_nominal", unit="kg/s",
                        description="Mass flow through heater"),
        CasadiParameter(name="cp_water", unit="J/kg*K",
                        description="specific heat capacity of water"),
        CasadiParameter(name="rho_water", unit="kg/m^3",
                        description="density of water in heating cycle"),
        CasadiParameter(name="scalingFactor", unit="-",
                        description="scaling factor from bes-rules for heat pump"),
        CasadiParameter(name="valve_leakage", unit="-",
                        description="Valve leakage"),
    ]

    outputs: List[CasadiOutput] = [
        CasadiOutput(name="Tamb", value=273.15, unit="K",
                     description="Ambient temperature output"),

        CasadiOutput(name="valve_actual", value=0, unit="-"),
        CasadiOutput(name="mTra_flow", value=0, unit="kg/s"),
        CasadiOutput(name="TTraSup", value=273.15, unit="K"),
        CasadiOutput(name="TTraRet", value=273.15, unit="K"),
        CasadiOutput(name="QTra_flow", value=0, unit="W"),

        CasadiOutput(name="Q_storage_loss", value=0, unit="W"),
        CasadiOutput(name="Qdot_hp", value=0, unit="W"),
        CasadiOutput(name="Qdot_hp_max", value=0, unit="W"),
        CasadiOutput(name="PEleHeaPum", value=0, unit="W"),
        CasadiOutput(name="PEleEleHea", value=0, unit="W"),

        CasadiOutput(name="PEleIntGai_out", value=0, unit="W"),

        CasadiOutput(name="PElePV_out", value=0, unit="W"),
        CasadiOutput(name="PEleFee", value=0, unit="W"),
        CasadiOutput(name="c_feed_in_out", value=0, unit="€/kWh"),
        CasadiOutput(name="c_grid_out", value=0, unit="€/kWh"),
    ]


class MPC(CasadiModel):
    config: MPCModelConfig

    def setup_system(self):
        bes_parameters = self.config.bes_parameters

        # valve
        valve_actual = self.valve_leakage + self.yValSet * (1 - self.valve_leakage)
        mTra_flow = self.mTra_flow_nominal * valve_actual

        # heater
        TTraSup = self.get_T_layer(self.config.nLayer)
        # from energy balance and heat transfer
        TTraOut = component_models.radiator_Q_flow_given_exponent_outlet_temperature(
            casadi_model=self,
            TTraSup=TTraSup,
            T_Air=self.T_Air,
            Q_flow=self.Q_demand,
            mTra_flow=mTra_flow,
        )
        QTra_flow = mTra_flow * self.cp_water * (TTraSup - TTraOut)

        # Supply temperature control
        THeaPumSup = self.THeaPumSet

        # buffer storage
        mHeaPum_flow = bes_parameters["hydraulic.generation.m_flow_nominal[1]"]
        Q_storage_loss = component_models.storage_n_layer(
            casadi_model=self,
            bes_parameters=bes_parameters,
            mTra_flow=mTra_flow,
            mGen_flow=mHeaPum_flow,
            TTraRet=TTraOut,
            TGenSup=THeaPumSup
        )

        # heat pump
        TStoRet = self.get_T_layer(1)

        QHeaPum_flow_max, QHeaPum_flow, PEleHeaPum, PEleEleHea = component_models.vitocal250_with_ideal_heater(
            casadi_model=self, bes_parameters=bes_parameters,
            THeaPumIn=TStoRet,
            THeaPumSup=THeaPumSup,
            THeaPumSou=self.T_amb,
            mHeaPum_flow=mHeaPum_flow
        )

        # electric energy
        PEleFee = self.P_el_demand + PEleHeaPum + PEleEleHea - self.P_el_pv

        # Constraints: List[(lower bound, function, upper bound)]
        # best practise: hard constraints -> soft with high penalty
        self.constraints = [
            # heater
            #(293.15, TTraSup + self.TTraSup_slack, ca.inf),
            (bes_parameters["hydraulic.distribution.parStoBuf.TAmb"], TTraSup, ca.inf),
            (self.Q_demand, QTra_flow + self.QTra_flow_slack, self.Q_demand),
            # heatpump
            (293.15, THeaPumSup + self.THeaPumSup_slack, 273.15 + 70),
            (0, QHeaPum_flow, QHeaPum_flow_max),
            (0, PEleHeaPum, 6770 * self.scalingFactor),
            # storage
            #(0, self.TBufSet - TTraSup, 0),
            #(0, QHeaPum_flow + self.QHeaPum_flow_slack, QHeaPum_flow_max),
            #(0, PEleHeaPum + self.PEleHeaPum_slack, 6770 * self.scalingFactor),
            # electric power
            (0, PEleFee + self.P_el_feed_into_grid - self.P_el_feed_from_grid, 0),
            # split into in and out to avoid if-else in costs
            (0, self.P_el_feed_into_grid, self.P_el_pv),
            (0, self.P_el_feed_from_grid, ca.inf)
        ]

        # Objective function
        C_el_feed_from_grid = self.c_grid / 3600 * self.P_el_feed_from_grid / 1000  # €/kWh * 1h/3600s * W / 1000
        C_el_feed_into_grid = self.c_feed_in / 3600 * self.P_el_feed_into_grid / 1000  # €/kWh * 1h/3600s * W / 1000
        C_el = (C_el_feed_from_grid - C_el_feed_into_grid)  # €

        objective = sum(
            [
                C_el,  # €/s  * 900 s
                #1e-3 * self.TTraSup_slack ** 2,
                1e-3 * self.THeaPumSup_slack ** 2,
                #1e-7 * self.PEleHeaPum_slack ** 2,
                1e-3 * (self.QTra_flow_slack / 1000) ** 2,   # €/s/W
            ]
        )

        # Outputs
        # not needed to work
        # all for comparison with sim
        self.Tamb.alg = self.T_amb
        self.valve_actual.alg = valve_actual
        self.mTra_flow.alg = mTra_flow

        self.TTraSup.alg = TTraSup
        self.TTraRet.alg = TTraOut
        self.QTra_flow.alg = self.Q_demand

        self.Q_storage_loss.alg = Q_storage_loss

        self.Qdot_hp.alg = QHeaPum_flow
        self.Qdot_hp_max.alg = QHeaPum_flow_max
        self.PEleHeaPum.alg = PEleHeaPum
        self.PEleEleHea.alg = PEleEleHea
        self.PEleIntGai_out.alg = self.P_el_demand

        self.PElePV_out.alg = self.P_el_pv
        self.PEleFee.alg = PEleFee

        self.c_feed_in_out.alg = self.c_feed_in
        self.c_grid_out.alg = self.c_grid

        return objective

    def get_T_layer(self, _n):
        return self._states.get(f"T_TES_{_n}")
