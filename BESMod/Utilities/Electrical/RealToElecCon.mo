within BESMod.Utilities.Electrical;
model RealToElecCon
  "Transfer from real interface to electrical connector"
  parameter Integer nLoa(min=1) "Number of loads connected (connectorSizing=true)" annotation(Dialog(connectorSizing=true));
  parameter Integer nGen(min=1) "Number of loads connected (connectorSizing=true)" annotation(Dialog(connectorSizing=true));

  Modelica.Blocks.Interfaces.RealInput PEleLoa[nLoa] "Electrical power of load"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}})));
  Systems.Electrical.Interfaces.InternalElectricalPin internalElectricalPin
    annotation (Placement(transformation(extent={{92,-8},{112,12}})));
  Modelica.Blocks.Math.MultiSum multiSumElecLoad(nu=nLoa)
    annotation (Placement(transformation(extent={{-78,34},{-66,46}})));
  Modelica.Blocks.Interfaces.RealInput PEleGen[nGen]
    "Electrical power of generation"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));
  Modelica.Blocks.Math.MultiSum multiSumElecGen(nu=nGen)
    annotation (Placement(transformation(extent={{-80,-46},{-68,-34}})));
equation
  multiSumElecLoad.y = internalElectricalPin.PElecLoa;
  multiSumElecGen.y = internalElectricalPin.PElecGen;

  connect(PEleLoa, multiSumElecLoad.u)
    annotation (Line(points={{-120,40},{-78,40}}, color={0,0,127}));
  connect(PEleGen, multiSumElecGen.u)
    annotation (Line(points={{-120,-40},{-80,-40}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={Line(
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
end RealToElecCon;
