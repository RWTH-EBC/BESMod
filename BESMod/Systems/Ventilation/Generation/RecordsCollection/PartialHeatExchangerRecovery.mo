within BESMod.Systems.Ventilation.Generation.RecordsCollection;
partial record PartialHeatExchangerRecovery
  extends Modelica.Icons.Record;

  parameter Modelica.SIunits.Efficiency epsHex "Heat exchanger effectiveness";
  parameter Modelica.SIunits.PressureDifference dpHex_nominal "Nominal pressure drop on one HEX pipe";
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialHeatExchangerRecovery;
