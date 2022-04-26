within BESMod.Systems.Ventilation.Distribution.BaseClasses;
partial model PartialDistribution
  "Base distribution model for ventilation systems"
    extends BESMod.Utilities.Icons.DistributionIcon;

    extends
    BESMod.Systems.BaseClasses.PartialFluidSubsystemWithParameters;

  Modelica.Fluid.Interfaces.FluidPort_a portExh_in[nParallelDem](
      redeclare final package Medium = Medium)
    "Inlet for the demand of ventilation" annotation (Placement(transformation(
          extent={{-110,-70},{-90,-50}}), iconTransformation(extent={{-110,-50},
            {-90,-30}})));
  Modelica.Fluid.Interfaces.FluidPort_b portSupply_out[nParallelDem](
     redeclare final package Medium = Medium)
    "Outlet of the demand of Ventilation" annotation (Placement(transformation(
          extent={{-110,50},{-90,70}}), iconTransformation(extent={{-110,30},{-90,
            50}})));
  Modelica.Fluid.Interfaces.FluidPort_a portSupply_in[nParallelSup](redeclare
      final package Medium =
               Medium)
    "Inlet for the demand of ventilation" annotation (Placement(transformation(
          extent={{90,50},{110,70}}), iconTransformation(extent={{90,30},{110,50}})));
  Modelica.Fluid.Interfaces.FluidPort_b portExh_out[nParallelSup](redeclare
      final package Medium =
               Medium)
    "Outlet of the demand of Ventilation" annotation (Placement(transformation(
          extent={{90,-70},{110,-50}}), iconTransformation(extent={{90,-50},{110,
            -30}})));
  Interfaces.DistributionOutputs
                               outBusDist
    annotation (Placement(transformation(extent={{-14,-114},{14,-84}})));
  Interfaces.DistributionControlBus sigBusDistr
    annotation (Placement(transformation(extent={{-10,90},{10,110}})));
  Electrical.Interfaces.InternalElectricalPin internalElectricalPin
    annotation (Placement(transformation(extent={{60,-108},{80,-88}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialDistribution;
