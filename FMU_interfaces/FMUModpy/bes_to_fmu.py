import pathlib
from typing import Union, List
from ebcpy import FMU_API, DymolaAPI, TimeSeriesData
# import .variable_search as search
import FMUModpy.variable_search as search


def generate_inputs(sim_api, save_path, sim_setup, variables, variables_prefix=None):
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
        name_unit = para.split(".")[-1] + info[1]
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
    return values


def get_parameter_value(sim_api, parameters: Union[str, List[str]]):
    if isinstance(parameters, str):
        parameters = [parameters]
    values = {}
    for para in parameters:
        values[para] = str(sim_api.states[para].value)
    for name, value in values.items():
        print(f"{name} = {value}")
    return values




if __name__ == "__main__":
    # can't finde hydraulic.gerneration.sigBusGen in dym_api only in fmu
    # dym_api = DymolaAPI(
    #     cd=r'D:\sbg-hst\Repos\BESMod\working_dir',
    #     model_name="BESMod.Examples.UseCaseModelicaConferencePaper.TEASERBuilding",
    #     packages=[r"D:\sbg-hst\Repos\BESMod\installed_dependencies\IBPSA\IBPSA\package.mo",
    #               r"D:\sbg-hst\Repos\BESMod\installed_dependencies\AixLib\AixLib\package.mo",
    #               r"D:\sbg-hst\Repos\BESMod\installed_dependencies\BuildingSystems\BuildingSystems\package.mo",
    #               r"D:\sbg-hst\Repos\BESMod\BESMod\package.mo"],
    #     show_window=True
    # )
    fmu_api = FMU_API(cd=pathlib.Path(__file__).parent.joinpath("results"),
                      model_name=pathlib.Path(__file__).parent.joinpath("models",
                                                                        "TEASERBuilding_noVen_Tsen.fmu"))
    example_bes = BES(fmu_api)

    example_bes.get_top_down_parameters("hydraulic.generation")
    example_bes.get_top_down_parameters("hydraulic.distribution")
    example_bes.get_top_down_parameters("hydraulic.transfer")
    # example_bes.get_top_down_parameters("ventilation.generation")
    # example_bes.get_top_down_parameters("ventilation.distribution")
    example_bes.get_top_down_parameters("hydraulic")

    # example_bes.get_parameter_value(["ventilation.generation.m_flow_nominal[1]",
    #                                  "ventilation.distribution.TSup_nominal[1]"])

    save_path = pathlib.Path(__file__).parent.joinpath("data", "TEASERBuilding_data_hydraulic.csv")
    # single_variables = ["hydraulic.generation.portGen_in[1].m_flow",
    #                     "hydraulic.generation.weaBus.TDryBul"]
    # single_variables = ["hydraulic.transfer.portTra_in[1].m_flow",
    #                     "hydraulic.transfer.portTra_in[1].p",
    #                     "hydraulic.transfer.portTra_out[1].m_flow",
    #                     "hydraulic.transfer.portTra_out[1].p",
    #                     "hydraulic.transfer.heatPortRad[1].T",
    #                     "hydraulic.transfer.heatPortRad[1].Q_flow",
    #                     "hydraulic.transfer.heatPortCon[1].T",
    #                     "hydraulic.transfer.heatPortCon[1].Q_flow",
    #                     "hydraulic.transfer.outBusTra.T_out[1]",
    #                     "hydraulic.distribution.sigBusDistr.TStoBufBotMea",
    #                     "hydraulic.transfer.outBusTra.T_in[1]",
    #                     "hydraulic.distribution.sigBusDistr.TStoBufTopMea",
    #                     "hydraulic.transfer.traControlBus.opening[1]"]
    single_variables = ["hydraulic.generation.sigBusGen.uPump"]
    sim_setup = {"start_time": 0,
                 "stop_time": 604800,
                 "output_interval": 600}
    example_bes.auto_gen_inputs(save_path=save_path,
                                sim_setup=sim_setup,
                                subsystem="hydraulic")
    # example_bes.generate_inputs(
    #     save_path=save_path,
    #     variables=single_variables,
    #     variables_prefix="hydraulic.generation.sigBusGen",
    #     sim_setup=sim_setup
    # )

    example_bes.close()
