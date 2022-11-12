within BESMod.Utilities.SupervisoryControl;
model SupervisoryControl

  parameter BESMod.Utilities.SupervisoryControl.Types.SupervisoryControlType ctrlType
    "Type of supervisory control";

  Modelica.Blocks.Interfaces.RealInput uSup if ctrlType == BESMod.HugosProject.Utilities.SupervisoryControl.Types.SupervisoryControlType.Internal
                                            "Input from supervisory control"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  Modelica.Blocks.Interfaces.RealInput uLoc "Local control input"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));
  Modelica.Blocks.Interfaces.BooleanInput activateInt if ctrlType == BESMod.HugosProject.Utilities.SupervisoryControl.Types.SupervisoryControlType
    .Internal
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput y
                                         "Control output"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));
  Modelica.Blocks.Logical.Switch swi
    "Switch between external signal and direct feedthrough signal"
    annotation (Placement(transformation(extent={{0,-16},{32,16}})));
  Modelica.Blocks.Sources.BooleanExpression activateExt if ctrlType == BESMod.HugosProject.Utilities.SupervisoryControl.Types.SupervisoryControlType
    .External
    "Block to activate use of external signal"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Modelica.Blocks.Sources.RealExpression uExt if ctrlType == BESMod.HugosProject.Utilities.SupervisoryControl.Types.SupervisoryControlType.External
    "External input signal"
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  Modelica.Blocks.Sources.BooleanConstant deactivateAlways(final k=false) if
    ctrlType == BESMod.HugosProject.Utilities.SupervisoryControl.Types.SupervisoryControlType.Local
    "Block to activate use of external signal"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Modelica.Blocks.Sources.Constant uSupDeacticate(final k=0) if ctrlType ==
    BESMod.HugosProject.Utilities.SupervisoryControl.Types.SupervisoryControlType.Local
    "Constant zero for deactivated sup control"
    annotation (Placement(transformation(extent={{-56,32},{-40,48}})));
equation
  connect(uLoc, swi.u3) annotation (Line(points={{-120,-80},{-12,-80},{-12,-12.8},
          {-3.2,-12.8}}, color={0,0,127}));
  connect(swi.y, y)
    annotation (Line(points={{33.6,0},{120,0}}, color={0,0,127}));
  connect(uExt.y, swi.u1) annotation (Line(points={{-39,20},{-20,20},{-20,12.8},
          {-3.2,12.8}}, color={0,0,127}));
  connect(activateExt.y, swi.u2)
    annotation (Line(points={{-39,0},{-3.2,0}}, color={255,0,255}));
  connect(activateInt, swi.u2) annotation (Line(points={{-120,0},{-64,0},{-64,-12},
          {-30,-12},{-30,0},{-3.2,0}},color={255,0,255}));
  connect(deactivateAlways.y, swi.u2) annotation (Line(points={{-39,-30},{-24,-30},
          {-24,0},{-3.2,0}}, color={255,0,255}));
  connect(uSup, swi.u1) annotation (Line(points={{-120,80},{-12,80},{-12,12.8},{
          -3.2,12.8}}, color={0,0,127}));
  connect(uSupDeacticate.y, swi.u1) annotation (Line(points={{-39.2,40},{-20,40},
          {-20,12.8},{-3.2,12.8}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                              Text(
          extent={{-102,-88},{102,-184}},
          lineColor={0,0,0},
          textString="%name%"),
        Rectangle(
          extent={{100,100},{-100,-100}},
          lineColor={28,108,200},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(points={{-100,80},{-38,80}},
          color={0,0,127}),
        Line(points={{-100,0},{-40,0}},
          color={255,0,255}),
        Line(points={{-40,12},{-40,-12}},
          color={255,0,255}),
        Line(points={{12,0},{100,0}},
          color={0,0,127}),
        Line(points=DynamicSelect({{-38,80},{6,2}}, if swi.u2 then {{-38,80},{6,2}} else {{-38,-80},{6,2}}),
          color={0,0,127},
          thickness=1),
        Ellipse(lineColor={0,0,255},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          extent={{2,-8},{18,8}}),
        Line(points={{-100,-80},{-40,-80},{-40,-80}},
          color={0,0,127})}),                                    Diagram(graphics,
        coordinateSystem(preserveAspectRatio=false)));
end SupervisoryControl;
