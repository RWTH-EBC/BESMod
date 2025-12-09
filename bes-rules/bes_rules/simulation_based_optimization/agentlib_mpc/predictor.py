"""
Model taken from here
https://git-ce.rwth-aachen.de/ebc/projects/ACS_EBC0022_ERANET_I-Greta_bsc/optimization/-/tree/fwu-pkr
"""
import agentlib as al
import pandas as pd
from agentlib.core import Agent


class PredictorModuleConfig(al.BaseModuleConfig):
    """
    Module that outputs a prediction of the heat load at a specified interval.
    """
    send_measurements: bool = False
    send_predictions: bool = True
    outputs: al.AgentVariables = []
    parameters: al.AgentVariables = [
        al.AgentVariable(name="time_step", value=600,
                         description="Sampling time for prediction."),
        al.AgentVariable(name="prediction_horizon", value=8,
                         description="Number of sampling points for prediction."),
        al.AgentVariable(name="sampling_time", value=10,
                         description="Time between prediction updates."),
        al.AgentVariable(name="disturbances_path", value="benchmarks/cases/Hamburg_BJ1994/disturbances.csv",
                         description="Path to disturbance data.")
    ]


class PredictorModule(al.BaseModule):
    """Module that outputs a prediction at a specified interval."""

    config: PredictorModuleConfig

    def register_callbacks(self):
        pass

    def __init__(self, *, config: dict, agent: Agent):
        super().__init__(config=config, agent=agent)
        # disturbance data
        self.disturbances = pd.read_csv(self.get("disturbances_path").value, index_col=0, dtype=float)
        self.disturbances.interpolate(method="index", inplace=True)

    def process(self):
        """Sets a new prediction at each time step."""
        ts = self.get("time_step").value
        k = self.get("prediction_horizon").value
        sample_time = self.get("sampling_time").value

        outputs_to_send = [
            output.name.replace("_prediction", "").replace("_measurement", "")
            for output in self.config.outputs
        ]

        while True:
            now = self.env.now
            j = self.disturbances.index.get_indexer([now], method='nearest').item()
            i = self.disturbances.index.get_indexer([now + k * ts], method='nearest').item() + 1

            for label in outputs_to_send:
                if self.config.send_predictions:
                    single_dist_prediction = self.disturbances[label].iloc[j:i]
                    self.set(label + "_prediction", single_dist_prediction)
                if self.config.send_measurements:
                    single_dist_measurement = self.disturbances[label].iloc[j]
                    self.set(label + "_measurement", single_dist_measurement)

            yield self.env.timeout(sample_time)
