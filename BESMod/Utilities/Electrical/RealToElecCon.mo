within BESMod.Utilities.Electrical;
model RealToElecCon
  "Transfer from real interface to electrical connector"
  parameter Boolean use_souLoa=true "= true if real interface for electrical load is activated";
  parameter Boolean use_souGen=true "= true if real interface for electrical generation is activated";

  Modelica.Blocks.Interfaces.RealInput PEleLoa if use_souLoa
                                                         "Electrical power of load"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}})));
  Systems.Electrical.Interfaces.InternalElectricalPinOut internalElectricalPin
    annotation (Placement(transformation(extent={{92,-8},{112,12}})));
  Modelica.Blocks.Interfaces.RealInput PEleGen if use_souGen
    "Electrical power of generation"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));
  Modelica.Blocks.Sources.Constant NoFlowLoa(final k=0) if not use_souLoa
    annotation (Placement(transformation(extent={{-96,80},{-84,92}})));
  Modelica.Blocks.Sources.Constant NoFlowGen(final k=0) if not use_souGen
    annotation (Placement(transformation(extent={{-94,-86},{-82,-74}})));
  Modelica.Blocks.Routing.RealPassThrough realPassThroughLoa
    annotation (Placement(transformation(extent={{-68,30},{-48,50}})));
  Modelica.Blocks.Routing.RealPassThrough realPassThroughGen
    annotation (Placement(transformation(extent={{-68,-50},{-48,-30}})));
equation

  realPassThroughLoa.y = internalElectricalPin.PElecLoa;
  realPassThroughGen.y = internalElectricalPin.PElecGen;

  connect(NoFlowLoa.y, realPassThroughLoa.u) annotation (Line(points={{-83.4,86},
          {-78,86},{-78,40},{-70,40}}, color={0,0,127}));
  connect(PEleLoa, realPassThroughLoa.u)
    annotation (Line(points={{-120,40},{-70,40}}, color={0,0,127}));
  connect(realPassThroughGen.u, PEleGen)
    annotation (Line(points={{-70,-40},{-120,-40}}, color={0,0,127}));
  connect(NoFlowGen.y, realPassThroughGen.u) annotation (Line(points={{-81.4,-80},
          {-76,-80},{-76,-40},{-70,-40}}, color={0,0,127}));
    annotation (Line(points={{-120,40},{-74,40}}, color={0,0,127}),
                Line(points={{-120,-40},{-74,-40}}, color={0,0,127}),
              Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(
          extent={{100,100},{-100,-100}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),                                 Line(
          points={{-86,0},{-1,0},{84,0}},
          color={0,140,72},
          thickness=1,
          smooth=Smooth.Bezier),
        Polygon(
          points={{66,14},{66,-14},{86,0},{66,14}},
          lineColor={0,0,0},
          lineThickness=1,
          fillColor={0,140,72},
          fillPattern=FillPattern.Solid), Text(
          extent={{-98,-100},{100,-160}},
          lineColor={0,0,0},
          textString="%name")}),                                 Diagram(graphics,
        coordinateSystem(preserveAspectRatio=false)), Documentation(info="<html>
<h4>Information</h4>
<p>Model for transferring real power inputs to the electrical connectors. 
The model provides an interface between real-valued electrical power signals and an 
internal electrical connector system.</p>

<h4>Important Parameters</h4>
<ul>
  <li><code>use_souLoa</code> (default=true): Activates the real interface for electrical loads</li>
  <li><code>use_souGen</code> (default=true): Activates the real interface for electrical generation</li>
</ul>
</html>"));
end RealToElecCon;
