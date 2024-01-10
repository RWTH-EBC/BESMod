within BESMod.Systems.Hydraulical.Control.Components.BuildingSupplyTemperatureSetpoints.BaseClasses;
model PartialSetpoint
  parameter Integer nZones "Number of heated zones";
  parameter Modelica.Units.SI.Temperature TSup_nominal
    "Nominal supply temperature";
  parameter Modelica.Units.SI.Temperature TRet_nominal
    "Nominal supply temperature";
  parameter Modelica.Units.SI.Temperature TOda_nominal
    "Nominal outdoor air temperature";
  parameter Real nHeaTra "Exponent of heat transfer system";
  Modelica.Blocks.Interfaces.RealOutput TSet(final unit="K", final displayUnit="degC")
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.RealInput TOda(final unit="K", final displayUnit="degC")
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealInput TZoneMea[nZones](each final unit="K",
      each final displayUnit="degC") "Zones temperatures measurements"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
  Modelica.Blocks.Interfaces.RealInput TZoneSet[nZones](each final unit="K",
      each final displayUnit="degC") "Zones set temperatures"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                             Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
                             Text(
          extent={{-100,230},{100,30}},
          lineColor={0,0,0},
          textString="%name")}),                                 Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialSetpoint;
