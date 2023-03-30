def get_key_names_form_dict_by_prefix(mydict, prefix, use_upper_lower=True, n_results=False):
    if not use_upper_lower:
        prefix = prefix.lower()
        res = [key for key, val in mydict.items() if key.lower().startswith(prefix)]
    else:
        res = [key for key, val in mydict.items() if key.startswith(prefix)]
    if n_results:
        print(len(res))
    return res


def get_key_names_form_dict_which_contain(mydict, substrings):
    # nicht funktionfähig für mehrere Substrings
    if type(substrings) is list:
        res = [key for key, val in mydict.items() if substrings[0] in key]
        substrings.pop(0)
        for sub in substrings:
            res = [key for key in res if sub in key]
    else:
        res = [key for key, val in mydict.items() if substrings in key]
    print(len(res))
    return res


def get_variable_names_by_prefix(mylist, prefix, additional_substings=None):
    res = [v for v in mylist if v.startswith(prefix)]
    print(f"Number of names with specified prefix {len(res)}")
    if additional_substings is not None:
        for sub in additional_substings:
            res = [key for key in res if sub in key]
        print(f"Number of names with specified prefix and Subsrtings {len(res)}")
    return res


def get_variable_names_which_contain(mylist, substring):
    res = [key for key in mylist if substring in key]
    return res


def get_suffix_of_dymola_variable_name(dymola_variable_name):
    def get_suffix(name):
        index_last_dot = name.rfind('.')
        suffix = name[index_last_dot + 1:]
        return suffix

    if type(dymola_variable_name) is list:
        variable_names = []
        for n in dymola_variable_name:
            variable_names.append(get_suffix(n))
        return variable_names
    else:
        variable_name = get_suffix(dymola_variable_name)
        return variable_name
