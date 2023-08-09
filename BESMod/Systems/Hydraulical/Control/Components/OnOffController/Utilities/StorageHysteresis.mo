within BESMod.Systems.Hydraulical.Control.Components.OnOffController.Utilities;
block StorageHysteresis "On-off controller for a storage control."
  extends Modelica.Blocks.Icons.PartialBooleanBlock;
  Modelica.Blocks.Interfaces.RealInput T_set "Set temperature"
    annotation (Placement(transformation(extent={{-140,100},{-100,60}})));
  Modelica.Blocks.Interfaces.RealInput T_top
    "Connector of Real input signal used as measurement signal of upper level storage temperature"
    annotation (Placement(transformation(extent={{-140,20},{-100,-20}})));
  Modelica.Blocks.Interfaces.BooleanOutput y
    "Connector of Real output signal used as actuator signal"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

  parameter Real bandwidth(start=0.1) "Bandwidth around reference signal";
  parameter Boolean pre_y_start=false "Value of pre(y) at initial time";

  Modelica.Blocks.Interfaces.RealInput T_bot
    "Connector of Real input signal used as measurement signal of bottom temperature of storage"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-100}})));
initial equation
  pre(y) = pre_y_start;
equation
  y = pre(y) and (T_bot < T_set + bandwidth/2) or (T_top < T_set - bandwidth/2);
  annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}), graphics={
        Text(
          extent={{-92,74},{44,44}},
          textString="reference"),
        Text(
          extent={{-94,-52},{-34,-74}},
          textString="u"),
        Line(points={{-76,-32},{-68,-6},{-50,26},{-24,40},{-2,42},{16,36},{32,28},{48,12},{58,-6},{68,-28}},
          color={0,0,127}),
        Line(points={{-78,-2},{-6,18},{82,-12}},
          color={255,0,0}),
        Line(points={{-78,12},{-6,30},{82,0}}),
        Line(points={{-78,-16},{-6,4},{82,-26}}),
        Line(points={{-82,-18},{-56,-18},{-56,-40},{64,-40},{64,-20},{90,-20}},
          color={255,0,255})}), Documentation(info="<html>
<p>The block StorageHysteresis sets the output signal <b>y</b> to <b>true</b> when the input signal <b>T_top</b> falls below the <b>T_set</b> signal minus half of the bandwidth and sets the output signal <b>y</b> to <b>false</b> when the input signal <b>T_bot</b> exceeds the <b>T_set</b> signal plus half of the bandwidth.</p>
<p>This control ensure that the whole storage has the required temperature. If you just want to control one layer, apply the same Temperature to both <b>T_top</b> and <b>T_bot</b>.</p>
</html>"));
end StorageHysteresis;
