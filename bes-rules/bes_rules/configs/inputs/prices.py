from typing import Optional, TYPE_CHECKING

from bes_rules.configs.inputs.base import BaseInputConfig
from bes_rules.objectives.annuity import Annuity, StochasticParameter

if TYPE_CHECKING:
    from bes_rules.configs import InputConfig
    from bes_rules.configs import StudyConfig


class Prices(BaseInputConfig):
    year: Optional[int] = None
    only_wholesale_price: Optional[bool] = False

    def get_modelica_modifier(self, input_config: "InputConfig"):
        return ""

    def get_name(self):
        if self.year is None:
            return ""
        _type = "Spot" if self.only_wholesale_price else ""
        return f"{self.year}{_type}"

    def get_c_grid(self, study_config: "StudyConfig"):
        for obj in study_config.objectives:
            if isinstance(obj, Annuity):
                if isinstance(obj.k_el, StochasticParameter):
                    c_grid_constant = obj.k_el
                else:
                    c_grid_constant = obj.k_el
                if isinstance(obj.k_el_feed_in, StochasticParameter):
                    c_feed_in_constant = obj.k_el_feed_in
                else:
                    c_feed_in_constant = obj.k_el_feed_in
                break
        else:
            raise ValueError("Annuity not found in objectives, "
                             "can't set c_grid or c_feed_in")
        if self.year is None:
            return c_grid_constant, c_feed_in_constant
        from bes_rules.boundary_conditions.prices import load_dynamic_electricity_prices

        c_grid = load_dynamic_electricity_prices(
            year=self.year,
            time_step=study_config.simulation.sim_setup["output_interval"],
            init_period=study_config.simulation.init_period,
            only_wholesale_price=self.only_wholesale_price
        )
        return c_grid, c_feed_in_constant
