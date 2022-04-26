within BESMod.Utilities.Electrical;
model RealToElecCon
  "Transfer from real interface to electrical connector"
  parameter Integer nLoa(min=1)        "Number of loads connected (connectorSizing=true)" annotation(Dialog(connectorSizing=true));
  parameter Integer nGen(min=1) "Number of loads connected (connectorSizing=true)" annotation(Dialog(connectorSizing=true));
  parameter Boolean SouLoa = true "= true if real interface for electrical load is activated";
  parameter Boolean SouGen = true "= true if real interface for electrical generation is activated";


  Modelica.Blocks.Interfaces.RealInput PEleLoa[nLoa] if SouLoa "Electrical power of load"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}})));
  Systems.Electrical.Interfaces.InternalElectricalPin internalElectricalPin
    annotation (Placement(transformation(extent={{92,-8},{112,12}})));
  Modelica.Blocks.Interfaces.RealInput PEleGen[nGen] if SouGen
    "Electrical power of generation"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));
  Modelica.Blocks.Math.MultiSum multiSumLoa(nu= if SouLoa then nLoa else 1)
    annotation (Placement(transformation(extent={{-74,34},{-62,46}})));
  Modelica.Blocks.Math.MultiSum multiSumGen(nu= if SouGen then nGen else 1)
    annotation (Placement(transformation(extent={{-74,-46},{-62,-34}})));
  Modelica.Blocks.Sources.Constant NoFlowLoa[1](each k=0)
    annotation (Placement(transformation(extent={{-96,80},{-84,92}})));
  Modelica.Blocks.Sources.Constant NoFlowGen[1](each k=0)
    annotation (Placement(transformation(extent={{-94,-86},{-82,-74}})));
equation

  multiSumLoa.y = internalElectricalPin.PElecLoa;
  multiSumGen.y = internalElectricalPin.PElecGen;


  if not SouLoa then
    internalElectricalPin.PElecLoa = 0;
    connect(NoFlowLoa.y, multiSumLoa.u);
  end if;
  if not SouGen then
    internalElectricalPin.PElecGen = 0;
    connect(NoFlowGen.y, multiSumGen.u);
  end if;


  connect(PEleLoa, multiSumLoa.u)
    annotation (Line(points={{-120,40},{-74,40}}, color={0,0,127}));
  connect(PEleGen, multiSumGen.u)
    annotation (Line(points={{-120,-40},{-74,-40}}, color={0,0,127}));
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
