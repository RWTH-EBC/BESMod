"""
Module to emulate control signals in order to test
the casadi model
"""
import agentlib as al
from agentlib.core import Agent

from ebcpy import TimeSeriesData


class ControlEmulatorModuleConfig(al.BaseModuleConfig):
    emulation_path: str
    time_step: float
    outputs: al.AgentVariables = []


class ControlEmulatorModule(al.BaseModule):
    config: ControlEmulatorModuleConfig

    def register_callbacks(self):
        pass

    def __init__(self, *, config: dict, agent: Agent):
        super().__init__(config=config, agent=agent)
        # disturbance data
        self.emulations = TimeSeriesData(self.config.emulation_path).to_df()

    def process(self):
        """Sets a new prediction at each time step."""
        while True:
            now = self.env.now
            j = self.emulations.index.get_indexer([now], method='nearest').item()

            for output in self.config.outputs:
                single_dist_measurement = self.emulations[output.name].iloc[j]
                self.set(output.name, single_dist_measurement)
                self.logger.debug("Sending control emulation %s=%s with alias %s",
                                  output.name, single_dist_measurement, output.alias)

            yield self.env.timeout(self.config.time_step)
