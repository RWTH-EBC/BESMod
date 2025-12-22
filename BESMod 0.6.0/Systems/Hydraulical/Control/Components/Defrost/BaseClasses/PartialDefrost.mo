within BESMod.Systems.Hydraulical.Control.Components.Defrost.BaseClasses;
partial model PartialDefrost "Partial model for defrost control"

  AixLib.Fluid.HeatPumps.ModularReversible.BaseClasses.RefrigerantMachineControlBus
    sigBus "Bus with the most relevant information for hp frosting calculation"
    annotation (Placement(transformation(extent={{-128,-20},{-88,20}}),
        iconTransformation(extent={{-130,-108},{-90,-68}})));
  Modelica.Blocks.Interfaces.BooleanOutput hea "Heating mode for heat pump"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
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
end PartialDefrost;
