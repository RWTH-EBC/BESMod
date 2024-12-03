within BESMod.Systems.RecordsCollection;
record SubsystemControlBaseDataDefinition
  "Record used to include data of each subsystem into the control of the subsystem"
  extends Modelica.Icons.Record;
  parameter Integer nParallelDem(min=1)
    "Number of parallel demand systems of this system"                                annotation (Dialog(group=
          "System Design"));
  parameter Integer nParallelSup(min=1)
    "Number of parallel supply systems of this system"                                annotation (Dialog(group=
          "System Design"));

  parameter Modelica.Units.SI.HeatFlowRate Q_flow_nominal[nParallelDem]
    "Nominal heat flow rate" annotation (Dialog(group="System Design"));
  parameter Modelica.Units.SI.Temperature TOda_nominal
    "Nominal outdoor air temperature" annotation (Dialog(group="System Design"));

  parameter Modelica.Units.SI.Temperature TDem_nominal[nParallelDem]
    "Nominal demand temperature" annotation (Dialog(group="System Design"));
  parameter Modelica.Units.SI.Temperature TSup_nominal[nParallelSup]
    "Nominal supply temperature" annotation (Dialog(group="System Design"));
  parameter Modelica.Units.SI.TemperatureDifference dTTra_nominal[nParallelDem]
    "Nominal temperature difference for heat transfer"
    annotation (Dialog(group="System Design"));
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal[nParallelDem]
    "Nominal mass flow rate" annotation (Dialog(group="System Design"));
  parameter Modelica.Units.SI.PressureDifference dp_nominal[nParallelDem]
    "Nominal pressure difference at m_flow_nominal"
    annotation (Dialog(group="System Design"));
  parameter Modelica.Units.SI.TemperatureDifference dTLoss_nominal[nParallelDem]=
     fill(0, nParallelDem) "Nominal temperature difference due to heat losses"
    annotation (Dialog(group="System Design"));
  parameter Real f_design[nParallelDem]=fill(1, nParallelDem)
    "Factor for oversizing due to heat losses"
    annotation (Dialog(group="System Design"));
  parameter Modelica.Units.SI.HeatFlowRate QLoss_flow_nominal[nParallelDem]=
      f_design .* Q_flow_nominal .- Q_flow_nominal
    "Nominal heat flow rate due to heat losses"
    annotation (Dialog(group="System Design"));
  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(graphics,
        coordinateSystem(preserveAspectRatio=false)));
  annotation (Documentation(info="<html>
  <p>Record used to include data of each subsystem into the control of the subsystem.</p>
</html>"));
end SubsystemControlBaseDataDefinition;
