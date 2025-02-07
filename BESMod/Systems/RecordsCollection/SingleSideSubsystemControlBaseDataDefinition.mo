within BESMod.Systems.RecordsCollection;
record SingleSideSubsystemControlBaseDataDefinition
  "Record used to include data of single sided subsystem into the control of the subsystem"
  extends Modelica.Icons.Record;
  extends PartialSubsystemControlBaseDataDefinition;
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal[nParallelDem]
    "Nominal mass flow rate" annotation (Dialog(group="System Design"));
  parameter Modelica.Units.SI.PressureDifference dp_nominal[nParallelDem]
    "Nominal pressure difference at m_flow_nominal"
    annotation (Dialog(group="System Design"));
  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(graphics,
        coordinateSystem(preserveAspectRatio=false)));
end SingleSideSubsystemControlBaseDataDefinition;
