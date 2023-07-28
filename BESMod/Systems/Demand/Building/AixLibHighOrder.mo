within BESMod.Systems.Demand.Building;
model AixLibHighOrder "High order building model from AixLib library"

  extends BaseClasses.PartialDemand(
    nZones=HOMBuiEnv.nZones,
    final AZone=HOMBuiEnv.AZone[1:nZones],
    final hZone=HOMBuiEnv.hZone[1:nZones],
    final ABui=HOMBuiEnv.ABui,
    final hBui=HOMBuiEnv.hBui,
    final ARoo=HOMBuiEnv.ARoof);
  extends Components.BaseClasses.HighOrderModelParameters;

  final parameter AixLib.DataBase.Weather.SurfaceOrientation.SurfaceOrientationBaseDataDefinition  SOD=
  AixLib.DataBase.Weather.SurfaceOrientation.SurfaceOrientationData_N_E_S_W_RoofN_Roof_S()
    "Surface orientation data"  annotation (
      Dialog(group = "Solar radiation on oriented surfaces", descriptionLabel = true),
      choicesAllMatching = true);

  parameter Boolean useConstVentRate;
  parameter Real ventRate[nZones]=fill(0, nZones) if useConstVentRate "Constant mechanical ventilation rate" annotation (Dialog(enable=useConstVentRate));
  parameter Modelica.Units.SI.Temperature TSoil=281.65     "Temperature of soil";
  parameter Real TimeCorrection=0 "for TRY = 0.5, for TMY = 0";
  parameter Modelica.Units.NonSI.Time_hour DiffWeatherDataTime=1 "difference between local time and UTC, e.g. +1 for MET";
  parameter Real GroundReflection = 0.2 "ground reflection coefficient";

  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature tempOutside
    annotation (Placement(transformation(extent={{10,10},{-10,-10}},
        rotation=90,
        origin={-50,50})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature preTSoi(T=TSoil)
    "Prescribed soil temperature"
    annotation (Placement(transformation(extent={{-20,-100},{0,-80}})));
  AixLib.Utilities.Interfaces.Adaptors.ConvRadToCombPort convRadToCombPort[nZones]
    annotation (Placement(transformation(extent={{-40,-4},{-60,-20}})));
  replaceable Components.AixLibHighOrderOFD HOMBuiEnv(
    use_ventilation=use_ventilation,
    redeclare package MediumZone = MediumZone,
    energyDynamicsWalls=energyDynamicsWalls,
    energyDynamics=energyDynamics,
    T0_air=T0_air,
    TWalls_start=TWalls_start,
    redeclare model WindowModel = WindowModel (windowarea=2),
    redeclare model CorrSolarGainWin = CorrSolarGainWin,
    use_sunblind=use_sunblind,
    UValOutDoors=UValOutDoors,
    use_infiltEN12831=use_infiltEN12831,
    n50=n50,
    e=e,
    Type_Win=Type_Win,
    wallTypes=wallTypes) "High order building envelope" annotation (
      choicesAllMatching=true, Placement(transformation(extent={{-22,-36},{38,34}})));


  Components.SunWithWeaBus
                  Sun(
    TimeCorrection=TimeCorrection,
    DiffWeatherDataTime=DiffWeatherDataTime) annotation (Placement(
        transformation(extent={{-22,42},{2,64}})));
  Components.RadOnTiltedSurf_LiuWeaBus
                     RadOnTiltedSurf[SOD.nSurfaces](
    each GroundReflection=GroundReflection,
    Azimut=SOD.Azimut,
    Tilt=SOD.Tilt,
    each WeatherFormat=1) annotation(Placement(transformation(extent={{18,42},{42,
            64}})));

  Modelica.Blocks.Sources.Constant constVentRate[nZones](final k=ventRate) if
       useConstVentRate               annotation (Placement(transformation(
          extent={{10,-10},{-10,10}}, rotation=180,
        origin={-90,10})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow InternalGains[nZones]
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-50,-50})));
  Utilities.Electrical.ZeroLoad zeroLoad
    annotation (Placement(transformation(extent={{24,-108},{44,-88}})));
equation
  connect(weaBus.TDryBul, tempOutside.T) annotation (Line(
      points={{-47,98},{-47,96},{-50,96},{-50,62}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  connect(convRadToCombPort.portConv, heatPortCon) annotation (Line(points={{-60,-7},
          {-72,-7},{-72,-6},{-104,-6},{-104,46},{-86,46},{-86,60},{-100,60}},
                                                color={191,0,0}));
  connect(convRadToCombPort.portRad, heatPortRad) annotation (Line(points={{-60,-17},
          {-86,-17},{-86,-60},{-100,-60}},      color={0,0,0}));
  connect(HOMBuiEnv.heatingToRooms1, convRadToCombPort.portConvRadComb)
    annotation (Line(points={{-21.4,-1},{-32,-1},{-32,-12},{-40,-12}}, color={191,
          0,0}));
  connect(HOMBuiEnv.thermOutside, tempOutside.port) annotation (Line(points={{-22,
          33.3},{-20,33.3},{-20,30},{-50,30},{-50,40}}, color={191,0,0}));
  connect(HOMBuiEnv.groundTemp, preTSoi.port)
    annotation (Line(points={{8,-36},{8,-90},{0,-90}}, color={191,0,0}));
  connect(HOMBuiEnv.portVent_in, portVent_in) annotation (Line(points={{38,-23.4},
          {74,-23.4},{74,38},{100,38}}, color={0,127,255}));
  connect(HOMBuiEnv.portVent_out, portVent_out) annotation (Line(points={{38,-31.8},
          {74,-31.8},{74,-40},{100,-40}}, color={0,127,255}));

        // Connecting n RadOnTiltedSurf
  for i in 1:SOD.nSurfaces loop
    connect(Sun.OutDayAngleSun, RadOnTiltedSurf[i].InDayAngleSun)       annotation (
      Line(points={{0.8,53.66},{0.8,50.69},{20.52,50.69}},        color={0,0,127}));
    connect(Sun.OutHourAngleSun, RadOnTiltedSurf[i].InHourAngleSun) annotation (
      Line(points={{0.8,50.14},{10.66,50.14},{10.66,48.49},{20.52,48.49}},
                                                                  color={0,0,127}));
    connect(Sun.OutDeclinationSun, RadOnTiltedSurf[i].InDeclinationSun) annotation (Line(points={{0.8,
            46.84},{2,46.84},{2,46.29},{20.52,46.29}},
        color={0,0,127}));
    connect(RadOnTiltedSurf[i].weaBus, weaBus) annotation (Line(
      points={{23.04,64.22},{23.04,76},{-47,76},{-47,98}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  end for;

  connect(HOMBuiEnv.SolarRadiationPort_RoofN, RadOnTiltedSurf[5].OutTotalRadTilted)
    annotation (Line(points={{40.4,30.5},{52,30.5},{52,57.4},{40.8,57.4}},
                                                                       color={255,
          128,0}));
  connect(HOMBuiEnv.SolarRadiationPort_RoofS, RadOnTiltedSurf[6].OutTotalRadTilted)
    annotation (Line(points={{40.4,21.4},{52,21.4},{52,57.4},{40.8,57.4}},
                                                                       color={255,
          128,0}));
  connect(HOMBuiEnv.North, RadOnTiltedSurf[1].OutTotalRadTilted) annotation (
      Line(points={{40.4,13},{52,13},{52,57.4},{40.8,57.4}},
                                                         color={255,128,0}));
  connect(HOMBuiEnv.East, RadOnTiltedSurf[2].OutTotalRadTilted) annotation (
      Line(points={{40.4,3.9},{52,3.9},{52,57.4},{40.8,57.4}},
                                                           color={255,128,0}));
  connect(HOMBuiEnv.South, RadOnTiltedSurf[3].OutTotalRadTilted) annotation (
      Line(points={{40.4,-5.2},{52,-5.2},{52,57.4},{40.8,57.4}},
                                                             color={255,128,0}));
  connect(HOMBuiEnv.West, RadOnTiltedSurf[4].OutTotalRadTilted) annotation (
      Line(points={{40.4,-14.3},{52,-14.3},{52,57.4},{40.8,57.4}},
                                                               color={255,128,0}));
  connect(weaBus.winSpe, HOMBuiEnv.WindSpeedPort) annotation (Line(
      points={{-47,98},{-50,98},{-50,76},{-64,76},{-64,22},{-36,22},{-36,20.7},{
          -23.8,20.7}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));

  connect(InternalGains.port, convRadToCombPort.portConv) annotation (Line(
        points={{-60,-50},{-68,-50},{-68,-7},{-60,-7}}, color={191,0,0}));
  connect(InternalGains.Q_flow, useProBus.intGains) annotation (Line(points={{-40,-50},
          {60,-50},{60,70},{51,70},{51,101}},      color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(constVentRate.y, HOMBuiEnv.AirExchangePort) annotation (Line(points={{
          -79,10},{-23.8,10},{-23.8,10.9}}, color={0,0,127}));
  connect(HOMBuiEnv.TZoneMea, buiMeaBus.TZoneMea) annotation (Line(points={{-23.2,
          -18.5},{-46,-18.5},{-46,-30},{-78,-30},{-78,96},{0,96},{0,99}}, color=
         {0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(zeroLoad.internalElectricalPin, internalElectricalPin) annotation (
      Line(
      points={{44,-98},{56,-98},{56,-82},{70,-82},{70,-96}},
      color={0,0,0},
      thickness=1));
  if not useConstVentRate then
    connect(HOMBuiEnv.AirExchangePort, useProBus.natVent) annotation (Line(points=
         {{-23.8,10.9},{-72,10.9},{-72,101},{51,101}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  end if;
  connect(Sun.weaBus, weaBus) annotation (Line(
      points={{-16.96,64.22},{-16.96,76},{-47,76},{-47,98}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end AixLibHighOrder;
