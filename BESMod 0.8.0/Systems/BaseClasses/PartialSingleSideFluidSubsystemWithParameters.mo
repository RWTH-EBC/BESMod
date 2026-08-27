within BESMod.Systems.BaseClasses;
model PartialSingleSideFluidSubsystemWithParameters
  "Parameters for a single sided fluid subsystem"
  extends PartialSubsystemParameters;
  extends PartialPipeParameters;
  extends PartialFluidSubsystem;


  // Mass flow rates
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal[nParallelDem](each
      min=Modelica.Constants.eps) "Nominal mass flow rate" annotation (Dialog(
        group="Design - Bottom Up: Parameters are defined by the subsystem"));
  parameter Modelica.Units.SI.MassFlowRate mOld_flow_design[nParallelDem](each
      min=Modelica.Constants.eps)=m_flow_nominal "Design mass flow rate of old design" annotation (Dialog(
        group="Design - Bottom Up: Parameters are defined by the subsystem"));
  parameter Modelica.Units.SI.MassFlowRate m_flow_design[nParallelDem](each
      min=Modelica.Constants.eps) = m_flow_nominal "Nominal design mass flow rate" annotation (Dialog(
        group="Design - Internal: Parameters are defined by the subsystem"));

  parameter Modelica.Units.SI.PressureDifference dpOld_design[nParallelDem] =
    dp_design .* (mOld_flow_design ./ m_flow_design).^2
    "Old design pressure difference at mOld_flow_design"
    annotation (Dialog(tab="Pressure losses",
    group="Design - Internal: Parameters are defined by the subsystem"));
  parameter Modelica.Units.SI.PressureDifference dp_design[nParallelDem]
    "Design pressure difference at m_flow_design"
         annotation (Dialog(tab="Pressure losses",
    group="Design - Bottom Up: Parameters are defined by the subsystem"));
  parameter Modelica.Units.SI.PressureDifference dp_nominal[nParallelDem] =
    dp_design .* (m_flow_nominal ./ m_flow_design).^2
    "Nominal pressure difference at m_flow_nominal"
    annotation (Dialog(tab="Pressure losses",
    group="Design - Internal: Parameters are defined by the subsystem"));

  parameter Modelica.Units.SI.Velocity v_design[nParallelDem]
    "Nominal fluid velocity, used to design pipes"
    annotation(Dialog(tab="Pressure losses",
      group="Design - Internal: Parameters are defined by the subsystem"));
  parameter Modelica.Units.SI.Length dPip_design[nParallelDem]=
    if useRoundPipes then
     sqrt(4*m_flow_design./rho./v_design./Modelica.Constants.pi)
    else
     sqrt(m_flow_design./rho./v_design)
      "Hydraulic diameter of pipes"
    annotation(Dialog(tab="Pressure losses",
      group="Design - Internal: Parameters are defined by the subsystem"));
  parameter Modelica.Units.SI.Velocity v_nominal[nParallelDem]=
    if useRoundPipes then
     sqrt(4*m_flow_nominal./rho./dPip_design./Modelica.Constants.pi)
    else
     sqrt(m_flow_nominal./rho./dPip_design)
    "Nominal fluid velocity at m_flow_nominal"
    annotation(Dialog(tab="Pressure losses",
      group="Design - Internal: Parameters are defined by the subsystem"));

  annotation (Documentation(info="<html>
  <p>This model contains parameters relevant for a fluid subsystem with fluid 
  ports only on one side, e.g. generation or transfer system.</p>
</html>"));
end PartialSingleSideFluidSubsystemWithParameters;
