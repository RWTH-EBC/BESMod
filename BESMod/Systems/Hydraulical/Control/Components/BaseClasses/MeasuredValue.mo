within BESMod.Systems.Hydraulical.Control.Components.BaseClasses;
type MeasuredValue = enumeration(
    GenerationSupplyTemperature
                              "Supply temperature of generation system",
    DistributionTemperature
                          "Temperature in distribution")
  "Select possible measurements for control" annotation (Icon(graphics={
                                        Text(
        extent={{-150,138},{150,98}},
        textString="%name",
        textColor={0,0,255}),   Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid)}));
  annotation (Documentation(info="<html>
<h4>Information</h4>
<p>Enumeration type defining possible temperature measurements used for control:</p>
<ul>
  <li><code>GenerationSupplyTemperature</code>: Supply temperature of generation system</li>
  <li><code>DistributionTemperature</code>: Temperature in distribution</li>
</ul>
</html>"));
