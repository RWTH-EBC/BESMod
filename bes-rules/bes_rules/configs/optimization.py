from __future__ import annotations
from typing import List, Union, Optional
from pydantic import ConfigDict, BaseModel, Field, field_validator, FieldValidationInfo

import pandas as pd


class OptimizationConstraint(BaseModel):

    name: str

    def apply(self, df: pd.DataFrame, input_config, set_to_nan: bool = False) -> pd.DataFrame:
        """Applies the constraint on the given DataFrame"""
        raise NotImplementedError


class OptimizationVariable(BaseModel):
    name: str  # Name of parameter in Modelica code
    lower_bound: Union[float, int]
    upper_bound: Union[float, int]
    levels: int = Field(
        title="Number of levels for this variable, in case of a ffd.",
        default=2,
        ge=1
    )
    discrete_steps: float = Field(
        default=0.0,
        title="If greater than 0, this is used instead of levels using np.arange"
    )
    discrete_values: Optional[List[float]] = Field(
        default=[],
        title="If not empty, these discrete values will be studied"
    )


class OptimizationConfig(BaseModel):
    framework: str
    method: str
    solver_settings: dict = {}
    objective_names: list = []
    variables: List[OptimizationVariable]
    multi_objective: Optional[bool] = Field(default=None, validate_default=True)
    weightings: Optional[list] = Field(default=None, validate_default=True)
    constraints: Optional[List[OptimizationConstraint]] = []
    model_config = ConfigDict(arbitrary_types_allowed=True)

    @field_validator("multi_objective")
    @classmethod
    def check_mo(cls, mo, info: FieldValidationInfo):
        n_var = len(info.data["objective_names"])
        if n_var < 2:
            return False
        if mo is None:
            raise TypeError("You have to specify if you are using multi- "
                            "or single-objective if specifying more than 1 objective.")
        return mo

    @field_validator("weightings")
    @classmethod
    def check_weightings(cls, weightings, info: FieldValidationInfo):
        n_var = len(info.data["objective_names"])

        if weightings is None:
            if info.data["multi_objective"] or n_var == 0:
                return None
            return [1 / n_var] * n_var
        assert len(weightings) == n_var, "Weightings not equal to length of objective names"
        assert sum(weightings) == 1, "Weightings sum is not 1"
        return weightings

    def get_variable_names(self):
        return [var.name for var in self.variables]
