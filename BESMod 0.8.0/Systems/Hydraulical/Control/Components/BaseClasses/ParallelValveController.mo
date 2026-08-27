within BESMod.Systems.Hydraulical.Control.Components.BaseClasses;
model ParallelValveController
  "Model to switch a three way valve based on device usage"
  Modelica.Blocks.Interfaces.BooleanInput priGen
    "=true if primary generator should be on"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));
  Modelica.Blocks.Interfaces.BooleanInput secGen
    "=true if secondary generator should be used"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  Modelica.Blocks.Interfaces.RealOutput uThrWayVal
    "1 for primary device, 0 for secondary device"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

equation
  if secGen and not priGen then
    uThrWayVal = 0;
  elseif priGen and not secGen then
    uThrWayVal = 1;
  else
    uThrWayVal = 0.5;
  end if;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                                        Text(
        extent={{-150,138},{150,98}},
        textString="%name",
        textColor={0,0,255}),   Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid)}),                        Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
  Model to controla three way valve in a 
  parallel configuration of two heating devives.
</p>
<p>
  If only one device is running, switch fully to that side. 
  Else, let the valve half open.
</p>
</html>"));
end ParallelValveController;
