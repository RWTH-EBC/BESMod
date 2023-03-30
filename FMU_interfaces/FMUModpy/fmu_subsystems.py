import pathlib
import FMUModpy.variable_search as search
from ebcpy import FMU_API, TimeSeriesData
import pandas as pd


def get_info(fmu_api, data=None):
    input_names_fmu = list(fmu_api.inputs.keys())
    output_names_fmu = list(fmu_api.outputs.keys())

    setup_info_name = 'setup_info.txt'
    info_str = (
        f"inputs:\t{input_names_fmu}\n"
        f"outputs:{output_names_fmu}\n"
    )
    if data is not None:
        print("Simulation has index-frequency of %s with "
              "standard deviation of %s" % data.frequency)
        info_str = info_str + f"data:\t{data.get_variable_names()}\ntags:\t{data.get_tags()}\n" + \
                   f"index-frequency: {data.frequency[0]}; standard deviation: {data.frequency[1]}"
        partial_input_pairs_dict_str = "\ninput_pairs = {"
        for input_name in input_names_fmu:
            partial_input_pairs_dict_str += f"\n\t: \"{input_name}\","
        partial_input_pairs_dict_str += "\n}"
        info_str += partial_input_pairs_dict_str
    print(info_str)
    return info_str


def define_input_data(input_pairs, data):
    """
        Function for setting the input pairs, which match the names of the measured data to the
        required names of the data of the FMU
        :param dict input_pairs:
            A dictionary to pair the names of measured data to the names of the data.
            The dictionary has to follow the structure.
            ``input_pairs = {MEASUREMENT_NAME: FMU_INPUT_NAME}´´
        """
    input_data = data.loc[:, input_pairs.keys()]
    copy_input_pairs = input_pairs.copy()
    for key, val in input_pairs.items():
        if type(val) == list:
            for i in val:
                input_data = pd.concat([input_data, data.loc[:, [key]].rename(columns={key: i})],
                                       axis=1)
            input_data.pop(key)
            copy_input_pairs.pop(key)
    input_data.rename(columns=copy_input_pairs, inplace=True)
    return input_data


# def simulate(self, parameters=None) -> TimeSeriesData:
#     simulation_setup = {"start_time": self.input_data.index[0],
#                         "stop_time": self.input_data.index[-1],
#                         "output_interval": self.input_data.frequency[0]}
#
#     self.fmu_api.set_sim_setup(sim_setup=simulation_setup)
#
#     results = self.fmu_api.simulate(inputs=self.input_data,
#                                     parameters=parameters)
#     print(results)
#     return results


