within BESMod.Systems.RecordsCollection;
record TwoSideSubsystemControlBaseDataDefinition
  "Record used to include data of two sided subsystem into the control of the subsystem"
  extends Modelica.Icons.Record;
  extends PartialSubsystemControlBaseDataDefinition;
  parameter Modelica.Units.SI.MassFlowRate mDem_flow_nominal[nParallelDem]
    "Nominal mass flow rate of demand system" annotation (Dialog(group="System Design"));
  parameter Modelica.Units.SI.PressureDifference dpDem_nominal[nParallelDem]
    "Nominal pressure difference at m_flow_nominal of demand system"
    annotation (Dialog(group="System Design"));
  parameter Modelica.Units.SI.MassFlowRate mSup_flow_nominal[nParallelSup]
    "Nominal mass flow rate of supply system" annotation (Dialog(group="System Design"));
  parameter Modelica.Units.SI.PressureDifference dpSup_nominal[nParallelSup]
    "Nominal pressure difference at m_flow_nominal of supply system"
    annotation (Dialog(group="System Design"));

  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(graphics,
        coordinateSystem(preserveAspectRatio=false)));
end TwoSideSubsystemControlBaseDataDefinition;
