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

  replaceable parameter
    BESMod.Systems.RecordsCollection.Movers.MoverBaseDataDefinition
    pumpData
    annotation (choicesAllMatching=true, Placement(transformation(extent={{-96,-96},{-84,-84}})));

  replaceable TappingProfiles.BaseClasses.PartialDHW calcmFlow constrainedby
    TappingProfiles.BaseClasses.PartialDHW(
    final TCold=TDHWCold_nominal,
    final dWater=rho,
    final c_p_water=cp,
    final TSetDHW=TDHW_nominal) annotation (choicesAllMatching=true,
      Placement(transformation(
        extent={{-17,18},{17,-18}},
        rotation=180,
        origin={-21,20})));
Modelica.Blocks.Math.UnitConversions.From_degC fromDegC
    "Profiles for internal gains" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={30,-10})));
  BESMod.Utilities.KPIs.InternalKPICalculator internalKPICalculator(
    unit="W",
    integralUnit="J",
    final calc_singleOnTime=false,
    final calc_totalOnTime=false,
    final calc_numSwi=false,
    final calc_movAve=false,
    final y=-port_b.m_flow*cp*(TIs.y - TDHWCold_nominal))
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
    final dp_nominal=100)                 annotation (Placement(transformation(
        extent={{-9.5,9.5},{9.5,-9.5}},
        rotation=180,
        origin={-69.5,-50.5})));
  IBPSA.Fluid.Sources.Boundary_ph bou_sink(
    redeclare package Medium = Medium,
    final p=p_start,
    nPorts=1)
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-50,60})));
  IBPSA.Fluid.Sources.Boundary_pT bouSou(
    final T=TDHWCold_nominal,
    final nPorts=1,
    redeclare final package Medium = Medium,
    final p=p_start)
    annotation (Placement(transformation(extent={{-20,-60},{-40,-40}})));
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
  Modelica.Blocks.Sources.RealExpression TIs(y=Medium.temperature(
        Medium.setState_phX(
        port_a.p,
        inStream(port_a.h_outflow),
        inStream(port_a.Xi_outflow)))) annotation (Placement(transformation(
        extent={{-10,-11},{10,11}},
        rotation=180,
        origin={30,21})));
equation
  connect(fromDegC.y, calcmFlow.TSet) annotation (Line(points={{19,-10},{8,-10},
          {8,9.2},{-0.6,9.2}}, color={0,0,127}));
  connect(internalKPICalculator.KPIBus, outBusDHW.Q_flow) annotation (Line(
      points={{80.2,-50},{104,-50},{104,0},{100,0}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(pump.port_a, bouSou.ports[1]) annotation (Line(
      points={{-60,-50.5},{-50,-50.5},{-50,-50},{-40,-50}},
      color={0,127,255}));
  connect(pump.port_b, port_b) annotation (Line(
      points={{-79,-50.5},{-84,-50.5},{-84,-60},{-100,-60}},
      color={0,127,255}));
  connect(calcmFlow.m_flow_out, pump.m_flow_in) annotation (Line(
      points={{-39.7,20},{-69.5,20},{-69.5,-39.1}},
      color={0,0,127}));
  connect(zeroLoad.internalElectricalPin, internalElectricalPin) annotation (
      Line(
      points={{40,-90},{56,-90},{56,-84},{70,-84},{70,-98}},
      color={0,0,0},
      thickness=1));
  connect(combiTimeTableDHWInput.y[4], fromDegC.u)
    annotation (Line(points={{59,50},{48,50},{48,-10},{42,-10}},
                                               color={0,0,127}));
  connect(combiTimeTableDHWInput.y[2], calcmFlow.m_flow_in) annotation (Line(
        points={{59,50},{48,50},{48,64},{6,64},{6,30.8},{-0.6,30.8}},
                                                     color={0,0,127}));
  connect(TIs.y, calcmFlow.TIs) annotation (Line(points={{19,21},{18,21},{18,20},
          {-0.6,20}}, color={0,0,127}));
  connect(port_a, bou_sink.ports[1])
    annotation (Line(points={{-100,60},{-60,60}}, color={0,127,255}));
end DHW;
