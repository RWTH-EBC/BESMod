import json
import pathlib

from bes_rules import STARTUP_BESMOD_MOS
from bes_rules import configs, boundary_conditions
from bes_rules.configs.plotting import PlotConfig
from bes_rules.input_variations import run_input_variations
from bes_rules.simulation_based_optimization.utils import constraints
from bes_rules.rule_extraction.surrogates.bayes import load_best_hyperparameters


def get_inputs_config_to_simulate(modifiers: list = None, years_of_construction: list = None):
    weathers = boundary_conditions.weather.get_weather_configs_by_names(region_names=["Potsdam"])
    buildings_per_year = boundary_conditions.building.get_all_tabula_sfh_buildings(as_dict=True)
    if years_of_construction is None:
        years_of_construction = buildings_per_year.keys()
    buildings_to_simulate = [
        buildings_per_year[f"{year}_standard"] for year in years_of_construction
    ]
    dhw_profiles = [{"profile": "M"}]
    return configs.InputsConfig(
        full_factorial=True,
        weathers=weathers,
        buildings=buildings_to_simulate,
        dhw_profiles=dhw_profiles,
        modifiers=modifiers
    )


def run(
        study_name: str,
        base_path: pathlib.Path,
        n_cpu: int = 1,
        time_step: int = 900,
        surrogate_builder_kwargs: dict = {},
        surrogate_builder_class=None,
        model: str = "MonoenergeticVitoCal",
        use_bayes: bool = True
):
    sim_config = get_simulation_config(
        model=model,
        time_step=time_step,
        convert_to_hdf_and_delete_mat=True,
        recalculate=False,
        equidistant_output=True
    )

    optimization_config = get_optimization_config(
        configs.OptimizationVariable(
            name="parameterStudy.TBiv",
            lower_bound=273.15 - 20,
            upper_bound=278.15 if use_bayes else 279.15,  # For FFD plan to include 5 °C
            discrete_steps=1
        ),
        configs.OptimizationVariable(
            name="parameterStudy.VPerQFlow",
            lower_bound=5,
            upper_bound=50,
            levels=6,
        ),
        use_bayes=use_bayes,
        n_iter=25
    )

    inputs_config = get_inputs_config_to_simulate()
    config = configs.StudyConfig(
        base_path=base_path,
        n_cpu=n_cpu,
        name=study_name,
        simulation=sim_config,
        optimization=optimization_config,
        inputs=inputs_config,
        test_only=False
    )
    run_input_variations(
        config=config, run_inputs_in_parallel=use_bayes,
        surrogate_builder_class=surrogate_builder_class,
        **surrogate_builder_kwargs
    )


def get_optimization_config(*variables: configs.OptimizationVariable, **kwargs):
    obj_kwargs = dict(
        constraints=[
            constraints.BivalenceTemperatureGreaterNominalOutdoorAirTemperature(),
            constraints.HydraulicSeperatorConstraint()  # Only active if modifier is passed
        ],
        variables=variables
    )
    use_bayes = kwargs.get("use_bayes", False)
    if not use_bayes:
        return configs.OptimizationConfig(framework="doe", method="ffd", **obj_kwargs)

    return configs.OptimizationConfig(
        framework="bayes",
        method="Not implemented",
        solver_settings={
            "allow_duplicate_points": False,
            "hyperparameters": kwargs["hyperparameters"],
            "n_iter": kwargs.get("n_iter", 21),
            "scale_variables": False
        },
        objective_names=["SCOP_Sys"],
        hyperparameters=load_best_hyperparameters(),
        **obj_kwargs
    )


def get_simulation_config(
        model: str,
        time_step: int = 600,
        n_days: int = 365,
        equidistant_output: bool = True,
        **kwargs):
    y_variables = {
        "$T_\mathrm{Oda}$ in °C": "outputs.weather.TDryBul",
        "$T_\mathrm{Room}$ in °C": ["outputs.building.TZone[1]", "outputs.user.TZoneSet[1]"],
        "$y_\mathrm{Val}$ in %": "outputs.hydraulic.tra.opening[1]",
        "$T_\mathrm{DHW}$ in °C": ["outputs.hydraulic.disCtrl.TStoDHWBotMea",
                                   "outputs.hydraulic.disCtrl.TStoDHWTopMea"],
        "$T_\mathrm{Buf}$ in °C": ["outputs.hydraulic.disCtrl.TStoBufBotMea",
                                   "outputs.hydraulic.disCtrl.TStoBufTopMea"],
        "$T_\mathrm{HeaPum}$ in °C": ["outputs.hydraulic.genCtrl.THeaPumIn",
                                      "outputs.hydraulic.genCtrl.THeaPumOut"],
        # "$COP$ in -": "outputs.hydraulic.genCtrl.COP",
        "$y_\mathrm{HeaPum}$ in %": "outputs.hydraulic.genCtrl.yHeaPumSet",
        "$\dot{Q}_\mathrm{DHW}$ in kW": "outputs.DHW.Q_flow.value",
        "$\dot{Q}_\mathrm{Bui}$ in kW": "outputs.building.eneBal[1].traGain.value",
        "$P_\mathrm{el,HeaPum}$": "outputs.hydraulic.gen.PEleHeaPum.value",
        "$P_\mathrm{el,EleHea}$": "outputs.hydraulic.gen.PEleEleHea.value"
    }
    plot_settings = dict(
        plot_config=PlotConfig.load_default(),
        y_variables=y_variables
    )

    return configs.SimulationConfig(
        startup_mos=STARTUP_BESMOD_MOS,
        model_name=f"BESMod.BESRules.DesignOptimization.{model}",
        sim_setup=dict(stop_time=86400 * n_days, output_interval=time_step),
        equidistant_output=equidistant_output,
        plot_settings=plot_settings,
        dymola_api_kwargs={"time_delay_between_starts": 5},
        result_names=["scalingFactor"],
        **kwargs
    )

