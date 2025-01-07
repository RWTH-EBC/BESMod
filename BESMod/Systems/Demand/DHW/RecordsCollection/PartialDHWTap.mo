within BESMod.Systems.Demand.DHW.RecordsCollection;
record PartialDHWTap
  extends Modelica.Icons.Record;

  parameter Real table[:, 5] "Table data for dhw tapping";
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=max(table[:, 3])
    "Nominal mass flow rate";
  parameter Modelica.Units.SI.Volume VDHWDayAt60 "Average daily tapping volume, calculated at 60 °C";
  parameter Modelica.Units.SI.Time tCrit(displayUnit="h") "Time for critical period according to EN 15450" annotation (Dialog(group="Design - Bottom Up: Parameters are defined by the subsystem"));
  parameter Real QCrit "Energy demand in kWh during critical period according to EN 15450 assuming 60 °C set temperature" annotation (Dialog(group="Design - Bottom Up: Parameters are defined by the subsystem"));
  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(graphics,
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html><p>
  <span style=\"font-size: 8.25pt;\">These records are based on the EU
  Regulation 812/2013 profiles and the approach in the EN 15450 to size
  DHW tanks based on a critical time period.</span>
</p>
</html>"));
end PartialDHWTap;
