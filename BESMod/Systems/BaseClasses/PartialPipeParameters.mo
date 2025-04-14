within BESMod.Systems.BaseClasses;
partial model PartialPipeParameters "Contains parameters for pipes"

  parameter Boolean useRoundPipes
    "=false to use quadratic pipes for ventilation"
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

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialPipeParameters;
