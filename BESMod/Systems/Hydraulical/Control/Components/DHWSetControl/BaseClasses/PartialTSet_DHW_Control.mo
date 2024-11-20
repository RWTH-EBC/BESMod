within BESMod.Systems.Hydraulical.Control.Components.DHWSetControl.BaseClasses;
partial model PartialTSet_DHW_Control "Model to output the dhw set temperature"
  parameter Modelica.Units.SI.Temperature TSetDHW_nominal
    "Nominal DHW set temperature";
  Modelica.Blocks.Interfaces.RealOutput TSetDHW(unit="K", displayUnit="degC")
    "DHW set temperature"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Systems.Hydraulical.Interfaces.DistributionControlBus sigBusDistr
    "Necessary to control DHW temperatures"
    annotation (Placement(transformation(extent={{-114,-14},{-86,12}})));
  Modelica.Blocks.Interfaces.BooleanOutput
                                  y "Set auxilliar heater to true"
    annotation (Placement(transformation(extent={{100,-68},{120,-48}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5), Text(
          extent={{-128,28},{124,-18}},
          lineColor={28,108,200},
          lineThickness=1,
          textString="%name")}),                                 Diagram(graphics,
        coordinateSystem(preserveAspectRatio=false)), Documentation(info="<html>
<p>Partial model for domestic hot water (DHW) set temperature control.</p>
<p>This model provides the basic structure to output a DHW set temperature and a 
boolean signal for auxiliary heating. It is meant to be extended by other models 
implementing specific control strategies.</p>
</html>"));
end PartialTSet_DHW_Control;
