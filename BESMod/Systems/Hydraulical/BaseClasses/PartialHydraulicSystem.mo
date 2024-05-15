within BESMod.Systems.Hydraulical.BaseClasses;
partial model PartialHydraulicSystem
  "Complete hydraulic system model"
  extends BESMod.Systems.BaseClasses.PartialFluidSubsystem;
  parameter Boolean subsystemDisabled "To enable the icon if the subsystem is disabled" annotation (Dialog(tab="Graphics"));
  parameter Boolean use_dhw=true "=false to disable DHW";
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
      dTTra_nominal=fill(1, generation.nParallelDem),
      dTTra_nominal_design=fill(1, generation.nParallelDem),
      dp_nominal=fill(0, generation.nParallelDem))       constrainedby
    BESMod.Systems.Hydraulical.Generation.BaseClasses.PartialGeneration(
    final TDem_nominal=distribution.TSup_nominal,
    final TDem_nominal_old_design=distribution.TSup_nominal_old_design,
    final Q_flow_nominal={sum(distribution.Q_flow_nominal)*generation.f_design[
        i] + distribution.QDHWBefSto_flow_nominal for i in 1:generation.nParallelDem},
    final Q_flow_nominal_old_design={sum(distribution.Q_flow_nominal_old_design)*generation.f_design[
        i] + distribution.QDHWBefSto_flow_nominal for i in 1:generation.nParallelDem},
    redeclare package Medium = Medium,
    final dpDem_nominal=distribution.dpSup_nominal,
    final dpDem_nominal_old_design=distribution.dpSup_nominal_old_design,
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
    final parGen(
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
    final parTra(
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
      final QLoss_flow_nominal=transfer.QLoss_flow_nominal,
      final TTra_nominal=transfer.TTra_nominal,
      final QSup_flow_nominal=transfer.QSup_flow_nominal,
      final dpSup_nominal=transfer.dpSup_nominal,
      final mSup_flow_nominal=transfer.mSup_flow_nominal,
      final nHeaTra=transfer.nHeaTra),
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
    final Q_flow_nominal_old_design=transfer.QSup_flow_nominal_old_design,
    final TDem_nominal=transfer.TSup_nominal,
    final TDem_nominal_old_design=transfer.TSup_nominal_old_design,
    final allowFlowReversal=allowFlowReversal,
    final show_T=show_T,
    final rho=rho,
    final cp=cp,
    final TOda_nominal=hydraulicSystemParameters.TOda_nominal,
    final use_dhw=use_dhw,
    final mDem_flow_nominal=transfer.mSup_flow_nominal,
    final mDem_flow_nominal_old_design=transfer.mSup_flow_nominal_old_design,
    final mSup_flow_nominal=generation.m_flow_nominal,
    final mSup_flow_nominal_old_design=generation.m_flow_nominal_old_design,
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
    transfer(dp_nominal=fill(0, transfer.nParallelDem), nHeaTra=1)
                                                        constrainedby
    Transfer.BaseClasses.PartialTransfer(
    redeclare final package Medium = Medium,
    final energyDynamics=energyDynamics,
    final massDynamics=massDynamics,
    final p_start=p_start,
    final T_start=T_start,
    final X_start=X_start,
    final C_start=C_start,
    final TTra_nominal=hydraulicSystemParameters.TSup_nominal,
    final TTra_nominal_old_design=hydraulicSystemParameters.TSupNoRetrofit_nominal,
    final AZone=hydraulicSystemParameters.AZone,
    final hZone=hydraulicSystemParameters.hZone,
    final ABui=hydraulicSystemParameters.ABui,
    final hBui=hydraulicSystemParameters.hBui,
    final dpSup_nominal=distribution.dpDem_nominal,
    final dpSup_nominal_old_design=distribution.dpDem_nominal_old_design,
    final C_nominal=C_nominal,
    final mSenFac=mSenFac,
    final TOda_nominal=hydraulicSystemParameters.TOda_nominal,
    final nParallelDem=hydraulicSystemParameters.nZones,
    final TAmb=hydraulicSystemParameters.TAmb,
    final Q_flow_nominal=hydraulicSystemParameters.Q_flow_nominal,
    final Q_flow_nominal_old_design=hydraulicSystemParameters.QNoRetrofit_flow_nominal,
    final TDem_nominal=hydraulicSystemParameters.TZone_nominal,
    final TDem_nominal_old_design=transfer.TDem_nominal,
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
  Modelica.Fluid.Interfaces.FluidPort_a portDHW_in(redeclare final package Medium =
               MediumDHW) "Inet for the distribution from the DHW" annotation (
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
equation
  connect(generation.portGen_out,distribution. portGen_in) annotation (Line(
        points={{-24,14.8},{-16,14.8},{-16,14},{-10,14},{-10,14.8},{-12,14.8}},
                                                              color={0,127,255}));
  connect(generation.portGen_in,distribution. portGen_out) annotation (Line(
        points={{-24,-11.6},{-12,-11.6}},                           color={0,127,
          255}));
  connect(transfer.portTra_out,distribution. portBui_in) annotation (Line(
        points={{112,-23.12},{112,-11.6},{90,-11.6}},
                                                 color={0,127,255}));
  connect(distribution.portBui_out,transfer. portTra_in) annotation (Line(
        points={{90,14.8},{112,14.8},{112,6.4}},color={0,127,255}));
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
  connect(portDHW_out,distribution. portDHW_out) annotation (Line(points={{200,-60},
          {100,-60},{100,-52},{96,-52},{96,-51.2},{90,-51.2}},
                                             color={0,127,255}));
  connect(distribution.portDHW_in, portDHW_in) annotation (Line(points={{90,
          -77.6},{98,-77.6},{98,-78},{192,-78},{192,-120},{200,-120}},
                                              color={0,127,255}));
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
                          Diagram(graphics,
                                  coordinateSystem(preserveAspectRatio=false,
          extent={{-180,-140},{200,140}})));
end PartialHydraulicSystem;
