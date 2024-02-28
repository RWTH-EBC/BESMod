within BESMod.Systems.Hydraulical.Control.Components.ThermostaticValveController;
model ThermostaticValvePControlled
 extends BaseClasses.PartialThermostaticValveController;

 parameter Real Kvs[nZones]=fill(1.2, nZones)   "Kv value at full opening (=1)";
 parameter Real Kv_setT[nZones]=fill(1.4, nZones)
    "Kv value when set temperature = measured temperature";
 parameter Real P[nZones] = fill(2, nZones) "Deviation of P-controller when valve is closed";

equation
  for i in 1:nZones loop
    //Calculating the valve opening depending on the temperature deviation
    opening[i] =min(1, max(leakageOpening, (P[i] -TZoneMea [i] -TZoneSet
              [i])*(Kv_setT[i]/Kvs[i])/P[i]));
  end for;
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
          fillPattern=FillPattern.Solid)}),                      Diagram(graphics,
        coordinateSystem(preserveAspectRatio=false)));
end ThermostaticValvePControlled;
