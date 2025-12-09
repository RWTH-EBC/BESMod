import pandas as pd

from .objective import TimeSeriesDependentObjective, BaseObjectiveMapping


class GridInteractionMapping(BaseObjectiveMapping):
    electric_power_demand: str = "outputs.electrical.dis.PEleLoa.value"


class GridInteractionObjective(TimeSeriesDependentObjective):

    mapping: GridInteractionMapping = GridInteractionMapping()
    peak_bound: float = 5000.0

    def calc_tsd(self, df: pd.DataFrame, time_step: float, results_last_point: dict = None) -> dict:
        # df_copy = df.copy()
        # df_copy.to_datetime_index(unit_of_index="s")
        # df_copy.clean_and_space_equally(desired_freq="60s")
        # times_greater_peak = df_copy.loc[:, (self.mapping.electric_power_demand, "raw")] > self.peak_bound
        # time_counter_peak = np.count_nonzero(times_greater_peak)
        # time_counter = len(df_copy.loc[:, self.mapping.electric_power_demand])
        # time_proc = (time_counter_peak / time_counter * 100)
        electric_power_demand = self.get_values_or_last_point(
            variable=self.mapping.electric_power_demand, df=df, results_last_point=results_last_point
        )
        return {
            #"W-Peak-Time": time_proc,
            "Max-Power-Peak": electric_power_demand.max()
        }

    def get_objective_names(self):
        return [
            "Max-Power-Peak",
            #"W-Peak-Time"
        ]
