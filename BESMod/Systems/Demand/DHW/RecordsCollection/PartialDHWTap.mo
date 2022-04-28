within BESMod.Systems.Demand.DHW.RecordsCollection;
record PartialDHWTap
  extends Modelica.Icons.Record;

  parameter Real table[:, 5] "Table data for dhw tapping";
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=max(table[:, 3])
    "Nominal mass flow rate";
  parameter Modelica.Units.SI.Volume V_dhw_day "Average daily tapping volume";

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialDHWTap;
