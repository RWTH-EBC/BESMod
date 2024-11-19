within BESMod.Systems.Ventilation.Generation.RecordsCollection;
partial record PartialHeatExchangerRecovery
  extends Modelica.Icons.Record;

  parameter Modelica.Units.SI.Efficiency epsHex "Heat exchanger effectiveness";
  parameter Modelica.Units.SI.PressureDifference dpHex_nominal
    "Nominal pressure drop on one HEX pipe";
  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(graphics,
        coordinateSystem(preserveAspectRatio=false)));
  annotation (Documentation(info="<html>
<p>This model is a partial record that contains basic parameters for a heat exchanger recovery system.</p>

<h4>Important Parameters</h4>
<ul>
<li><code>epsHex</code> - Heat exchanger effectiveness [1]</li>
<li><code>dpHex_nominal</code> - Nominal pressure drop on one HEX pipe [Pa]</li>
</ul>
</html>"));
end PartialHeatExchangerRecovery;
