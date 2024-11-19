within BESMod.Utilities.Electrical;
model ConverterExample
  extends Modelica.Icons.Example;
  RealToElecCon realToElecConGen(use_souLoa=false)
    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));
  RealToElecCon realToElecConLoa(use_souGen=false)
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));
  RealToElecCon realToElecConBoth
    annotation (Placement(transformation(extent={{-20,60},{0,80}})));
  Modelica.Blocks.Sources.Sine sineLoa(
    amplitude=5,
    f=0.01,
    offset=5)
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
  Modelica.Blocks.Sources.Sine sineGen(
    amplitude=5,
    f=0.01,
    offset=5,
    startTime=10)
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));
  Systems.Electrical.Interfaces.InternalElectricalPinOut internalElectricalPinOnlyLoad
    annotation (Placement(transformation(extent={{100,20},{120,40}})));
  Systems.Electrical.Interfaces.InternalElectricalPinOut internalElectricalPinInputAndOutput
    annotation (Placement(transformation(extent={{100,60},{120,80}})));
  Systems.Electrical.Interfaces.InternalElectricalPinOut internalElectricalPinOnlyGeneration
    annotation (Placement(transformation(extent={{100,-40},{120,-20}})));
  RealToElecConSplit realToElecConSplit
    annotation (Placement(transformation(extent={{-20,-80},{0,-60}})));
  Systems.Electrical.Interfaces.InternalElectricalPinOut internalElectricalPinAutomaticSplit
    annotation (Placement(transformation(extent={{100,-80},{120,-60}})));
  Modelica.Blocks.Sources.Sine sineBoth(
    amplitude=5,
    f=0.01,
    startTime=10)
    annotation (Placement(transformation(extent={{-100,-80},{-80,-60}})));
equation
  connect(sineLoa.y, realToElecConLoa.PEleLoa) annotation (Line(points={{-79,30},
          {-52,30},{-52,34},{-22,34}}, color={0,0,127}));
  connect(realToElecConLoa.internalElectricalPin, internalElectricalPinOnlyLoad)
    annotation (Line(
      points={{0.2,30.2},{55.1,30.2},{55.1,30},{110,30}},
      color={0,0,0},
      thickness=1));
  connect(realToElecConBoth.internalElectricalPin,
    internalElectricalPinInputAndOutput) annotation (Line(
      points={{0.2,70.2},{55.1,70.2},{55.1,70},{110,70}},
      color={0,0,0},
      thickness=1));
  connect(realToElecConGen.internalElectricalPin,
    internalElectricalPinOnlyGeneration) annotation (Line(
      points={{0.2,-29.8},{0.2,-28},{96,-28},{96,-30},{110,-30}},
      color={0,0,0},
      thickness=1));
  connect(realToElecConSplit.internalElectricalPin,
    internalElectricalPinAutomaticSplit) annotation (Line(
      points={{0.2,-69.8},{0.2,-68},{96,-68},{96,-70},{110,-70}},
      color={0,0,0},
      thickness=1));
  connect(realToElecConBoth.PEleLoa, sineLoa.y) annotation (Line(points={{-22,
          74},{-52,74},{-52,30},{-79,30}}, color={0,0,127}));
  connect(realToElecConBoth.PEleGen, sineGen.y) annotation (Line(points={{-22,
          66},{-58,66},{-58,-30},{-79,-30}}, color={0,0,127}));
  connect(realToElecConGen.PEleGen, sineGen.y) annotation (Line(points={{-22,
          -34},{-58,-34},{-58,-30},{-79,-30}}, color={0,0,127}));
  connect(sineBoth.y, realToElecConSplit.PEle)
    annotation (Line(points={{-79,-70},{-22,-70}}, color={0,0,127}));
  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)), Documentation(info="<html>
<h4>Information</h4>
<p>
This model demonstrates different configurations of electrical power conversion from real signals to electrical connectors. It shows four different use cases:
</p>
<ul>
<li>Load only conversion using <a href=\"modelica://BESMod.Utilities.Electrical.RealToElecCon\">RealToElecCon</a> with use_souGen=false</li>
<li>Generation only conversion using <a href=\"modelica://BESMod.Utilities.Electrical.RealToElecCon\">RealToElecCon</a> with use_souLoa=false</li>
<li>Both load and generation using <a href=\"modelica://BESMod.Utilities.Electrical.RealToElecCon\">RealToElecCon</a> with default settings</li>
<li>Automatic splitting of power into load/generation using <a href=\"modelica://BESMod.Utilities.Electrical.RealToElecConSplit\">RealToElecConSplit</a></li>
</ul>
</html>"));
end ConverterExample;
