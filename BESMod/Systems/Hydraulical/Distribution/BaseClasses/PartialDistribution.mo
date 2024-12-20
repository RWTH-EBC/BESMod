within BESMod.Systems.Hydraulical.Distribution.BaseClasses;
partial model PartialDistribution
  "Partial distribution model for HPS"
  extends BESMod.Utilities.Icons.StorageIcon;
  extends BESMod.Systems.BaseClasses.PartialTwoSideFluidSubsystemWithParameters(
    Q_flow_design={if use_oldHeat_design[i] then QOld_flow_design[i] else
        Q_flow_nominal[i] for i in 1:nParallelDem},
    mSup_flow_design={if use_oldSupPump_design[i] then mSupOld_flow_design[i] else
        mSup_flow_nominal[i] for i in 1:nParallelSup},
    dpSup_design={if use_oldSupPump_design[i] then dpSupOld_design[i] else
        dpSup_nominal[i] for i in 1:nParallelSup},
    mDem_flow_design={if use_oldDemPump_design[i] then mDemOld_flow_design[i] else
        mDem_flow_nominal[i] for i in 1:nParallelDem},
    dpDem_design={if use_oldDemPump_design[i] then dpDemOld_design[i] else
        dpDem_nominal[i] for i in 1:nParallelDem},
    final useRoundPipes=true,
    vSup_design=fill(0.7,nParallelDem),
    vDem_design=fill(0.5,nParallelDem),
    TSup_nominal=TDem_nominal .+ dTLoss_nominal .+ dTTra_nominal,
    TSupOld_design=TDemOld_design .+ dTLoss_nominal .+ dTTraOld_design);
  extends PartialDHWParameters;
  parameter Boolean use_dhw=true "=false to disable DHW";

  parameter Boolean use_oldHeat_design[nParallelDem]=fill(false, nParallelDem)
    "If true, design heat flow rates of the demand system with no retrofit (old state) are used"
    annotation (Dialog(group="Design - Internal: Parameters are defined by the subsystem"));
  parameter Boolean use_oldDemPump_design[nParallelDem]=fill(false, nParallelDem)
    "If true, design parameters of the demand system with no retrofit (old state) for pumps are used"
    annotation (Dialog(group="Design - Internal: Parameters are defined by the subsystem"));
  parameter Boolean use_oldSupPump_design[nParallelDem]=fill(false, nParallelDem)
    "If true, design parameters of the supply system with no retrofit (old state) for pumps are used"
    annotation (Dialog(group="Design - Internal: Parameters are defined by the subsystem"));

  replaceable package MediumDHW =
      Modelica.Media.Interfaces.PartialMedium
    annotation (choicesAllMatching=true);

  replaceable package MediumGen =
      Modelica.Media.Interfaces.PartialMedium
    annotation (choicesAllMatching=true);

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
