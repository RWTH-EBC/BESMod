import pathlib
from typing import Union
from FMUModpy.bes_to_fmu import get_top_down_parameters, generate_inputs
from FMUModpy.fmu_subsystems import get_info
from ebcpy import FMU_API, DymolaAPI

# define relevant paths
working_dir = pathlib.Path(__file__).parent.joinpath("working_dir")
models_path = working_dir.joinpath("models")
data_path = working_dir.joinpath("data")


def main(bes_sim_api: Union[FMU_API, DymolaAPI],
         subsystem: str,
         module_fmu: Union[str, pathlib.Path] = None,
         bes_inputs_names: [str] = None,
         bes_inputs_prefixes: [str] = None):
    # Get the top-down parameters of the subsystem form a bes model.
    # They can then be copied to the model of the FMU-Interface from
    # the desired subsystem. After that the model of the subsystem in
    # the FMU-interface can be exported from Dymola and copied to the
    # models folder in the working dir.
    get_top_down_parameters(sim_api=bes_sim_api, subsystem=subsystem)

    # We can now use the fmu model of the subsystem to get the info
    # which data are needed for the simulation of the model and
    # generate them with simulation of the complete bes simulation
    # from which we use the subsystem.
    if module_fmu:
        # load the fmu in the FMUInterface class which gives us some
        # functions to easily use the models
        fmu = FMU_API(model_name=module_fmu, cd=data_path)

        # Get the info of the needed data
        get_info(fmu)

    if bes_inputs_names:
        name_for_save_str = subsystem.replace(".", "_")
        sim_setup = {"start_time": 0,
                     "stop_time": 604800,
                     "output_interval": 600}
        generate_inputs(
            sim_api=bes_sim_api,
            save_path=data_path.joinpath(f"inputs_{name_for_save_str}.csv"),
            sim_setup=sim_setup,
            variables=bes_inputs_names,
            variables_prefix=bes_inputs_prefixes)


if __name__ == "__main__":
    # can't find hydraulic.gerneration.sigBusGen in dym_api only in fmu
    # dym_api = DymolaAPI(
    #     cd=r'D:\sbg-hst\Repos\BESMod\working_dir',
    #     model_name="BESMod.Examples.UseCaseModelicaConferencePaper.TEASERBuilding",
    #     packages=[r"D:\sbg-hst\Repos\BESMod\installed_dependencies\IBPSA\IBPSA\package.mo",
    #               r"D:\sbg-hst\Repos\BESMod\installed_dependencies\AixLib\AixLib\package.mo",
    #               r"D:\sbg-hst\Repos\BESMod\installed_dependencies\BuildingSystems\BuildingSystems\package.mo",
    #               r"D:\sbg-hst\Repos\BESMod\BESMod\package.mo"],
    #     show_window=True
    # )
    bes_fmu_api = FMU_API(cd=working_dir.parent.joinpath("results"),
                          model_name=models_path.joinpath("TEASERBuilding_noVen_Tsen.fmu"))

    subsystem = "hydraulic.transfer"  # choose one of the predefined fmu models of the subsystems
    module_fmu = None
    variables = None
    prefixes = None

    # predefined fmu models of subsystem from the UseCaseModelicaConference example using the TEASERBuilding.
    # Also defining the names in the bes simulation for the input generation of each model, where the
    # described workflow in the main function was used.
    if subsystem == "hydraulic":
        module_fmu = models_path.joinpath(
            "BESMod_Systems_Hydraulical_FMIHydraulicSystemModelicaConferenceUseCase_xml.fmu")
        variables = ["hydraulic.portDHW_out.m_flow",
                     "hydraulic.portDHW_out.p",
                     "hydraulic.T_DisToDHW.T",
                     "hydraulic.portDHW_in.m_flow",
                     "hydraulic.portDHW_in.p",
                     "hydraulic.T_DHWToDis.T",
                     "hydraulic.heatPortCon[1].T",
                     "hydraulic.heatPortCon[1].Q_flow",
                     "hydraulic.heatPortRad[1].T",
                     "hydraulic.heatPortRad[1].Q_flow",
                     "hydraulic.weaBus.TDryBul",
                     "hydraulic.buiMeaBus.TZoneMea[1]",
                     "hydraulic.useProBus.TZoneSet[1]"]
        prefixes = ["hydraulic.sigBusHyd"]
    elif subsystem == "hydraulic.generation":
        module_fmu = models_path.joinpath(
            "BESMod_Systems_Hydraulical_Generation_FMIHeatPumpAndHeatingRod.fmu"
        )
        variables = ["hydraulic.generation.portGen_in[1].m_flow",
                     "hydraulic.generation.weaBus.TDryBul"]
        prefixes = ["hydraulic.generation.sigBusGen",
                    "hydraulic.generation.outBusGen"]
    elif subsystem == "hydraulic.distribution":
        module_fmu = models_path.joinpath(
            "BESMod_Systems_Hydraulical_Distribution_FMIDistributionTwoStorageParallel.fmu"
        )
        variables = ["hydraulic.distribution.sigBusDistr.uThrWayVal",
                     "hydraulic.distribution.portGen_in[1].m_flow",
                     "hydraulic.distribution.portGen_in[1].p",
                     "hydraulic.T_GenToDis[1].T",
                     "hydraulic.T_DisToGen[1].T",
                     "hydraulic.distribution.portBui_in[1].m_flow",
                     "hydraulic.distribution.portBui_in[1].p",
                     "hydraulic.T_TraToDis[1].T",
                     "hydraulic.T_DisToTra[1].T",
                     "hydraulic.distribution.portDHW_in.m_flow",
                     "hydraulic.distribution.portDHW_in.p",
                     "hydraulic.T_DHWToDis.T",
                     "hydraulic.T_DisToDHW.T"]
    elif subsystem == "hydraulic.transfer":
        module_fmu = models_path.joinpath(
            "BESMod_Systems_Hydraulical_Transfer_FMIIdealValveRadiator_xml.fmu"
        )
        variables = ["hydraulic.transfer.heatPortCon[1].T",
                     "hydraulic.transfer.heatPortCon[1].Q_flow",
                     "hydraulic.transfer.heatPortRad[1].T",
                     "hydraulic.transfer.heatPortRad[1].Q_flow",
                     "hydraulic.transfer.portTra_in[1].m_flow",
                     "hydraulic.transfer.portTra_in[1].p",
                     "hydraulic.T_DisToTra[1].T",
                     "hydraulic.transfer.portTra_out[1].p",
                     "hydraulic.T_TraToDis[1].T",
                     "hydraulic.transfer.traControlBus.opening[1]"]
    else:
        raise ValueError("No example fmu interface model for the subsystem defined.")

    main(bes_sim_api=bes_fmu_api,
         subsystem=subsystem,
         module_fmu=module_fmu,
         bes_inputs_names=variables,
         bes_inputs_prefixes=prefixes)
