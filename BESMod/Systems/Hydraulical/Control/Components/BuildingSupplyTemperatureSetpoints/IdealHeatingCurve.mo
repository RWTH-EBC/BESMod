within BESMod.Systems.Hydraulical.Control.Components.BuildingSupplyTemperatureSetpoints;
model IdealHeatingCurve "Ideal linear heating curve"
  extends BaseClasses.PartialSetpoint;
  Modelica.Blocks.Math.MinMax maxTZoneSet(final nu=nZones)
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));
  parameter Modelica.Units.SI.TemperatureDifference dTAddCon=0
    "Constant offset of ideal heating curve";
  parameter Modelica.Units.SI.Temperature THeaThr=293.15 "Heating threshold temeperature";

  replaceable function heaCur =
    BESMod.Systems.Hydraulical.Control.Components.BuildingSupplyTemperatureSetpoints.BaseClasses.Functions.ConstantGradientHeatCurve
    constrainedby BESMod.Systems.Hydraulical.Control.Components.BuildingSupplyTemperatureSetpoints.BaseClasses.Functions.PartialHeatingCurve
    "Linearization approach"
    annotation(choicesAllMatching=true);
protected
  parameter Modelica.Units.SI.Temperature TSupMea_nominal=
    (TSup_nominal + TRet_nominal) / 2 "Nominal mean temperature";
  Real derQRel = - 1 / (maxTZoneSet.yMax - TOda_nominal);

equation
  if TOda < maxTZoneSet.yMax then
    TSet = heaCur(TOda, THeaThr, maxTZoneSet.yMax, TSup_nominal, TRet_nominal, TOda_nominal, nHeaTra);
  else
    // No heating required.
    TSet = maxTZoneSet.yMax + dTAddCon;
  end if;
  connect(maxTZoneSet.u, TZoneSet) annotation (Line(points={{-60,-70},{-84,-70},{-84,
          -80},{-120,-80}}, color={0,0,127}));
end IdealHeatingCurve;
