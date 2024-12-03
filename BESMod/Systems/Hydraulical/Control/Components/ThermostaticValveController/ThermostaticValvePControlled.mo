within BESMod.Systems.Hydraulical.Control.Components.ThermostaticValveController;
model ThermostaticValvePControlled
 extends BaseClasses.PartialThermostaticValveController;

 parameter Real Kvs[nZones]=fill(1.2, nZones)   "Kv value at full opening (=1)";
 parameter Real Kv_setT[nZones]=fill(1.4, nZones)
    "Kv value when set temperature = measured temperature";
 parameter Real P[nZones] = fill(2, nZones) "Deviation of P-controller when valve is closed";

protected
  Real yVal_internal[nZones] "Internally calculated opening";
  Modelica.Blocks.Sources.RealExpression opening_internal[nZones](final y=
        yVal_internal)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
equation
  for i in 1:nZones loop
    //Calculating the valve opening depending on the temperature deviation
    yVal_internal[i] =min(1, max(leakageOpening, (P[i] -TZoneMea [i] -TZoneSet
              [i])*(Kv_setT[i]/Kvs[i])/P[i]));
  end for;
  connect(opening_internal.y, opening)
    annotation (Line(points={{11,0},{120,0}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Line(points={{-82,-82},{-82,-22},{-82,0},{74,0}},  color={0,0,127}),
        Polygon(
          points={{88,-82},{66,-74},{66,-90},{88,-82}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-92,-82},{80,-82}}, color={192,192,192}),
        Line(points={{-82,76},{-82,-92}}, color={192,192,192}),
        Polygon(
          points={{-82,88},{-90,66},{-74,66},{-82,88}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid)}),                      Diagram(
        coordinateSystem(preserveAspectRatio=false)), Documentation(info="<html>
<p>A thermostatic valve controller implementing a P-control strategy. 
The valve opening is determined based on the deviation between 
the zone set temperature and measured temperature. 
</p>
<ul>
  <li><code>Kvs[nZones]</code>: Kv value at full valve opening (=1)</li>
  <li><code>Kv_setT[nZones]</code>: Kv value when set temperature equals measured temperature</li>
  <li><code>P[nZones]</code>: Temperature deviation at which valve is fully closed</li>
</ul>
</html>"));
end ThermostaticValvePControlled;
