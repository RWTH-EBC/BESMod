from abc import abstractmethod

from pydantic import BaseModel, ConfigDict


class BaseInputConfig(BaseModel):
    model_config = ConfigDict(
        arbitrary_types_allowed=True,
        extra="forbid",
        protected_namespaces=()
    )

    @abstractmethod
    def get_modelica_modifier(self, input_config: "InputConfig"):
        raise NotImplementedError

    def get_name(self):
        return "None"
