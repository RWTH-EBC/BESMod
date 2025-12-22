from pathlib import Path
import logging

import pandas as pd

from ebcpy import DymolaAPI

from bes_rules.configs import InputConfig
from bes_rules.simulation_based_optimization import BaseSupervisoryControl

logger = logging.getLogger(__name__)
logger.setLevel("DEBUG")


class AgentLibMPC(BaseSupervisoryControl):
    """
    Class used to generate FMUs and MPC-configs for AgentLib-MPC Co-Simulations.

    You can pass a custom run_mpc function via `external_control_function` to actually run the multi-agent system.
    Inputs to this function are defined by `get_function_inputs_for_parameters`.
    See the examples and `BaseSupervisoryControl` for how to do that.
    """

    def get_function_inputs_for_parameters(
            self,
            design_parameters: dict,
            bes_parameters: dict,
            fmu_path: Path,
            predictions: pd.DataFrame,
            save_path: Path,
            state_result_names: list,
            output_result_names: list

    ):
        zone_mo_path = self.input_config.building.package_path.parent.joinpath(
            *self.input_config.building.record_name.split(".")[1:]
        ).with_suffix(".mo")

        predictions.to_csv(self.get_predictive_control_path().joinpath("disturbances.csv"))

        return dict(
            design_parameters=design_parameters,
            start_time=self.config.simulation.sim_setup.get("start_time", 0),
            stop_time=self.config.simulation.sim_setup["stop_time"] + self.config.simulation.init_period,
            output_interval=self.config.simulation.sim_setup["output_interval"],
            predictive_control_path=self.get_predictive_control_path(),
            save_path=save_path,
            zone_mo_path=zone_mo_path,
            state_result_names=state_result_names,
            output_result_names=output_result_names,
            bes_parameters=bes_parameters,
            **self._predictive_control_options,
        )
