import datetime
import logging
from pathlib import Path

from agentlib.utils.multi_agent_system import LocalMASAgency

from bes_rules.simulation_based_optimization.agentlib_mpc.config_editor import generator_simulator_comparison_configs

logger = logging.getLogger(__name__)


def run(
        design_config_path: Path,
        start_time: float,
        stop_time: float,
        control_emulator_mapping: dict
):
    agent_configs = generator_simulator_comparison_configs(
        mpc_agent=design_config_path.joinpath("mpc.json"),
        predictor_agent=design_config_path.joinpath("predictor.json"),
        simulator_agent=design_config_path.joinpath("simulator.json"),
        control_emulator_mapping=control_emulator_mapping
    )
    # configs
    env_config = {"rt": False, "t_sample": 180, "offset": start_time, "clock": True}

    # run
    logging.basicConfig(level=logging.INFO)
    mas = LocalMASAgency(
        agent_configs=agent_configs,
        env=env_config,
        variable_logging=False,
    )
    mas.run(until=stop_time)
