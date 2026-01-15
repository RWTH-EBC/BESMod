import logging
import pathlib
import json
from typing import Dict, Union, List

import matplotlib.pyplot as plt
import numpy as np
from pydantic import BaseModel
from cycler import cycler
from ebcpy import TimeSeriesData

logger = logging.getLogger(__name__)


class PlotVariableConfig(BaseModel):
    quantity: str = None
    label: str = None
    labels: Dict[str, str] = None
    unit: str = None
    factor: float = 1
    offset: float = 0


class PlotConfig(BaseModel):
    variables: Dict[str, PlotVariableConfig]
    rcParams: Dict
    language: str = "en"
    file_endings: List[str] = ["png"]

    def __init__(self, **data):
        super().__init__(**data)
        self.variables = populate_variables(self.variables)
        self.update_rc_params(rcParams=self.rcParams)

    def get_variable(self, variable: str) -> PlotVariableConfig:
        return self.variables.get(variable, PlotVariableConfig(label=f"${variable}$"))

    def update_config(self, config):
        for key, variable in config.get("variables", {}).items():
            variable = PlotVariableConfig(**variable)
            self.variables[key] = populate_based_on_quantity(variable)

        self.update_rc_params(rcParams=config.get("rcParams", {}))

    def update_rc_params(self, rcParams: dict):
        from bes_rules.plotting import EBCColors
        if "axes.prop_cycle" not in rcParams:
            rcParams["axes.prop_cycle"] = cycler(color=EBCColors.ebc_palette_sort_2)
        self.rcParams.update(rcParams)
        plt.rcParams.update(self.rcParams)
        logging.info("Updated rcParams with %s", rcParams)

    def scale_df(self, df):
        df = df.copy()
        if isinstance(df, TimeSeriesData):
            for variable, config in self.variables.items():
                if variable not in df.get_variable_names():
                    continue
                df.loc[:, (variable, "raw")] /= config.factor
                df.loc[:, (variable, "raw")] -= config.offset
        else:
            for variable, config in self.variables.items():
                if variable not in df.columns:
                    continue
                df.loc[:, variable] /= config.factor
                df.loc[:, variable] -= config.offset

        return df

    def scale(self, variable: str, value: Union[float, np.ndarray]) -> float:
        config = self.get_variable(variable)
        return value / config.factor - config.offset

    def get_label_and_unit(self, variable: str, linebreak: bool = False):
        var_obj = self.get_variable(variable)
        label = self.get_label(variable=variable)
        if linebreak:
            split = "\nin "
        else:
            split = " in "
        if var_obj.unit is None:
            return f"{label}{split}[not set]"
        return f"{label}{split}{var_obj.unit}"

    def save(
            self,
            fig: plt.Figure, save_path: pathlib.Path, large_dataset: bool = False,
            **kwargs
    ):
        """
        Saves the given figure with all configured file endings in the given save-path.
        """
        if large_dataset and "png" not in self.file_endings:
            logger.warning("Plot is really large, we are saving it using png under %s", save_path)
            file_endings = ["png"]
        else:
            file_endings = self.file_endings

        logger.info("Plot saved under %s with file endings %s", save_path, file_endings)
        if "." in save_path.name:
            logger.warning(
                "'.' detected in name of save-path, you should "
                "call .save with no existing suffix or dots in the name"
            )
        for ending in file_endings:
            fig.savefig(save_path.with_name(f"{save_path.name}.{ending}"), **kwargs)

    def get_label(self, variable: str):
        var_obj = self.get_variable(variable)
        if var_obj.labels is None and var_obj.label is None:
            return variable
        if var_obj.labels is None or self.language not in var_obj.labels:
            if self.language != "en":
                logger.debug(f"Language {self.language} not supported for variable {variable}, using default entry.")
            return var_obj.label
        return var_obj.labels[self.language]

    @classmethod
    def parse_json_file(cls, json_file: pathlib.Path, update_rc: bool = True):
        with open(json_file, "r", encoding="utf-8") as file:
            config = json.load(file)
        if not update_rc:
            config["rcParams"] = {}
        config["variables"].update(get_energy_balance_variables())

        return cls.model_validate(config)

    @classmethod
    def load_default(cls, update_rc: bool = True, language: str = None):
        from bes_rules import DATA_PATH
        config = cls.parse_json_file(DATA_PATH.joinpath(
            "default_configs", "plotting.json"), update_rc=update_rc
        )
        if language is not None:
            config.language = language
        return config


def populate_based_on_quantity(variable: PlotVariableConfig):
    supported_quantities = {
        "One": {"unit": "-", "offset": 0, "factor": 1},
        "Temperature": {"unit": "°C", "offset": 273.15, "factor": 1},
        "TemperatureDifference": {"unit": "K", "offset": 0, "factor": 1},
        "Energy": {"unit": "kWh", "offset": 0, "factor": 3600000},
        "EnergyMega": {"unit": "MWh", "offset": 0, "factor": 3600000000},
        "Power": {"unit": "kW", "offset": 0, "factor": 1000},
        "Percent": {"unit": "%", "offset": 0, "factor": 0.01},
        "Discomfort": {"unit": "Kh", "offset": 0, "factor": 3600},
        "MassFlowRate": {"unit": "kg/s", "offset": 0, "factor": 1},
        "Pressure": {"unit": "bar", "offset": 0, "factor": 1e5}
    }
    if variable.quantity is None:
        return variable
    if variable.quantity not in supported_quantities:
        logger.error("Given quantity %s not supported", variable.quantity)
        return variable
    variable.unit = supported_quantities[variable.quantity]["unit"]
    variable.offset = supported_quantities[variable.quantity]["offset"]
    variable.factor = supported_quantities[variable.quantity]["factor"]
    return variable


def populate_variables(variables):
    return {key: populate_based_on_quantity(variable) for key, variable in variables.items()}


def get_energy_balance_variables():
    base = "outputs.building.eneBal[1]"
    variables = {}

    def get_latex_label(_quantity, _name, _typ):
        _name = _name[0].capitalize() + _name[1:]
        if _quantity == "Power":
            return "$\dot{Q}_\mathrm{%s,%s}$" % (_name, _typ)
        return "$Q_\mathrm{%s,%s}$" % (_name, _typ)

    for unit, quantity in zip(["value", "integral"], ["Power", "Energy"]):
        for typ in ["Loss", "Gain"]:
            for var in ["airExc", "extWall", "floor", "roof", "win", "tra"]:
                variables[f"{base}.{var}{typ}.{unit}"] = PlotVariableConfig(
                    quantity=quantity,
                    label=get_latex_label(quantity, var, typ)
                )
        for var in ["sol", "light", "per", "mac"]:
            variables[f"{base}.{var}Gain.{unit}"] = PlotVariableConfig(
                quantity=quantity,
                label=get_latex_label(quantity, var, "Gain")
            )
    return variables
