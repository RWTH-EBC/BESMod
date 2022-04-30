within BESMod.Systems.Hydraulical.Distribution.BaseClasses;
partial model PartialDistribution
  "Partial distribution model for HPS"
  extends BESMod.Utilities.Icons.StorageIcon;
  extends
    BESMod.Systems.BaseClasses.PartialFluidSubsystemWithParameters(      final
      dp_nominal=dpDem_nominal,
      TSup_nominal=TDem_nominal .+ dTLoss_nominal .+ dTTra_nominal);
  extends PartialDHWParameters;
  replaceable package MediumDHW =
      Modelica.Media.Interfaces.PartialMedium
    annotation (choicesAllMatching=true);

  replaceable package MediumGen =
      Modelica.Media.Interfaces.PartialMedium
    annotation (choicesAllMatching=true);
  parameter Modelica.Units.SI.MassFlowRate mSup_flow_nominal[nParallelSup]
    "Nominal mass flow rate of system supplying the distribution" annotation (
      Dialog(group=
          "Design - Top Down: Parameters are given by the parent system"));
  parameter Modelica.Units.SI.MassFlowRate mDem_flow_nominal[nParallelDem]
    "Nominal mass flow rate of demand system of the distribution" annotation (
      Dialog(group=
          "Design - Top Down: Parameters are given by the parent system"));
  parameter Modelica.Units.SI.TemperatureDifference dTTraDHW_nominal
    "Nominal temperature difference to transfer heat to the DHW storage"
    annotation (Dialog(group="DHW Demand"));
  parameter Modelica.Units.SI.PressureDifference dpSup_nominal[nParallelSup]
    "Nominal pressure loss of resistances connected to the supply system of the distribution"
    annotation (Dialog(group=
          "Design - Bottom Up: Parameters are defined by the subsystem"));
  parameter Modelica.Units.SI.PressureDifference dpDem_nominal[nParallelDem]
    "Nominal pressure loss of resistances connected to the demand system of the distribution"
    annotation (Dialog(group=
          "Design - Bottom Up: Parameters are defined by the subsystem"));

  Modelica.Fluid.Interfaces.FluidPort_a portGen_in[nParallelSup](redeclare
      final package Medium = MediumGen) "Inlet from the generation" annotation (
     Placement(transformation(extent={{-110,70},{-90,90}}), iconTransformation(
          extent={{-110,70},{-90,90}})));
  Modelica.Fluid.Interfaces.FluidPort_b portGen_out[nParallelSup](redeclare
      final package Medium = MediumGen) "Outlet to the generation" annotation (
      Placement(transformation(extent={{-110,30},{-90,50}}), iconTransformation(
          extent={{-110,30},{-90,50}})));
  Modelica.Fluid.Interfaces.FluidPort_b portBui_out[nParallelDem](redeclare
      final package Medium =
               Medium) "Outlet for the distribution to the building"
    annotation (Placement(transformation(extent={{90,70},{110,90}}),
        iconTransformation(extent={{90,70},{110,90}})));
  Modelica.Fluid.Interfaces.FluidPort_a portBui_in[nParallelDem](redeclare
      final package Medium =
               Medium) "Inlet for the distribution from the building"
    annotation (Placement(transformation(extent={{90,30},{110,50}}),
        iconTransformation(extent={{90,30},{110,50}})));

  Modelica.Fluid.Interfaces.FluidPort_b portDHW_out(redeclare final package
      Medium = MediumDHW) "Outlet for the distribution to the DHW" annotation (
      Placement(transformation(extent={{90,-32},{110,-12}}), iconTransformation(
          extent={{90,-30},{110,-10}})));
  Modelica.Fluid.Interfaces.FluidPort_a portDHW_in(redeclare final package
      Medium = MediumDHW) "Inet for the distribution from the DHW" annotation (
      Placement(transformation(extent={{90,-92},{110,-72}}), iconTransformation(
          extent={{90,-70},{110,-50}})));

  BESMod.Systems.Hydraulical.Interfaces.DistributionControlBus
    sigBusDistr
    annotation (Placement(transformation(extent={{-24,80},{24,122}})));
  BESMod.Systems.Hydraulical.Interfaces.DistributionOutputs
    outBusDist
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));
  Electrical.Interfaces.InternalElectricalPin internalElectricalPin
    annotation (Placement(transformation(extent={{60,-108},{80,-88}})));
  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(graphics,
        coordinateSystem(preserveAspectRatio=false)));
end PartialDistribution;
