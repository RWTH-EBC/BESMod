within BESMod.Systems.Hydraulical.BaseClasses;
partial model PartialHydraulicSystem
  "Complete hydraulic system model"
  extends BESMod.Systems.BaseClasses.PartialFluidSubsystem;
  parameter Boolean subsystemDisabled "To enable the icon if the subsystem is disabled" annotation (Dialog(tab="Graphics"));
  parameter Boolean use_dhw=true "=false to disable DHW";
  parameter Boolean use_for_fmu_inputs=false
  "=true to enable temperature sensors at fluid ports of subsystems" annotation(Dialog(tab="Advanced"));
  replaceable package MediumDHW = IBPSA.Media.Water constrainedby
    Modelica.Media.Interfaces.PartialMedium
    annotation (__Dymola_choicesAllMatching=true);
  BESMod.Systems.Electrical.Interfaces.InternalElectricalPinOut
    internalElectricalPin
    annotation (Placement(transformation(extent={{160,-150},{180,-130}})));
  replaceable parameter BESMod.Systems.Hydraulical.RecordsCollection.HydraulicSystemBaseDataDefinition
    hydraulicSystemParameters constrainedby
    BESMod.Systems.Hydraulical.RecordsCollection.HydraulicSystemBaseDataDefinition
    annotation (choicesAllMatching=true, Placement(transformation(extent={{-178,-136},{-158,-116}})));

  replaceable BESMod.Systems.Hydraulical.Generation.BaseClasses.PartialGeneration generation(
      dTTra_nominal=fill(1, generation.nParallelDem), dp_nominal=fill(0,
        generation.nParallelDem))       constrainedby
    BESMod.Systems.Hydraulical.Generation.BaseClasses.PartialGeneration(
    final TDem_nominal=distribution.TSup_nominal,
    final Q_flow_nominal={sum(distribution.Q_flow_nominal)*generation.f_design[
        i] + distribution.QDHWBefSto_flow_nominal for i in 1:generation.nParallelDem},
    redeclare package Medium = Medium,
    final dpDem_nominal=distribution.dpSup_nominal,
    final energyDynamics=energyDynamics,
    final massDynamics=massDynamics,
    final p_start=p_start,
    final T_start=T_start,
    final TOda_nominal=hydraulicSystemParameters.TOda_nominal,
    final X_start=X_start,
    final C_start=C_start,
    final TAmb=hydraulicSystemParameters.TAmb,
    final C_nominal=C_nominal,
    final mSenFac=mSenFac,
    final allowFlowReversal=allowFlowReversal,
    final show_T=show_T,
    final rho=rho,
    final cp=cp,
    final use_openModelica=use_openModelica) annotation (
      choicesAllMatching=true, Placement(transformation(extent={{-140,-104},{-24,
            28}})));
  replaceable BESMod.Systems.Hydraulical.Control.BaseClasses.PartialControl control
    constrainedby Control.BaseClasses.PartialControl(
    final use_dhw=use_dhw,
    final generationParameters(
      final nParallelDem=generation.nParallelDem,
      final nParallelSup=generation.nParallelSup,
      final Q_flow_nominal=generation.Q_flow_nominal,
      final TOda_nominal=hydraulicSystemParameters.TOda_nominal,
      final TDem_nominal=generation.TDem_nominal,
      final TSup_nominal=generation.TSup_nominal,
      final dTTra_nominal=generation.dTTra_nominal,
      final m_flow_nominal=generation.m_flow_nominal,
      final dp_nominal=generation.dp_nominal,
      final dTLoss_nominal=generation.dTLoss_nominal,
      final f_design=generation.f_design,
      final QLoss_flow_nominal=generation.QLoss_flow_nominal),
    final distributionParameters(
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
      final TOda_nominal=hydraulicSystemParameters.TOda_nominal,
      final QLoss_flow_nominal=distribution.QLoss_flow_nominal,
      final mDHW_flow_nominal=distribution.mDHW_flow_nominal,
      final TDHW_nominal=distribution.TDHW_nominal,
      final VDHWDay=distribution.VDHWDay,
      final QDHW_flow_nominal=distribution.QDHW_flow_nominal,
      final TDHWCold_nominal=distribution.TDHWCold_nominal,
      final dTTraDHW_nominal=distribution.dTTraDHW_nominal,
      final tCrit=hydraulicSystemParameters.tCrit,
      final QCrit=hydraulicSystemParameters.QCrit),
    final transferParameters(
      final nParallelDem=transfer.nParallelDem,
      final nParallelSup=transfer.nParallelSup,
      final Q_flow_nominal=transfer.Q_flow_nominal,
      final TOda_nominal=hydraulicSystemParameters.TOda_nominal,
      final TDem_nominal=transfer.TDem_nominal,
      final TSup_nominal=transfer.TSup_nominal,
      final dTTra_nominal=transfer.dTTra_nominal,
      final m_flow_nominal=transfer.m_flow_nominal,
      final dp_nominal=transfer.dp_nominal,
      final dTLoss_nominal=transfer.dTLoss_nominal,
      final f_design=transfer.f_design,
      final QLoss_flow_nominal=transfer.QLoss_flow_nominal),
    final use_openModelica=use_openModelica)
    annotation (choicesAllMatching=true, Placement(transformation(extent={{-132,54},
            {154,122}})));
  replaceable BESMod.Systems.Hydraulical.Distribution.BaseClasses.PartialDistribution distribution(
    dTTra_nominal=fill(1, distribution.nParallelDem),
    m_flow_nominal=fill(0, distribution.nParallelDem),
    dTTraDHW_nominal=1,
    designType=BESMod.Systems.Hydraulical.Distribution.Types.DHWDesignType.NoStorage,
    QDHWStoLoss_flow=0,
    VStoDHW=0,
    dpSup_nominal=fill(0, distribution.nParallelDem),
    dpDem_nominal=fill(0, distribution.nParallelDem)) constrainedby
    Distribution.BaseClasses.PartialDistribution(
    redeclare package Medium = Medium,
    redeclare final package MediumDHW = MediumDHW,
    redeclare final package MediumGen = Medium,
    final energyDynamics=energyDynamics,
    final massDynamics=massDynamics,
    final p_start=p_start,
    final T_start=T_start,
    final X_start=X_start,
    final C_start=C_start,
    final C_nominal=C_nominal,
    final mSenFac=mSenFac,
    final TAmb=hydraulicSystemParameters.TAmb,
    final Q_flow_nominal=transfer.QSup_flow_nominal,
    final TDem_nominal=transfer.TSup_nominal,
    final allowFlowReversal=allowFlowReversal,
    final show_T=show_T,
    final rho=rho,
    final cp=cp,
    final TOda_nominal=hydraulicSystemParameters.TOda_nominal,
    final use_dhw=use_dhw,
    final mDem_flow_nominal=transfer.mSup_flow_nominal,
    final mSup_flow_nominal=generation.m_flow_nominal,
    final mDHW_flow_nominal=hydraulicSystemParameters.mDHW_flow_nominal,
    final VDHWDay=hydraulicSystemParameters.VDHWDay,
    final QDHW_flow_nominal=hydraulicSystemParameters.QDHW_flow_nominal,
    final TDHWCold_nominal=hydraulicSystemParameters.TDHWCold_nominal,
    final TDHW_nominal=hydraulicSystemParameters.TDHW_nominal,
    final tCrit=hydraulicSystemParameters.tCrit,
    final QCrit=hydraulicSystemParameters.QCrit,
    final use_openModelica=use_openModelica) annotation (choicesAllMatching=true,
      Placement(transformation(extent={{-12,-104},{90,28}})));

  replaceable BESMod.Systems.Hydraulical.Transfer.BaseClasses.PartialTransfer
    transfer(dp_nominal=fill(0, transfer.nParallelDem)) constrainedby
    Transfer.BaseClasses.PartialTransfer(
    redeclare final package Medium = Medium,
    final energyDynamics=energyDynamics,
    final massDynamics=massDynamics,
    final p_start=p_start,
    final T_start=T_start,
    final X_start=X_start,
    final C_start=C_start,
    final TTra_nominal=hydraulicSystemParameters.TSup_nominal,
    final AZone=hydraulicSystemParameters.AZone,
    final hZone=hydraulicSystemParameters.hZone,
    final ABui=hydraulicSystemParameters.ABui,
    final hBui=hydraulicSystemParameters.hBui,
    final dpSup_nominal=distribution.dpDem_nominal,
    final C_nominal=C_nominal,
    final mSenFac=mSenFac,
    final TOda_nominal=hydraulicSystemParameters.TOda_nominal,
    final nParallelDem=hydraulicSystemParameters.nZones,
    final TAmb=hydraulicSystemParameters.TAmb,
    final Q_flow_nominal=hydraulicSystemParameters.Q_flow_nominal,
    final TDem_nominal=hydraulicSystemParameters.TZone_nominal,
    final allowFlowReversal=allowFlowReversal,
    final show_T=show_T,
    final rho=rho,
    final cp=cp,
    final use_openModelica=use_openModelica) annotation (choicesAllMatching=true, Placement(transformation(
          extent={{112,-44},{180,28}})));
  IBPSA.BoundaryConditions.WeatherData.Bus
      weaBus "Weather data bus" annotation (Placement(transformation(extent={{-200,56},
            {-158,100}}),        iconTransformation(extent={{-188,-10},{-168,10}})));
  BESMod.Systems.Interfaces.HydraulicOutputs outBusHyd if not use_openModelica
    annotation (Placement(transformation(extent={{-30,-166},{28,-118}})));

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPortCon[hydraulicSystemParameters.nZones]
    "Heat port for convective heat transfer with room air temperature"
    annotation (Placement(transformation(extent={{190,68},{210,88}}),
        iconTransformation(extent={{190,68},{210,88}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPortRad[hydraulicSystemParameters.nZones]
    "Heat port for radiative heat transfer with room radiation temperature"
    annotation (Placement(transformation(extent={{190,-10},{210,10}}),
        iconTransformation(extent={{190,-10},{210,10}})));
  Modelica.Fluid.Interfaces.FluidPort_b portDHW_out(redeclare final package
      Medium = MediumDHW) "Outlet for the distribution to the DHW" annotation (
      Placement(transformation(extent={{190,-70},{210,-50}}),iconTransformation(
          extent={{188,-76},{208,-56}})));
  Modelica.Fluid.Interfaces.FluidPort_a portDHW_in(redeclare final package
      Medium = MediumDHW) "Inet for the distribution from the DHW" annotation (
      Placement(transformation(extent={{190,-130},{210,-110}}),
                                                             iconTransformation(
          extent={{188,-116},{208,-96}})));
  BESMod.Systems.Interfaces.UseProBus useProBus annotation (
      Placement(transformation(extent={{-72,116},{-30,162}}),
        iconTransformation(extent={{-106,116},{-56,164}})));
  BESMod.Systems.Interfaces.BuiMeaBus buiMeaBus annotation (
      Placement(transformation(extent={{110,122},{156,160}}),
        iconTransformation(extent={{68,120},{114,158}})));

  Interfaces.SystemControlBus sigBusHyd annotation (Placement(transformation(
          extent={{12,120},{58,160}}), iconTransformation(extent={{12,120},{
            58,160}})));
  BESMod.Utilities.Electrical.MultiSumElec multiSumElec(nPorts=3) annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={132,-124})));
  Modelica.Fluid.Sensors.TemperatureTwoPort T_GenToDis[generation.nParallelDem](
     redeclare package Medium = Medium) if use_for_fmu_inputs
    annotation (Placement(transformation(extent={{-20,24},{-16,28}})));
  Modelica.Fluid.Sensors.TemperatureTwoPort T_DisToGen[generation.nParallelDem](
     redeclare package Medium = Medium) if use_for_fmu_inputs
    annotation (Placement(transformation(extent={{-16,-4},{-20,0}})));
  Modelica.Fluid.Sensors.TemperatureTwoPort T_DisToTra[distribution.nParallelDem](
     redeclare package Medium = Medium) if use_for_fmu_inputs
    annotation (Placement(transformation(extent={{102,18},{106,22}})));
  Modelica.Fluid.Sensors.TemperatureTwoPort T_TraToDis[distribution.nParallelDem](
     redeclare package Medium = Medium) if use_for_fmu_inputs
    annotation (Placement(transformation(extent={{106,-10},{102,-6}})));
  Modelica.Fluid.Sensors.TemperatureTwoPort T_DisToDHW(redeclare package Medium =
        Medium) if use_for_fmu_inputs
    annotation (Placement(transformation(extent={{106,-58},{110,-54}})));
  Modelica.Fluid.Sensors.TemperatureTwoPort T_DHWToDis(redeclare package Medium =
        Medium) if use_for_fmu_inputs
    annotation (Placement(transformation(extent={{112,-72},{108,-68}})));
equation
  connect(control.sigBusGen,generation. sigBusGen) annotation (
      Line(
      points={{-79.5667,54.34},{-80,54.34},{-80,26.68},{-80.84,26.68}},
      color={215,215,215},
      thickness=0.5));
  connect(control.sigBusDistr,distribution. sigBusDistr)
    annotation (Line(
      points={{11.5958,54},{11.5958,38},{32,38},{32,28.66},{39,28.66}},
      color={215,215,215},
      thickness=0.5));
  connect(transfer.heatPortCon, heatPortCon) annotation (Line(points={{180,6.4},
          {192,6.4},{192,78},{200,78}}, color={191,0,0}));
  connect(transfer.heatPortRad, heatPortRad) annotation (Line(points={{180,
          -22.4},{200,-22.4},{200,0}},
                                color={191,0,0}));
  connect(distribution.outBusDist, outBusHyd.dis) annotation (Line(
      points={{39,-104},{39,-142},{-1,-142}},
      color={135,135,135},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  connect(generation.outBusGen, outBusHyd.gen) annotation (Line(
      points={{-82,-104},{-82,-142},{-1,-142}},
      color={135,135,135},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  connect(transfer.outBusTra, outBusHyd.tra) annotation (Line(
      points={{146,-45.44},{146,-68},{214,-68},{214,-142},{-1,-142}},
      color={135,135,135},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  connect(control.outBusCtrl, outBusHyd.ctrl) annotation (Line(
      points={{154,88},{214,88},{214,-142},{-1,-142}},
      color={135,135,135},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(weaBus,control. weaBus) annotation (Line(
      points={{-179,78},{-174,78},{-174,89.7},{-128.425,89.7}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(weaBus,generation. weaBus) annotation (Line(
      points={{-179,78},{-179,76},{-176,76},{-176,78},{-174,78},{-174,0},{
          -138.84,0},{-138.84,1.6}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(control.sigBusTra,transfer. traControlBus) annotation (Line(
      points={{114.675,54},{116,54},{116,42},{146,42},{146,28}},
      color={215,215,215},
      thickness=0.5));
  connect(useProBus,control. useProBus) annotation (Line(
      points={{-51,139},{-51,132.87},{-56.3292,132.87},{-56.3292,122.68}},
      color={0,127,0},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(buiMeaBus,control. buiMeaBus) annotation (Line(
      points={{133,141},{50,141},{50,138},{49.7292,138},{49.7292,123.02}},
      color={255,128,0},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));

  connect(sigBusHyd,control. sigBusHyd) annotation (Line(
      points={{35,140},{-5.68333,140},{-5.68333,122.34}},
      color={215,215,215},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(multiSumElec.internalElectricalPinOut, internalElectricalPin)
    annotation (Line(
      points={{142,-124},{170,-124},{170,-140}},
      color={0,0,0},
      thickness=1));
  connect(transfer.internalElectricalPin, multiSumElec.internalElectricalPinIn[
    1]) annotation (Line(
      points={{170.48,-43.28},{170.48,-106},{110,-106},{110,-124.133},{122.2,
          -124.133}},
      color={0,0,0},
      thickness=1));
  connect(distribution.internalElectricalPin, multiSumElec.internalElectricalPinIn[
    2]) annotation (Line(
      points={{74.7,-102.68},{74.7,-123.8},{122.2,-123.8}},
      color={0,0,0},
      thickness=1));
  connect(generation.internalElectricalPin, multiSumElec.internalElectricalPinIn[
    3]) annotation (Line(
      points={{-40.24,-104},{-40.24,-123.467},{122.2,-123.467}},
      color={0,0,0},
      thickness=1));
  connect(generation.portGen_out, T_GenToDis.port_a) annotation (Line(points={{-24,
          14.8},{-24,18},{-20,18},{-20,26}}, color={0,127,255}));
  connect(T_GenToDis.port_b, distribution.portGen_in) annotation (Line(points={{
          -16,26},{-16,20},{-12,20},{-12,14.8}}, color={0,127,255}));
  connect(distribution.portGen_out, T_DisToGen.port_a) annotation (Line(points={
          {-12,-11.6},{-12,-8},{-16,-8},{-16,-2}}, color={0,127,255}));
  connect(generation.portGen_in, T_DisToGen.port_b) annotation (Line(points={{-24,
          -11.6},{-24,-8},{-20,-8},{-20,-2}}, color={0,127,255}));
  connect(distribution.portBui_out, T_DisToTra.port_a) annotation (Line(points={
          {90,14.8},{96,14.8},{96,20},{102,20}}, color={0,127,255}));
  connect(T_DisToTra.port_b, transfer.portTra_in) annotation (Line(points={{106,
          20},{112,20},{112,6},{110,6},{110,6.4},{112,6.4}}, color={0,127,255}));
  connect(T_TraToDis.port_a, transfer.portTra_out) annotation (Line(points={{106,
          -8},{106,-14},{104,-14},{104,-23.12},{112,-23.12}}, color={0,127,255}));
  connect(T_TraToDis.port_b, distribution.portBui_in) annotation (Line(points={{
          102,-8},{96,-8},{96,-11.6},{90,-11.6}}, color={0,127,255}));
  connect(distribution.portDHW_out, T_DisToDHW.port_a) annotation (Line(points={
          {90,-51.2},{96,-51.2},{96,-56},{106,-56}}, color={0,127,255}));
  connect(T_DisToDHW.port_b, portDHW_out) annotation (Line(points={{110,-56},{144,
          -56},{144,-60},{200,-60}}, color={0,127,255}));
  connect(distribution.portDHW_in, T_DHWToDis.port_b) annotation (Line(points={{
          90,-77.6},{90,-70},{108,-70}}, color={0,127,255}));
  connect(T_DHWToDis.port_a, portDHW_in) annotation (Line(points={{112,-70},{168,
          -70},{168,-78},{192,-78},{192,-120},{200,-120}}, color={0,127,255}));
  if not use_for_fmu_inputs then
  connect(generation.portGen_out, distribution.portGen_in)
    annotation (Line(points={{-24,14.8},{-12,14.8}}, color={0,127,255}));
  connect(generation.portGen_in, distribution.portGen_out)
    annotation (Line(points={{-24,-11.6},{-12,-11.6}}, color={0,127,255}));
  connect(distribution.portBui_out, transfer.portTra_in) annotation (Line(
        points={{90,14.8},{102,14.8},{102,6.4},{112,6.4}}, color={0,127,255}));
  connect(distribution.portBui_in, transfer.portTra_out) annotation (Line(
        points={{90,-11.6},{90,-10},{98,-10},{98,-23.12},{112,-23.12}}, color={0,
          127,255}));
  connect(distribution.portDHW_out, portDHW_out) annotation (Line(points={{90,-51.2},
          {90,-50},{96,-50},{96,-56},{100,-56},{100,-62},{144,-62},{144,-60},{200,
          -60}}, color={0,127,255}));
  connect(distribution.portDHW_in, portDHW_in) annotation (Line(points={{90,-77.6},
          {144,-77.6},{144,-120},{200,-120}}, color={0,127,255}));
  end if;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-180,-140},
            {200,140}}), graphics={
        Rectangle(
          extent={{-180,140},{200,-140}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-46,84},{-62,52},{-30,52},{-46,84}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{-20,84},{10,84}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{62,86},{66,86}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{10,100},{62,66},{62,100},{10,66},{10,100}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{36,82},{36,116}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{46,116},{26,116}},
          color={0,0,0},
          thickness=0.5),
        Rectangle(
          extent={{68,102},{86,-20}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{92,102},{110,-20}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{116,102},{134,-20}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{140,102},{158,-20}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{164,102},{182,-20}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-72,100},{-20,66},{-20,100},{-72,66},{-72,100}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{-46,52},{-46,-66},{190,-66}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{-104,84},{-74,84}},
          color={0,0,0},
          thickness=0.5),
        Ellipse(
          extent={{-104,114},{-166,52}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-150,112},{-104,84}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{-152,58},{-104,84}},
          color={0,0,0},
          thickness=0.5),     Text(
          extent={{-96,-130},{108,-226}},
          lineColor={0,0,0},
          textString="%name%"),
      Ellipse(
        visible=subsystemDisabled,
        extent={{-74,80},{86,-80}},
        lineColor={215,215,215},
        fillColor={255,0,0},
        fillPattern=FillPattern.Solid),
      Ellipse(
        visible=subsystemDisabled,
        extent={{-49,55},{61,-55}},
        lineColor={255,255,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Rectangle(
        visible=subsystemDisabled,
        extent={{-60,14},{60,-14}},
        lineColor={255,0,0},
        fillColor={255,0,0},
        fillPattern=FillPattern.Solid,
        rotation=45,
          origin={4,-2})}),
                          Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-180,-140},{200,140}})));
end PartialHydraulicSystem;
