import json
import os
from pathlib import Path
from bes_rules.utils.modelica import parse_modelica_record
from bes_rules import REPO_ROOT
from bes_rules.simulation_based_optimization.agentlib_mpc import config_editor


def generator_simulator_comparison_configs(
        mpc_agent: Path,
        predictor_agent: Path,
        simulator_agent: Path,
        control_emulator_mapping: dict
):
    # Simulator first, change result file name
    with open(simulator_agent, "r") as file:
        fmu_agent_config = json.load(file)
    old_result_file = Path(fmu_agent_config["modules"][1]["result_filename"])
    fmu_agent_config["modules"][1]["result_filename"] = old_result_file.with_stem(
        old_result_file.stem + "_debug").as_posix()
    fmu_agent_config["id"] = "fmu"
    # Predictor, change predictions to measurements
    with open(predictor_agent, "r") as file:
        predictor_agent_config = json.load(file)
    old_outputs = predictor_agent_config["modules"][1]["outputs"]
    new_outputs = []
    for output in old_outputs:
        new_outputs.append({
            "name": output["name"].replace("_prediction", "_measurement"),
            "value": output["value"]
        })
    predictor_agent_config["modules"][1]["outputs"] = new_outputs
    predictor_agent_config["modules"][1]["send_measurements"] = True
    predictor_agent_config["modules"][1]["send_predictions"] = False

    # Last, create simulator config from MPC config
    with open(mpc_agent, "r") as file:
        mpc_agent_config = json.load(file)
    mpc_model = mpc_agent_config["modules"][1]["optimization_backend"]["model"]
    # states = mpc_agent_config["modules"][1]["states"]
    old_inputs = mpc_agent_config["modules"][1]["inputs"]
    t_sample_simulation = fmu_agent_config["modules"][1]["t_sample_simulation"]
    t_sample_communication = fmu_agent_config["modules"][1]["t_sample_communication"]

    config_editor.update_module_parameters(predictor_agent_config["modules"][1],
                                           {"sampling_time": t_sample_communication})

    new_inputs = []
    for variable in old_inputs:
        new_inputs.append({
            "name": variable["name"],
            "value": variable["value"],
            "alias": variable["alias"].replace("_prediction", "_measurement")
        })
    controls = mpc_agent_config["modules"][1]["controls"]
    new_inputs.extend(controls)  # These go with no name changes
    simulator_casadi_module = {
        "type": "simulator",
        "module_id": "sim",
        "model": mpc_model,
        "save_results": True,
        "t_sample_simulation": t_sample_simulation,
        "t_sample_communication": t_sample_communication,
        "shared_variable_fields": [
            "outputs",
            "states"
        ],
        "result_filename": old_result_file.with_stem(old_result_file.stem + "_casadi_debug").as_posix(),
        "overwrite_result_file": True,
        "result_causalities": [
            "input",
            "output",
            "local"
        ],
        "inputs": new_inputs,
    }
    casadi_agent_config = {
        "id": "casadi",
        "modules": [
            mpc_agent_config["modules"][0],  # Local broadcast
            simulator_casadi_module
        ]
    }
    # Control signal emulator
    predictions_path = Path(fmu_agent_config["modules"][1]["model"]["path"]).parent
    emulator_config = {
        "id": "control_emulator",
        "modules": [
            mpc_agent_config["modules"][0],  # Local broadcast
            {
                "type": {
                    "class_name": "ControlEmulatorModule",
                    "file": Path(__file__).parent.joinpath("control_signal_emulator.py").as_posix()
                },
                "time_step": t_sample_communication,
                "emulation_path": predictions_path.joinpath("predictions.mat").as_posix(),
                "outputs": [
                    {"name": key, "alias": value}
                    for key, value in control_emulator_mapping.items()
                ],
                "shared_variable_fields": [
                    "outputs"
                ]
            }
        ]
    }

    agent_configs = [casadi_agent_config, fmu_agent_config, predictor_agent_config, emulator_config]
    return agent_configs


def generate_agent_configs(
        design_parameters: dict,
        mpc_module: Path,
        predictor_module: Path,
        simulator_module: Path,
        save_path: Path,
        mpc_parameters: dict,
        bes_parameters: dict,
        zone_mo_path: Path,
        predictive_control_path: Path,
        state_result_names: list,
        output_result_names: list,
        output_interval: float,
        prediction_horizon: int,
        design_case_name: str,
        model_path: Path,
        save_mpc_results: bool,
        save_mpc_stats: bool
):
    config_path = save_path.joinpath(f"generated_configs_{design_case_name}")
    os.makedirs(config_path, exist_ok=True)
    agentlib_mpc_bes_rules = REPO_ROOT.joinpath("bes_rules", "simulation_based_optimization", "agentlib_mpc")
    zone_parameters = parse_modelica_record(zone_mo_path)

    # Define the dictionary
    parameters_dict = {
        "AZone": zone_parameters['AZone'],
        "VAir": zone_parameters['VAir'],
        "air_rho": bes_parameters["building.thermalZone[1].airExc.rho"],
        "air_cp": bes_parameters["building.thermalZone[1].airExc.c"],
        "CAir": (
                zone_parameters['VAir'] *
                bes_parameters["building.thermalZone[1].airExc.rho"] *
                bes_parameters["building.thermalZone[1].airExc.c"]
        ),
        "CRoof": zone_parameters['CRoof'],
        "CExt": zone_parameters['CExt'],
        "CInt": zone_parameters['CInt'],
        "CFloor": zone_parameters['CFloor'],
        "hConRoofOut": zone_parameters['hConRoofOut'],
        "hConRoof": zone_parameters['hConRoof'],
        "RRoof": zone_parameters['RRoof'],
        "RRoofRem": zone_parameters['RRoofRem'],
        "hConExt": zone_parameters['hConExt'],
        "RExt": zone_parameters['RExt'],
        "hConWallOut": zone_parameters['hConWallOut'],
        "RExtRem": zone_parameters['RExtRem'],
        "hConInt": zone_parameters['hConInt'],
        "RInt": zone_parameters['RInt'],
        "hConWin": zone_parameters['hConWin'],
        "hConWinOut": zone_parameters['hConWinOut'],
        "RWin": zone_parameters['RWin'],
        "hConFloor": zone_parameters['hConFloor'],
        "RFloor": zone_parameters['RFloor'],
        "RFloorRem": zone_parameters["RFloorRem"],
        "hRad": zone_parameters['hRad'],
        "hRadRoof": zone_parameters['hRadRoof'],
        "hRadWall": zone_parameters['hRadWall'],
        "gWin": zone_parameters['gWin'],
        "ratioWinConRad": zone_parameters['ratioWinConRad'],
        "AExttot": sum(zone_parameters['AExt'])
        if isinstance(zone_parameters['AExt'], list)
        else zone_parameters['AExt'],
        "AInttot": sum(zone_parameters['AInt'])
        if isinstance(zone_parameters['AInt'], list)
        else zone_parameters['AInt'],
        "AWintot": sum(zone_parameters['AWin'])
        if isinstance(zone_parameters['AWin'], list)
        else zone_parameters['AWin'],
        "AFloortot": sum(zone_parameters['AFloor'])
        if isinstance(zone_parameters['AFloor'], list)
        else zone_parameters['AFloor'],
        "ARooftot": sum(zone_parameters['ARoof'])
        if isinstance(zone_parameters['ARoof'], list)
        else zone_parameters['ARoof'],
        "ATransparent": sum(zone_parameters['ATransparent'])
        if isinstance(zone_parameters['ATransparent'], list)
        else zone_parameters['ATransparent'],
        "activityDegree": zone_parameters['activityDegree'],
        "specificPeople": zone_parameters['specificPeople'],
        "ratioConvectiveHeatPeople": zone_parameters['ratioConvectiveHeatPeople'],
        "internalGainsMachinesSpecific": zone_parameters['internalGainsMachinesSpecific'],
        "ratioConvectiveHeatMachines": zone_parameters['ratioConvectiveHeatMachines'],
        "lightingPowerSpecific": zone_parameters['lightingPowerSpecific'],
        "ratioConvectiveHeatLighting": zone_parameters['ratioConvectiveHeatLighting'],
        "nEle_heater": bes_parameters["hydraulic.transfer.parRad.nEle"],
        "V_Ele_heater": bes_parameters["hydraulic.transfer.rad[1].vol[1].V"],
        "UA_heater": (
                bes_parameters["hydraulic.transfer.rad[1].UAEle"] *
                bes_parameters["hydraulic.transfer.parRad.nEle"]
        ),
        "UA_heater_Ele": bes_parameters["hydraulic.transfer.rad[1].UAEle"],
        "n_heater_exp": bes_parameters["hydraulic.transfer.parRad.n"],
        "fraRad": bes_parameters["hydraulic.transfer.parRad.fraRad"],
        "mTra_flow_nominal": bes_parameters["hydraulic.transfer.m_flow_nominal[1]"],
        "valve_leakage": max(0.05, bes_parameters.get("hydraulic.transfer.parTra.leakageOpening", 0.001)),
        "cp_water": bes_parameters["hydraulic.transfer.cp"],
        "rho_water": bes_parameters["hydraulic.transfer.rho"],
        "scalingFactor": bes_parameters["scalingFactor"]
    }

    mpc_model = {
        "type": {
            "file": model_path.as_posix(),
            "class_name": "MPC"
        },
        "bes_parameters": bes_parameters,
        "zone_parameters": zone_parameters,
        "parameters": [{"name": name, "value": value} for name, value in parameters_dict.items()]
    }

    def _get_variables_dict(l: list):
        return {var["name"]: var for var in l}

    def add_missing_variables(names: list, variables: list, values: list = None):
        variables = _get_variables_dict(variables)
        if values is None:
            values = [None] * len(names)
        for name, value in zip(names, values):
            if name in variables and value is not None:
                variables[name]["value"] = value
            elif name not in variables and value is not None:
                variables[name] = {"name": name, "value": value}
            else:
                variables[name] = {"name": name}
        return list(variables.values())

    # Simulator
    simulator_config = config_editor.load_config(simulator_module)
    if simulator_config["model"]["type"] == "fmu":
        simulator_config["model"]["path"] = f"{predictive_control_path}/BES.fmu"
        simulator_config["t_sample_communication"] = output_interval
        simulator_config["t_sample_simulation"] = output_interval
        simulator_config["parameters"] = add_missing_variables(
            names=list(design_parameters.keys()),
            values=list(design_parameters.values()),
            variables=simulator_config.get("parameters", {})
        )
        simulator_config["states"] = add_missing_variables(
            names=state_result_names,
            variables=simulator_config["states"]
        )
        simulator_config["outputs"] = add_missing_variables(
            names=output_result_names,
            variables=simulator_config["outputs"]
        )
    else:
        simulator_config["model"] = mpc_model
    simulator_config["result_filename"] = save_path.joinpath(f"{design_case_name}_sim_agent.csv").as_posix()
    simulator_agent_path = config_editor.create_and_save_agent(
        name="simulator", module_config=simulator_config, path=config_path
    )
    mpc_config = config_editor.load_config(mpc_module)
    if save_mpc_results or save_mpc_stats:
        mpc_config["optimization_backend"]["results_file"] = save_path.joinpath(
            f"{design_case_name}_mpc_agent.csv"
        ).as_posix()
    mpc_config["optimization_backend"]["save_only_stats"] = save_mpc_stats and not save_mpc_results
    mpc_config["time_step"] = output_interval
    mpc_config["prediction_horizon"] = prediction_horizon
    mpc_config = config_editor.update_module_parameters(mpc_config=mpc_config, parameters=mpc_parameters)
    mpc_config["optimization_backend"]["model"] = mpc_model
    if mpc_config.get("enable_deactivation", False):
        other_modules = [{
            "type": "agentlib_mpc.skip_mpc_intervals",
            # "intervals": [(2, 2.5)],
            "intervals": [(120, 273)],
            "time_unit": "days",
            "t_sample": output_interval,
            "log_level": "DEBUG",
            "controls_when_deactivated": [
                {"name": "TBufSet", "value": 303.15},
                {"name": "yValSet", "value": 0},
                {"name": "yEleHeaSet", "value": 0},
                {"name": "actExtVal", "value": False},
                {"name": "actExtDHWCtrl", "value": False},
                {"name": "actExtBufCtrl", "value": False}
            ],
        }]
    else:
        other_modules = None
    print(other_modules)
    mpc_agent_path = config_editor.create_and_save_agent(
        name="mpc", module_config=mpc_config, path=config_path, other_modules=other_modules
    )

    predictor_config = config_editor.load_config(predictor_module)
    predictor_config["type"] = {
        "file": str(agentlib_mpc_bes_rules.joinpath("predictor.py")),
        "class_name": "PredictorModule"
    }
    predictor_config["send_predictions"] = True
    predictor_config["parameters"].extend(
        [
            {
                "name": "time_step",
                "value": output_interval
            },
            {
                "name": "prediction_horizon",
                "value": prediction_horizon + 1
            },
            {
                "name": "disturbances_path",
                "value": f"{predictive_control_path}/disturbances.csv"
            }
        ]
    )

    predictor_agent_path = config_editor.create_and_save_agent(
        name="predictor", module_config=predictor_config, path=config_path
    )
    # This order is important!! (simulator has the same time step as MPC and has to get the control signals first)
    return [
        predictor_agent_path,
        mpc_agent_path,
        simulator_agent_path
    ]
