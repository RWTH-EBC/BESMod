within BESMod.Systems.Hydraulical.Control.Components.PumpController;
package BaseClasses

  partial model PartialPumpController
   parameter Real minSpeed = 0.1
      "may be useful for simulation stability. Always check the influence it has on your results";
   parameter Modelica.Units.SI.TemperatureDifference dTSet;

    Modelica.Blocks.Interfaces.RealInput TSup(each final unit="K", each final
        displayUnit="degC") "Supply temperatur"
      annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
    Modelica.Blocks.Interfaces.RealOutput yPum
      annotation (Placement(transformation(extent={{100,-20},{140,20}})));
    Modelica.Blocks.Interfaces.RealInput TRet(each final unit="K", each final
        displayUnit="degC") "Return Temperature"
      annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));

    Modelica.Blocks.Interfaces.BooleanInput GenOn
      annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(
            extent={{-100,100},{100,-100}},
            lineColor={0,0,0},
            fillColor={215,215,215},
            fillPattern=FillPattern.Solid,
            lineThickness=0.5)}),                                  Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end PartialPumpController;
end BaseClasses;
