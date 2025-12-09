import datetime
import logging
from pathlib import Path

from agentlib.utils.multi_agent_system import LocalMASAgency
from .config_editor import generate_agent_configs

logger = logging.getLogger(__name__)


def run(
        design_parameters: dict,
        mpc_parameters: dict,
        predictive_control_path: Path,
        output_interval: int,
        start_time: float,
        stop_time: float,
        save_path: Path,
        mpc_module: Path,
        predictor_module: Path,
        simulator_module: Path,
        bes_parameters: dict,
        state_result_names: list,
        output_result_names: list,
        zone_mo_path: Path,
        model_path: Path,
        save_mpc_results: bool,
        save_mpc_stats: bool
):
    # configs
    env_config = {"rt": False, "t_sample": 180, "offset": start_time}
    save_path_folder = save_path.parent
    # output_interval: time step in seconds,
    # prediction_horizon: prediction horizon in multiples of output_interval (24h)
    agent_configs = generate_agent_configs(
        design_parameters=design_parameters,
        mpc_module=mpc_module,
        predictor_module=predictor_module,
        simulator_module=simulator_module,
        save_path=save_path_folder,
        mpc_parameters=mpc_parameters,
        bes_parameters=bes_parameters,
        zone_mo_path=zone_mo_path,
        state_result_names=state_result_names,
        output_result_names=output_result_names,
        predictive_control_path=predictive_control_path,
        output_interval=output_interval,
        design_case_name=save_path.stem,
        model_path=model_path,
        prediction_horizon=round(24 * 60 * 60 / output_interval),
        save_mpc_results=save_mpc_results,
        save_mpc_stats=save_mpc_stats,
    )

    # run
    logging.basicConfig(level=logging.INFO, filename=save_path_folder.joinpath(f"logging_{save_path.stem}.txt"))
    mas = LocalMASAgency(
        agent_configs=agent_configs,
        env=env_config,
        variable_logging=False,
        use_direct_callback_databroker=True
    )
    sim_start = datetime.datetime.now()
    logger.info("Simulation start: %s", sim_start)
    mas.run(until=stop_time)
    sim_end = datetime.datetime.now()
    logger.info("Simulation End: %s", sim_end)
    results = mas.get_results(cleanup=False)
    days_sim_len = (stop_time - start_time) / 86400
    stats_file = save_path_folder.joinpath("sim_time.txt")
    with open(stats_file, "w") as f:
        f.write(f"Start:\t{sim_start}\n")
        f.write(f"End:\t{sim_end}\n")
        f.write(f"Duration:\t{sim_end - sim_start}\n")
        f.write(f"start_time:\t{start_time}\n")
        f.write(f"Dur/day:\t{(sim_end - sim_start)/days_sim_len}\n")

    df = results["simulator"]["sim"]
    df.to_excel(save_path)
    return save_path
