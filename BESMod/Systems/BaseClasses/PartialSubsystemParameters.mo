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
  parameter Modelica.Units.SI.Temperature TSupOld_design[nParallelSup]=TSup_nominal
    "Old design supply temperature" annotation (Dialog(group=
          "Design - Bottom Up: Parameters are defined by the subsystem"));
  parameter Modelica.Units.SI.TemperatureDifference dTTra_nominal[nParallelDem]
    "Nominal temperature difference for heat transfer" annotation (Dialog(group=
         "Design - Bottom Up: Parameters are defined by the subsystem"));
  parameter Modelica.Units.SI.TemperatureDifference dTTraOld_design[nParallelDem]=dTTra_nominal
    "Old design temperature difference for heat transfer" annotation (Dialog(group=
         "Design - Bottom Up: Parameters are defined by the subsystem"));

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal[nParallelDem](each
      min=Modelica.Constants.eps) "Nominal mass flow rate" annotation (Dialog(
        group="Design - Bottom Up: Parameters are defined by the subsystem"));

  parameter Modelica.Units.SI.MassFlowRate mOld_flow_design[nParallelDem](each
      min=Modelica.Constants.eps)=m_flow_nominal "Design mass flow rate of old design" annotation (Dialog(
        group="Design - Bottom Up: Parameters are defined by the subsystem"));
  /*  parameter Modelica.Units.SI.PressureDifference dpOld_design[nParallelDem] =
    dp_design .* (mOld_flow_design ./ m_flow_design).^2
    "Old design pressure difference at mOld_flow_design"
    annotation (Dialog(tab="Pressure losses",
    group="Design - Internal: Parameters are defined by the subsystem"));
  */
  parameter Modelica.Units.SI.PressureDifference dp_design[nParallelDem]
    "Design pressure difference at m_flow_design"
         annotation (Dialog(tab="Pressure losses",
    group="Design - Bottom Up: Parameters are defined by the subsystem"));
  parameter Modelica.Units.SI.PressureDifference dp_nominal[nParallelDem] =
    dp_design .* (m_flow_nominal ./ m_flow_design).^2
    "Nominal pressure difference at m_flow_nominal"
    annotation (Dialog(tab="Pressure losses",
    group="Design - Internal: Parameters are defined by the subsystem"));

  parameter Modelica.Units.SI.TemperatureDifference dTLoss_nominal[nParallelDem]=
     fill(0, nParallelDem) "Nominal temperature difference due to heat losses"
    annotation (Dialog(tab="Heat Losses", group=
          "Design - Bottom Up: Parameters are defined by the subsystem"));
  parameter Real f_design[nParallelDem]=fill(1, nParallelDem)
    "Factor for oversizing, e.g. due to heat losses"
    annotation (Dialog(group="Design - Bottom Up: Parameters are defined by the subsystem"));
  parameter Modelica.Units.SI.HeatFlowRate QLoss_flow_nominal[nParallelDem]=
      f_design .* Q_flow_nominal .- Q_flow_nominal
    "Nominal heat flow rate due to heat losses"
    annotation (Dialog(tab="Heat Losses", group="Design - Bottom Up: Parameters are defined by the subsystem"));

  parameter Modelica.Units.SI.HeatFlowRate Q_flow_nominal[nParallelDem](each min=Modelica.Constants.eps)
    "Nominal heat flow rate" annotation (Dialog(group=
          "Design - Top Down: Parameters are given by the parent system"));

  parameter Modelica.Units.SI.HeatFlowRate QOld_flow_design[nParallelDem](each min=Modelica.Constants.eps) = Q_flow_nominal
    "Old design heat flow rate" annotation (Dialog(group=
          "Design - Top Down: Parameters are given by the parent system"));
  parameter Modelica.Units.SI.Temperature TOda_nominal
    "Nominal outdoor air temperature" annotation (Dialog(group=
          "Design - Top Down: Parameters are given by the parent system"));
  parameter Modelica.Units.SI.Temperature TDem_nominal[nParallelDem]
    "Nominal demand temperature" annotation (Dialog(group=
          "Design - Top Down: Parameters are given by the parent system"));
  parameter Modelica.Units.SI.Temperature TDemOld_design[nParallelDem]=TDem_nominal
    "Old design demand temperature" annotation (Dialog(group=
          "Design - Top Down: Parameters are given by the parent system"));
  parameter Modelica.Units.SI.Temperature TAmb
    "Ambient temperature of system. Used to calculate default heat loss."
    annotation (Dialog(group=
          "Design - Top Down: Parameters are given by the parent system"));

  parameter Modelica.Units.SI.HeatFlowRate Q_flow_design[nParallelDem](each min=Modelica.Constants.eps) = Q_flow_nominal
    "Nominal design heat flow rate" annotation (Dialog(group=
          "Design - Internal: Parameters are defined by the subsystem"));
  parameter Modelica.Units.SI.MassFlowRate m_flow_design[nParallelDem](each
      min=Modelica.Constants.eps) = m_flow_nominal "Nominal design mass flow rate" annotation (Dialog(
        group="Design - Internal: Parameters are defined by the subsystem"));
  parameter Modelica.Units.SI.TemperatureDifference dTTra_design[nParallelDem] = dTTra_nominal
    "Nominal design temperature difference for heat transfer" annotation (Dialog(group=
         "Design - Internal: Parameters are defined by the subsystem"));

    annotation (Dialog(group=
          "Design - Internal: Parameters are defined by the subsystem"),
              Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(graphics,
        coordinateSystem(preserveAspectRatio=false)));
end PartialSubsystemParameters;
