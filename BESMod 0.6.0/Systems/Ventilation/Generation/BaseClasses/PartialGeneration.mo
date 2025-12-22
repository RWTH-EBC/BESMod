within BESMod.Systems.Ventilation.Generation.BaseClasses;
partial model PartialGeneration
  "Base model for all ventilation generation systems"
  extends BESMod.Utilities.Icons.GenerationIcon;
  extends BESMod.Systems.BaseClasses.PartialFluidSubsystemWithParameters;
  parameter Modelica.Units.SI.PressureDifference dpDem_nominal[nParallelDem]
    "Nominal pressure loss of resistances in the demand system of the generation"
    annotation (Dialog(group=
          "Design - Top Down: Parameters are given by the parent system"));

  Interfaces.GenerationOutputs outBusGen if not use_openModelica
    annotation (Placement(transformation(extent={{88,-16},{116,14}})));
  Modelica.Fluid.Interfaces.FluidPort_b portVent_out[nParallelDem](redeclare
      final package Medium = Medium) "Outlet of the demand of Ventilation"
    annotation (Placement(transformation(extent={{-110,-50},{-90,-30}}),
        iconTransformation(extent={{-110,-50},{-90,-30}})));
  Modelica.Fluid.Interfaces.FluidPort_a portVent_in[nParallelDem](redeclare
      final package Medium = Medium) "Inlet for the demand of ventilation"
    annotation (Placement(transformation(extent={{-110,32},{-90,52}}),
        iconTransformation(extent={{-110,32},{-90,52}})));

  IBPSA.BoundaryConditions.WeatherData.Bus
      weaBus "Weather data bus" annotation (Placement(transformation(extent={{20,78},
            {62,122}}),          iconTransformation(extent={{-8,90},{12,
            110}})));

  Interfaces.GenerationControlBus sigBusGen
    annotation (Placement(transformation(extent={{-52,88},{-32,108}})));
  Electrical.Interfaces.InternalElectricalPinOut internalElectricalPin
    annotation (Placement(transformation(extent={{60,-108},{80,-88}})));
  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(graphics,
        coordinateSystem(preserveAspectRatio=false)));
end PartialGeneration;
