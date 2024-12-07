within BESMod.Systems.BaseClasses;
model PartialFluidSubsystemWithParameters
  extends PartialSubsystemParameters;
  extends PartialFluidSubsystem;

  parameter Boolean useRoundPipes "=false to use quadratic pipes for ventilation"
    annotation(Dialog(tab="Pressure losses",
      group="Design - Internal: Parameters are defined by the subsystem"));
  parameter Modelica.Units.SI.Velocity v_design[nParallelDem]
    "Nominal fluid velocity, used to design pipes"
    annotation(Dialog(tab="Pressure losses",
      group="Design - Internal: Parameters are defined by the subsystem"));
  parameter Modelica.Units.SI.Length roughness=2.5e-5
    "Absolute roughness of pipe, with a default for a smooth steel pipe (dummy if use_roughness = false)"
    annotation(Dialog(tab="Pressure losses",
      group="Design - Internal: Parameters are defined by the subsystem"));
  parameter Real ReC=4000
    "Reynolds number where transition to turbulence starts"
    annotation(Dialog(tab="Pressure losses",
      group="Design - Internal: Parameters are defined by the subsystem"));
  parameter Real facPerBend=0.7 "Resistance factor due to one bend"
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

end PartialFluidSubsystemWithParameters;
