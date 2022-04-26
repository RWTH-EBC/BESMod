within BESMod.Systems.Demand.DHW.BaseClasses;
partial model PartialDHW "Partial model for domestic hot water (DHW)"
  extends BESMod.Systems.BaseClasses.PartialFluidSubsystem;
  extends BESMod.Utilities.Icons.DHWIcon;
  parameter Boolean use_pressure=false "=true to use pressure based system";
  replaceable parameter
    BESMod.Systems.RecordsCollection.Movers.MoverBaseDataDefinition
    pumpData
    annotation (choicesAllMatching=true, Placement(transformation(extent={{-96,-96},{-84,-84}})));
  replaceable parameter RecordsCollection.DHWDesignParameters parameters;

  Components.Pumps.ArtificalPumpFixedT artificalPumpFixedT(
    redeclare package Medium = Medium,
    p=p_start,
    T_fixed=parameters.TDHWCold_nominal) if not use_pressure
                                         annotation (Placement(transformation(
        extent={{-14,-14},{14,14}},
        rotation=270,
        origin={-60,-8})));
  replaceable TappingProfiles.BaseClasses.PartialDHW calcmFlow constrainedby
    TappingProfiles.BaseClasses.PartialDHW(
    final TCold=parameters.TDHWCold_nominal,
    final dWater=rho,
    final c_p_water=cp,
    final TSetDHW=parameters.TDHW_nominal) annotation (choicesAllMatching=true,
      Placement(transformation(
        extent={{-17,18},{17,-18}},
        rotation=180,
        origin={-15,-8})));
  IBPSA.Fluid.Sensors.TemperatureTwoPort senT(
    final transferHeat=false,
    redeclare final package Medium = Medium,
    final m_flow_nominal=0.1) "Temperature of DHW" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-60,44})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare final package Medium =
        Medium) "Inlet for the demand of DHW" annotation (Placement(
        transformation(extent={{-110,50},{-90,70}}),  iconTransformation(extent={{-110,50},
            {-90,70}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare final package Medium =
        Medium) "Outlet of the demand of DHW" annotation (Placement(
        transformation(extent={{-110,-70},{-90,-50}}), iconTransformation(
          extent={{-110,-70},{-90,-50}})));
  BESMod.Systems.Interfaces.DHWOutputs outBusDHW
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Modelica.Blocks.Math.UnitConversions.From_degC fromDegC
    "Profiles for internal gains" annotation (Placement(transformation(
        extent={{7,-7},{-7,7}},
        rotation=0,
        origin={41,63})));
  Utilities.KPIs.InternalKPICalculator internalKPICalculator(
    final calc_singleOnTime=false,
    final calc_totalOnTime=false,
    final calc_numSwi=false,
    final calc_movAve=false,
    final y=-port_b.m_flow*cp*(senT.T - parameters.TDHWCold_nominal))
    annotation (Placement(transformation(extent={{60,-68},{80,-32}})));
  IBPSA.Fluid.Movers.FlowControlled_m_flow pump(
    redeclare final package Medium = Medium,
    final energyDynamics=energyDynamics,
    final massDynamics=massDynamics,
    final p_start=p_start,
    final T_start=parameters.TDHWCold_nominal,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=parameters.mDHW_flow_nominal,
    final m_flow_small=1E-4*abs(parameters.mDHW_flow_nominal),
    final show_T=show_T,
    redeclare
      BESMod.Systems.RecordsCollection.Movers.AutomaticConfigurationData
      per(
      final speed_rpm_nominal=pumpData.speed_rpm_nominal,
      final m_flow_nominal=parameters.mDHW_flow_nominal,
      final dp_nominal(displayUnit="Pa") = 100,
      final rho=rho,
      final V_flowCurve=pumpData.V_flowCurve,
      final dpCurve=pumpData.dpCurve),
    final inputType=IBPSA.Fluid.Types.InputType.Continuous,
    final addPowerToMedium=pumpData.addPowerToMedium,
    final nominalValuesDefineDefaultPressureCurve=false,
    final tau=pumpData.tau,
    final use_inputFilter=pumpData.use_inputFilter,
    final riseTime=pumpData.riseTimeInpFilter,
    final dp_nominal=100) if use_pressure annotation (Placement(transformation(
        extent={{-8.5,9.5},{8.5,-9.5}},
        rotation=180,
        origin={-64.5,-76.5})));
  IBPSA.Fluid.Sources.Boundary_ph bou_sink(
    redeclare package Medium = Medium,
    final p=p_start,
    nPorts=1)       if use_pressure
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-2,28})));
  IBPSA.Fluid.Sources.Boundary_pT bouSou(
    final T=parameters.TDHWCold_nominal,
    final nPorts=1,
    redeclare final package Medium = Medium,
    final p=p_start) if use_pressure
    annotation (Placement(transformation(extent={{-16,-86},{-36,-66}})));
  BESMod.Systems.Interfaces.UseProBus useProBus annotation (
      Placement(transformation(extent={{-22,82},{20,116}}), iconTransformation(
          extent={{44,88},{66,112}})));
  Electrical.Interfaces.InternalElectricalPin internalElectricalPin
    annotation (Placement(transformation(extent={{60,-108},{80,-88}})));
equation
  connect(port_a, senT.port_a) annotation (Line(points={{-100,60},{-60,60},{-60,
          54}},            color={0,127,255}));
  connect(senT.T,calcmFlow. TIs) annotation (Line(points={{-49,44},{56,44},{56,
          -8},{5.4,-8}},    color={0,0,127}));
  connect(fromDegC.y, calcmFlow.TSet) annotation (Line(points={{33.3,63},{22,63},
          {22,-18.8},{5.4,-18.8}},
                               color={0,0,127}));
  connect(senT.port_b, artificalPumpFixedT.port_a)
    annotation (Line(points={{-60,34},{-60,6}}, color={0,127,255}));
  connect(artificalPumpFixedT.m_flow_in, calcmFlow.m_flow_out)
    annotation (Line(points={{-43.76,-8},{-33.7,-8}}, color={0,0,127}));
  connect(artificalPumpFixedT.port_b, port_b) annotation (Line(points={{-60,-22},
          {-60,-60},{-100,-60}}, color={0,127,255}));
  connect(internalKPICalculator.KPIBus, outBusDHW.Q_flow) annotation (Line(
      points={{80.2,-50},{104,-50},{104,0},{100,0}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(pump.port_a, bouSou.ports[1]) annotation (Line(
      points={{-56,-76.5},{-41.5,-76.5},{-41.5,-76},{-36,-76}},
      color={0,127,255},
      pattern=LinePattern.Dash));
  connect(pump.port_b, port_b) annotation (Line(
      points={{-73,-76.5},{-81.5,-76.5},{-81.5,-60},{-100,-60}},
      color={0,127,255},
      pattern=LinePattern.Dash));
  connect(calcmFlow.m_flow_out, pump.m_flow_in) annotation (Line(
      points={{-33.7,-8},{-42,-8},{-42,-65.1},{-64.5,-65.1}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(fromDegC.u, useProBus.TDHWDemand) annotation (Line(points={{
          49.4,63},{56,63},{56,99},{-1,99}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(calcmFlow.m_flow_in, useProBus.mDHWDemand_flow) annotation (
      Line(points={{5.4,2.8},{56,2.8},{56,99},{-1,99}},     color={0,0,
          127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(senT.port_b, bou_sink.ports[1]) annotation (Line(
      points={{-60,34},{-60,28},{-12,28}},
      color={0,127,255},
      pattern=LinePattern.Dash));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialDHW;
