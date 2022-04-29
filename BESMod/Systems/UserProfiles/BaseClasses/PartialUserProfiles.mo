within BESMod.Systems.UserProfiles.BaseClasses;
partial model PartialUserProfiles
  "Partial model for replaceable user profiles"

  parameter Integer nZones=1 "Number of zones to transfer heat to"  annotation(Dialog(group="Top-Down"));

  parameter Modelica.Units.SI.Temperature TSetZone_nominal[nZones]=fill(293.15,
      nZones) "Nominal set temerature of zones"
    annotation (Dialog(group="Top-Down"));
  parameter Boolean use_dhw = true "= false to disable DHW" annotation(Dialog(group="Top-Down"));
  parameter Modelica.Units.SI.Temperature TSetDHW=323.15
    "Constant DHW demand temperature for design"
    annotation (Dialog(group="Top-Down", enable=use_dhw));
  parameter Modelica.Units.SI.Temperature TDHWWaterCold=283.15
    "Cold water temperature (new water)"
    annotation (Dialog(group="Top-Down", enable=use_dhw));
  parameter Modelica.Units.SI.MassFlowRate mDHW_flow_nominal
    "Nominal mass flow rate" annotation (Dialog(group="Bottom-Up", enable=use_dhw));
  parameter Modelica.Units.SI.Volume VolDHWDay "Average daily tapping volume"
    annotation (Dialog(group="Bottom-Up", enable=use_dhw));

  BESMod.Systems.Interfaces.UseProBus useProBus annotation (
      Placement(transformation(extent={{80,-34},{150,32}}), iconTransformation(
          extent={{80,-34},{150,32}})));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-120,
            -120},{120,120}}),
                         graphics={
        Text(
          extent={{-196,136},{190,24}},
          lineColor={0,0,0},
          textString="%name%
"),     Polygon(points={{-118,-96},{-118,-96}}, lineColor={28,108,200}),
        Bitmap(extent={{-96,-96},{90,92}}, fileName="modelica://BESMod/Resources/Images/Users.png")}),
      Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,-120},
            {120,120}})));
end PartialUserProfiles;
