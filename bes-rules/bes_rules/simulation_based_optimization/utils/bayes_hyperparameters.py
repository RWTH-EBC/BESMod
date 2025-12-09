import json
import logging
import os
from pathlib import Path

import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
from scipy.interpolate import LinearNDInterpolator, NearestNDInterpolator
from scipy.interpolate import interp1d

from scipy.stats import uniform
from sklearn.gaussian_process import GaussianProcessRegressor
from sklearn.gaussian_process.kernels import Matern
from sklearn.model_selection import RandomizedSearchCV, GridSearchCV
from sklearn.preprocessing import MinMaxScaler
from sklearn.model_selection import ShuffleSplit

logger = logging.getLogger(__name__)


def tune_hyperparameters(
        variables: dict,
        number_of_iterations: int,
        path_training_data: Path,
        save_path: Path,
        randomized_search: bool = False,
        n_per_grid_per_dimension: int = 25,
        use_new_cv: bool = False
) -> dict:
    """
    Tune Gaussian Process hyperparameters using RandomizedSearchCV.

    Parameters:
    variables (dict): A dictionary containing variable names as keys and their respective
                      hyperparameter ranges (length scales) as values.
    optimization_variables (list): A list of column names to be used as input features.
    number_of_iterations (int): Number of iterations for the RandomizedSearchCV.
    path_training_data (Path): Path to the Excel file containing training data.
    save_path (Path): Path to save the results and figures.

    Returns:
    dict: A dictionary containing the best hyperparameters for each variable.
    """
    best_hyperparams_dict = {}
    os.makedirs(save_path, exist_ok=True)
    i_obj = 0
    # Loop through each variable defined in the input dictionary
    results = {}
    for objective, opt_variables_length_scale in variables.items():
        logger.info("Tune objective %s/%s: %s", i_obj + 1, len(variables), objective)
        i_obj += 1
        optimization_variables = list(opt_variables_length_scale.keys())

        # Read training data from Excel
        df = pd.read_excel(path_training_data)

        # Use the provided optimization variable names
        X = df[optimization_variables].values
        y = df[objective].values

        # Extract length scales dynamically from the variable dictionary
        length_scales = []
        for opt_variable_length_scale in opt_variables_length_scale.values():
            length_scales.append(opt_variable_length_scale[0])

        # Define the Gaussian Process kernel
        kernel = Matern(length_scale=length_scales, nu=2.5)

        _param_name = "kernel__length_scale"

        # Initialize the Gaussian Process Regressor
        gp = GaussianProcessRegressor(kernel=kernel, optimizer=None)

        if use_new_cv:
            cv = ShuffleSplit(
                n_splits=10,  # Number of different random splits to try
                train_size=int(len(df) * 0.25),
                test_size=None,  # Use remaining samples for validation
                random_state=42
            )
        else:
            cv = 5


        if randomized_search:
            # Define the parameter distribution for the Randomized Search
            param_dist = {
                _param_name: uniform(
                    loc=length_scales,
                    scale=[scale[1] - scale[0] for scale in opt_variables_length_scale.values()]
                )
            }
            # Perform Randomized Search for hyperparameter tuning
            searcher = RandomizedSearchCV(
                gp, scoring="neg_mean_squared_error",
                param_distributions=param_dist,
                n_iter=number_of_iterations, cv=cv
            )
        else:
            length_scales = [np.linspace(scale[0], scale[1], n_per_grid_per_dimension)
                             for scale in opt_variables_length_scale.values()]
            # Create the mesh grid
            ls0_mesh, ls1_mesh = np.meshgrid(*length_scales)
            # Convert the mesh to a list of tuples for sklearn
            length_scale_combinations = list(zip(ls0_mesh.flatten(), ls1_mesh.flatten()))
            param_grid = {_param_name: length_scale_combinations}
            # Perform Grid Search for hyperparameter tuning
            searcher = GridSearchCV(
                gp, scoring="neg_mean_squared_error",
                param_grid=param_grid,
                cv=cv
            )
        searcher.fit(X, y)

        hyperparams = searcher.cv_results_["params"]
        scores = searcher.cv_results_["mean_test_score"]  # Negative mean squared error

        def _get_param(params, idx):
            if isinstance(params[_param_name], float):
                return params[_param_name]
            return params[_param_name][idx]

        # Prepare results DataFrame
        results_df = pd.DataFrame({
            **{
                optimization_variable: [_get_param(params, idx) for params in hyperparams]
                for idx, optimization_variable in enumerate(optimization_variables)
            },
            "Mean Squared Error": -scores
        })

        # Save results to Excel
        output_file_path = save_path.joinpath(f"{objective}.xlsx")
        results_df.to_excel(output_file_path, index=False)
        results[objective] = results_df
        # Extract the best hyperparameters
        best_hyperparams = hyperparams[searcher.best_index_]
        best_hyperparams_dict[objective] = {
            optimization_variable: _get_param(best_hyperparams, idx)
            for idx, optimization_variable in enumerate(optimization_variables)
        }

        # Plot the results in 3D for hyperparameters vs MSE
        for i in range(1, len(optimization_variables)):
            fig = plt.figure(figsize=(10, 8))
            ax = fig.add_subplot(111, projection="3d")
            scatter = ax.scatter(
                results_df[optimization_variables[0]],
                results_df[optimization_variables[i]],
                results_df["Mean Squared Error"],
                c=results_df["Mean Squared Error"],
                cmap="viridis",
                alpha=0.7
            )

            ax.set_xlabel(optimization_variables[0])
            ax.set_ylabel(optimization_variables[i])
            ax.set_zlabel("Mean Squared Error")
            ax.set_title(f"MSE vs {optimization_variables[0]} and {optimization_variables[i]}")

            cbar = plt.colorbar(scatter, ax=ax)
            cbar.set_label("Mean Squared Error")

            # Save the 3D scatter plot
            hyperparam_plot_filename = f"{objective}_3Dscatter_{optimization_variables[i]}.png"
            hyperparam_plot_file_path = save_path.joinpath(hyperparam_plot_filename)
            plt.savefig(hyperparam_plot_file_path, dpi=300)
            plt.close()  # Close the figure to prevent display

    json_output_path = save_path.joinpath("best_hyperparameters.json")
    with open(json_output_path, "w") as json_file:
        json.dump(best_hyperparams_dict, json_file, indent=4)

    return best_hyperparams_dict, results


def autotune_hyperparameters(
        objectives: list,
        optimization_variables: list,
        path_training_data: Path,
        save_path: Path,
        max_iterations: int = 5,
        percentage_to_include: int = 20,
        use_new_cv: bool = False,
        randomized_search: bool = False
):
    import copy
    default_scales = [1, 2000]
    default_length_scales = {variable: default_scales for variable in optimization_variables}
    variables = {
        objective: copy.deepcopy(default_length_scales)
        for objective in objectives
    }
    percentage_convergence_step = percentage_to_include / (max_iterations - 1)
    all_results = {objective: [] for objective in variables}
    for i in range(max_iterations):
        logger.info("Iteration %s/%s: %s", i + 1, max_iterations, variables)
        best_hyp, results_df = tune_hyperparameters(
            variables=variables,
            number_of_iterations=500,
            path_training_data=path_training_data,
            save_path=save_path.joinpath(f"iter_{i}"),
            use_new_cv=use_new_cv,
            randomized_search=randomized_search
        )
        # Update variables:
        for objective, paras in best_hyp.items():
            all_results[objective].append(results_df[objective])
            for opt_var, best_value in paras.items():
                variables[objective][opt_var] = [
                    best_value * (1 - percentage_to_include / 100),
                    best_value * (1 + percentage_to_include / 100)
                ]
        percentage_to_include -= percentage_convergence_step
        percentage_to_include = max(percentage_to_include, 1)

    with open(save_path.joinpath("best_hyperparameters.json"), "w") as json_file:
        json.dump(best_hyp, json_file, indent=4)
    print(best_hyp)
    for objective in objectives:
        pd.concat(all_results[objective]).to_excel(save_path.joinpath(_get_res_name(objective)))


def _get_res_name(name):
    return f"{name}_all_results.xlsx"


def autotune_for_multiple_scenarios(results_path: Path, save_path: Path):
    objectives = [
        "SCOP_Sys",
        "outputs.hydraulic.gen.heaPum.numSwi",
    ]
    optimization_variables = [
        "parameterStudy.TBiv",
        "parameterStudy.VPerQFlow",
    ]

    # Create or load data:
    objective_results = {objective: [] for objective in objectives}
    scenario_names = []
    for file in os.listdir(results_path):
        if not (file.startswith("TRY") and file.endswith(".xlsx")):
            continue
        save_path_scenario = save_path.joinpath(file.replace(".xslx", ""))
        os.makedirs(save_path_scenario, exist_ok=True)
        if not all([os.path.exists(save_path_scenario.joinpath(_get_res_name(objective))) for objective in objectives]):
            autotune_hyperparameters(
                objectives=objectives,
                optimization_variables=optimization_variables,
                path_training_data=results_path.joinpath(file),
                save_path=save_path_scenario,
                max_iterations=4,
                randomized_search=False,
                use_new_cv=True
            )
        scenario_names.append(save_path_scenario.stem)
        for objective in objectives:
            objective_results[objective].append(pd.read_excel(save_path_scenario.joinpath(_get_res_name(objective))))

    for objective, scenario_results in objective_results.items():
        save_path_obj = save_path.joinpath(objective)
        os.makedirs(save_path_obj, exist_ok=True)
        performance_matrix, all_optimal_params = find_robust_hyperparameters_via_interpolation(
            scenario_results=scenario_results,
            param_cols=optimization_variables,
            save_path_plot=save_path_obj
        )
        df = pd.DataFrame(
            data=performance_matrix,
            index=scenario_names,
            columns=scenario_names
        )
        df.loc[:, "Mittelwert"] = np.array([np.mean(row.values) for _, row in df.iterrows()])
        df.loc[:, "Maximum"] = np.array([np.max(row.values) for _, row in df.iterrows()])
        for variable in optimization_variables:
            df.loc[:, variable] = [optimal_params[variable] for optimal_params in all_optimal_params]
        df.to_excel(
            save_path_obj.joinpath("HyperparameterPerformance.xlsx")
        )


def find_robust_hyperparameters_via_interpolation(scenario_results, param_cols, save_path_plot: Path):
    """
    Find robust hyperparameters by interpolating each scenario's performance
    at the optimal points of other scenarios.

    Parameters:
    -----------
    scenario_results : list of DataFrames
        Each DataFrame contains hyperparameter optimization results for one scenario
    param_cols : list of str
        Names of columns containing hyperparameters
    save_path_plot: Path
        If a plot should be created

    Returns:
    --------
    DataFrame with robust hyperparameter candidates and their cross-scenario performance
    """
    n_scenarios = len(scenario_results)

    # Create interpolators for each scenario
    interpolators = []
    metric = "Mean Squared Error"
    for i, results in enumerate(scenario_results):
        # Extract parameters and metric
        X = results[param_cols].values
        y = results[metric].values
        if len(param_cols) == 1:
            interpolators.append(interp1d(X[:, 0], y, kind="linear", bounds_error=False, fill_value=np.mean(y)))
        else:
            interpolators.append(LinearNDInterpolator(X, y))

    # For each parameter set, interpolate performance across all scenarios
    performance_matrix = np.zeros((n_scenarios, n_scenarios))
    latex_labels = {
        "parameterStudy.TBiv": "$l_{T_\mathrm{Biv}}$",
        "parameterStudy.VPerQFlow": "$l_{v_\mathrm{\dot{Q}_{Geb}}}$",
    }
    param_names = []
    all_optimal_params = []
    for i, results in enumerate(scenario_results):
        # Collect all optimal parameter combinations from all scenarios
        optimal_params = results.loc[results.loc[:, metric].argmin(), param_cols]
        param_names.append(
            ",".join([f"{latex_labels[name]}={value:.1E}" for name, value in optimal_params.to_dict().items()])
        )
        all_optimal_params.append(optimal_params)
        print(", ".join([str(value) for value in optimal_params]))
    for i, optimal_params in enumerate(all_optimal_params):
        for j, interpolator in enumerate(interpolators):
            performance_matrix[i, j] = interpolator(optimal_params)[0]
    if save_path_plot is not None:
        # Plot
        fig, ax = plot_performance_matrix(
            performance_matrix,
            scenario_names=None,  # Will use defaults
            param_names=param_names,
            metric_name="$MSE$ in -",
            cmap="viridis"
        )
        fig.savefig(save_path_plot.joinpath("HyperparameterPerformance.png"))

    return performance_matrix, all_optimal_params


def plot_performance_matrix(performance_matrix, scenario_names=None, param_names=None,
                            cmap="viridis", metric_name="Performance"):
    from bes_rules.plotting import get_figure_size, EBCColors, utils
    plot_config = utils.load_plot_config()
    # Create default labels if none provided
    n_params, n_scenarios = performance_matrix.shape

    if scenario_names is None:
        scenario_names = [f"Case {i + 1}" for i in range(n_scenarios)]

    # Create figure and axes
    fig, ax = plt.subplots(figsize=get_figure_size(2, 1))

    # Plot heatmap
    im = ax.imshow(performance_matrix, cmap=cmap, aspect='auto')

    # Add colorbar
    cbar = plt.colorbar(im, ax=ax)
    cbar.set_label(metric_name)

    # Set ticks and labels
    ax.set_xticks(np.arange(n_scenarios))
    ax.set_yticks(np.arange(n_params))
    ax.set_xticklabels(scenario_names, rotation=45)
    ax.set_yticklabels(param_names)

    fig.tight_layout()
    return fig, ax


if __name__ == "__main__":
    from bes_rules import RESULTS_FOLDER

    logging.basicConfig(level="INFO")

    autotune_for_multiple_scenarios(
        save_path=RESULTS_FOLDER.joinpath("BayesHyperparametersCornerPointsGridNewCvTest"),
        results_path=RESULTS_FOLDER.joinpath("storages_biv_corner_points")
    )
    # Example usage
    autotune_hyperparameters(
        objectives=[
            "SCOP_Sys",
            "costs_total",
            "outputs.hydraulic.gen.heaPum.numSwi",
        ],
        optimization_variables=[
            "parameterStudy.TBiv",
            "parameterStudy.VPerQFlow",
            # "parameterStudy.ShareOfPEleNominal"
        ],
        path_training_data=RESULTS_FOLDER.joinpath(
            "RE_Journal", "BESCtrl", "DesignOptimizationResults",
            "TRY2015_536322100078_Jahr_B1994_retrofit_SingleDwelling_M_South",
            "DesignOptimizerResults.xlsx"),
        save_path=RESULTS_FOLDER.joinpath("BayesHyperparameters")
    )
