from typing import List

import numpy as np
from sklearn.linear_model import LinearRegression
from bes_rules.plotting.utils import PlotConfig


class Regressor:
    """Class to build regression models"""

    @staticmethod
    def get_parameters(x: np.ndarray, y: np.ndarray) -> np.ndarray:
        raise NotImplementedError

    @staticmethod
    def eval(x: np.ndarray, parameters: np.ndarray) -> np.ndarray:
        raise NotImplementedError

    @staticmethod
    def get_equation_string(
            design_variable: str,
            feature_names: List[str],
            parameters: np.ndarray,
            plot_config: PlotConfig
    ) -> str:
        raise NotImplementedError

    @property
    def name(self):
        return self.__class__.__name__.replace("Regressor", "")


class LinearRegressor(Regressor):

    @staticmethod
    def get_parameters(x: np.ndarray, y: np.ndarray) -> np.ndarray:
        model = LinearRegression().fit(x.transpose(), y)
        parameters = np.array(list(model.coef_) + [model.intercept_])
        return parameters

    @staticmethod
    def eval(x: np.ndarray, parameters: np.ndarray) -> np.ndarray:
        return parameters[-1] + np.sum([x[i] * parameters[i] for i in range(len(x))], axis=0)

    @staticmethod
    def get_equation_string(
            design_variable: str,
            feature_names: List[str],
            parameters: np.ndarray,
            plot_config: PlotConfig
    ) -> str:
        design_variable, feature_names = rename_according_to_plot_config(
            design_variable, feature_names, plot_config
        )
        sum_string = " + ".join(
            f"{feature_name} $\\cdot$ {parameter:.1e}"
            for feature_name, parameter in zip(feature_names, parameters[:-1])
        )
        return f"{design_variable} = {parameters[-1]:.1e} + {sum_string}"


class PowerLawRegressor(Regressor):

    @staticmethod
    def get_parameters(x: np.ndarray, y: np.ndarray) -> np.ndarray:
        return LinearRegressor.get_parameters(transform(x), transform(y))

    @staticmethod
    def eval(x: np.ndarray, parameters: np.ndarray) -> np.ndarray:
        return np.exp(LinearRegressor.eval(transform(x), parameters))

    @staticmethod
    def get_equation_string(
            design_variable: str,
            feature_names: List[str],
            parameters: np.ndarray,
            plot_config: PlotConfig
    ) -> str:
        from bes_rules.rule_extraction import innovization
        feature_offsets = [innovization.get_feature_offset(feature) for feature in feature_names]
        design_variable, feature_names = rename_according_to_plot_config(
            design_variable, feature_names, plot_config
        )

        def _possibly_add(feature, offset):
            if offset == 0:
                return feature
            return f"({offset} + {feature})"

        product = " $\\cdot$  ".join(
            _possibly_add(feature_name[:-1], offset) + "^{" + f"{parameter:.1e}" + "}$"
            for feature_name, offset, parameter in zip(feature_names, feature_offsets, parameters[:-1])
        )
        return f"{design_variable} = {product} $\\cdot$ {np.exp(parameters[-1]):.1e}"


class PolynomialRegressor(Regressor):

    @staticmethod
    def get_parameters(x: np.ndarray, y: np.ndarray, n_order: int = 2) -> np.ndarray:
        ret: np.ndarray = np.polyfit(x, y, n_order)
        return ret

    @staticmethod
    def eval(x: np.ndarray, parameters: np.ndarray):
        n_order = len(parameters) - 1
        result: np.ndarray = x ** n_order * parameters[0]
        for idx, par in enumerate(parameters[1:]):
            result += x ** (n_order - idx - 1) * par
        return result


def rename_according_to_plot_config(
        design_variable: str,
        feature_names: List[str],
        plot_config: PlotConfig
):
    return (
        plot_config.get_label(design_variable),
        [plot_config.get_label(feature_name) for feature_name in feature_names]
    )


def transform(x: np.ndarray):
    if x.min() <= 0:
        raise ValueError(
            "Regression data contains values smaller or equal to zero, "
            "can't perform linearized power law regression"
        )
    else:
        return np.log(x)
