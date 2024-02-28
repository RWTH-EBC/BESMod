within BESMod.Utilities.Electrical;
model RealToElecConSplit
  "Transfer from real interface to electrical connector using and automatic split between generation and load"

  Modelica.Blocks.Interfaces.RealInput PEle
    "Electrical power (positive: generation, negativ: load)"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Systems.Electrical.Interfaces.InternalElectricalPinOut internalElectricalPin
    annotation (Placement(transformation(extent={{92,-8},{112,12}})));
  Modelica.Blocks.Nonlinear.Limiter limLoa(final uMax=0, final uMin=-Modelica.Constants.inf)
    "Limit for only load of electrical energy"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Modelica.Blocks.Nonlinear.Limiter limGen(final uMax=Modelica.Constants.inf,
      final uMin=0)
    "Limit for only generation of electrical energy"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
equation

  limLoa.y = internalElectricalPin.PElecLoa;
  limGen.y = internalElectricalPin.PElecGen;

  connect(PEle, limLoa.u) annotation (Line(points={{-120,0},{-74,0},{-74,30},{-62,
          30}}, color={0,0,127}));
  connect(PEle, limGen.u) annotation (Line(points={{-120,0},{-74,0},{-74,-30},{-62,
          -30}}, color={0,0,127}));
    annotation (Line(points={{-120,40},{-74,40}}, color={0,0,127}),
                Line(points={{-120,-40},{-74,-40}}, color={0,0,127}),
              Icon(coordinateSystem(preserveAspectRatio=false), graphics={Line(
          points={{-86,0},{-1,0},{84,0}},
          color={0,140,72},
          thickness=1,
          smooth=Smooth.Bezier),
        Polygon(
          points={{66,14},{66,-14},{86,0},{66,14}},
          lineColor={0,0,0},
          lineThickness=1,
          fillColor={0,140,72},
          fillPattern=FillPattern.Solid)}),                      Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end RealToElecConSplit;
