within BESMod.Systems.Hydraulical.Control.Components.BuildingSupplyTemperatureSetpoints;
model IdealHeatingCurve "Ideal linear heating curve"
  extends BaseClasses.PartialSetpoint;
  Modelica.Blocks.Math.MinMax maxTZoneSet(final nu=nZones)
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));
  parameter Modelica.Units.SI.TemperatureDifference dTAddCon=0
    "Constant offset of ideal heating curve";
protected
  parameter Modelica.Units.SI.Temperature TSupMea_nominal=
    (TSup_nominal + TRet_nominal) / 2 "Nominal mean temperature";
  Real derQRel = - 1 / (maxTZoneSet.yMax - TOda_nominal);

equation
  if TOda < maxTZoneSet.yMax then
    TSet = TSup_nominal + dTAddCon + (derQRel * (TSupMea_nominal - maxTZoneSet.yMax) *
    1 / nHeaTra + (TSup_nominal - TRet_nominal) / 2 * derQRel) * (TOda - TOda_nominal);
  else
    // No heating required.
    TSet = maxTZoneSet.yMax + dTAddCon;
  end if;
  connect(maxTZoneSet.u, TZoneSet) annotation (Line(points={{-60,-70},{-84,-70},{-84,
          -80},{-120,-80}}, color={0,0,127}));
end IdealHeatingCurve;
