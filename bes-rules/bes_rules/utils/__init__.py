

def check_unique_keys(*args):
    all_keys = []
    for arg in args:
        assert isinstance(arg, dict), "Arguments must be type dict"
        all_keys.extend(list(arg.keys()))
    if len(set(all_keys)) != len(all_keys):
        raise KeyError("Multiple dicts have same keys. Can't merge!")


def save_merge_dicts(*args):
    check_unique_keys(*args)
    merged = {}
    for arg in args:
        merged.update(arg)
    return merged



def create_or_append_list(d: dict, key, value):
    if key in d:
        d[key].append(value)
    else:
        d[key] = [value]
    return d
