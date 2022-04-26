within BESMod.Utilities.KPIs;
model InternalKPICalculator
  "KPIs for internal variables. Add via Attributes -> y=someVar"
  extends BaseClasses.PartialKPICalculator(integrator2(y_start=Modelica.Constants.eps));

  Modelica.Blocks.Interfaces.RealInput y "Value of Real input";

  Modelica.Blocks.Sources.RealExpression internal_u(y=y) annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-112,0})));
equation
  connect(internalU.u, internal_u.y)
    annotation (Line(points={{-90,0},{-101,0}}, color={0,0,127}));
  annotation (Documentation(info="<html>
<p>If no input is given, specify &quot;y=...&quot; as a modifier.</p>
</html>"));
end InternalKPICalculator;
