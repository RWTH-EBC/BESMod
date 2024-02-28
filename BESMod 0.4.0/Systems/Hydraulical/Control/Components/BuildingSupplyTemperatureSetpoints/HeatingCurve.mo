within BESMod.Systems.Hydraulical.Control.Components.BuildingSupplyTemperatureSetpoints;
model HeatingCurve
  "Defines supply temperature to building in dependency of ambient temperature"
  extends PartialSetpoint;
  Modelica.Blocks.Math.MinMax maxTZoneSet(final nu=nZones)
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));
protected
  parameter Modelica.Units.SI.Temperature TSupMea_nominal=
    (TSup_nominal + TRet_nominal) / 2 "Nominal mean temperature";
  Real derQRel = - 1 / (maxTZoneSet.yMax - TOda_nominal);

equation
  if TOda < maxTZoneSet.yMax then
    TSet = TSup_nominal + (derQRel * (TSupMea_nominal - maxTZoneSet.yMax) * 1 / nHeaTra +
            (TSup_nominal - TRet_nominal) / 2 * derQRel)
      * (TOda - TOda_nominal);
  else
    // No heating required.
    TSet = maxTZoneSet.yMax;
  end if;
  connect(maxTZoneSet.u, TZoneSet) annotation (Line(points={{-60,-70},{-84,-70},{-84,
          -80},{-120,-80}}, color={0,0,127}));
end HeatingCurve;
