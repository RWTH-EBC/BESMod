from pathlib import Path
import json
import os.path
import warnings
warnings.simplefilter(action='ignore', category=FutureWarning)


REPO_ROOT = Path(__file__).absolute().parents[1]
PC_SPECIFIC_SETTING_PATH = REPO_ROOT.joinpath("pc_specific_settings.json")
DATA_PATH = REPO_ROOT.joinpath("data")
STARTUP_BESMOD_MOS = REPO_ROOT.parent.joinpath("startup.mos")

if os.path.exists(PC_SPECIFIC_SETTING_PATH):
    with open(PC_SPECIFIC_SETTING_PATH, "r") as file:
        PC_SPECIFIC_SETTINGS = json.load(file)
    STARTUP_BESMOD_MOS = Path(PC_SPECIFIC_SETTINGS["STARTUP_BESMOD_MOS"])
    DATA_PATH = Path(PC_SPECIFIC_SETTINGS["DATA_PATH"])
    N_CPU = PC_SPECIFIC_SETTINGS["N_CPU"]
    RESULTS_FOLDER = Path(PC_SPECIFIC_SETTINGS["RESULTS_FOLDER"])
else:
    if not os.path.exists(STARTUP_BESMOD_MOS):
        raise FileNotFoundError("Please create a pc_specific_settings.json, did not find BESMod startup. See ReadMe!")
    N_CPU = 1
    RESULTS_FOLDER = Path.home().joinpath("Results_BESRules")
