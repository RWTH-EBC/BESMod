from sklearn.linear_model import LinearRegression
from sklearn.preprocessing import PolynomialFeatures
import numpy as np
import matplotlib.pyplot as plt

from bes_rules.utils.heat_pumps import load_vitocal250_COPs


def fit_linear_regression(variables: list, y: np.ndarray, show_plot: bool = True):
    X = np.column_stack(list(variables))
    model = LinearRegression().fit(X, y)
    r2_score = model.score(X, y)
    print(f"{r2_score=}")
    print(f"intercept = {model.intercept_}")
    print(f"coef = [{', '.join((str(v) for v in model.coef_))}]")
    if show_plot:
        plt.figure()
        plt.scatter(y, model.intercept_ + np.matmul(model.coef_, np.array(variables)))
        plt.show()


def create_variables_n_degree(degree, *x_arrays):
    X = np.column_stack(x_arrays)
    return PolynomialFeatures(degree=degree, include_bias=False).fit_transform(X).transpose()


def create_linear_regression(variables: dict, y: np.ndarray, y_name: str):
    X = np.column_stack(list(variables.values()))
    model = LinearRegression().fit(X, y)
    func_string = f"{y_name}={model.intercept_}+" + "+".join(
        [f"{model.coef_[i]}*{var_name}" for i, var_name in enumerate(variables)]
    )
    func_string_latex = f"{y_name}={model.intercept_:.2E}+" + "+".join(
        [f"{model.coef_[i]:.2E} \cdot " + var_name.replace('**', '^').replace('*', ' \cdot ') for i, var_name in enumerate(variables)]
    )
    r2_score = model.score(X, y)
    print(func_string)
    print(func_string_latex)
    print(f"{r2_score=}")
    plt.figure()
    plt.title(y_name)
    plt.scatter(y, model.predict(X))
    plt.plot([y.min(), y.max()], [y.min(), y.max()], color="black")
    plt.show()
    return func_string, r2_score


def plot_surface_of_function_fit(regression: callable, variable="QCon", version: str = "old"):
    # Create data points
    T_VL = np.array([
        308.15,
        318.15,
        328.15,
        338.15,
        343.15
    ])
    T_Oda = np.array([253.15, 258.15, 266.15, 275.15, 280.15, 283.15, 293.15, 303.15, 308.15])
    T_VL, T_Oda = np.meshgrid(T_VL, T_Oda)

    T_VL_mesh = np.linspace(308.15, 343.15, 1000)
    T_Oda_mesh = np.linspace(253.15, 308.15, 1000)
    T_VL_mesh, T_Oda_mesh = np.meshgrid(T_VL_mesh, T_Oda_mesh)
    extra = "_old" if version == "old" else ""

    # Calculate Z values
    if variable == "COP":
        df = load_vitocal250_COPs(f"cop_extrapolation{extra}")
    else:
        df = load_vitocal250_COPs(f"QConMax{extra}")
    Z_regression = regression(T_VL_mesh, T_Oda_mesh)

    def foo(T_Oda, T_VL):
        return df.loc[T_Oda, T_VL]

    foo_vector = np.vectorize(foo)
    Z_table = foo_vector(T_Oda, T_VL)

    # Create the 3D plot
    fig = plt.figure(figsize=(10, 8))
    ax = fig.add_subplot(111, projection='3d')

    # Plot the surface
    surf = ax.plot_surface(T_VL_mesh, T_Oda_mesh, Z_regression, cmap='viridis', edgecolor='none', label="regression")
    ax.scatter(T_VL, T_Oda, Z_table, color='black', edgecolor='none', label="table")

    # Add labels and title
    ax.set_xlabel('TVL')
    ax.set_ylabel('TOda')
    ax.set_zlabel(variable)
    ax.set_title(version)
    # Add colorbar
    fig.colorbar(surf)

    plt.show()
