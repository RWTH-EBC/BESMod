from .annuity import Annuity
from .tewi import TEWI
from .scop import SCOP
from .objective import BaseObjective, BaseObjectiveMapping, TimeSeriesDependentObjective
from .miscellaneous import Miscellaneous
from .grid_interaction import GridInteractionObjective
from .mean_temperature import MeanTemperatureKPI


def get_all_objectives(as_dict: bool = False):
    objectives = [
        Annuity(),
        TEWI(),
        SCOP(),
        Miscellaneous()
    ]
    if as_dict:
        return {obj.__class__.__name__: obj for obj in objectives}
    return objectives


def get_time_series_dependent_objectives():
    return [
        GridInteractionObjective()
    ]
