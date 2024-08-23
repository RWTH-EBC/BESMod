within BESMod.Systems.Hydraulical.Components.Frosting.BaseClasses;
partial model PartialFrosting
  "Partial model for frosting and defrost control"

  Modelica.Blocks.Interfaces.RealInput relHum
    "Input relative humidity of outdoor air" annotation (Placement(
        transformation(extent={{-140,60},{-100,100}}), iconTransformation(
          extent={{-140,56},{-100,96}})));
  AixLib.Fluid.HeatPumps.ModularReversible.BaseClasses.RefrigerantMachineControlBus
    genConBus
    "Bus with the most relevant information for hp frosting calculation"
    annotation (Placement(transformation(extent={{-128,-80},{-88,-40}}),
        iconTransformation(extent={{-130,-108},{-90,-68}})));
  Modelica.Blocks.Interfaces.RealOutput iceFacMea "Value of Real output"
    annotation (Placement(transformation(extent={{100,50},{120,70}})));
  Modelica.Blocks.Interfaces.BooleanOutput modeHeaPum "Value of Boolean output"
    annotation (Placement(transformation(extent={{100,-70},{120,-50}})));
  Modelica.Blocks.Interfaces.RealInput TOda "Outdoor air temperature" annotation (
     Placement(transformation(extent={{-140,-40},{-100,0}}), iconTransformation(
          extent={{-140,-16},{-100,24}})));
  Modelica.Blocks.Interfaces.RealInput QEva_flow "Evaporator heat flow"
    annotation (Placement(transformation(extent={{-140,10},{-100,50}}),
        iconTransformation(extent={{-140,-74},{-100,-34}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5), Text(
          extent={{-76,102},{66,66}},
          lineColor={28,108,200},
          textString="%name%")}),                                Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialFrosting;
