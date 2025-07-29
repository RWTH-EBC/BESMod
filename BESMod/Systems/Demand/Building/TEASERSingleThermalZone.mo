within BESMod.Systems.Demand.Building;
model TEASERSingleThermalZone
  "Reduced order single zone building model, coupled with TEASER"
  extends BaseClasses.PartialDemand(
    hBui=0,
    ABui=0,
    ARoo=0,
    hZone=zoneParam.VAir ./ zoneParam.AZone,
    AZone=zoneParam.AZone);

  parameter Real solGainFacConst = 1 annotation(Evaluate=false);
  parameter Real solGainFacTDryBul = 0 annotation(Evaluate=false);
  parameter Real solGainFacTSet = 0 annotation(Evaluate=false);

  parameter Real intGainFacConst = 1 annotation(Evaluate=false);
  parameter Real intGainFacTDryBul = 0 annotation(Evaluate=false);
  parameter Real intGainFacTSet = 0 annotation(Evaluate=false);

  parameter AixLib.ThermalZones.HighOrder.Components.Types.CalcMethodConvectiveHeatTransfer calcMethodOut=AixLib.ThermalZones.HighOrder.Components.Types.CalcMethodConvectiveHeatTransfer.Custom_hCon
  "Calculation method for convective heat transfer coefficient at outside surface";
  parameter AixLib.DataBase.Surfaces.RoughnessForHT.PolynomialCoefficients_ASHRAEHandbook surfaceType = AixLib.DataBase.Surfaces.RoughnessForHT.Brick_RoughPlaster()
    "Surface type";

  replaceable parameter BESMod.Systems.Demand.Building.RecordsCollection.BuildingSingleZoneRecordDummy oneZoneParam constrainedby
    BESMod.Systems.Demand.Building.RecordsCollection.BuildingSingleZoneBaseRecord
    "Default zone if only one is chosen" annotation(choicesAllMatching=true);
  parameter BESMod.Systems.Demand.Building.RecordsCollection.BuildingSingleZoneBaseRecord zoneParam[nZones] = fill(oneZoneParam, nZones)
    "Choose an array of multiple zones" annotation(choicesAllMatching=true);
  parameter Boolean useUserProfileNatVent = false;
  parameter Real ventRate[nZones]=fill(0, nZones) "Constant mechanical ventilation rate";

  parameter Boolean use_verboseEnergyBalance=true   "=false to disable the integration of the verbose energy balance";
  parameter Modelica.Units.SI.TemperatureDifference dTComfort=2
    "Temperature difference to room set temperature at which the comfort is still acceptable. In DIN EN 15251, all temperatures below 22 °C - 2 K count as discomfort. Hence the default value. If your room set temperature is lower, consider using smaller values.";
  parameter Boolean incElePro = false
    "=false to not include electrical energy consumption in the electrical connectors";
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation (Dialog(tab="Dynamics"));
  parameter Modelica.Units.SI.Temperature T_start=min(TSetZone_nominal)
    "Start value of temperature" annotation (Dialog(tab="Initialization"));
  parameter Boolean use_absIntGai=false "=true to use absolute internal gains from user-profiles, e.g. from real data. Only supported for single zone";
  final parameter Modelica.Units.SI.HeatFlowRate QRec_flow_nominal[nZones]= {
        zoneParam[i].heaLoadFacOut * (TSetZone_nominal[i] - TOda_nominal) +
        zoneParam[i].heaLoadFacGrd*(TSetZone_nominal[i] - zoneParam[i].TSoil)
        for i in 1:nZones}
    "Nominal heat flow rate according to record at TOda_nominal";

  BESMod.Systems.Demand.Building.Components.TEASERBuildingSingleZone.BuildingSingleThermalZone.BuildingSingleThermalZone thermalZone[nZones](
    redeclare each final package Medium = MediumZone,
    each final energyDynamics=energyDynamics,
    each final T_start=T_start,
    final zoneParam=zoneParam,
    each final calcMethodOut=calcMethodOut,
    each final surfaceType=surfaceType,
    each final use_MechanicalAirExchange=true,
    each final use_NaturalAirExchange=false,
    each final nPorts=if use_ventilation then 2 else 0,
    each final TOda_nominal=TOda_nominal,
    each final TSetZone_nominal=TSetZone_nominal[1],
    each final solGainFacConst=solGainFacConst,
    each final solGainFacTDryBul=solGainFacTDryBul,
    each final solGainFacTSet=solGainFacTSet) annotation (Placement(
        transformation(extent={{35,12},{-39,84}}, rotation=0)));

  Modelica.Blocks.Sources.Constant constTSetRoom[nZones](final k=
        TSetZone_nominal)                                      annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={70,80})));

  Modelica.Blocks.Sources.Constant constVentRate[nZones](final k=ventRate) if not useUserProfileNatVent
                                         annotation (Placement(transformation(
          extent={{-10,-10},{10,10}}, rotation=180,
        origin={70,20})));

  Modelica.Blocks.Sources.RealExpression QVent[nZones](y=
        portVent_in.m_flow.*inStream(portVent_in.h_outflow) .+ portVent_out.m_flow
        .*portVent_out.h_outflow) if use_ventilation and use_verboseEnergyBalance
    "Internal gains"                                               annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-90,-216})));
  Modelica.Blocks.Sources.RealExpression QAirExc[nZones](y=
        thermalZone.airExc.Q_flow) if use_verboseEnergyBalance "Internal gains"                annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-90,-160})));
  Modelica.Thermal.HeatTransfer.Sensors.HeatFlowSensor heaFloSenRad[nZones]
    "Measure radiative heat flow"
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));
  Modelica.Thermal.HeatTransfer.Sensors.HeatFlowSensor heatFlowSensorConv[
    nZones]
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Modelica.Blocks.Math.Add          addTra[nZones] if use_verboseEnergyBalance
    annotation (Placement(transformation(extent={{-10,10},{10,-10}},
        rotation=0,
        origin={-90,-198})));

  Modelica.Blocks.Routing.RealPassThrough realPassThroughIntGains[nZones,3]
    annotation (Placement(transformation(extent={{-100,0},{-80,20}})));
  Modelica.Blocks.Routing.RealPassThrough realPassThroughTDry[nZones]
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={70,50})));
  Modelica.Blocks.Math.Add calTOpe[nZones](
    each final k1=0.5,
    each final k2=0.5,
    each y(unit="K", displayUnit="degC"))
    "Calculate operative room temperature"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-70,80})));
  BESMod.Utilities.Electrical.RealToElecCon realToElecCon(use_souGen=false)
                                                annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={82,-148})));
  Modelica.Blocks.Math.Gain gain(final k=if incElePro then 1 else 0)
                                                               annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={68,-120})));
  Modelica.Blocks.Math.MultiSum multiSumEle(final k=fill(1, multiSumEle.nu),
      nu=if use_absIntGai then 4*nZones else 2*nZones)  annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={30,-120})));
  Utilities.KPIs.ZoneEnergyBalance zoneEneBal[nZones](each final
      with_ventilation=use_ventilation, each final with_floor=zoneParam[1].AFloor
         > 0)
    if use_verboseEnergyBalance "Zone energy balance"
    annotation (Placement(transformation(extent={{-60,-200},{-22,-140}})));
  Modelica.Blocks.Sources.RealExpression QExtWall_flow[nZones](y=thermalZone.ROM.extWall.Q_flow)
    if use_verboseEnergyBalance "External wall heat flow rate" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-90,-110})));
  Utilities.KPIs.ZoneTemperature zonTem[nZones](each final dTComfort=dTComfort,
      final TSetZone_nominal=TSetZone_nominal)
    "Zone temperature KPIs for air temperature"
    annotation (Placement(transformation(extent={{0,-50},{20,-30}})));
  Utilities.KPIs.ZoneTemperature zonTemOpe[nZones](each final dTComfort=
        dTComfort, final TSetZone_nominal=TSetZone_nominal)
    "Zone temperature KPIs for operative temperature"
    annotation (Placement(transformation(extent={{0,-80},{20,-60}})));
  Modelica.Blocks.Sources.RealExpression QRoof_flow[nZones](y=thermalZone.ROM.roof.Q_flow)
    if use_verboseEnergyBalance "Roof heat flow rate" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-90,-120})));
  Modelica.Blocks.Sources.RealExpression QFloor_flow[nZones](y=thermalZone.ROM.floor.Q_flow)
    if use_verboseEnergyBalance and zoneParam[1].AFloor > 0
                                "Floor heat flow rate" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-90,-134})));
  Modelica.Blocks.Sources.RealExpression QWin_flow[nZones](y=thermalZone.ROM.window.Q_flow)
    if use_verboseEnergyBalance "Window heat flow rate"                                        annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-90,-148})));
  Modelica.Blocks.Sources.RealExpression QSol_flow[nZones](y={if ATot[i] > 0 then
        sum({thermalZone[i].ROM.solRad[n]*thermalZone[i].ROM.ATransparent[n]*
        thermalZone[i].ROM.gWin for n in 1:thermalZone[i].ROM.nOrientations})
         else 0 for i in 1:nZones}) if use_verboseEnergyBalance
    "Solar radiative  heat flow rate" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-90,-170})));

protected
  parameter Modelica.Units.SI.Area ATot[nZones]={sum(zoneParam[i].AExt)+sum(zoneParam[i].AWin) for i in 1:nZones} "Sum of wall surface areas";
initial equation
  assert(if use_absIntGai then nZones == 1 else true, "use_absIntGai is only supported for single zones");
equation

  for i in 1:nZones loop
    connect(weaBus.TDryBul, realPassThroughTDry[i].u) annotation (Line(
        points={{-46.895,98.11},{-6,98.11},{-6,98},{90,98},{90,50},{82,50}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{6,3},{6,3}},
        horizontalAlignment=TextAlignment.Left));
    connect(useProBus.intGains, realPassThroughIntGains[i, :].u) annotation (Line(
        points={{51,101},{-120,101},{-120,10},{-102,10}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{-3,-6},{-3,-6}},
        horizontalAlignment=TextAlignment.Right));
    connect(thermalZone[i].QIntGains_flow[1], multiSumEle.u[2*i-1]) annotation (Line(
        points={{-42.7,32.4},{-42.7,32},{-120,32},{-120,-88},{-26,-88},{-26,-120},
          {20,-120}},                 color={0,0,127}));
    connect(thermalZone[i].QIntGains_flow[2], multiSumEle.u[2*i]) annotation (Line(
        points={{-42.7,33.6},{-42.7,32},{-120,32},{-120,-88},{-26,-88},{-26,-120},
            {20,-120}},               color={0,0,127}));
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
  if use_absIntGai then
    connect(useProBus.absIntGaiRad, multiSumEle.u[4]) annotation (Line(
        points={{51,101},{51,0},{-28,0},{-28,-68},{-6,-68},{-6,-134},{12,-134},{
          12,-120},{20,-120}},        color={0,0,127}));
    connect(useProBus.absIntGaiConv, multiSumEle.u[3]) annotation (Line(
      points={{51,101},{51,0},{-28,0},{-28,-68},{-6,-68},{-6,-134},{12,-134},{12,
          -120},{20,-120}},           color={0,0,127}));
  end if;
  connect(constTSetRoom.y, thermalZone.TSetCool) annotation (Line(points={{59,80},
          {48,80},{48,62.4},{33.52,62.4}},color={0,0,127}));
  connect(constTSetRoom.y, thermalZone.TSetHeat) annotation (Line(points={{59,80},
          {48,80},{48,62},{42,62},{42,52.32},{33.52,52.32}},
                                            color={0,0,127}));

  connect(constVentRate.y, thermalZone.ventRate) annotation (Line(points={{59,20},
          {42,20},{42,32.88},{33.52,32.88}},color={0,0,127}));

  connect(thermalZone.intGainsConv, heatFlowSensorConv.port_b) annotation (Line(
        points={{-39.74,49.44},{-49.87,49.44},{-49.87,50},{-60,50}},    color={
          191,0,0}));
  connect(heatPortCon, heatFlowSensorConv.port_a)
    annotation (Line(points={{-100,60},{-84,60},{-84,50},{-80,50}},
                                                  color={191,0,0}));
  connect(heatPortRad, heaFloSenRad.port_a)
    annotation (Line(points={{-100,-60},{-80,-60}}, color={191,0,0}));
  connect(heaFloSenRad.port_b, thermalZone.intGainsRad) annotation (Line(points=
         {{-60,-60},{-52,-60},{-52,60},{-46,60},{-46,60.24},{-39.74,60.24}},
        color={191,0,0}));
  connect(heaFloSenRad.Q_flow, addTra.u2) annotation (Line(points={{-70,-71},{
          -70,-98},{-112,-98},{-112,-192},{-102,-192}}, color={0,0,127}));
  connect(heatFlowSensorConv.Q_flow, addTra.u1) annotation (Line(points={{-70,39},
          {-70,-46},{-114,-46},{-114,-204},{-102,-204}},         color={0,0,127}));
  connect(thermalZone.TAir, outBusDem.TZone) annotation (Line(points={{-42.7,
          76.8},{-46,76.8},{-46,76},{-48,76},{-48,-2},{98,-2}},
                                              color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(thermalZone.TAir, buiMeaBus.TZoneMea) annotation (Line(points={{-42.7,
          76.8},{-48,76.8},{-48,88},{0,88},{0,99}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(realPassThroughIntGains.y, thermalZone.intGains) annotation (Line(
        points={{-79,10},{-32,10},{-32,14},{-31.6,14},{-31.6,17.76}},
                                                                    color={0,0,
          127}));
  connect(realPassThroughTDry.y, thermalZone.ventTemp) annotation (Line(points={{59,50},
          {42,50},{42,42.24},{33.52,42.24}},                             color=
          {0,0,127}));
  connect(calTOpe.u2, thermalZone.TAir) annotation (Line(points={{-58,86},{-48,
          86},{-48,76.8},{-42.7,76.8}}, color={0,0,127}));
  connect(calTOpe.u1, thermalZone.TRad) annotation (Line(points={{-58,74},{-52,
          74},{-52,69.6},{-42.7,69.6}}, color={0,0,127}));
  connect(calTOpe.y, buiMeaBus.TZoneOpeMea) annotation (Line(points={{-81,80},{
          -122,80},{-122,110},{0,110},{0,99}},
        color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(calTOpe.y, outBusDem.TZoneOpe) annotation (Line(points={{-81,80},{
          -122,80},{-122,28},{-44,28},{-44,8},{-18,8},{-18,-2},{98,-2}},
                                      color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(gain.y,realToElecCon. PEleLoa) annotation (Line(points={{79,-120},{84,
          -120},{84,-134},{62,-134},{62,-144},{70,-144}},
                                        color={0,0,127}));
  connect(multiSumEle.y, gain.u)
    annotation (Line(points={{41.7,-120},{56,-120}}, color={0,0,127}));
  connect(realToElecCon.internalElectricalPin, internalElectricalPin)
    annotation (Line(
      points={{92.2,-147.8},{96,-147.8},{96,-96},{70,-96}},
      color={0,0,0},
      thickness=1));

  connect(zoneEneBal.QAirExc_flow, QAirExc.y)
    annotation (Line(points={{-63.8,-164},{-70,-164},{-70,-160},{-79,-160}},
                                                       color={0,0,127}));
  connect(QVent.y, zoneEneBal.QVen_flow) annotation (Line(points={{-79,-216},{-79,
          -200},{-63.8,-200}}, color={0,0,127}));
  connect(addTra.y, zoneEneBal.QTra_flow) annotation (Line(points={{-79,-198},{-79,
          -194},{-63.8,-194}},                                   color={0,0,127}));
  connect(zoneEneBal.zoneEneBal, outBusDem.eneBal) annotation (Line(
      points={{-21.62,-170},{-14,-170},{-14,-2},{98,-2}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(zonTem.dTComCoo, outBusDem.dTComCoo) annotation (Line(points={{21,
          -44.8},{24,-44.8},{24,-2},{98,-2}},
                                       color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(zonTemOpe.dTComCoo, outBusDem.dTComCooOpe) annotation (Line(points={{21,
          -74.8},{50,-74.8},{50,-74},{80,-74},{80,-2},{98,-2}},
                                         color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(zonTem.dTComHea, outBusDem.dTComHea) annotation (Line(points={{21,-35},
          {78,-35},{78,-2},{98,-2}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(zonTemOpe.dTComHea, outBusDem.dTComHeaOpe) annotation (Line(points={{21,-65},
          {80,-65},{80,-2},{98,-2}},                       color={0,0,127}),
      Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(zonTemOpe.dTCtrl, outBusDem.dTCtrlHeaOpe) annotation (Line(points={{21,-70},
          {80,-70},{80,-2},{98,-2}},                          color={0,0,127}),
      Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(zonTem.dTCtrl, outBusDem.dTCtrl) annotation (Line(points={{21,-40},{
          80,-40},{80,-2},{98,-2}},            color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(zonTemOpe.TZone, calTOpe.y) annotation (Line(points={{-2,-65},{-2,-66},
          {-50,-66},{-50,-40},{-122,-40},{-122,80},{-81,80}}, color={0,0,127}));
  connect(thermalZone.TAir, zonTem.TZone) annotation (Line(points={{-42.7,76.8},
          {-44,76.8},{-44,76},{-48,76},{-48,-35},{-2,-35}}, color={0,0,127}));
  connect(zonTem.TZoneSet, useProBus.TZoneSet) annotation (Line(points={{-2,-45},
          {-2,-46},{-14,-46},{-14,6},{50,6},{50,76},{51,76},{51,101}},
                                                                     color={0,0,
          127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(zonTemOpe.TZoneSet, useProBus.TZoneSet) annotation (Line(points={{-2,-75},
          {-2,-76},{-14,-76},{-14,6},{50,6},{50,76},{51,76},{51,101}},
                 color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(QExtWall_flow.y, zoneEneBal.QExtWall_flow) annotation (Line(points={{-79,
          -110},{-72,-110},{-72,-140},{-63.8,-140}}, color={0,0,127}));
  connect(zoneEneBal.QRoof_flow, QRoof_flow.y) annotation (Line(points={{-63.8,-146},
          {-74,-146},{-74,-120},{-79,-120}}, color={0,0,127}));
  connect(QFloor_flow.y, zoneEneBal.QFloor_flow) annotation (Line(points={{-79,-134},
          {-76,-134},{-76,-152},{-63.8,-152}}, color={0,0,127}));
  connect(zoneEneBal.QWin_flow, QWin_flow.y) annotation (Line(points={{-63.8,-158},
          {-74,-158},{-74,-148},{-79,-148}}, color={0,0,127}));
  connect(thermalZone.QIntGains_flow[1], zoneEneBal.QLig_flow) annotation (Line(
        points={{-42.7,32.4},{-120,32.4},{-120,-176},{-63.8,-176}}, color={0,0,127}));
  connect(thermalZone.QIntGains_flow[3], zoneEneBal.QPer_flow) annotation (Line(
        points={{-42.7,34.8},{-40,34.8},{-40,32},{-120,32},{-120,-182},{-63.8,
          -182}},                                                   color={0,0,127}));
  connect(thermalZone.QIntGains_flow[2], zoneEneBal.QMac_flow) annotation (Line(
        points={{-42.7,33.6},{-40,33.6},{-40,32},{-120,32},{-120,-188},{-63.8,
          -188}},                                                   color={0,0,127}));
  connect(QSol_flow.y, zoneEneBal.QSol_flow)
    annotation (Line(points={{-79,-170},{-63.8,-170}}, color={0,0,127}));
  if useUserProfileNatVent then
    connect(useProBus.natVent, thermalZone.ventRate) annotation (Line(
      points={{51,101},{51,32.88},{33.52,32.88}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  end if;
  connect(useProBus.TRoomSet, thermalZone[1].TSetRooms) annotation (Line(
      points={{51,101},{50,101},{50,88.68},{37.59,88.68}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(useProBus.intGainRooms, thermalZone[1].intGainRooms) annotation (Line(
      points={{51,101},{50,101},{50,64},{92,64},{92,124},{34.63,124},{34.63,
          82.92}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(useProBus.natVentRooms, thermalZone[1].natVentRooms) annotation (Line(
      points={{51,101},{50,101},{50,62},{94,62},{94,126},{23.9,126},{23.9,84}},

      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
    annotation (Diagram(coordinateSystem(extent={{-100,-220},{100,100}})),
      Documentation(info="<html>
<p>This model uses the reduced-order approach with the common TEASER output to model the building envelope. Relevant KPIs are calculated.</p>
<p>You can model multiple thermal zones. We refer to the documentation of TEASER and the ThermalZone model for more information on usage.</p>
<p>Assumptions</p>
</html>"));
end TEASERSingleThermalZone;
