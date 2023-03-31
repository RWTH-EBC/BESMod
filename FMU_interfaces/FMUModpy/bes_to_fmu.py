import pathlib
from typing import Union, List
from ebcpy import FMU_API, DymolaAPI
import FMUModpy.variable_search as search


def generate_inputs(sim_api: Union[FMU_API, DymolaAPI],
                    save_path: Union[str, pathlib.Path],
                    sim_setup: dict,
                    variables: List[str],
                    variables_prefix: List[str] = None):
    """
    Generate inputs from a bes simulation for a model in an FMU-interface.

    :param sim_api:
        Sim_api of the bes model.
    :param save_path:
        Path where to save the data.
    :param sim_setup:
        Dict with the keys "start_time", "stop_time" and "output_interval".
    :param variables:
        Specific names of variables to save.
    :param variables_prefix:
        Default None. Can be specified to get all variables with the same prefix.
        specially useful for inputs in a bus connector.
    """
    sim_api.set_sim_setup(sim_setup)
    if variables_prefix:
        if not isinstance(variables_prefix, list):
            variables_prefix = [variables_prefix]
        for prefix in variables_prefix:
            variables.extend(search.get_variable_names_by_prefix(sim_api.variables, prefix))

    sim_api.result_names = variables

    result = sim_api.simulate()
    print(result)
    result.save(save_path)


def get_top_down_parameters(sim_api, subsystem, diff_name=None):
    """
    Prints the top-down parameters of a subsystem from a bes model with their value and uint.
    This can be directly copied and pasted in Dymola as modelica text in the declaration
    of the Subsystem in the FMU-interfaces
    :param sim_api:
        FMU_api or DymolaAPI of the bes model
    :param str subsystem:
        Subsystem to get parameter values from: "hydraulic", "hydraulic.generation",
        "hydraulic.distribution", "hydraulic.transfer", "ventilation.generation"
        and "ventilation.distribution".
    :param str diff_name:
        Default None. If the name in the model differs from the subsystem string,
        the name has to be specified here
    """
    if diff_name:
        name = diff_name
    else:
        name = subsystem
    if subsystem == "hydraulic":
        parameters = {f"{name}.hydraulicSystemParameters.nZones": ("single", " [-]"),
                      f"{name}.hydraulicSystemParameters.Q_flow_nominal": ("array", " [W]"),
                      f"{name}.hydraulicSystemParameters.AZone": ("array", " [m^2]"),
                      f"{name}.hydraulicSystemParameters.hZone": ("array", " [m]"),
                      f"{name}.hydraulicSystemParameters.ABui": ("single", " [m^2]"),
                      f"{name}.hydraulicSystemParameters.hBui": ("single", " [m]"),
                      f"{name}.hydraulicSystemParameters.TOda_nominal": ("single", " [K]"),
                      f"{name}.hydraulicSystemParameters.TSup_nominal": ("array", " [K]"),
                      f"{name}.hydraulicSystemParameters.TZone_nominal": ("array", " [K]"),
                      f"{name}.hydraulicSystemParameters.TAmb": ("single", " [K]"),
                      f"{name}.hydraulicSystemParameters.ARoo": ("single", " [m^2]"),
                      f"{name}.hydraulicSystemParameters.mDHW_flow_nominal": ("single", " [kg/s]"),
                      f"{name}.hydraulicSystemParameters.TDHW_nominal": ("single", " [K]"),
                      f"{name}.hydraulicSystemParameters.TDHWCold_nominal": ("single", " [K]"),
                      f"{name}.hydraulicSystemParameters.VDHWDay": ("single", " [m^3]"),
                      f"{name}.hydraulicSystemParameters.QDHW_flow_nominal": ("single", " [W]"),
                      f"{name}.hydraulicSystemParameters.tCrit": ("single", " [s]"),
                      f"{name}.hydraulicSystemParameters.QCrit": ("single", " [kwh]")}
    elif subsystem == "hydraulic.generation":
        parameters = {f"{name}.Q_flow_nominal": ("array", " [W]"),
                      f"{name}.TOda_nominal": ("single", " [K]"),
                      f"{name}.TDem_nominal": ("array", " [K]"),
                      f"{name}.TAmb": ("single", " [K]"),
                      f"{name}.dpDem_nominal": ("array", " [Pa]")}
    elif subsystem == "hydraulic.distribution":
        parameters = {f"{name}.Q_flow_nominal": ("array", " [W]"),
                      f"{name}.TOda_nominal": ("single", " [K]"),
                      f"{name}.TDem_nominal": ("array", " [K]"),
                      f"{name}.TAmb": ("single", " [K]"),
                      f"{name}.mDHW_flow_nominal": ("single", " [kg/s]"),
                      f"{name}.QDHW_flow_nominal": ("single", " [W]"),
                      f"{name}.TDHW_nominal": ("single", " [K]"),
                      f"{name}.VDHWDay": ("single", " [m^3]"),
                      f"{name}.TDHWCold_nominal": ("single", " [K]"),
                      f"{name}.tCrit": ("single", " [s]"),
                      f"{name}.QCrit": ("single", " [kwh]"),
                      f"{name}.mSup_flow_nominal": ("array", " [kg/s]"),
                      # "hydraulic.generation.m_flow_nominal": ("array", " [kg/s] (mSup_flow_nominal)"),
                      f"{name}.mDem_flow_nominal": ("array", " [kg/s]")}
    elif subsystem == "hydraulic.transfer":
        parameters = {f"{name}.Q_flow_nominal": ("array", " [W]"),
                      f"{name}.TOda_nominal": ("single", " [K]"),
                      f"{name}.TDem_nominal": ("array", " [K]"),
                      f"{name}.TAmb": ("single", " [K]"),
                      f"{name}.TTra_nominal": ("array", " [K]"),
                      f"{name}.dpSup_nominal": ("array", " [Pa]"),
                      f"{name}.AZone": ("array", " [m^2]"),
                      f"{name}.hZone": ("array", " [m]"),
                      f"{name}.ABui": ("single", " [m^2]"),
                      f"{name}.hBui": ("single", " [m]")}
    elif subsystem == "ventilation.generation":
        parameters = {f"{name}.Q_flow_nominal": ("array", " [W]"),
                      f"{name}.TOda_nominal": ("single", " [K]"),
                      f"{name}.TDem_nominal": ("array", " [K]"),
                      f"{name}.TAmb": ("single", " [K]"),
                      f"{name}.dpDem_nominal": ("array", " [Pa]")}
    elif subsystem == "ventilation.distribution":
        parameters = {f"{name}.Q_flow_nominal": ("array", " [W]"),
                      f"{name}.TOda_nominal": ("single", " [K]"),
                      f"{name}.TDem_nominal": ("array", " [K]"),
                      f"{name}.TAmb": ("single", " [K]")}
    else:
        raise ValueError(f"The top down parameters of the subsystem {subsystem} are not defined.")
    values = {}
    for para, info in parameters.items():
        unit = info[1].split("[")[-1].split("]")[0]
        if unit == "-":
            name_modelica_unit = para.split(".")[-1]
        else:
            name_modelica_unit = para.split(".")[-1] + f"(displayUnit=\"{unit}\")"
        if info[0] == "array":
            array_paras = search.get_key_names_form_dict_by_prefix(sim_api.states, para)
            array_values = "{"
            for name in array_paras:
                array_values += f"{str(sim_api.states[name].value)},"
            values[name_modelica_unit] = array_values[:-1] + "}"
        else:
            values[name_modelica_unit] = str(sim_api.states[para].value)
    print(f"Top-Down parameters of the subsystem {subsystem} in the model {sim_api.model_name}:")
    for name, value in values.items():
        print(f"{name} = {value},")


def get_parameter_value(sim_api, parameters: Union[str, List[str]]):
    if isinstance(parameters, str):
        parameters = [parameters]
    values = {}
    for para in parameters:
        values[para] = str(sim_api.states[para].value)
    for name, value in values.items():
        print(f"{name} = {value}")
    return values
