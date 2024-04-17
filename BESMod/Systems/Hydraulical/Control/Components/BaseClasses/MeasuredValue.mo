within BESMod.Systems.Hydraulical.Control.Components.BaseClasses;
type MeasuredValue = enumeration(
    GenerationSupplyTemperature
                              "Supply temperature of generation system",
    DistributionTemperature
                          "Temperature in distribution")
  "Select possible measurements for control";
