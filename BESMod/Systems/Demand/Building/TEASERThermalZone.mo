within BESMod.Systems.Demand.Building;
model TEASERThermalZone
  "Reduced order building model, coupled with TEASER"
  extends BaseClasses.PartialDemand(
    hBui=sum(zoneParam.VAir)^(1/3),
    ABui=2*sum(zoneParam.VAir)^(1/3),
    hZone=zoneParam.VAir ./ zoneParam.AZone,
    AZone=zoneParam.AZone);
  replaceable parameter AixLib.DataBase.ThermalZones.ZoneBaseRecord oneZoneParam constrainedby
    AixLib.DataBase.ThermalZones.ZoneBaseRecord
    "Default zone if only one is chosen" annotation(choicesAllMatching=true);
  parameter AixLib.DataBase.ThermalZones.ZoneBaseRecord zoneParam[nZones]=fill(oneZoneParam, nZones)
    "Choose an array of multiple zones" annotation(choicesAllMatching=true);
  parameter Real ventRate[nZones]=fill(0, nZones) "Constant mechanical ventilation rate";

  parameter Boolean use_verboseEnergyBalance = true "=false to disable the integration of the verbose energy balance";
  parameter Modelica.SIunits.TemperatureDifference dTComfort=2
                                                       "Temperature difference to room set temperature at which the comfort is still acceptable. In DIN EN 15251, all temperatures below 22 °C - 2 K count as discomfort. Hence the default value. If your room set temperature is lower, consider using smaller values.";

  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation (Dialog(tab="Dynamics"));
  parameter Modelica.SIunits.Temperature T_start=
      293.15 "Start value of temperature"
    annotation (Dialog(tab="Initialization"));

  AixLib.ThermalZones.ReducedOrder.ThermalZone.ThermalZone thermalZone[nZones](
    redeclare each final package Medium = MediumZone,
    each final energyDynamics=energyDynamics,
    each final T_start=T_start,
    final zoneParam=zoneParam,
    each final use_AirExchange=true,
    each final nPorts=if use_ventilation then 2 else 0) annotation (Placement(
        transformation(extent={{35,12},{-39,84}}, rotation=0)));

  Modelica.Blocks.Sources.Constant constTSetRoom[nZones](final k=
        TSetZone_nominal) "Transform Volume l to massflowrate" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={74,60})));

  Modelica.Blocks.Sources.Constant constVentRate[nZones](final k=ventRate)
                                                              "Transform Volume l to massflowrate"
                                         annotation (Placement(transformation(
          extent={{-10,-10},{10,10}}, rotation=180,
        origin={74,30})));

  Utilities.KPIs.InputKPICalculator inputKPICalculatorTraGain[nZones](
    each calc_singleOnTime=false,
    each calc_totalOnTime=false,
    each calc_numSwi=false,
    each calc_movAve=false,
    each calc_intBelThres=false) if use_hydraulic and use_verboseEnergyBalance
                            annotation (Placement(transformation(
        extent={{-7,-11},{7,11}},
        rotation=0,
        origin={-7,-63})));
  Utilities.KPIs.InputKPICalculator inputKPICalculatorTraLoss[nZones](
    each calc_singleOnTime=false,
    each calc_totalOnTime=false,
    each calc_numSwi=false,
    each calc_movAve=false,
    each calc_intBelThres=false) if use_hydraulic and use_verboseEnergyBalance
                            annotation (Placement(transformation(
        extent={{-7,-12},{7,12}},
        rotation=0,
        origin={-7,-80})));
  Modelica.Blocks.Nonlinear.Limiter limUp[nZones](each final uMax=
        Modelica.Constants.inf, each final uMin=0) if use_hydraulic and use_verboseEnergyBalance
    annotation (Placement(transformation(extent={{-28,-66},{-22,-60}})));
  Modelica.Blocks.Nonlinear.Limiter limDown[nZones](each final uMax=
       0, each final uMin=-Modelica.Constants.inf) if use_hydraulic and use_verboseEnergyBalance
    annotation (Placement(transformation(extent={{-30,-82},{-24,-76}})));
  Utilities.KPIs.InputKPICalculator    inputKPICalculator   [nZones](
    each calc_singleOnTime=false,
    each calc_totalOnTime=false,
    each calc_numSwi=false,
    each calc_movAve=false,
    each calc_intBelThres=false) if use_verboseEnergyBalance
    annotation (Placement(transformation(
        extent={{-7,-13},{7,13}},
        rotation=180,
        origin={25,-81})));
  Utilities.KPIs.InputKPICalculator inputKPICalculatorVentGain[nZones](
    each calc_singleOnTime=false,
    each calc_totalOnTime=false,
    each calc_numSwi=false,
    each calc_movAve=false,
    each calc_intBelThres=false) if use_ventilation and use_verboseEnergyBalance
                            annotation (Placement(transformation(
        extent={{-7,-11},{7,11}},
        rotation=180,
        origin={25,-97})));
  Modelica.Blocks.Sources.RealExpression QVent[nZones](y=
        portVent_in.m_flow*inStream(portVent_in.h_outflow) + portVent_out.m_flow
        *portVent_out.h_outflow) if use_ventilation and use_verboseEnergyBalance
    "Internal gains"                                               annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={62,-106})));
  Utilities.KPIs.InputKPICalculator inputKPICalculatorVentLoss[nZones](
    each calc_singleOnTime=false,
    each calc_totalOnTime=false,
    each calc_numSwi=false,
    each calc_movAve=false,
    each calc_intBelThres=false) if use_ventilation and use_verboseEnergyBalance
                            annotation (Placement(transformation(
        extent={{-7,-12},{7,12}},
        rotation=180,
        origin={25,-114})));
  Modelica.Blocks.Nonlinear.Limiter limVentUp[nZones](each final
      uMax=Modelica.Constants.inf, each final uMin=0)
    if use_ventilation and use_verboseEnergyBalance
    annotation (Placement(transformation(extent={{-3,-3},{3,3}},
        rotation=180,
        origin={43,-97})));
  Modelica.Blocks.Nonlinear.Limiter limVentDown[nZones](each final
      uMax=0, each final uMin=-Modelica.Constants.inf)
    if use_ventilation and use_verboseEnergyBalance
    annotation (Placement(transformation(extent={{-3,-3},{3,3}},
        rotation=180,
        origin={41,-115})));
  Utilities.KPIs.InputKPICalculator inputKPICalculatorTraGain2[nZones](
    each calc_singleOnTime=false,
    each calc_totalOnTime=false,
    each calc_numSwi=false,
    each calc_movAve=false,
    each calc_intBelThres=false) if use_verboseEnergyBalance annotation (Placement(transformation(
        extent={{-7,-11},{7,11}},
        rotation=0,
        origin={-7,-97})));
  Modelica.Blocks.Sources.RealExpression QAirExc[nZones](y=
        thermalZone.airExc.Q_flow) if use_verboseEnergyBalance "Internal gains"                annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-48,-106})));
  Utilities.KPIs.InputKPICalculator inputKPICalculatorTraLoss2[nZones](
    each calc_singleOnTime=false,
    each calc_totalOnTime=false,
    each calc_numSwi=false,
    each calc_movAve=false,
    each calc_intBelThres=false) if use_verboseEnergyBalance annotation (Placement(transformation(
        extent={{-7,-12},{7,12}},
        rotation=0,
        origin={-7,-114})));
  Modelica.Blocks.Nonlinear.Limiter limAirExcUp[nZones](each final
      uMax=Modelica.Constants.inf, each final uMin=0)
                                                     if use_verboseEnergyBalance
    annotation (Placement(transformation(extent={{-28,-100},{-22,-94}})));
  Modelica.Blocks.Nonlinear.Limiter limAixExDown[nZones](
      each final uMax=0, each final uMin=-Modelica.Constants.inf)
                                                                 if use_verboseEnergyBalance
    annotation (Placement(transformation(extent={{-30,-116},{-24,-110}})));
  Modelica.Thermal.HeatTransfer.Sensors.HeatFlowSensor heatFlowSensorRad[
    nZones] if use_hydraulic
    annotation (Placement(transformation(extent={{-82,-70},{-62,-50}})));
  Modelica.Thermal.HeatTransfer.Sensors.HeatFlowSensor heatFlowSensorConv[
    nZones] if use_hydraulic
    annotation (Placement(transformation(extent={{-86,50},{-66,70}})));
  Modelica.Blocks.Math.Add          addTra
                                         [nZones]
    if use_hydraulic and use_verboseEnergyBalance
    annotation (Placement(transformation(extent={{-52,-80},{-42,-70}})));
  Utilities.KPIs.ComfortCalculator comfortCalculatorCool[nZones](TComBou=
        TSetZone_nominal .+ dTComfort, each for_heating=false)
    annotation (Placement(transformation(extent={{-24,-52},{-4,-32}})));
  Utilities.KPIs.ComfortCalculator comfortCalculatorHea[nZones](TComBou=
        TSetZone_nominal .- dTComfort, each for_heating=true)
    annotation (Placement(transformation(extent={{-24,-30},{-4,-10}})));
  Utilities.KPIs.InputKPICalculator inputKPICalculatorOwaGain[nZones](
    each calc_singleOnTime=false,
    each calc_totalOnTime=false,
    each calc_numSwi=false,
    each calc_movAve=false,
    each calc_intBelThres=false) if use_verboseEnergyBalance annotation (Placement(transformation(
        extent={{-7,-11},{7,11}},
        rotation=0,
        origin={-7,-137})));
  Modelica.Blocks.Sources.RealExpression QOwa[nZones](y=
        thermalZone.ROM.extWall.Q_flow) if use_verboseEnergyBalance "Internal gains" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-48,-146})));
  Utilities.KPIs.InputKPICalculator inputKPICalculatorOwaLoss[nZones](
    each calc_singleOnTime=false,
    each calc_totalOnTime=false,
    each calc_numSwi=false,
    each calc_movAve=false,
    each calc_intBelThres=false) if use_verboseEnergyBalance annotation (Placement(transformation(
        extent={{-7,-12},{7,12}},
        rotation=0,
        origin={-7,-154})));
  Modelica.Blocks.Nonlinear.Limiter limAirExcUp1
                                               [nZones](each final
      uMax=Modelica.Constants.inf, each final uMin=0) if use_verboseEnergyBalance
    annotation (Placement(transformation(extent={{-28,-140},{-22,-134}})));
  Modelica.Blocks.Nonlinear.Limiter limAixExDown1
                                                [nZones](each final
      uMax=0, each final uMin=-Modelica.Constants.inf) if use_verboseEnergyBalance
    annotation (Placement(transformation(extent={{-30,-156},{-24,-150}})));
  Utilities.KPIs.InputKPICalculator inputKPICalculatorFloorGain[
    nZones](
    each calc_singleOnTime=false,
    each calc_totalOnTime=false,
    each calc_numSwi=false,
    each calc_movAve=false,
    each calc_intBelThres=false) if oneZoneParam.AFloor > 0  and use_verboseEnergyBalance
    annotation (Placement(transformation(
        extent={{-7,-11},{7,11}},
        rotation=0,
        origin={-7,-173})));
  Modelica.Blocks.Sources.RealExpression QFloor[nZones](y=
        thermalZone.ROM.floor.Q_flow)
    if oneZoneParam.AFloor > 0 and use_verboseEnergyBalance "Internal gains" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-48,-182})));
  Utilities.KPIs.InputKPICalculator inputKPICalculatorFloorLoss[
    nZones](
    each calc_singleOnTime=false,
    each calc_totalOnTime=false,
    each calc_numSwi=false,
    each calc_movAve=false,
    each calc_intBelThres=false) if oneZoneParam.AFloor > 0 and use_verboseEnergyBalance
    annotation (Placement(transformation(
        extent={{-7,-12},{7,12}},
        rotation=0,
        origin={-7,-190})));
  Modelica.Blocks.Nonlinear.Limiter limAirExcUp2
                                               [nZones](each final
      uMax=Modelica.Constants.inf, each final uMin=0)
    if oneZoneParam.AFloor > 0 and use_verboseEnergyBalance
    annotation (Placement(transformation(extent={{-28,-176},{-22,-170}})));
  Modelica.Blocks.Nonlinear.Limiter limAixExDown2
                                                [nZones](each final
      uMax=0, each final uMin=-Modelica.Constants.inf)
    if oneZoneParam.AFloor > 0 and use_verboseEnergyBalance
    annotation (Placement(transformation(extent={{-30,-192},{-24,-186}})));
  Utilities.KPIs.InputKPICalculator inputKPICalculatorRoofGain[nZones](
    each calc_singleOnTime=false,
    each calc_totalOnTime=false,
    each calc_numSwi=false,
    each calc_movAve=false,
    each calc_intBelThres=false) if use_verboseEnergyBalance annotation (Placement(transformation(
        extent={{-7,-11},{7,11}},
        rotation=0,
        origin={-75,-137})));
  Modelica.Blocks.Sources.RealExpression QRoof[nZones](y=
        thermalZone.ROM.roof.Q_flow) if use_verboseEnergyBalance "Internal gains" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-116,-146})));
  Utilities.KPIs.InputKPICalculator inputKPICalculatorRoofLoss[nZones](
    each calc_singleOnTime=false,
    each calc_totalOnTime=false,
    each calc_numSwi=false,
    each calc_movAve=false,
    each calc_intBelThres=false) if use_verboseEnergyBalance annotation (Placement(transformation(
        extent={{-7,-12},{7,12}},
        rotation=0,
        origin={-75,-154})));
  Modelica.Blocks.Nonlinear.Limiter limAirExcUp3
                                               [nZones](each final
      uMax=Modelica.Constants.inf, each final uMin=0) if use_verboseEnergyBalance
    annotation (Placement(transformation(extent={{-96,-140},{-90,-134}})));
  Modelica.Blocks.Nonlinear.Limiter limAixExDown3
                                                [nZones](each final
      uMax=0, each final uMin=-Modelica.Constants.inf) if use_verboseEnergyBalance
    annotation (Placement(transformation(extent={{-98,-156},{-92,-150}})));
  Utilities.KPIs.InputKPICalculator inputKPICalculatorWinGain[nZones](
    each calc_singleOnTime=false,
    each calc_totalOnTime=false,
    each calc_numSwi=false,
    each calc_movAve=false,
    each calc_intBelThres=false) if use_verboseEnergyBalance annotation (Placement(transformation(
        extent={{-7,-11},{7,11}},
        rotation=0,
        origin={-75,-173})));
  Modelica.Blocks.Sources.RealExpression QWin[nZones](y=
        thermalZone.ROM.window.Q_flow) if use_verboseEnergyBalance "Internal gains" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-116,-182})));
  Utilities.KPIs.InputKPICalculator inputKPICalculatorWinLoss[nZones](
    each calc_singleOnTime=false,
    each calc_totalOnTime=false,
    each calc_numSwi=false,
    each calc_movAve=false,
    each calc_intBelThres=false) if use_verboseEnergyBalance annotation (Placement(transformation(
        extent={{-7,-12},{7,12}},
        rotation=0,
        origin={-75,-190})));
  Modelica.Blocks.Nonlinear.Limiter limAirExcUp4
                                               [nZones](each final
      uMax=Modelica.Constants.inf, each final uMin=0) if use_verboseEnergyBalance
    annotation (Placement(transformation(extent={{-96,-176},{-90,-170}})));
  Modelica.Blocks.Nonlinear.Limiter limAixExDown4
                                                [nZones](each final
      uMax=0, each final uMin=-Modelica.Constants.inf) if use_verboseEnergyBalance
    annotation (Placement(transformation(extent={{-98,-192},{-92,-186}})));
  Modelica.Blocks.Math.MultiSum multiSum[nZones](each final nu=3) if use_verboseEnergyBalance annotation (Placement(transformation(extent={{-5,-5},{5,5}},
        rotation=180,
        origin={53,-81})));

  Modelica.Blocks.Sources.RealExpression NoLoad(y=0)
    "Simplified electrical load" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={142,-78})));
  Utilities.Electrical.RealToElecCon realToElecCon
    annotation (Placement(transformation(extent={{114,-88},{94,-68}})));
equation

  for i in 1:nZones loop
    connect(weaBus.TDryBul, thermalZone[i].ventTemp) annotation (Line(
        points={{-47,98},{126,98},{126,42.24},{33.52,42.24}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{6,3},{6,3}},
        horizontalAlignment=TextAlignment.Left));
    connect(useProBus.intGains, thermalZone[i].intGains) annotation (Line(
        points={{51,101},{-62,101},{-62,8},{-31.6,8},{-31.6,17.76}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{-3,-6},{-3,-6}},
        horizontalAlignment=TextAlignment.Right));
    if use_ventilation then
      connect(portVent_in[i], thermalZone[i].ports[1]) annotation (Line(points={{100,38},
              {82,38},{82,10},{-2,10},{-2,22.08}},                 color={0,127,
            255}));
      connect(portVent_out[i], thermalZone[i].ports[2]) annotation (Line(points={{100,-40},
              {82,-40},{82,2},{-2,2},{-2,22.08}},             color={0,127,255}));
    end if;
    connect(weaBus, thermalZone[i].weaBus) annotation (Line(
      points={{-47,98},{38,98},{38,69.6},{35,69.6}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  end for;
  connect(constTSetRoom.y, thermalZone.TSetCool) annotation (Line(points={{63,60},
          {48,60},{48,62.4},{33.52,62.4}},color={0,0,127}));
  connect(constTSetRoom.y, thermalZone.TSetHeat) annotation (Line(points={{63,60},
          {48,60},{48,52.32},{33.52,52.32}},color={0,0,127}));

  connect(constVentRate.y, thermalZone.ventRate) annotation (Line(points={{63,30},
          {48,30},{48,32.88},{33.52,32.88}},color={0,0,127}));

  // KPIs
  if use_hydraulic then
    connect(inputKPICalculatorTraGain.KPIBus, outBusDem.QTraGain) annotation (
      Line(
      points={{0.14,-63},{6,-63},{6,-64},{10,-64},{10,-2},{98,-2}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
    connect(inputKPICalculatorTraLoss.KPIBus, outBusDem.QTraLoss) annotation (
      Line(
      points={{0.14,-80},{10,-80},{10,-2},{98,-2}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));

    connect(limUp.y, inputKPICalculatorTraGain.u)
    annotation (Line(points={{-21.7,-63},{-15.54,-63}},
                                                      color={0,0,127}));
    connect(limDown.y, inputKPICalculatorTraLoss.u) annotation (Line(points={{-23.7,
            -79},{-22,-79},{-22,-80},{-15.54,-80}},
                                               color={0,0,127}));
  end if;
  connect(inputKPICalculator.KPIBus, outBusDem.QIntGain) annotation (Line(
      points={{17.86,-81},{14,-81},{14,-82},{10,-82},{10,-2},{98,-2}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(limAirExcUp.y, inputKPICalculatorTraGain2.u)
    annotation (Line(points={{-21.7,-97},{-15.54,-97}}, color={0,0,127}));
  connect(limAixExDown.y, inputKPICalculatorTraLoss2.u) annotation (Line(points={{-23.7,
          -113},{-22,-113},{-22,-114},{-15.54,-114}},   color={0,0,127}));
  connect(QAirExc.y, limAirExcUp.u) annotation (Line(points={{-37,-106},{-38,
          -106},{-38,-97},{-28.6,-97}},
                                 color={0,0,127}));
  connect(QAirExc.y, limAixExDown.u) annotation (Line(points={{-37,-106},{-37,
          -113},{-30.6,-113}},
                       color={0,0,127}));
  connect(inputKPICalculatorTraGain2.KPIBus, outBusDem.QAirExcGain) annotation (
     Line(
      points={{0.14,-97},{10,-97},{10,-2},{98,-2}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(inputKPICalculatorTraLoss2.KPIBus, outBusDem.QAirExcLoss) annotation (
     Line(
      points={{0.14,-114},{10,-114},{10,-2},{98,-2}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  if use_ventilation then
   connect(limVentUp.y, inputKPICalculatorVentGain.u) annotation (Line(points={{39.7,
            -97},{33.54,-97}},               color={0,0,127}));
   connect(limVentDown.y, inputKPICalculatorVentLoss.u) annotation (Line(points={{37.7,
            -115},{37.7,-114},{33.54,-114}},          color={0,0,127}));
   connect(QVent.y, limVentUp.u) annotation (Line(points={{51,-106},{56,-106},{
            56,-97},{46.6,-97}},
                         color={0,0,127}));
   connect(QVent.y, limVentDown.u) annotation (Line(points={{51,-106},{51,-114},
            {44.6,-114},{44.6,-115}},
                    color={0,0,127}));
   connect(inputKPICalculatorVentGain.KPIBus, outBusDem.QVentGain) annotation (
    Line(
    points={{17.86,-97},{17.86,-96},{10,-96},{10,-2},{98,-2}},
    color={255,204,51},
    thickness=0.5), Text(
    string="%second",
    index=1,
    extent={{6,3},{6,3}},
    horizontalAlignment=TextAlignment.Left));
   connect(inputKPICalculatorVentLoss.KPIBus, outBusDem.QVentLoss) annotation (
    Line(
    points={{17.86,-114},{10,-114},{10,-2},{98,-2}},
    color={255,204,51},
    thickness=0.5), Text(
    string="%second",
    index=1,
    extent={{6,3},{6,3}},
    horizontalAlignment=TextAlignment.Left));
  end if;

  connect(thermalZone.intGainsConv, heatFlowSensorConv.port_b) annotation (Line(
        points={{-39.74,49.44},{-39.74,48},{-52,48},{-52,60},{-66,60}}, color={
          191,0,0}));
  connect(heatPortCon, heatFlowSensorConv.port_a)
    annotation (Line(points={{-100,60},{-86,60}}, color={191,0,0}));
  connect(heatPortRad, heatFlowSensorRad.port_a)
    annotation (Line(points={{-100,-60},{-82,-60}}, color={191,0,0}));
  connect(heatFlowSensorRad.port_b, thermalZone.intGainsRad) annotation (Line(
        points={{-62,-60},{-48,-60},{-48,48},{-50,48},{-50,60.24},{-39.74,60.24}},
        color={191,0,0}));
  connect(addTra.y, limUp.u) annotation (Line(points={{-41.5,-75},{-32,-75},{
          -32,-63},{-28.6,-63}},
                      color={0,0,127}));
  connect(addTra.y, limDown.u) annotation (Line(points={{-41.5,-75},{-36,-75},{
          -36,-79},{-30.6,-79}},
                           color={0,0,127}));
  connect(heatFlowSensorRad.Q_flow, addTra.u2)
    annotation (Line(points={{-72,-70},{-72,-78},{-53,-78}}, color={0,0,127}));
  connect(heatFlowSensorConv.Q_flow, addTra.u1) annotation (Line(points={{-76,50},
          {-76,-72},{-53,-72}},                                  color={0,0,127}));
  connect(thermalZone.TAir, outBusDem.TZone) annotation (Line(points={{-42.7,
          76.8},{-48,76.8},{-48,-2},{98,-2}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(thermalZone.TAir, comfortCalculatorHea.TZone) annotation (Line(points={{-42.7,
          76.8},{-48,76.8},{-48,-20},{-26,-20}},        color={0,0,127}));
  connect(thermalZone.TAir, comfortCalculatorCool.TZone) annotation (Line(
        points={{-42.7,76.8},{-48,76.8},{-48,-42},{-26,-42}}, color={0,0,127}));
  connect(comfortCalculatorCool.dTComSec, outBusDem.dTComCoo) annotation (Line(
        points={{-3,-42},{10,-42},{10,-2},{98,-2}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(comfortCalculatorHea.dTComSec, outBusDem.dTComHea) annotation (Line(
        points={{-3,-20},{10,-20},{10,-2},{98,-2}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(limAirExcUp1.y, inputKPICalculatorOwaGain.u)
    annotation (Line(points={{-21.7,-137},{-15.54,-137}}, color={0,0,127}));
  connect(limAixExDown1.y, inputKPICalculatorOwaLoss.u) annotation (Line(points=
         {{-23.7,-153},{-22,-153},{-22,-154},{-15.54,-154}}, color={0,0,127}));
  connect(QOwa.y, limAirExcUp1.u) annotation (Line(points={{-37,-146},{-38,-146},
          {-38,-137},{-28.6,-137}}, color={0,0,127}));
  connect(QOwa.y, limAixExDown1.u) annotation (Line(points={{-37,-146},{-37,
          -153},{-30.6,-153}}, color={0,0,127}));
  connect(limAirExcUp2.y, inputKPICalculatorFloorGain.u)
    annotation (Line(points={{-21.7,-173},{-15.54,-173}}, color={0,0,127}));
  connect(limAixExDown2.y, inputKPICalculatorFloorLoss.u) annotation (Line(
        points={{-23.7,-189},{-22,-189},{-22,-190},{-15.54,-190}}, color={0,0,
          127}));
  connect(QFloor.y, limAirExcUp2.u) annotation (Line(points={{-37,-182},{-38,
          -182},{-38,-173},{-28.6,-173}}, color={0,0,127}));
  connect(QFloor.y, limAixExDown2.u) annotation (Line(points={{-37,-182},{-37,
          -189},{-30.6,-189}}, color={0,0,127}));
  connect(limAirExcUp3.y, inputKPICalculatorRoofGain.u)
    annotation (Line(points={{-89.7,-137},{-83.54,-137}}, color={0,0,127}));
  connect(limAixExDown3.y, inputKPICalculatorRoofLoss.u) annotation (Line(
        points={{-91.7,-153},{-90,-153},{-90,-154},{-83.54,-154}}, color={0,0,
          127}));
  connect(QRoof.y, limAirExcUp3.u) annotation (Line(points={{-105,-146},{-106,
          -146},{-106,-137},{-96.6,-137}}, color={0,0,127}));
  connect(QRoof.y, limAixExDown3.u) annotation (Line(points={{-105,-146},{-105,
          -153},{-98.6,-153}}, color={0,0,127}));
  connect(limAirExcUp4.y, inputKPICalculatorWinGain.u)
    annotation (Line(points={{-89.7,-173},{-83.54,-173}}, color={0,0,127}));
  connect(limAixExDown4.y, inputKPICalculatorWinLoss.u) annotation (Line(points=
         {{-91.7,-189},{-90,-189},{-90,-190},{-83.54,-190}}, color={0,0,127}));
  connect(QWin.y, limAirExcUp4.u) annotation (Line(points={{-105,-182},{-106,
          -182},{-106,-173},{-96.6,-173}}, color={0,0,127}));
  connect(QWin.y, limAixExDown4.u) annotation (Line(points={{-105,-182},{-105,
          -189},{-98.6,-189}}, color={0,0,127}));
  connect(inputKPICalculatorOwaGain.KPIBus, outBusDem.QOwaGain) annotation (
      Line(
      points={{0.14,-137},{8,-137},{8,-2},{98,-2}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(inputKPICalculatorOwaLoss.KPIBus, outBusDem.QOwaLoss) annotation (
      Line(
      points={{0.14,-154},{12,-154},{12,-2},{98,-2}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(inputKPICalculatorFloorGain.KPIBus, outBusDem.QFloorGain) annotation (
     Line(
      points={{0.14,-173},{10,-173},{10,-2},{98,-2}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(inputKPICalculatorFloorLoss.KPIBus, outBusDem.QFloorLoss) annotation (
     Line(
      points={{0.14,-190},{10,-190},{10,-2},{98,-2}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(inputKPICalculatorWinLoss.KPIBus, outBusDem.QWinLoss) annotation (
      Line(
      points={{-67.86,-190},{10,-190},{10,-2},{98,-2}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(inputKPICalculatorWinGain.KPIBus, outBusDem.QWinGain) annotation (
      Line(
      points={{-67.86,-173},{12,-173},{12,-2},{98,-2}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(inputKPICalculatorRoofLoss.KPIBus, outBusDem.QRoofLoss) annotation (
      Line(
      points={{-67.86,-154},{-26,-154},{-26,-152},{10,-152},{10,-2},{98,-2}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(inputKPICalculatorRoofGain.KPIBus, outBusDem.QRoofGain) annotation (
      Line(
      points={{-67.86,-137},{12,-137},{12,-2},{98,-2}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(thermalZone.TAir, buiMeaBus.TZoneMea) annotation (Line(points={{-42.7,
          76.8},{-48,76.8},{-48,92},{0,92},{0,99}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(multiSum.y, inputKPICalculator.u)
    annotation (Line(points={{47.15,-81},{33.54,-81}}, color={0,0,127}));
  connect(multiSum.u, thermalZone.QIntGains_flow) annotation (Line(points={{58,-81},
          {64,-81},{64,-80},{68,-80},{68,-4},{-50,-4},{-50,33.6},{-42.7,33.6}},
        color={0,0,127}));
  connect(NoLoad.y, realToElecCon.PEleLoa)
    annotation (Line(points={{131,-78},{114.6,-78}}, color={0,0,127}));
  connect(realToElecCon.internalElectricalPin, internalElectricalPin)
    annotation (Line(
      points={{93.8,-77.8},{70,-77.8},{70,-96}},
      color={0,0,0},
      thickness=1));
    annotation (Diagram(coordinateSystem(extent={{-100,-100},{100,100}})), Icon(
        coordinateSystem(extent={{-100,-120},{100,100}})));
end TEASERThermalZone;
