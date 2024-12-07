within BESMod.Systems.Hydraulical.Distribution.BaseClasses;
partial model PartialDistribution
  "Partial distribution model for HPS"
  extends BESMod.Utilities.Icons.StorageIcon;
  extends BESMod.Systems.BaseClasses.PartialFluidSubsystemWithParameters(
      final useRoundPipes=true,
      v_design=fill(0.7,nParallelDem),
      TSup_nominal=TDem_nominal .+ dTLoss_nominal .+ dTTra_nominal,
      TSupOld_design=TDemOld_design .+ dTLoss_nominal .+ dTTraOld_design);
  extends PartialDHWParameters;
  replaceable package MediumDHW =
      Modelica.Media.Interfaces.PartialMedium
    annotation (choicesAllMatching=true);

  replaceable package MediumGen =
      Modelica.Media.Interfaces.PartialMedium
    annotation (choicesAllMatching=true);
  parameter Boolean use_dhw=true "=false to disable DHW";
  parameter Modelica.Units.SI.MassFlowRate mSup_flow_nominal[nParallelSup](each min=Modelica.Constants.eps)
    "Nominal mass flow rate of system supplying the distribution" annotation (
      Dialog(group="Design - Top Down: Parameters are given by the parent system"));
  parameter Modelica.Units.SI.MassFlowRate mSupOld_flow_design[nParallelSup](each min=Modelica.Constants.eps) = mSup_flow_nominal
    "Old design mass flow rate of system supplying the distribution" annotation (
      Dialog(group="Design - Top Down: Parameters are given by the parent system"));
  parameter Modelica.Units.SI.MassFlowRate mSup_flow_design[nParallelSup](each min=Modelica.Constants.eps) = mSup_flow_nominal
    "Design mass flow rate of system supplying the distribution" annotation (
      Dialog(group="Design - Top Down: Parameters are given by the parent system"));
  parameter Modelica.Units.SI.MassFlowRate mDem_flow_nominal[nParallelDem](each min=Modelica.Constants.eps)
    "Nominal mass flow rate of demand system of the distribution" annotation (
      Dialog(group="Design - Top Down: Parameters are given by the parent system"));
  parameter Modelica.Units.SI.MassFlowRate mDemOld_flow_design[nParallelDem](each min=Modelica.Constants.eps) = mDem_flow_nominal
    "Old design mass flow rate of demand system of the distribution" annotation (
      Dialog(group="Design - Top Down: Parameters are given by the parent system"));
  parameter Modelica.Units.SI.MassFlowRate mDem_flow_design[nParallelDem](each min=Modelica.Constants.eps) = mDem_flow_nominal
    "Design mass flow rate of demand system of the distribution" annotation (
      Dialog(group="Design - Top Down: Parameters are given by the parent system"));
  parameter Modelica.Units.SI.TemperatureDifference dTTraDHW_nominal
    "Nominal temperature difference to transfer heat to the DHW storage"
    annotation (Dialog(group="DHW Demand"));
  parameter Modelica.Units.SI.PressureDifference dpSup_nominal[nParallelSup]
    "Nominal pressure loss of resistances connected to the supply system of the distribution"
    annotation (Dialog(group="Design - Top Down: Parameters are given by the parent system"));
  parameter Modelica.Units.SI.PressureDifference dpSupOld_design[nParallelSup]=dpSup_nominal
    "Old design pressure loss of resistances connected to the supply system of the distribution"
    annotation (Dialog(group="Design - Top Down: Parameters are given by the parent system"));
  parameter Modelica.Units.SI.PressureDifference dpDem_nominal[nParallelDem]
    "Nominal pressure loss of resistances connected to the demand system of the distribution"
    annotation (Dialog(group="Design - Top Down: Parameters are given by the parent system"));
  parameter Modelica.Units.SI.PressureDifference dpDemOld_design[nParallelDem] = dpDem_nominal
    "Old design pressure loss of resistances connected to the demand system of the distribution"
    annotation (Dialog(group="Design - Top Down: Parameters are given by the parent system"));

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
    outBusDist if not use_openModelica
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));
  BESMod.Systems.Electrical.Interfaces.InternalElectricalPinOut
    internalElectricalPin
    annotation (Placement(transformation(extent={{60,-108},{80,-88}})));
equation
  if not use_dhw then
  connect(portDHW_out, portDHW_in) annotation (Line(
      points={{100,-22},{100,-82}},
      color={0,127,255},
      pattern=LinePattern.Dash));
  end if;
  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
</html>"));
end PartialDistribution;
