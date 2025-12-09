from pathlib import Path
from bes_rules import RESULTS_FOLDER

PATH_OED_BOTH = RESULTS_FOLDER.joinpath("UseCase_TBivAndV", "input_analysis", "dhw", "OED_both")
USE_CASE_DESIGN_PATH = Path(__file__).parent
MPC_UTILS_PATH = USE_CASE_DESIGN_PATH.joinpath("mpc_utils")
