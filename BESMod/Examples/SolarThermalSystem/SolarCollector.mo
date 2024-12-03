within BESMod.Examples.SolarThermalSystem;
record SolarCollector "Custom values used for example"
  extends
    Systems.Hydraulical.Generation.RecordsCollection.SolarThermal.Generic(
    GMax=1000,
    dTMax=30,
    spacing(displayUnit="mm") = 0.02,
    dPipe(displayUnit="mm") = 0.012);

  annotation (Documentation(info="<html><h4>
  Information
</h4>
<p>
  Solar collector parameter record for a example system
</p>
</html>"));
end SolarCollector;
