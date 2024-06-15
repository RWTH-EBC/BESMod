within BESMod.Systems.Hydraulical.Generation.BaseClasses;
partial model PartialGeneration "Partial generation model for HPS"
  extends BESMod.Utilities.Icons.GenerationIcon;
  extends BESMod.Systems.BaseClasses.PartialFluidSubsystemWithParameters(
    final TSup_nominal=TDem_nominal .+ dTLoss_nominal,
    m_flow_nominal=Q_flow_nominal .* f_design ./ dTTra_nominal ./ 4184,                final
      nParallelSup=nParallelDem);

  parameter Modelica.Units.SI.PressureDifference dpDem_nominal[nParallelDem]
    "Nominal pressure loss of resistances in the demand system of the generation"
    annotation (Dialog(group=
          "Design - Top Down: Parameters are given by the parent system"));

  BESMod.Systems.Hydraulical.Interfaces.GenerationControlBus
    sigBusGen
    annotation (Placement(transformation(extent={{-18,78},{22,118}})));
  Modelica.Fluid.Interfaces.FluidPort_b portGen_out[nParallelDem](redeclare
      final package Medium = Medium) "Outlet of the generation" annotation (
      Placement(transformation(extent={{90,70},{110,90}}), iconTransformation(
          extent={{90,70},{110,90}})));
  Modelica.Fluid.Interfaces.FluidPort_a portGen_in[nParallelDem](redeclare final
      package       Medium = Medium) "Inlet to the generation" annotation (
      Placement(transformation(extent={{90,-12},{110,8}}), iconTransformation(
          extent={{90,30},{110,50}})));
  BESMod.Systems.Hydraulical.Interfaces.GenerationOutputs
    outBusGen if not use_openModelica
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));

  IBPSA.BoundaryConditions.WeatherData.Bus
      weaBus "Weather data bus" annotation (Placement(transformation(extent={{-122,58},
            {-80,102}}),         iconTransformation(extent={{-108,50},{-88,
            70}})));
  BESMod.Systems.Electrical.Interfaces.InternalElectricalPinOut
    internalElectricalPin
    annotation (Placement(transformation(extent={{62,-110},{82,-90}})));
  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(graphics,
        coordinateSystem(preserveAspectRatio=false)));
end PartialGeneration;
