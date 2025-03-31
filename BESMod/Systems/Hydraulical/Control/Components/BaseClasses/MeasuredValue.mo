within BESMod.Systems.Hydraulical.Control.Components.BaseClasses;
type MeasuredValue = enumeration(
    GenerationSupplyTemperature "Supply temperature of generation system",
    DistributionTemperature "Temperature leaving distribution",
    StorageTemperature "Temperature in storage")
  "Select possible measurements for control" annotation (Icon(graphics={
                                        Text(
        extent={{-150,138},{150,98}},
        textString="%name",
        textColor={0,0,255}),   Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid)}));
