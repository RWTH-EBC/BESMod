within BESMod.Systems.Demand.DHW;
model DHW "Standard DHW subsystem"
  extends BaseClasses.PartialDHW(
    QCrit=DHWProfile.QCrit,
    tCrit=DHWProfile.tCrit,
    TDHWCold_nominal=283.15,
    TDHW_nominal=323.15,
    VDHWDay=if use_dhwCalc then V_dhwCalc_day else DHWProfile.VDHWDay,
    mDHW_flow_nominal=DHWProfile.m_flow_nominal);
  replaceable parameter Systems.Demand.DHW.RecordsCollection.PartialDHWTap
    DHWProfile annotation (choicesAllMatching=true, Dialog(
      enable=not use_dhwCalc and use_dhw));

  parameter Boolean use_dhwCalc=false "=true to use the tables in DHWCalc. Will slow down the simulation, but represents DHW tapping more in a more realistic way."     annotation (Dialog(enable=use_dhw));
  parameter String tableName="DHWCalc" "Table name on file for DHWCalc"
    annotation (Dialog(enable=use_dhwCalc and use_dhw));
  parameter String fileName=Modelica.Utilities.Files.loadResource(
      "modelica://BESMod/Resources/DHWCalc.txt")
    "File where matrix is stored for DHWCalc"
    annotation (Dialog(enable=use_dhwCalc and use_dhw));
  parameter Modelica.Units.SI.Volume V_dhwCalc_day=0
    "Average daily tapping volume in DHWCalc table" annotation (Dialog(enable=use_dhwCalc));
  parameter Boolean use_pressure=false "=true to use pressure based system";
  replaceable parameter
    BESMod.Systems.RecordsCollection.Movers.MoverBaseDataDefinition
    pumpData
    annotation (choicesAllMatching=true, Placement(transformation(extent={{-96,-96},{-84,-84}})));

  Hydraulical.Components.Pumps.ArtificalPumpFixedT artificalPumpFixedT(
    redeclare package Medium = Medium,
    p=p_start,
    T_fixed=TDHWCold_nominal) if not use_pressure annotation (
      Placement(transformation(
        extent={{-14,-14},{14,14}},
        rotation=270,
        origin={-60,-8})));
  replaceable TappingProfiles.BaseClasses.PartialDHW calcmFlow constrainedby
    TappingProfiles.BaseClasses.PartialDHW(
    final TCold=TDHWCold_nominal,
    final dWater=rho,
    final c_p_water=cp,
    final TSetDHW=TDHW_nominal) annotation (choicesAllMatching=true,
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
Modelica.Blocks.Math.UnitConversions.From_degC fromDegC
    "Profiles for internal gains" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={30,50})));
  BESMod.Utilities.KPIs.InternalKPICalculator internalKPICalculator(
    unit="W",
    integralUnit="J",
    final calc_singleOnTime=false,
    final calc_totalOnTime=false,
    final calc_numSwi=false,
    final calc_movAve=false,
    final y=-port_b.m_flow*cp*(senT.T - TDHWCold_nominal))
    annotation (Placement(transformation(extent={{60,-68},{80,-32}})));
  IBPSA.Fluid.Movers.FlowControlled_m_flow pump(
    redeclare final package Medium = Medium,
    final energyDynamics=energyDynamics,
    final p_start=p_start,
    final T_start=TDHWCold_nominal,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=mDHW_flow_nominal,
    final m_flow_small=1E-4*abs(mDHW_flow_nominal),
    final show_T=show_T,
    redeclare
      BESMod.Systems.RecordsCollection.Movers.AutomaticConfigurationData
      per(
      final speed_rpm_nominal=pumpData.speed_rpm_nominal,
      final m_flow_nominal=mDHW_flow_nominal,
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
    final T=TDHWCold_nominal,
    final nPorts=1,
    redeclare final package Medium = Medium,
    final p=p_start) if use_pressure
    annotation (Placement(transformation(extent={{-16,-86},{-36,-66}})));
  BESMod.Utilities.Electrical.ZeroLoad zeroLoad
    annotation (Placement(transformation(extent={{20,-100},{40,-80}})));
  Modelica.Blocks.Sources.CombiTimeTable combiTimeTableDHWInput(
    final tableOnFile=use_dhwCalc,
    final table=DHWProfile.table,
    final tableName=tableName,
    final fileName=fileName,
    final columns=2:5,
    final smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    final extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic)
    "Read the input data from the given file. " annotation (Placement(visible=true,
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={70,50})));
equation
  connect(port_a, senT.port_a) annotation (Line(points={{-100,60},{-60,60},{-60,
          54}},            color={0,127,255}));
  connect(senT.T,calcmFlow. TIs) annotation (Line(points={{-49,44},{12,44},{12,-8},
          {5.4,-8}},        color={0,0,127}));
  connect(fromDegC.y, calcmFlow.TSet) annotation (Line(points={{19,50},{16,50},{
          16,-18.8},{5.4,-18.8}},
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
  connect(senT.port_b, bou_sink.ports[1]) annotation (Line(
      points={{-60,34},{-60,28},{-12,28}},
      color={0,127,255},
      pattern=LinePattern.Dash));
  connect(zeroLoad.internalElectricalPin, internalElectricalPin) annotation (
      Line(
      points={{40,-90},{56,-90},{56,-84},{70,-84},{70,-98}},
      color={0,0,0},
      thickness=1));
  connect(combiTimeTableDHWInput.y[4], fromDegC.u)
    annotation (Line(points={{59,50},{42,50}}, color={0,0,127}));
  connect(combiTimeTableDHWInput.y[2], calcmFlow.m_flow_in) annotation (Line(
        points={{59,50},{52,50},{52,2.8},{5.4,2.8}}, color={0,0,127}));
end DHW;
