###
# Example of how to specify the inputs for the FMU-interfaces from data with not matching variable names.
# Test simulation of the models in the FMU-interfaces and comparison of some outputs
# with the data from the bes.
###

import pathlib
from ebcpy import FMU_API, TimeSeriesData
from FMUModpy.fmu_subsystems import get_info, define_input_data
import matplotlib.pyplot as plt

working_dir = pathlib.Path(__file__).parent.joinpath("working_dir")
result_dir = working_dir.joinpath("results")
models_dir = working_dir.joinpath("models")
data_dir = working_dir.joinpath("data")


def main(model_name,
         data_path,
         input_pairs=None,
         goals=None):

    fmu = FMU_API(model_name=model_name, cd=result_dir)
    data = TimeSeriesData(data_path)

    # use the get_info function with loaded data to assist with the defining of the input data.
    # You can copy the half finished dictonary input_pairs which is printed by the function
    # and copy past the variable names of the data as a key to their matching input of the fmu-interface.
    get_info(fmu_api=fmu, data=data)

    # simulate the FMU-interface and compare some outputs with the results of the bes data
    if input_pairs:
        input_data = define_input_data(input_pairs=input_pairs, data=data)
        simulation_setup = {"start_time": input_data.index[0],
                            "stop_time": input_data.index[-1],
                            "output_interval": input_data.frequency[0]}

        fmu.set_sim_setup(sim_setup=simulation_setup)

        results = fmu.simulate(inputs=input_data)
        results.save(result_dir.joinpath("hydraulic.csv"))
        print(results)
        if goals:
            fix, axes = plt.subplots(len(goals.keys()), 1, sharex='all')
            for idx, (key, item) in enumerate(goals.items()):
                axes[idx].plot(data[item["bes"]], 'b',
                               results[item["subsystem"]], '--r')
                axes[idx].set_ylabel(key)
                axes[idx].legend(["bes", "subsystem"])

            plt.show()


if __name__ == "__main__":

    # Choose a subsystem to set up and simulate
    subsystem = "hydraulic.distribution"

    input_pairs = None
    goals = None

    if subsystem == "hydraulic":
        # TODO: There is a bug in this system. The temperature output of the fluid to the dhw does not match.
        model_name = models_dir.joinpath(
            "BESMod_Systems_Hydraulical_FMIHydraulicSystemModelicaConferenceUseCase_xml.fmu")
        data_path = data_dir.joinpath("inputs_hydraulic.csv")
        input_pairs = {
            'hydraulic.heatPortCon[1].T': "TConIn[1]",
            'hydraulic.heatPortRad[1].T': "TRadIn[1]",
            'hydraulic.portDHW_in.m_flow': "portDHW_in.m_flow",
            'hydraulic.portDHW_in.p': "portDHW_in.p",
            'hydraulic.T_DHWToDis.T': "portDHW_in.forward.T",
            'hydraulic.useProBus.TZoneSet[1]': "useProBus.TZoneSet[1]",
            'hydraulic.sigBusHyd.TSetDHW': "sigBusHyd.TSetDHW",
            'hydraulic.sigBusHyd.overwriteTSetDHW': "sigBusHyd.overwriteTSetDHW",
            'hydraulic.buiMeaBus.TZoneMea[1]': "buiMeaBus.TZoneMea[1]",
            'hydraulic.weaBus.TDryBul': "weaBus.TDryBul"
        }
        goals = {"T_DHW_out": {"bes": 'hydraulic.T_DisToDHW.T', 'subsystem': 'portDHW_out.forward.T'},
                 "Q_flow_con": {"bes": 'hydraulic.heatPortCon[1].Q_flow', "subsystem": 'QflowConOut[1]'},
                 "Q_flow_rad": {"bes": 'hydraulic.heatPortRad[1].Q_flow', "subsystem": 'QflowRadOut[1]'}}
    elif subsystem == "hydraulic.generation":
        model_name = models_dir.joinpath(
            "BESMod_Systems_Hydraulical_Generation_FMIHeatPumpAndHeatingRod.fmu")
        data_path = data_dir.joinpath("inputs_hydraulic_generation.csv")
        input_pairs = {
            'hydraulic.generation.sigBusGen.uHeaRod': "sigBus.uHeaRod",
            'hydraulic.generation.sigBusGen.uPump': "sigBus.uPump",
            'hydraulic.generation.sigBusGen.yHeaPumSet': "sigBus.yHeaPumSet",
            'hydraulic.generation.weaBus.TDryBul': "weaBus.TDryBul",
            'hydraulic.generation.portGen_in[1].m_flow': "portGen_in[1].m_flow",
            'hydraulic.generation.sigBusGen.THeaPumIn': "portGen_in[1].forward.T",
        }
        goals = {"T_out": {"bes": 'hydraulic.generation.sigBusGen.THeaRodMea', "subsystem": 'sigBus.THeaRodMea'},
                 "PelHP": {"bes": 'hydraulic.generation.outBusGen.PEleHP.value', "subsystem": 'outBus.PEleHP.value'}}
    elif subsystem == "hydraulic.distribution":
        # TODO: There is a bug in this system. The temperature output of the fluid to the dhw does not match.
        model_name = models_dir.joinpath(
            "BESMod_Systems_Hydraulical_Distribution_FMIDistributionTwoStorageParallel.fmu")
        data_path = data_dir.joinpath("inputs_hydraulic_distribution.csv")
        input_pairs = {
            'hydraulic.distribution.sigBusDistr.uThrWayVal': "sigBusDistr.uThrWayVal",
            'hydraulic.distribution.portGen_in[1].m_flow': "portGen_in[1].m_flow",
            'hydraulic.distribution.portGen_in[1].p': "portGen_in[1].p",
            'hydraulic.T_GenToDis[1].T': "portGen_in[1].forward.T",
            'hydraulic.distribution.portBui_in[1].m_flow': "portBui_in[1].m_flow",
            'hydraulic.distribution.portBui_in[1].p': "portBui_in[1].p",
            'hydraulic.T_TraToDis[1].T': "portBui_in[1].forward.T",
            'hydraulic.distribution.portDHW_in.m_flow': "portDHW_in.m_flow",
            'hydraulic.distribution.portDHW_in.p': "portDHW_in.p",
            'hydraulic.T_DHWToDis.T': "portDHW_in.forward.T",
        }
        goals = {"T_out_gen": {"bes": 'hydraulic.T_DisToGen[1].T', "subsystem": 'portGen_out[1].forward.T'},
                 "T_out_bui": {"bes": 'hydraulic.T_DisToTra[1].T', "subsystem": 'portBui_out[1].forward.T'},
                 "T_out_dhw": {"bes": 'hydraulic.T_DisToDHW.T', "subsystem": 'portDHW_out.forward.T'}}
    elif subsystem == "hydraulic.transfer":
        model_name = models_dir.joinpath(
            "BESMod_Systems_Hydraulical_Transfer_FMIIdealValveRadiator_xml.fmu")
        data_path = data_dir.joinpath("inputs_hydraulic_transfer.csv")
        input_pairs = {
            'hydraulic.transfer.heatPortCon[1].T': "TConIn[1]",
            'hydraulic.transfer.heatPortRad[1].T': "TRadIn[1]",
            'hydraulic.transfer.portTra_in[1].m_flow': "portTra_in[1].m_flow",
            'hydraulic.T_DisToTra[1].T': "portTra_in[1].forward.T",
            'hydraulic.T_TraToDis[1].T': "portTra_out[1].backward.T",
            'hydraulic.transfer.traControlBus.opening[1]': "traControlBus.opening[1]",
            'hydraulic.transfer.portTra_in[1].p': "p_ref_in[1]",
        }
        goals = {"Q_con": {"bes": 'hydraulic.transfer.heatPortCon[1].Q_flow', "subsystem": 'QflowConOut[1]'},
                 "Q_rad": {"bes": 'hydraulic.transfer.heatPortRad[1].Q_flow', "subsystem": 'QflowRadOut[1]'},
                 "T_out": {"bes": 'hydraulic.T_TraToDis[1].T', "subsystem": 'portTra_out[1].forward.T'}}
    else:
        raise ValueError("input pairs for the model not predefined")

    main(
        model_name=model_name,
        data_path=data_path,
        input_pairs=input_pairs,
        goals=goals
    )
