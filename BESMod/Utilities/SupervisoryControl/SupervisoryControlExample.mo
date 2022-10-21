within BESMod.Utilities.SupervisoryControl;
model SupervisoryControlExample
  extends Modelica.Icons.Example;
  SupervisoryControl locCtrl(ctrlType=BESMod.Utilities.SupervisoryControl.Types.SupervisoryControlType.Local)
    annotation (Placement(transformation(extent={{-18,-70},{14,-38}})));
  SupervisoryControl intCtrl(ctrlType=BESMod.Utilities.SupervisoryControl.Types.SupervisoryControlType.Internal)
    annotation (Placement(transformation(extent={{-18,-18},{14,14}})));
  SupervisoryControl extCtrl(
    actExt(y=activateSupCtrl.y),
    ctrlType=BESMod.Utilities.SupervisoryControl.Types.SupervisoryControlType.External,

    uExt(y=pulseSup.y))
    annotation (Placement(transformation(extent={{-20,38},{12,70}})));

  Modelica.Blocks.Sources.Pulse pulseLoc(period=1)
    annotation (Placement(transformation(extent={{-100,-70},{-80,-50}})));
  Modelica.Blocks.Sources.Pulse pulseSup(period=2)
    annotation (Placement(transformation(extent={{-100,10},{-80,30}})));
  Modelica.Blocks.Sources.BooleanPulse activateSupCtrl(period=4)
    annotation (Placement(transformation(extent={{-100,-30},{-80,-10}})));
equation
  connect(pulseLoc.y, locCtrl.uLoc) annotation (Line(points={{-79,-60},{-50,-60},
          {-50,-66.8},{-21.2,-66.8}}, color={0,0,127}));
  connect(pulseLoc.y, intCtrl.uLoc) annotation (Line(points={{-79,-60},{-76,-60},
          {-76,-12},{-21.2,-12},{-21.2,-14.8}}, color={0,0,127}));
  connect(pulseLoc.y, extCtrl.uLoc) annotation (Line(points={{-79,-60},{-76,-60},
          {-76,41.2},{-23.2,41.2}}, color={0,0,127}));
  connect(pulseSup.y, intCtrl.uSup) annotation (Line(points={{-79,20},{-52,20},
          {-52,10.8},{-21.2,10.8}}, color={0,0,127}));
  connect(activateSupCtrl.y, intCtrl.actInt) annotation (Line(points={{-79,-20},
          {-52,-20},{-52,-2},{-21.2,-2}}, color={255,0,255}));
  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(graphics,
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=10, __Dymola_Algorithm="Dassl"));
end SupervisoryControlExample;
