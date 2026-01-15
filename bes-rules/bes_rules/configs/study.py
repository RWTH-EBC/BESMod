import os
import json
from pathlib import Path
from typing import List, Union

from pydantic import field_validator, BaseModel, TypeAdapter, FieldValidationInfo

from bes_rules.configs.simulation import SimulationConfig
from bes_rules.configs.optimization import OptimizationConfig
from bes_rules.configs.inputs import InputsConfig
from bes_rules import objectives as objectives_module


class PathEncoder(json.JSONEncoder):
    def default(self, obj):
        if isinstance(obj, Path):
            return str(obj)
        return super().default(obj)


class StudyConfig(BaseModel):
    name: str
    base_path: Path
    simulation: SimulationConfig
    optimization: OptimizationConfig
    inputs: InputsConfig
    n_cpu: int
    objectives: List[objectives_module.BaseObjective] = objectives_module.get_all_objectives()
    time_series_dependent_objectives: List[objectives_module.TimeSeriesDependentObjective] = \
        objectives_module.get_time_series_dependent_objectives()
    test_only: bool = False

    @property
    def study_path(self):
        return self.base_path.joinpath(self.name)

    @field_validator("base_path")
    @classmethod
    def create_path(cls, path, info: FieldValidationInfo):
        study_path = path.joinpath(info.data["name"])
        os.makedirs(path, exist_ok=True)
        os.makedirs(study_path, exist_ok=True)
        return path

    def to_json(self):
        simulation_path = self.study_path.joinpath("simulation_config.json")
        optimization_path = self.study_path.joinpath("optimization_config.json")
        inputs_path = self.study_path.joinpath("inputs_config.json")
        with open(simulation_path, "w+") as file:
            json.dump(self.simulation.model_dump(exclude={"plot_settings"}), file, indent=2, cls=PathEncoder)
        with open(optimization_path, "w+") as file:
            json.dump(self.optimization.model_dump(), file, indent=2, cls=PathEncoder)
        with open(inputs_path, "w+") as file:
            json.dump(self.inputs.model_dump(), file, indent=2, cls=PathEncoder)

        self_clean = self.model_dump()
        self_clean.update(
            {
                "simulation": simulation_path,
                "study_path": self.study_path,
                "optimization": optimization_path,
                "inputs": inputs_path
            }
        )
        study_path = self.study_path.joinpath("study_config.json")
        with open(study_path, "w+") as file:
            json.dump(self_clean, file, indent=2, cls=PathEncoder)
        return [
            study_path,
            simulation_path,
            optimization_path,
            inputs_path
        ]

    @staticmethod
    def from_json(path: Union[Path, str]):
        study_config = _validate_json_path(path, dict)
        old_base_study = study_config["study_path"]
        new_base_study = Path(path).parent
        study_config["study_path"] = new_base_study
        study_config["base_path"] = new_base_study.parent

        def _switch_to_new_base_path(p: Path, new: Path, old: Path):
            return new.joinpath(Path(p).relative_to(old))

        simulation_config_path = _switch_to_new_base_path(
            study_config["simulation"], new=new_base_study, old=old_base_study
        )
        optimization_config_path = _switch_to_new_base_path(
            study_config["optimization"], new=new_base_study, old=old_base_study
        )
        inputs_config_path = _switch_to_new_base_path(
            study_config["inputs"], new=new_base_study, old=old_base_study
        )

        inputs = _validate_json_path(inputs_config_path, dict)
        #inputs["modifiers"] = [None]
        study_config.update(
            {
                "simulation": _validate_json_path(simulation_config_path, SimulationConfig),
                "optimization": _validate_json_path(optimization_config_path, OptimizationConfig),
                "inputs": InputsConfig(**inputs),
                "objectives": objectives_module.get_all_objectives(),
                "time_series_dependent_objectives": objectives_module.get_time_series_dependent_objectives()
            }
        )
        return StudyConfig(**study_config)

    def get_additional_result_names(self):
        res_names = []
        for metric in self.objectives + self.time_series_dependent_objectives:
            res_names.extend(metric.mapping.simulation_result_names)
        return list(set(res_names))


def _validate_json_path(path, obj):
    with open(path, "r") as file:
        data = json.load(file)
    if isinstance(data, dict):
        return obj(**data)
    return TypeAdapter(obj).validate_json(data)
