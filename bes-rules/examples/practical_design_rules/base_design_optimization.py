from bes_rules import configs, STARTUP_BESMOD_MOS
from bes_rules.simulation_based_optimization.utils import constraints


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
    from bes_rules.configs.plotting import PlotConfig
    plot_settings = dict(
        plot_config=PlotConfig.load_default(),
        y_variables=y_variables
    )

    return configs.SimulationConfig(
        startup_mos=STARTUP_BESMOD_MOS,
        model_name=f"BESRules.DesignOptimization.{model}",
        sim_setup=dict(stop_time=86400 * n_days, output_interval=time_step),
        equidistant_output=equidistant_output,
        plot_settings=plot_settings,
        dymola_api_kwargs={"time_delay_between_starts": 5},
        result_names=["scalingFactor"],
        **kwargs
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
        **obj_kwargs
    )


def extend_input_configs_with_modifiers(
        inputs_config_corner: configs.InputsConfig,
        modifiers: list,
        is_evu: bool = False
):
    weathers = []
    buildings = []
    users = []
    dhw_profiles = []
    all_modifiers = []

    for modifier in modifiers:
        weathers.extend(inputs_config_corner.weathers)
        buildings.extend(inputs_config_corner.buildings)
        users.extend(inputs_config_corner.users)
        dhw_profiles.extend(inputs_config_corner.dhw_profiles)
        all_modifiers.extend([modifier] * len(inputs_config_corner.weathers))

    kwargs = dict(
        full_factorial=False,
        weathers=weathers,
        buildings=buildings,
        users=users,
        dhw_profiles=dhw_profiles,
    )
    if is_evu:
        return configs.InputsConfig(
            evu_profiles=all_modifiers,
            **kwargs
        )
    return configs.InputsConfig(
        modifiers=all_modifiers,
        **kwargs
    )
