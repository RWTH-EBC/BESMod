import logging
from pathlib import Path
from typing import Union, Optional

from ebcpy import DymolaAPI, FMU_API
from typing import List
from pydantic import (
    field_validator, BaseModel,
    PrivateAttr, ConfigDict
)


logger = logging.getLogger(__name__)


class SimulationConfig(BaseModel):
    startup_mos: Path = None
    sim_setup: dict = None
    model_name: str = None
    packages: List[Union[Path, str]] = []
    result_names: list = []
    recalculate: bool = True
    show_window: bool = True
    debug: bool = False
    type: str = "Dymola"
    equidistant_output: bool = True
    init_period: float = 86400 * 2
    plot_settings: dict = {}
    dymola_api_kwargs: dict = {}
    model_config = ConfigDict(protected_namespaces=())
    variables_to_save: dict = {}
    extract_results_during_optimization: bool = True
    convert_to_hdf_and_delete_mat: bool = True
    save_results: Optional[bool] = True
    _unmodified_model_name: str = PrivateAttr(default=None)

    def __init__(self, **data):
        super().__init__(**data)
        self._unmodified_model_name = self.model_name

    @field_validator("type")
    @classmethod
    def check_type(cls, _type):
        if _type not in ["FMU", "Dymola", "Static"]:
            raise TypeError(f"Given API type '{_type}' is not supported.")
        return _type

    def modify_model_name(self, modifier: str):
        self.model_name = self.get_modified_model_name(modifier=modifier)

    def get_modified_model_name(self, modifier):
        return self._unmodified_model_name + modifier

    def get_unmodified_model_name(self):
        return self._unmodified_model_name

    def get_result_names(self) -> List[str]:
        from bes_rules.plotting.important_variables import get_names_of_plot_variables
        result_names_to_plot = get_names_of_plot_variables(
            x_variable=self.plot_settings.get("x_variable", ""),
            y_variables=self.plot_settings.get("y_variables", {}),
            x_vertical_lines=self.plot_settings.get("x_vertical_lines", [])
        )

        return self.result_names + result_names_to_plot


def start_api(
        config: SimulationConfig,
        working_directory, n_cpu,
        additional_packages: list = None,
        save_path_mos: Path = None):
    api_to_be_loaded = dict(
        config=config,
        working_directory=working_directory,
        n_cpu=n_cpu,
        additional_packages=additional_packages
    )

    if config.type == "Dymola":
        new_sim_api = start_dymola(
            **api_to_be_loaded,
            save_path_mos=save_path_mos
        )
    elif config.type == "FMU":
        new_sim_api = start_fmu(**api_to_be_loaded)
    else:
        raise TypeError("Simulation-API type not supported")

    new_sim_api.set_sim_setup(config.sim_setup)
    new_sim_api.sim_setup.stop_time += config.init_period

    return new_sim_api


def export_fmu(
        config: SimulationConfig,
        dym_api: DymolaAPI,
        save_path: str):
    res = dym_api.dymola.translateModelFMU(
        modelToOpen=config.model_name,
        storeResult=False,
        modelName='',
        fmiVersion='2',
        fmiType='me',
        includeSource=False,
        includeImage=0
    )
    if not res:
        msg = "Could not export fmu: %s" % dym_api.dymola.getLastErrorLog()
        raise Exception(msg)
    path_to_fmu = Path(save_path).joinpath(res + ".fmu")
    new_config = config.copy()
    new_config.model_name = path_to_fmu
    new_config.type = "FMU"
    new_config.packages = []
    new_config.show_window = False
    new_config.debug = False
    return new_config


def start_fmu(
        config: SimulationConfig, working_directory, n_cpu, **kwargs
):
    return FMU_API(
        working_directory=working_directory,
        model_name=config.model_name,
        n_cpu=n_cpu,
        log_fmu=True
    )


def generate_mos_script(config: SimulationConfig, additional_packages: list, save_path_mos: Path):
    with open(config.startup_mos, "r") as file:
        lines = file.readlines()
    lines.append("\n")
    for package in config.packages + additional_packages:
        clean_path = str(package).replace("\\", "//")
        lines.append(f'openModel("{clean_path}", changeDirectory=false);\n')
    with open(save_path_mos, "w") as file:
        file.writelines(lines)


def start_dymola(
        config: SimulationConfig, working_directory, n_cpu,
        additional_packages: list = None,
        save_path_mos: Path = None
):
    if additional_packages is None:
        additional_packages = []
    packages = config.packages + additional_packages

    if save_path_mos is not None:
        generate_mos_script(
            config=config,
            additional_packages=additional_packages,
            save_path_mos=save_path_mos
        )

    return DymolaAPI(
        working_directory=working_directory,
        model_name=config.model_name,
        mos_script_pre=config.startup_mos,
        packages=list(set(packages)),
        n_cpu=n_cpu,
        show_window=config.show_window,
        debug=config.debug,
        equidistant_output=config.equidistant_output,
        modify_structural_parameters=False,
        variables_to_save=config.variables_to_save,
        **config.dymola_api_kwargs
    )
