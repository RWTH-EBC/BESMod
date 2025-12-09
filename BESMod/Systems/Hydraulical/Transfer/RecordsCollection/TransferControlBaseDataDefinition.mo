within BESMod.Systems.Hydraulical.Transfer.RecordsCollection;
record TransferControlBaseDataDefinition
  "Custom transfer control data record"
  extends BESMod.Systems.RecordsCollection.SingleSideSubsystemControlBaseDataDefinition;

  parameter Modelica.Units.SI.HeatFlowRate QSup_flow_nominal[nParallelSup]=fill(sum(
      Q_flow_nominal .* f_design), nParallelSup)
    "Nominal heat flow rate at supply ports to transfer system" annotation (Dialog(group=
          "Design - Bottom Up: Parameters are defined by the subsystem"));
  parameter Modelica.Units.SI.Temperature TTra_nominal[nParallelDem] "Nominal supply temperature to transfer systems"
   annotation(Dialog(group="Design - Top Down: Parameters are given by the parent system"));
  parameter Modelica.Units.SI.MassFlowRate mSup_flow_nominal[nParallelSup]=fill(sum(
      m_flow_nominal), nParallelSup)
                                  "Nominal mass flow rate of the supply ports to the transfer system" annotation (Dialog(
        group="Design - Bottom Up: Parameters are defined by the subsystem"));

  parameter Modelica.Units.SI.PressureDifference dpSup_nominal[nParallelSup]
    "Nominal pressure loss of resistances in the supply system of the distribution"
    annotation (Dialog(group=
          "Design - Top Down: Parameters are given by the parent system"));

  parameter Real nHeaTra "Exponent of heat transfer system";
end TransferControlBaseDataDefinition;
