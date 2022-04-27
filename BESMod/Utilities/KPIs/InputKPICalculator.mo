within BESMod.Utilities.KPIs;
model InputKPICalculator "Calculate for given input"
  extends BaseClasses.PartialKPICalculator;
  Modelica.Blocks.Interfaces.RealInput u(unit=unit)
                                         "Connector of Real input signal"
    annotation (Placement(transformation(extent={{-142,-20},{-102,20}})));
equation
  connect(internalU.u, u)
    annotation (Line(points={{-90,0},{-122,0}}, color={0,0,127}));
  annotation (Documentation(info="<html>
<p>Calculate a set of KPIs for the given Real input signal</p>
</html>"));
end InputKPICalculator;
