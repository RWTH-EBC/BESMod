import json
from pathlib import Path


def update_module_parameters(mpc_config: dict, parameters: dict):
    for param, value in parameters.items():
        for i, _ in enumerate(mpc_config["parameters"]):
            if mpc_config["parameters"][i]["name"] == param:
                mpc_config["parameters"][i]["value"] = value
    return mpc_config


def load_config(path: Path):
    with open(path, 'r') as config_file:
        return json.load(config_file)


def create_and_save_agent(module_config: dict, name: str, path: Path, other_modules: list = None):
    communicator_module = {"type": "local_broadcast"}
    agent_path = path.joinpath(f"{name}.json")
    if other_modules is None:
        other_modules = []
    with open(agent_path, "w") as file:
        json.dump({
            "id": name,
            "modules": [
                communicator_module,
                module_config
            ] + other_modules
        }, file, indent=2)
    return agent_path
