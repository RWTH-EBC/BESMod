within BESMod.Systems.UserProfiles.BaseClasses;
partial model PartialUserProfiles
  "Partial model for replaceable user profiles"

  parameter Integer nZones=1 "Number of zones to transfer heat to"  annotation(Dialog(group="Top-Down"));

  parameter Modelica.Units.SI.Temperature TSetZone_nominal[nZones]=fill(293.15,
      nZones) "Nominal set temerature of zones"
    annotation (Dialog(group="Top-Down"));

  BESMod.Systems.Interfaces.UseProBus useProBus annotation (
      Placement(transformation(extent={{80,-34},{150,32}}), iconTransformation(
          extent={{80,-34},{150,32}})));

  IBPSA.BoundaryConditions.WeatherData.Bus
      weaBus "Weather data bus" annotation (Placement(transformation(extent={{-34,
            -148},{36,-90}}),    iconTransformation(extent={{-36,-152},{36,-82}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-120,
            -120},{120,120}}),
                         graphics={
        Text(
          extent={{-196,136},{190,24}},
          lineColor={0,0,0},
          textString="%name%
"),     Polygon(points={{-118,-96},{-118,-96}}, lineColor={28,108,200}),
        Bitmap(extent={{-96,-96},{90,92}}, fileName="modelica://BESMod/Resources/Images/Users.png")}),
      Diagram(graphics,
              coordinateSystem(preserveAspectRatio=false, extent={{-120,-120},
            {120,120}})));
end PartialUserProfiles;
