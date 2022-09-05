within BESMod.Systems.Demand.DHW.RecordsCollection;
record PartialDHWTap
  extends Modelica.Icons.Record;

  parameter Real table[:, 5] "Table data for dhw tapping";
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=max(table[:, 3])
    "Nominal mass flow rate";
  parameter Modelica.Units.SI.Volume VDHWDay "Average daily tapping volume";
  parameter Modelica.Units.SI.Time tCrit(displayUnit="h") "Time for critical period according to EN 15450" annotation (Dialog(group="Design - Bottom Up: Parameters are defined by the subsystem", enable=designType <> BESMod.Systems.Hydraulical.Distribution.Types.DHWDesignType.NoStorage));
  parameter Real QCrit "Energy demand in kWh during critical period according to EN 15450" annotation (Dialog(group="Design - Bottom Up: Parameters are defined by the subsystem", enable=designType <> BESMod.Systems.Hydraulical.Distribution.Types.DHWDesignType.NoStorage));
  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(graphics,
        coordinateSystem(preserveAspectRatio=false)));
end PartialDHWTap;
