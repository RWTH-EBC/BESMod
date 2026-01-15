import pathlib
import string
import ast


def parse_modelica_record(path):
    constants = {}
    with open(path) as f:
        for i, line in enumerate(f):
            try:
                line = line.translate({ord(c): None for c in string.whitespace})[:-1]
                line = line.replace("{", "[")
                line = line.replace("}", "]")
                name, value = line.split("=")
                if value == 'true':  # Evaluate Booleans
                    constants[name] = True
                elif value == 'false':
                    constants[name] = False
                elif value.startswith('['):
                    value = ast.literal_eval(value)  # Evaluate Lists
                    if len(value) == 1:
                        constants[name] = value[0]
                    else:
                        constants[name] = value
                else:
                    constants[name] = float(value)  # Evaluate Floats
            except:
                continue

    return constants


def load_modelica_file_modifier(file: pathlib.Path):
    file = str(file).replace("\\", "//")
    return f'Modelica.Utilities.Files.loadResource("{file}")'
