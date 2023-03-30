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

    get_info(fmu_api=fmu, data=data)

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

    subsystem = "hydraulic.distribution"

    input_pairs = None
    goals = None

    if subsystem == "hydraulic":
        model_name = models_dir.joinpath(
            "BESMod_Systems_Hydraulical_FMIHydraulicSystemModelicaConferenceUseCase_xml.fmu")
        data_path = data_dir.joinpath("inputs_hydraulic.csv")
        input_pairs = {
            'hydraulic.heatPortCon[1].T': "TConIn[1]",
            'hydraulic.heatPortRad[1].T': "TRadIn[1]",
            'hydraulic.portDHW_in.m_flow': "portDHW_in.m_flow",
            'hydraulic.portDHW_in.p': "portDHW_in.p",
            'hydraulic.T_DHWToDis.T': "portDHW_in.forward.T",
            # 'hydraulic.T_DisToDHW.T': "portDHW_out.backward.T",
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
    else:
        raise ValueError("input pairs for the model not predefined")

    main(
        model_name=model_name,
        data_path=data_path,
        input_pairs=input_pairs,
        goals=goals
    )
