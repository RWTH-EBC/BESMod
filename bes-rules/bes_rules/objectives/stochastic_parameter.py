from pydantic import field_validator, BaseModel
import numpy as np


class StochasticParameter(BaseModel):
    """
    Class for a stochastic parameter with a given
    mean and variation value. Specifying the type of
    distribution enables the use of the value in
    stochastic optimization.
    """

    value: float
    distribution: str = "uniform"
    distribution_kwargs: dict = {}

    @field_validator("distribution")
    @classmethod
    def check_valid_distribution(cls, distribution):
        assert distribution in ["uniform", "norm"], f"Distribution {distribution} not implemented"
        return distribution

    def __add__(self, other):
        return self.value + other

    def __radd__(self, other):
        return other + self.value

    def __sub__(self, other):
        return self.value - other

    def __rsub__(self, other):
        return other - self.value

    def __mul__(self, other):
        return self.value * other

    def __rmul__(self, other):
        return other * self.value

    def __truediv__(self, other):
        return self.value / other

    def __rtruediv__(self, other):
        return other / self.value

    def __pow__(self, power, modulo=None):
        return self.value ** power

    def __rpow__(self, other):
        return other ** self.value

    def get_random_values(self, n_samples: int):
        if self.distribution == "uniform":
            return np.random.uniform(
                self.distribution_kwargs.get("lower_bound", self.value),
                self.distribution_kwargs.get("upper_bound", self.value),
                n_samples)
        if self.distribution == "norm":
            return np.random.normal(
                self.value,
                self.distribution_kwargs.get("sigma", 0),
                n_samples
            )


if __name__ == '__main__':
    print(StochasticParameter(value=5, distribution="uniform"))
