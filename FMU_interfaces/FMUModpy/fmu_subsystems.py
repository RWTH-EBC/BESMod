import pathlib
import FMUModpy.variable_search as search
from ebcpy import FMU_API, TimeSeriesData
import pandas as pd


def get_info(fmu_api, data=None):
    """
    Prints relevant information useful for the set-up of a simulation of a model in an FMU-interface.
    :param fmu_api:
        FMU_api of the model in the FMU-interface-
    :param data:
        TimeSeriesData to use vor inputs.
    """
    input_names_fmu = list(fmu_api.inputs.keys())
    output_names_fmu = list(fmu_api.outputs.keys())

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


def define_input_data(input_pairs, data):
    """
        Function for creating input_data where the variables are renamed with the input pairs,
        which match the names of the measured data to the
        required names of the data of the FMU
        :param dict input_pairs:
            A dictionary to pair the names of measured data to the names of the input.
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



