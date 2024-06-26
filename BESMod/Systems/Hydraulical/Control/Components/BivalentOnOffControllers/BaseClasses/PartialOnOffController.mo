within BESMod.Systems.Hydraulical.Control.Components.BivalentOnOffControllers.BaseClasses;
partial model PartialOnOffController "Partial model for an on off controller"

  parameter Modelica.Units.SI.TemperatureDifference dTHys
    "Hysteresis for control";

  Modelica.Blocks.Interfaces.RealInput TStoTop
    "Top layer temperature of the storage in distribution system" annotation (
      Placement(transformation(extent={{-140,40},{-100,80}}), iconTransformation(
          extent={{-120,60},{-100,80}})));
  Modelica.Blocks.Interfaces.BooleanOutput priGenOn(start=true)
    "Turn the main the device on or off" annotation (Placement(transformation(
          extent={{100,50},{120,70}}), iconTransformation(extent={{100,56},{128,
            84}})));
  Modelica.Blocks.Interfaces.RealInput TSupSet "Set point temperature"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={0,-118}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,-110})));
  Modelica.Blocks.Interfaces.RealInput TStoBot
    "Supply temperature of the lower layers of the storage. Does not have to be the lowest layer, depending on comfort even the top may be selected"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}}),
        iconTransformation(extent={{-120,-60},{-100,-40}})));
  Modelica.Blocks.Interfaces.BooleanOutput secGenOn(start=true)
    "Turn the auxilliar heater on or off" annotation (Placement(transformation(
          extent={{100,-70},{120,-50}}), iconTransformation(extent={{100,-64},{
            128,-36}})));
  Modelica.Blocks.Interfaces.RealInput TOda "Ambient air temperature" annotation (
     Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,120}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,112})));
  Modelica.Blocks.Interfaces.RealOutput ySecGenSet(start=1)
    "Setpoint of the auxilliar heater" annotation (Placement(transformation(
          extent={{100,-90},{120,-70}}), iconTransformation(extent={{100,-100},{
            128,-72}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5)}), Diagram(graphics,
                                        coordinateSystem(preserveAspectRatio=
            false)));
end PartialOnOffController;
