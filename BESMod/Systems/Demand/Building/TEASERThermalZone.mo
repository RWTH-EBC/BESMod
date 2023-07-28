within BESMod.Systems.Demand.Building;
model TEASERThermalZone
  "Reduced order building model, coupled with TEASER"
  extends BaseClasses.PartialDemand(
    hBui=0,
    ABui=0,
    ARoo=0,
    hZone=zoneParam.VAir ./ zoneParam.AZone,
    AZone=zoneParam.AZone);
  replaceable parameter AixLib.DataBase.ThermalZones.ZoneRecordDummy oneZoneParam constrainedby
    AixLib.DataBase.ThermalZones.ZoneBaseRecord
    "Default zone if only one is chosen" annotation(choicesAllMatching=true);
  parameter AixLib.DataBase.ThermalZones.ZoneBaseRecord zoneParam[nZones] = fill(oneZoneParam, nZones)
    "Choose an array of multiple zones" annotation(choicesAllMatching=true);
  parameter Real ventRate[nZones]=fill(0, nZones) "Constant mechanical ventilation rate";

  parameter Boolean use_verboseEnergyBalance=true   "=false to disable the integration of the verbose energy balance";
  parameter Modelica.Units.SI.TemperatureDifference dTComfort=2
    "Temperature difference to room set temperature at which the comfort is still acceptable. In DIN EN 15251, all temperatures below 22 °C - 2 K count as discomfort. Hence the default value. If your room set temperature is lower, consider using smaller values.";

  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation (Dialog(tab="Dynamics"));
  parameter Modelica.Units.SI.Temperature T_start=293.15
    "Start value of temperature" annotation (Dialog(tab="Initialization"));
  final parameter Modelica.Units.SI.HeatFlowRate QRec_flow_nominal[nZones]= {
        (zoneParam[i].heaLoadFacOut +
          zoneParam[i].VAir * (0.5 - zoneParam[i].baseACH) / 3600 * cp * rho) *
          (TSetZone_nominal[i] - TOda_nominal) +
        zoneParam[i].heaLoadFacGrd*(TSetZone_nominal[i] - zoneParam[i].TSoil)
        for i in 1:nZones}
    "Nominal heat flow rate according to record at TOda_nominal";
  parameter Modelica.Units.SI.Temperature TOda_nominal "Nominal outdoor air temperature";

  AixLib.ThermalZones.ReducedOrder.ThermalZone.ThermalZone thermalZone[nZones](
    redeclare each final package Medium = MediumZone,
    each final energyDynamics=energyDynamics,
    each final T_start=T_start,
    final zoneParam=zoneParam,
    each final use_MechanicalAirExchange=true,
    each final use_NaturalAirExchange=true,
    each final nPorts=if use_ventilation then 2 else 0) annotation (Placement(
        transformation(extent={{35,12},{-39,84}}, rotation=0)));

  Modelica.Blocks.Sources.Constant constTSetRoom[nZones](final k=
        TSetZone_nominal)                                      annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={74,60})));

  Modelica.Blocks.Sources.Constant constVentRate[nZones](final k=ventRate)
                                         annotation (Placement(transformation(
          extent={{-10,-10},{10,10}}, rotation=180,
        origin={74,30})));

  BESMod.Utilities.KPIs.EnergyKPICalculator intKPICalTraGain[nZones](each final
            use_inpCon=true) if use_hydraulic and use_verboseEnergyBalance
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-30,-102})));
  BESMod.Utilities.KPIs.EnergyKPICalculator intKPICalTraLoss[nZones](each final
            use_inpCon=true) if use_hydraulic and use_verboseEnergyBalance
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-30,-130})));
  Modelica.Blocks.Nonlinear.Limiter limUp[nZones](each final uMax=
        Modelica.Constants.inf, each final uMin=0) if use_hydraulic and use_verboseEnergyBalance
    annotation (Placement(transformation(extent={{-80,-110},{-60,-90}})));
  Modelica.Blocks.Nonlinear.Limiter limDown[nZones](each final uMax=
       0, each final uMin=-Modelica.Constants.inf) if use_hydraulic and use_verboseEnergyBalance
    annotation (Placement(transformation(extent={{-80,-140},{-60,-120}})));
  BESMod.Utilities.KPIs.EnergyKPICalculator intKPICal[nZones](each final
      use_inpCon=true) if use_verboseEnergyBalance annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={30,-110})));
  BESMod.Utilities.KPIs.EnergyKPICalculator intKPICalVentGain[nZones](each final
            use_inpCon=true) if use_ventilation and use_verboseEnergyBalance
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={30,-182})));
  Modelica.Blocks.Sources.RealExpression QVent[nZones](y=
        portVent_in.m_flow.*inStream(portVent_in.h_outflow) .+ portVent_out.m_flow
        .*portVent_out.h_outflow) if use_ventilation and use_verboseEnergyBalance
    "Internal gains"                                               annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={90,-196})));
  BESMod.Utilities.KPIs.EnergyKPICalculator intKPICalVentLoss[nZones](each final
            use_inpCon=true) if use_ventilation and use_verboseEnergyBalance
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={30,-206})));
  Modelica.Blocks.Nonlinear.Limiter limVentUp[nZones](each final
      uMax=Modelica.Constants.inf, each final uMin=0) if
       use_ventilation and use_verboseEnergyBalance
    annotation (Placement(transformation(extent={{-9,-9},{9,9}},
        rotation=180,
        origin={63,-185})));
  Modelica.Blocks.Nonlinear.Limiter limVentDown[nZones](each final
      uMax=0, each final uMin=-Modelica.Constants.inf) if
       use_ventilation and use_verboseEnergyBalance
    annotation (Placement(transformation(extent={{-9,-9},{9,9}},
        rotation=180,
        origin={63,-205})));
  BESMod.Utilities.KPIs.EnergyKPICalculator intKPICalTraGain2[nZones](each final
            use_inpCon=true) if use_verboseEnergyBalance annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-30,-156})));
  Modelica.Blocks.Sources.RealExpression QAirExc[nZones](y=
        thermalZone.airExc.Q_flow) if use_verboseEnergyBalance "Internal gains"                annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-90,-166})));
  BESMod.Utilities.KPIs.EnergyKPICalculator intKPICalTraLoss2[nZones](each final
            use_inpCon=true) if use_verboseEnergyBalance annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-30,-186})));
  Modelica.Blocks.Nonlinear.Limiter limAirExcUp[nZones](each final
      uMax=Modelica.Constants.inf, each final uMin=0) if
                                                        use_verboseEnergyBalance
    annotation (Placement(transformation(extent={{-70,-166},{-50,-146}})));
  Modelica.Blocks.Nonlinear.Limiter limAixExDown[nZones](
      each final uMax=0, each final uMin=-Modelica.Constants.inf) if
                                                                    use_verboseEnergyBalance
    annotation (Placement(transformation(extent={{-70,-196},{-50,-176}})));
  Modelica.Thermal.HeatTransfer.Sensors.HeatFlowSensor heatFlowSensorRad[
    nZones]
    annotation (Placement(transformation(extent={{-82,-70},{-62,-50}})));
  Modelica.Thermal.HeatTransfer.Sensors.HeatFlowSensor heatFlowSensorConv[
    nZones]
    annotation (Placement(transformation(extent={{-86,50},{-66,70}})));
  Modelica.Blocks.Math.Add          addTra
                                         [nZones] if
       use_hydraulic and use_verboseEnergyBalance
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));
  BESMod.Utilities.KPIs.ComfortCalculator comfortCalculatorCool[nZones](TComBou=
       TSetZone_nominal .+ dTComfort, each for_heating=false)
    annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));
  BESMod.Utilities.KPIs.ComfortCalculator comfortCalculatorHea[nZones](TComBou=
        TSetZone_nominal .- dTComfort, each for_heating=true)
    annotation (Placement(transformation(extent={{-20,-20},{0,0}})));
  Modelica.Blocks.Math.MultiSum multiSum[nZones](each final nu=3) if use_verboseEnergyBalance annotation (Placement(transformation(extent={{-9,-9},
            {9,9}},
        rotation=180,
        origin={69,-129})));

  BESMod.Utilities.Electrical.ZeroLoad zeroLoad annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={94,-96})));
  Modelica.Blocks.Routing.RealPassThrough realPassThroughIntGains[nZones,3]
    annotation (Placement(transformation(extent={{-100,0},{-80,20}})));
  Modelica.Blocks.Routing.RealPassThrough realPassThroughTDry[nZones]
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={114,62})));
equation

  for i in 1:nZones loop
    connect(weaBus.TDryBul, realPassThroughTDry[i].u) annotation (Line(
        points={{-47,98},{-47,96},{134,96},{134,62},{126,62}},
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
    connect(intKPICalTraGain.KPI, outBusDem.QTraGain) annotation (
      Line(
      points={{-17.8,-102},{8,-102},{8,-2},{98,-2}},
      color={135,135,135},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
    connect(intKPICalTraLoss.KPI, outBusDem.QTraLoss) annotation (
      Line(
      points={{-17.8,-130},{8,-130},{8,-156},{116,-156},{116,-2},{98,-2}},
      color={135,135,135},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));

    connect(limUp.y, intKPICalTraGain.u)
    annotation (Line(points={{-59,-100},{-59,-102},{-41.8,-102}},
                                                      color={0,0,127}));
    connect(limDown.y, intKPICalTraLoss.u) annotation (Line(points={{-59,-130},
            {-41.8,-130}},                     color={0,0,127}));
  end if;
  connect(intKPICal.KPI, outBusDem.QIntGain) annotation (Line(
      points={{17.8,-110},{8,-110},{8,-2},{98,-2}},
      color={135,135,135},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(limAirExcUp.y, intKPICalTraGain2.u)
    annotation (Line(points={{-49,-156},{-41.8,-156}},  color={0,0,127}));
  connect(limAixExDown.y, intKPICalTraLoss2.u) annotation (Line(points={{-49,
          -186},{-41.8,-186}},                          color={0,0,127}));
  connect(QAirExc.y, limAirExcUp.u) annotation (Line(points={{-79,-166},{-79,
          -162},{-72,-162},{-72,-156}},
                                 color={0,0,127}));
  connect(QAirExc.y, limAixExDown.u) annotation (Line(points={{-79,-166},{-74,
          -166},{-74,-186},{-72,-186}},
                       color={0,0,127}));
  connect(intKPICalTraGain2.KPI, outBusDem.QAirExcGain) annotation (
     Line(
      points={{-17.8,-156},{116,-156},{116,-18},{84,-18},{84,-2},{98,-2}},
      color={135,135,135},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(intKPICalTraLoss2.KPI, outBusDem.QAirExcLoss) annotation (
     Line(
      points={{-17.8,-186},{8,-186},{8,-2},{98,-2}},
      color={135,135,135},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  if use_ventilation then
   connect(limVentUp.y, intKPICalVentGain.u) annotation (Line(points={{53.1,
            -185},{53.1,-182},{41.8,-182}},  color={0,0,127}));
   connect(limVentDown.y, intKPICalVentLoss.u) annotation (Line(points={{53.1,
            -205},{53.1,-206},{41.8,-206}},           color={0,0,127}));
   connect(QVent.y, limVentUp.u) annotation (Line(points={{79,-196},{73.8,-196},
            {73.8,-185}},color={0,0,127}));
   connect(QVent.y, limVentDown.u) annotation (Line(points={{79,-196},{79,-202},
            {73.8,-202},{73.8,-205}},
                    color={0,0,127}));
   connect(intKPICalVentGain.KPI, outBusDem.QVentGain) annotation (
    Line(
    points={{17.8,-182},{8,-182},{8,-2},{98,-2}},
    color={135,135,135},
    thickness=0.5), Text(
    string="%second",
    index=1,
    extent={{6,3},{6,3}},
    horizontalAlignment=TextAlignment.Left));
   connect(intKPICalVentLoss.KPI, outBusDem.QVentLoss) annotation (
    Line(
    points={{17.8,-206},{14,-206},{14,-192},{116,-192},{116,-74},{84,-74},{84,
            -2},{98,-2}},
    color={135,135,135},
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
  connect(addTra.y, limUp.u) annotation (Line(points={{-39,-70},{-36,-70},{-36,
          -84},{-88,-84},{-88,-100},{-82,-100}},
                      color={0,0,127}));
  connect(addTra.y, limDown.u) annotation (Line(points={{-39,-70},{-26,-70},{
          -26,-80},{-96,-80},{-96,-130},{-82,-130}},
                           color={0,0,127}));
  connect(heatFlowSensorRad.Q_flow, addTra.u2)
    annotation (Line(points={{-72,-71},{-72,-76},{-62,-76}}, color={0,0,127}));
  connect(heatFlowSensorConv.Q_flow, addTra.u1) annotation (Line(points={{-76,49},
          {-76,-46},{-114,-46},{-114,-64},{-62,-64}},            color={0,0,127}));
  connect(thermalZone.TAir, outBusDem.TZone) annotation (Line(points={{-42.7,
          76.8},{-48,76.8},{-48,-2},{98,-2}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(thermalZone.TAir, comfortCalculatorHea.TZone) annotation (Line(points={{-42.7,
          76.8},{-48,76.8},{-48,-10},{-22,-10}},        color={0,0,127}));
  connect(thermalZone.TAir, comfortCalculatorCool.TZone) annotation (Line(
        points={{-42.7,76.8},{-48,76.8},{-48,-10},{-28,-10},{-28,-50},{-22,-50}},
                                                              color={0,0,127}));
  connect(comfortCalculatorCool.dTComSec, outBusDem.dTComCoo) annotation (Line(
        points={{1,-50},{6,-50},{6,-2},{98,-2}},    color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(comfortCalculatorHea.dTComSec, outBusDem.dTComHea) annotation (Line(
        points={{1,-10},{0,-10},{0,-2},{98,-2}},    color={0,0,127}), Text(
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
  connect(multiSum.y, intKPICal.u)
    annotation (Line(points={{58.47,-129},{54,-129},{54,-110},{41.8,-110}},
                                                       color={0,0,127}));
  connect(multiSum.u, thermalZone.QIntGains_flow) annotation (Line(points={{78,-129},
          {86,-129},{86,-110},{56,-110},{56,4},{-28,4},{-28,10},{-32,10},{-32,8},
          {-42.7,8},{-42.7,33.6}},
        color={0,0,127}));
  connect(zeroLoad.internalElectricalPin, internalElectricalPin) annotation (
      Line(
      points={{84,-96},{70,-96}},
      color={0,0,0},
      thickness=1));
  connect(realPassThroughIntGains.y, thermalZone.intGains) annotation (Line(
        points={{-79,10},{-50,10},{-50,4},{-31.6,4},{-31.6,17.76}}, color={0,0,
          127}));
  connect(realPassThroughTDry.y, thermalZone.ventTemp) annotation (Line(points=
          {{103,62},{102,62},{102,74},{52,74},{52,42.24},{33.52,42.24}}, color=
          {0,0,127}));
    annotation (Diagram(coordinateSystem(extent={{-100,-220},{100,100}})),
      Documentation(info="<html>
<p>This model uses the reduced-order approach with the common TEASER output to model the building envelope. Relevant KPIs are calculated.</p>
<p>You can model multiple thermal zones. We refer to the documentation of TEASER and the ThermalZone model for more information on usage.</p>
<p>Assumptions</p>
</html>"));
end TEASERThermalZone;
