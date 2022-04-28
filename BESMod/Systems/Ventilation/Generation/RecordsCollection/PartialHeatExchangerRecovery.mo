within BESMod.Systems.Ventilation.Generation.RecordsCollection;
partial record PartialHeatExchangerRecovery
  extends Modelica.Icons.Record;

  parameter Modelica.Units.SI.Efficiency epsHex "Heat exchanger effectiveness";
  parameter Modelica.Units.SI.PressureDifference dpHex_nominal
    "Nominal pressure drop on one HEX pipe";
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialHeatExchangerRecovery;
