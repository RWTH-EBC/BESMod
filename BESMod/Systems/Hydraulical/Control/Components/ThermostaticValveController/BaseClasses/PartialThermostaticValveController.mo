within BESMod.Systems.Hydraulical.Control.Components.ThermostaticValveController.BaseClasses;
partial model PartialThermostaticValveController
 parameter Integer nZones(min=1) "Number of zones";
 parameter Real leakageOpening = 0.0001
    "may be useful for simulation stability. Always check the influence it has on your results";

  Modelica.Blocks.Interfaces.RealInput TZoneMea[nZones]
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  Modelica.Blocks.Interfaces.RealOutput opening[nZones]
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));
  Modelica.Blocks.Interfaces.RealInput TZoneSet[nZones]
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5)}),                                  Diagram(
        coordinateSystem(preserveAspectRatio=false)), Documentation(info="<html>
<p>
This is the base class model for thermostatic valve controllers. 
It defines basic interface requirements and parameters that should 
be implemented by any extending model. 
The model defines inputs for measured and setpoint zone temperatures and 
outputs valve opening positions.
</p>
</html>"));
end PartialThermostaticValveController;
