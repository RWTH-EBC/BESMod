within BESMod.Utilities.KPIs;
model EnergyKPICalculator "Give integral and value as KPI"
  extends BaseClasses.KPIIcon;
  parameter Boolean use_inpCon=true
    "= false to use an internal variable as input";

  Modelica.Blocks.Interfaces.RealInput y(final unit="W") if not use_inpCon
    "Value of Real input";

  Modelica.Blocks.Continuous.Integrator integrator2(
    use_reset=false,
    y_start=Modelica.Constants.eps,
    y(final unit="J"))
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
  Modelica.Blocks.Routing.RealPassThrough internalU(y(final unit="W"))
                                                    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-30,0})));
  Modelica.Blocks.Interfaces.RealInput u(final unit="W") if use_inpCon
    "Connector of Real input signal"
    annotation (Placement(transformation(extent={{-138,-20},{-98,20}})));
  BaseClasses.KPIIntegral KPI(value(unit="W"), integral(unit="J"))
    annotation (Placement(transformation(extent={{102,-20},{142,20}}),
        iconTransformation(extent={{102,-20},{142,20}})));
equation
  connect(internalU.y, KPI.value) annotation (Line(points={{-19,0},{50,0},{50,0.1},
          {122.1,0.1}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(integrator2.u, internalU.y) annotation (Line(points={{18,-30},{-8,-30},
          {-8,0},{-19,0}}, color={0,0,127}));
  connect(integrator2.y, KPI.integral) annotation (Line(points={{41,-30},{72,-30},
          {72,0.1},{122.1,0.1}}, color={0,0,127}));
  connect(internalU.u,u)
    annotation (Line(points={{-42,0},{-118,0}}, color={0,0,127}));
  connect(internalU.u,y);
  annotation (Documentation(info="<html>
<p>Calculates the integral of the given value and passes the value as well. </p>
<p>Useful to output value and integral directly. </p>
</html>"));
end EnergyKPICalculator;
