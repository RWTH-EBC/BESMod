within BESMod.BESRules.BaseClasses;
partial model PartialBESRulesSystem
  "Partial system for BESRules with 2D table data"
  extends BESMod.Systems.BaseClasses.PartialBuildingEnergySystem(
    redeclare replaceable
      BESMod.BESRules.DesignOptimization.DesignOptimizationVariables parameterStudy,
    redeclare replaceable BESMod.Systems.UserProfiles.TEASERInputsStoIntGai userProfiles,
    final use_openModelica=true,
    redeclare BESMod.BESRules.BaseClasses.SystemParameters systemParameters(
        QBui_flow_nominal=building.QRec_flow_nominal, THydSup_nominal=fill(
          THyd_nominal, systemParameters.nZones)),
    redeclare final package MediumDHW = AixLib.Media.Water,
    redeclare final package MediumZone = AixLib.Media.Air,
    redeclare final package MediumHyd = AixLib.Media.Water,
    weaDat(final computeWetBulbTemperature=true),
    redeclare BESMod.Systems.Ventilation.NoVentilation ventilation,
    hydraulic(energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial));
  parameter Modelica.Units.SI.Temperature THyd_nominal=273.15 + 55
                                                                 "Nominal radiator temperature";
  parameter Modelica.Units.SI.TemperatureDifference dTHyd_nominal=10 "Nominal radiator temperature difference";
  parameter Modelica.Units.SI.Temperature TOpeEnvAtBiv_nominal=Modelica.Constants.inf
    "Maximum temperature the heat pump can supply at TBiv, default disables the constraint";
  parameter Modelica.Units.SI.Temperature THydAtBiv_nominal=min(TOpeEnvAtBiv_nominal,
      BESMod.Systems.Hydraulical.Control.Components.BuildingSupplyTemperatureSetpoints.BaseClasses.Functions.ConstantGradientHeatCurve(
      parameterStudy.TBiv,
      parameterStudy.THeaThr,
      max(systemParameters.TSetZone_nominal),
      THyd_nominal,
      THyd_nominal - dTHyd_nominal,
      systemParameters.TOda_nominal,
      hydraulic.transfer.nHeaTra))
        "Nominal radiator temperature at bivalent temperature";
equation
  connect(userProfiles.useProBus, outputs.user) annotation (Line(
      points={{-225.167,150.775},{-144,150.775},{-144,172},{285,172},{285,0}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(weaDat.weaBus, outputs.weather) annotation (Line(
      points={{-220,70},{-214,70},{-214,170},{285,170},{285,0}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  annotation (experiment(
      StopTime=31536000,
      Interval=600,
      __Dymola_Algorithm="Dassl"));
end PartialBESRulesSystem;
