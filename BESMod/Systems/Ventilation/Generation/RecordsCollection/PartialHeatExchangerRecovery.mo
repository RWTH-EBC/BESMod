within BESMod.Systems.Ventilation.Generation.RecordsCollection;
partial record PartialHeatExchangerRecovery
  extends Modelica.Icons.Record;

  parameter Modelica.Units.SI.Efficiency epsHex "Heat exchanger effectiveness";
  parameter Modelica.Units.SI.PressureDifference dpHex_nominal
    "Nominal pressure drop on one HEX pipe";
  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(graphics,
        coordinateSystem(preserveAspectRatio=false)));
end PartialHeatExchangerRecovery;
