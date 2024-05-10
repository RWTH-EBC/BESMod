within BESMod.Systems.BaseClasses;
model PartialSubsystemParameters "Model for a partial subsystem"

  parameter Integer nParallelDem(min=1)
    "Number of parallel demand systems of this system"                                annotation (Dialog(group=
          "Design - Bottom Up: Parameters are defined by the subsystem"));
  parameter Integer nParallelSup(min=1)
    "Number of parallel supply systems of this system"                                annotation (Dialog(group=
          "Design - Bottom Up: Parameters are defined by the subsystem"));
  parameter Modelica.Units.SI.Temperature TSup_nominal[nParallelSup]
    "Nominal supply temperature" annotation (Dialog(group=
          "Design - Bottom Up: Parameters are defined by the subsystem"));
  parameter Modelica.Units.SI.Temperature TSup_nominal_old_design[nParallelSup]
    "Nominal supply temperature, if the supply system is based on the old system" annotation (Dialog(group=
          "Design - Bottom Up: Parameters are defined by the subsystem"));
  parameter Modelica.Units.SI.TemperatureDifference dTTra_nominal[nParallelDem]
    "Nominal temperature difference for heat transfer" annotation (Dialog(group=
         "Design - Bottom Up: Parameters are defined by the subsystem"));

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal[nParallelDem](each
      min=Modelica.Constants.eps) "Nominal mass flow rate at operation" annotation (Dialog(
        group="Design - Bottom Up: Parameters are defined by the subsystem"));

  parameter Modelica.Units.SI.PressureDifference dp_nominal[nParallelDem]
    "Nominal pressure difference at m_flow_nominal" annotation (Dialog(group=
          "Design - Bottom Up: Parameters are defined by the subsystem"));

  parameter Modelica.Units.SI.TemperatureDifference dTLoss_nominal[nParallelDem]=
     fill(0, nParallelDem) "Nominal temperature difference due to heat losses"
    annotation (Dialog(group=
          "Design - Bottom Up: Parameters are defined by the subsystem"));
  parameter Real f_design[nParallelDem]=fill(1, nParallelDem)
    "Factor for oversizing due to heat losses"
    annotation (Dialog(group="Design - Bottom Up: Parameters are defined by the subsystem"));
  parameter Modelica.Units.SI.HeatFlowRate QLoss_flow_nominal[nParallelDem]=
      f_design .* Q_flow_nominal .- Q_flow_nominal
    "Nominal heat flow rate due to heat losses" annotation (Dialog(group=
          "Design - Bottom Up: Parameters are defined by the subsystem"));

  parameter Modelica.Units.SI.HeatFlowRate Q_flow_nominal[nParallelDem](each min=Modelica.Constants.eps)
    "Nominal heat flow rate" annotation (Dialog(group=
          "Design - Top Down: Parameters are given by the parent system"));

  parameter Modelica.Units.SI.HeatFlowRate Q_flow_nominal_old_design[nParallelDem](each min=Modelica.Constants.eps) = Q_flow_nominal
    "Nominal heat flow rate at design of System" annotation (Dialog(group=
          "Design - Top Down: Parameters are given by the parent system"));
  parameter Modelica.Units.SI.Temperature TOda_nominal
    "Nominal outdoor air temperature" annotation (Dialog(group=
          "Design - Top Down: Parameters are given by the parent system"));
  parameter Modelica.Units.SI.Temperature TDem_nominal[nParallelDem]
    "Nominal demand temperature" annotation (Dialog(group=
          "Design - Top Down: Parameters are given by the parent system"));
  parameter Modelica.Units.SI.Temperature TDem_nominal_old_design[nParallelDem]
    "Nominal no retrofit demand temperature" annotation (Dialog(group=
          "Design - Top Down: Parameters are given by the parent system"));
  parameter Modelica.Units.SI.Temperature TAmb
    "Ambient temperature of system. Used to calculate default heat loss."
    annotation (Dialog(group=
          "Design - Top Down: Parameters are given by the parent system"));

  parameter Boolean NoRetrofit[nParallelDem]=fill(false, nParallelDem)
    "If, true Q_flow_nominal[i]=QNoRetrofit_flow_nominal[i] and TTra_nominal[i]=TSupNoRetrofit_nominal for i in nParallelDem"
    annotation (Dialog(group="Design - Internal: Parameters are defined by the subsystem at first design"));
  parameter Modelica.Units.SI.HeatFlowRate Q_flow_nominal_design[nParallelDem](each min=Modelica.Constants.eps) = {if NoRetrofit[i] then Q_flow_nominal_old_design[i] else Q_flow_nominal[i] for i in 1:nParallelDem}
    "Nominal heat flow rate at design of System" annotation (Dialog(group=
          "Design - Internal: Parameters are defined by the subsystem at first design"));
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal_design[nParallelDem](each
      min=Modelica.Constants.eps) = m_flow_nominal "Nominal mass flow rate at design" annotation (Dialog(
        group="Design - Internal: Parameters are defined by the subsystem at first design"));
  parameter Modelica.Units.SI.TemperatureDifference dTTra_nominal_design[nParallelDem] = dTTra_nominal
    "Nominal temperature difference for heat transfer at design" annotation (Dialog(group=
         "Design - Internal: Parameters are defined by the subsystem at first design"));
  parameter Modelica.Units.SI.PressureDifference dp_nominal_design[nParallelDem] = dp_nominal
    "Nominal pressure difference at m_flow_nominal_design" annotation (Dialog(group=
          "Design - Internal: Parameters are defined by the subsystem at first design"));

  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(graphics,
        coordinateSystem(preserveAspectRatio=false)));
end PartialSubsystemParameters;
