within BESMod.Systems.Ventilation.BaseClasses;
partial model PartialVentilationSystem
  extends BESMod.Utilities.Icons.VentilationIcon;
  extends BESMod.Systems.BaseClasses.PartialFluidSubsystem;
  parameter Boolean subsystemDisabled "To enable the icon if the subsystem is disabled" annotation (Dialog(tab="Graphics"));

  replaceable parameter RecordsCollection.SupplySystemBaseDataDefinition
    ventilationSystemParameters constrainedby
    RecordsCollection.SupplySystemBaseDataDefinition
    annotation (choicesAllMatching=true,
    Dialog(group="Design - Top Down: Parameters are given by the parent system"),
    Placement(transformation(extent={{-100,-98},{-80,-78}})));
  replaceable Generation.BaseClasses.PartialGeneration generation(
      dTTra_nominal=fill(1, generation.nParallelDem),
      m_flow_nominal=fill(1, generation.nParallelDem),
      dp_nominal=fill(0, generation.nParallelDem))
    constrainedby Generation.BaseClasses.PartialGeneration(
    Q_flow_nominal={sum(distribution.Q_flow_nominal .* distribution.f_design)},
    redeclare final package Medium = Medium,
    final energyDynamics=energyDynamics,
    final massDynamics=massDynamics,
    TOda_nominal=ventilationSystemParameters.TOda_nominal,
    final TDem_nominal=distribution.TSup_nominal,
    final TAmb=ventilationSystemParameters.TAmb,
    final p_start=p_start,
    final T_start=T_start,
    final X_start=X_start,
    final C_start=C_start,
    final C_nominal=C_nominal,
    final mSenFac=mSenFac,
    final allowFlowReversal=allowFlowReversal,
    final show_T=show_T,
    final rho=rho,
    final cp=cp,
    dpDem_nominal=distribution.dp_nominal,
    final use_openModelica=use_openModelica)
    annotation (choicesAllMatching=true, Placement(transformation(extent={{26,-56},
            {80,-2}})));

  replaceable Distribution.BaseClasses.PartialDistribution distribution(
      dTTra_nominal=fill(1, distribution.nParallelDem),
      m_flow_nominal=fill(1, distribution.nParallelDem),
      dp_nominal=fill(0, distribution.nParallelDem))
    constrainedby Distribution.BaseClasses.PartialDistribution(
    redeclare package Medium = Medium,
    final nParallelDem=ventilationSystemParameters.nZones,
    final Q_flow_nominal=ventilationSystemParameters.Q_flow_nominal,
    TOda_nominal=ventilationSystemParameters.TOda_nominal,
    final TDem_nominal=ventilationSystemParameters.TZone_nominal,
    final TSup_nominal=ventilationSystemParameters.TSup_nominal,
    final TAmb=ventilationSystemParameters.TAmb,
    final energyDynamics=energyDynamics,
    final massDynamics=massDynamics,
    final p_start=p_start,
    final T_start=T_start,
    final X_start=X_start,
    final C_start=C_start,
    final C_nominal=C_nominal,
    final mSenFac=mSenFac,
    final allowFlowReversal=allowFlowReversal,
    final show_T=show_T,
    final rho=rho,
    final cp=cp,
    final use_openModelica=use_openModelica)
    annotation (choicesAllMatching=true, Placement(transformation(extent={{-60,-52},{-16,0}})));

  replaceable Control.BaseClasses.PartialControl control constrainedby
    Control.BaseClasses.PartialControl(
    final parGen(
      final nParallelDem=generation.nParallelDem,
      final nParallelSup=generation.nParallelSup,
      final Q_flow_nominal=generation.Q_flow_nominal,
      final TOda_nominal=ventilationSystemParameters.TOda_nominal,
      final TDem_nominal=generation.TDem_nominal,
      final TSup_nominal=generation.TSup_nominal,
      final dTTra_nominal=generation.dTTra_nominal,
      final m_flow_nominal=generation.m_flow_nominal,
      final dp_nominal=generation.dp_nominal,
      final dTLoss_nominal=generation.dTLoss_nominal,
      final f_design=generation.f_design,
      final QLoss_flow_nominal=generation.QLoss_flow_nominal),
    final parDis(
      final nParallelDem=distribution.nParallelDem,
      final nParallelSup=distribution.nParallelSup,
      final Q_flow_nominal=distribution.Q_flow_nominal,
      final TDem_nominal=distribution.TDem_nominal,
      final TSup_nominal=distribution.TSup_nominal,
      final dTTra_nominal=distribution.dTTra_nominal,
      final m_flow_nominal=distribution.m_flow_nominal,
      final dp_nominal=distribution.dp_nominal,
      final dTLoss_nominal=distribution.dTLoss_nominal,
      final f_design=distribution.f_design,
      final TOda_nominal=ventilationSystemParameters.TOda_nominal,
      final QLoss_flow_nominal=distribution.QLoss_flow_nominal),
    final use_openModelica=use_openModelica) annotation (choicesAllMatching=
        true, Placement(transformation(extent={{-26,22},{28,68}})));
  BESMod.Systems.Interfaces.VentilationOutputs outBusVen if not
    use_openModelica
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));
  IBPSA.BoundaryConditions.WeatherData.Bus
      weaBus "Weather data bus" annotation (Placement(transformation(extent={{88,60},
            {122,88}}),          iconTransformation(extent={{90,-10},{110,10}})));
  Modelica.Fluid.Interfaces.FluidPort_a portVent_in[
    ventilationSystemParameters.nZones](
      redeclare final package Medium = Medium)
    "Inlet for the demand of ventilation"
    annotation (Placement(transformation(extent={{-110,50},{-90,70}}),
        iconTransformation(extent={{-110,30},{-90,50}})));
  Modelica.Fluid.Interfaces.FluidPort_b portVent_out[
    ventilationSystemParameters.nZones](
      redeclare final package Medium = Medium)
    "Outlet of the demand of Ventilation"
    annotation (Placement(transformation(extent={{-110,-70},{-90,-50}}),
        iconTransformation(extent={{-110,-48},{-90,-28}})));

  BESMod.Systems.Interfaces.BuiMeaBus buiMeaBus annotation (
      Placement(transformation(extent={{-74,86},{-46,112}}), iconTransformation(
          extent={{38,88},{64,114}})));
  BESMod.Systems.Interfaces.UseProBus useProBus annotation (
      Placement(transformation(extent={{24,80},{60,120}}), iconTransformation(
          extent={{-78,86},{-50,116}})));

  Interfaces.SystemControlBus sigBusVen annotation (Placement(transformation(
          extent={{-18,86},{18,114}}), iconTransformation(extent={{-18,86},{18,
            114}})));
  Electrical.Interfaces.InternalElectricalPinOut internalElectricalPin
    annotation (Placement(transformation(extent={{60,-108},{80,-88}})));
  BESMod.Utilities.Electrical.MultiSumElec multiSumElec(nPorts=2) annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={40,-98})));
equation
  connect(weaBus, generation.weaBus) annotation (Line(
      points={{105,74},{53.54,74},{53.54,-2}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(generation.outBusGen, outBusVen.generation) annotation (Line(
      points={{80.54,-29.27},{104,-29.27},{104,-84},{0,-84},{0,-100}},
      color={135,135,135},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(generation.portVent_in, distribution.portSupply_in) annotation (
      Line(
        points={{26,-17.66},{2,-17.66},{2,-15.6},{-16,-15.6}},
                                                           color={0,127,255}));
  connect(distribution.portExh_out, generation.portVent_out) annotation (Line(
        points={{-16,-36.4},{4,-36.4},{4,-39.8},{26,-39.8}},
                                                     color={0,127,255}));
  connect(distribution.portSupply_out, portVent_in) annotation (Line(points={{
          -60,
          -15.6},{-82,-15.6},{-82,60},{-100,60}},
                                                color={0,127,255}));
  connect(distribution.portExh_in, portVent_out) annotation (Line(points={{-60,
          -36.4},
          {-82,-36.4},{-82,-60},{-100,-60}},
                                           color={0,127,255}));
  connect(distribution.outBusDist, outBusVen.distribution) annotation (Line(
      points={{-38,-51.74},{-38,-84},{0,-84},{0,-100}},
      color={135,135,135},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  connect(weaBus, control.weaBus) annotation (Line(
      points={{105,74},{1.54,74},{1.54,68}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(control.outBusCtrl, outBusVen.control) annotation (Line(
      points={{28,45},{54,45},{54,46},{104,46},{104,-84},{0,-84},{0,-100}},
      color={135,135,135},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(control.sigBusDistr, distribution.sigBusDistr) annotation (Line(
      points={{-15.2,22.46},{-25.6,22.46},{-25.6,0},{-38,0}},
      color={215,215,215},
      thickness=0.5));
  connect(control.sigBusGen, generation.sigBusGen) annotation (Line(
      points={{17.2,22},{16,22},{16,-2.54},{41.66,-2.54}},
      color={215,215,215},
      thickness=0.5));
  connect(control.useProBus, useProBus) annotation (Line(
      points={{-27.35,31.89},{-40,31.89},{-40,88},{42,88},{42,100}},
      color={0,127,0},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(control.buiMeaBus, buiMeaBus) annotation (Line(
      points={{-26.81,58.34},{-60,58.34},{-60,99}},
      color={255,128,0},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(sigBusVen, control.sigBusVen) annotation (Line(
      points={{0,100},{0,92},{-46,92},{-46,45.23},{-27.08,45.23}},
      color={215,215,215},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(multiSumElec.internalElectricalPinOut, internalElectricalPin)
    annotation (Line(
      points={{50,-98},{70,-98}},
      color={0,0,0},
      thickness=1));
  connect(generation.internalElectricalPin, multiSumElec.internalElectricalPinIn[
    1]) annotation (Line(
      points={{71.9,-55.46},{74,-55.46},{74,-78},{20,-78},{20,-98.05},{30.2,
          -98.05}},
      color={0,0,0},
      thickness=1));
  connect(distribution.internalElectricalPin, multiSumElec.internalElectricalPinIn[
    2]) annotation (Line(
      points={{-22.6,-51.48},{-22.6,-78},{20,-78},{20,-97.55},{30.2,-97.55}},
      color={0,0,0},
      thickness=1));
  annotation (Icon(
      graphics,              coordinateSystem(preserveAspectRatio=false)), Diagram(graphics,
        coordinateSystem(preserveAspectRatio=false)));
end PartialVentilationSystem;
