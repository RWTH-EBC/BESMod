within BESMod.Utilities.KPIs;
model CalculateHeatMeanTemperature
  "Mean temperature weigthed with heat flow rate"
  Modelica.Blocks.Continuous.Integrator intTQ(
    final k=1,
    final use_reset=false,
    y_start=273.15,
    y(final unit="K.J"))
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  Modelica.Blocks.Math.Product pro
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Modelica.Blocks.Interfaces.RealInput T(unit="K", displayUnit="degC")
    "Temperature"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  Modelica.Blocks.Interfaces.RealInput Q_flow(unit="W") "Heat flow rate"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));
  Modelica.Blocks.Continuous.Integrator intQ(
    final k=1,
    final use_reset=false,
    y_start=1,
    y(final unit="K.J"))
    annotation (Placement(transformation(extent={{-20,-70},{0,-50}})));
  Modelica.Blocks.Math.Division division
    annotation (Placement(transformation(extent={{40,-30},{60,-10}})));
  Modelica.Blocks.Interfaces.RealOutput TMea(unit="K", displayUnit="degC")
    "Mean temperature"
    annotation (Placement(transformation(extent={{90,-30},{110,-10}})));
equation
  connect(pro.u1, T) annotation (Line(points={{-62,6},{-94,6},{-94,60},{-120,60}},
        color={0,0,127}));
  connect(pro.u2, Q_flow) annotation (Line(points={{-62,-6},{-94,-6},{-94,-60},
          {-120,-60}}, color={0,0,127}));
  connect(pro.y, intTQ.u)
    annotation (Line(points={{-39,0},{-22,0}}, color={0,0,127}));
  connect(division.u1, intTQ.y)
    annotation (Line(points={{38,-14},{6,-14},{6,0},{1,0}}, color={0,0,127}));
  connect(division.u2, intQ.y) annotation (Line(points={{38,-26},{6,-26},{6,-60},
          {1,-60}}, color={0,0,127}));
  connect(intQ.u, Q_flow)
    annotation (Line(points={{-22,-60},{-120,-60}}, color={0,0,127}));
  connect(division.y, TMea)
    annotation (Line(points={{61,-20},{100,-20}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                                Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid)}), Diagram(coordinateSystem(
          preserveAspectRatio=false)));
end CalculateHeatMeanTemperature;
