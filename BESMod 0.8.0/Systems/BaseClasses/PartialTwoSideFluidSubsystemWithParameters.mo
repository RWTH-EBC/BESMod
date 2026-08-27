within BESMod.Systems.BaseClasses;
model PartialTwoSideFluidSubsystemWithParameters
  "Parameters for a single sided fluid subsystem"
  extends PartialSubsystemParameters;
  extends PartialPipeParameters;
  extends PartialFluidSubsystem;

  // Demand side
  parameter Modelica.Units.SI.MassFlowRate mDem_flow_nominal[nParallelDem](
    each min=Modelica.Constants.eps)
    "Nominal mass flow rate of demand system of the distribution" annotation (
      Dialog(group="Design - Top Down: Parameters are given by the parent system"));
  parameter Modelica.Units.SI.MassFlowRate mDem_flow_design[nParallelDem](
    each min=Modelica.Constants.eps) = mDem_flow_nominal
    "Design mass flow rate of demand system of the distribution" annotation (
      Dialog(group="Design - Internal: Parameters are defined by the subsystem"));
  parameter Modelica.Units.SI.MassFlowRate mDemOld_flow_design[nParallelDem](
    each min=Modelica.Constants.eps)
    "Old design mass flow rate of demand system of the distribution" annotation (
      Dialog(group="Design - Top Down: Parameters are given by the parent system"));

  parameter Modelica.Units.SI.PressureDifference dpDem_nominal[nParallelDem]
    "Nominal pressure loss of resistances connected to the demand system of the distribution"
    annotation (Dialog(tab="Pressure losses",
      group="Design - Top Down: Parameters are given by the parent system"));
  parameter Modelica.Units.SI.PressureDifference dpDem_design[nParallelDem] = dpDem_nominal
    "Design pressure loss of resistances connected to the demand system of the distribution"
    annotation (Dialog(tab="Pressure losses",
      group="Design - Internal: Parameters are defined by the subsystem"));
  parameter Modelica.Units.SI.PressureDifference dpDemOld_design[nParallelDem]
    "Old design pressure loss of resistances connected to the demand system of the distribution"
    annotation (Dialog(tab="Pressure losses",
      group="Design - Top Down: Parameters are given by the parent system"));

  parameter Modelica.Units.SI.Velocity vDem_design[nParallelDem]
    "Nominal fluid velocity at demand side, used to design pipes"
    annotation(Dialog(tab="Pressure losses",
      group="Design - Internal: Parameters are defined by the subsystem"));
  parameter Modelica.Units.SI.Length dPipDem_design[nParallelDem]=
    if useRoundPipes then
     sqrt(4*mDem_flow_design./rho./vDem_design./Modelica.Constants.pi)
    else
     sqrt(mDem_flow_design./rho./vDem_design)
      "Hydraulic diameter of pipes at demand side"
    annotation(Dialog(tab="Pressure losses",
      group="Design - Internal: Parameters are defined by the subsystem"));
  parameter Modelica.Units.SI.Velocity vDem_nominal[nParallelDem]=
    if useRoundPipes then
     sqrt(4*mDem_flow_nominal./rho./dPipDem_design./Modelica.Constants.pi)
    else
     sqrt(mDem_flow_nominal./rho./dPipDem_design)
    "Nominal fluid velocity at mDem_flow_nominal"
    annotation(Dialog(tab="Pressure losses",
      group="Design - Internal: Parameters are defined by the subsystem"));

  // Supply side
  parameter Modelica.Units.SI.MassFlowRate mSup_flow_nominal[nParallelSup](each min=Modelica.Constants.eps)
    "Nominal mass flow rate of system supplying the distribution" annotation (
      Dialog(group="Design - Top Down: Parameters are given by the parent system"));
  parameter Modelica.Units.SI.MassFlowRate mSup_flow_design[nParallelSup](each min=Modelica.Constants.eps) = mSup_flow_nominal
    "Design mass flow rate of system supplying the distribution" annotation (
      Dialog(group="Design - Internal: Parameters are defined by the subsystem"));
  parameter Modelica.Units.SI.MassFlowRate mSupOld_flow_design[nParallelSup](each min=Modelica.Constants.eps)
    "Old design mass flow rate of system supplying the distribution" annotation (
      Dialog(group="Design - Top Down: Parameters are given by the parent system"));

  parameter Modelica.Units.SI.PressureDifference dpSup_nominal[nParallelSup]
    "Nominal pressure loss of resistances connected to the supply system of the distribution"
    annotation (Dialog(tab="Pressure losses",
      group="Design - Top Down: Parameters are given by the parent system"));
  parameter Modelica.Units.SI.PressureDifference dpSup_design[nParallelSup] = dpSup_nominal
    "Design pressure loss of resistances connected to the supply system of the distribution"
    annotation (Dialog(tab="Pressure losses",
      group="Design - Internal: Parameters are defined by the subsystem"));
  parameter Modelica.Units.SI.PressureDifference dpSupOld_design[nParallelSup]=dpSup_nominal
    "Old design pressure loss of resistances connected to the supply system of the distribution"
    annotation (Dialog(tab="Pressure losses",
      group="Design - Top Down: Parameters are given by the parent system"));

  parameter Modelica.Units.SI.Velocity vSup_design[nParallelSup]
    "Nominal fluid velocity at demand side, used to design pipes"
    annotation(Dialog(tab="Pressure losses",
      group="Design - Internal: Parameters are defined by the subsystem"));
  parameter Modelica.Units.SI.Length dPipSup_design[nParallelSup]=
    if useRoundPipes then
     sqrt(4*mSup_flow_design./rho./vSup_design./Modelica.Constants.pi)
    else
     sqrt(mSup_flow_design./rho./vSup_design)
      "Hydraulic diameter of pipes at demand side"
    annotation(Dialog(tab="Pressure losses",
      group="Design - Internal: Parameters are defined by the subsystem"));
  parameter Modelica.Units.SI.Velocity vSup_nominal[nParallelSup]=
    if useRoundPipes then
     sqrt(4*mSup_flow_nominal./rho./dPipSup_design./Modelica.Constants.pi)
    else
     sqrt(mSup_flow_nominal./rho./dPipSup_design)
    "Nominal fluid velocity at m_flow_nominal"
    annotation(Dialog(tab="Pressure losses",
      group="Design - Internal: Parameters are defined by the subsystem"));
  annotation (Documentation(info="<html>
  <p>This model contains parameters relevant for a fluid subsystem with fluid 
  ports on two sides, e.g. distribution system.</p>
</html>"));
end PartialTwoSideFluidSubsystemWithParameters;
