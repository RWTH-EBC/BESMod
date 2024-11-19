within BESMod.Systems.Hydraulical.Control.Components.DHWSetControl;
model ConstTSet_DHW "Constant DHW set temperature"
  extends BaseClasses.PartialTSet_DHW_Control;

  Modelica.Blocks.Sources.Constant const(final k=TSetDHW_nominal)
    annotation (Placement(transformation(extent={{-18,-22},{28,24}})));

  Modelica.Blocks.Sources.BooleanConstant
                                   booleanConstant(final k=false)
    annotation (Placement(transformation(extent={{38,-66},{60,-48}})));
equation
  connect(const.y, TSetDHW) annotation (Line(points={{30.3,1},{68.15,1},{68.15,0},
          {110,0}}, color={0,0,127}));
  connect(booleanConstant.y, y) annotation (Line(points={{61.1,-57},{86.15,-57},
          {86.15,-58},{110,-58}}, color={255,0,255}));
  annotation (Icon(graphics={
        Polygon(
          points={{-80,90},{-86,68},{-74,68},{-80,90}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Line(points={{-80,68},{-80,-80}}, color={95,95,95}),
        Line(
          points={{-80,0},{80,0}},
          color={0,0,255},
          thickness=0.5),
        Polygon(
          points={{90,-70},{68,-64},{68,-76},{90,-70}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{70,-80},{94,-100}},
          textString="time"),
        Line(points={{-90,-70},{82,-70}}, color={95,95,95})}), Documentation(
        info="<html>
<p>This class creates a constant DHW set temperature.</p>
</html>"));
end ConstTSet_DHW;
