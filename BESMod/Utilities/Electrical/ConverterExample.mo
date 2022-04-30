within BESMod.Utilities.Electrical;
model ConverterExample
  extends Modelica.Icons.Example;
  RealToElecCon realToElecConGen(use_souLoa=false)
    annotation (Placement(transformation(extent={{-32,-84},{14,-40}})));
  RealToElecCon realToElecConLoa(use_souGen=false)
    annotation (Placement(transformation(extent={{-34,-24},{12,20}})));
  RealToElecCon realToElecConBoth
    annotation (Placement(transformation(extent={{-34,30},{12,74}})));
  Modelica.Blocks.Sources.Sine sine(f=0.01)
    annotation (Placement(transformation(extent={{-106,50},{-86,70}})));
  Modelica.Blocks.Sources.Sine sine1(f=0.01, startTime=10)
    annotation (Placement(transformation(extent={{-102,14},{-82,34}})));
equation
  connect(sine.y, realToElecConBoth.PEleLoa) annotation (Line(points={{-85,60},
          {-61.8,60},{-61.8,60.8},{-38.6,60.8}}, color={0,0,127}));
  connect(sine1.y, realToElecConBoth.PEleGen) annotation (Line(points={{-81,24},
          {-46,24},{-46,43.2},{-38.6,43.2}}, color={0,0,127}));
  connect(sine.y, realToElecConLoa.PEleLoa) annotation (Line(points={{-85,60},
          {-50,60},{-50,6.8},{-38.6,6.8}}, color={0,0,127}));
  connect(sine1.y, realToElecConGen.PEleGen) annotation (Line(points={{-81,24},
          {-52,24},{-52,-70.8},{-36.6,-70.8}}, color={0,0,127}));
  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(graphics,
        coordinateSystem(preserveAspectRatio=false)));
end ConverterExample;
