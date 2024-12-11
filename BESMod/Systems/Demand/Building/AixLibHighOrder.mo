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
  parameter Real GroundReflectance = 0.2 "ground reflectance coefficient";

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


  Modelica.Blocks.Sources.Constant constVentRate[nZones](final k=ventRate)
    if useConstVentRate               annotation (Placement(transformation(
          extent={{10,-10},{-10,10}}, rotation=180,
        origin={-90,10})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow InternalGains[nZones]
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-50,-50})));
  Utilities.Electrical.ZeroLoad zeroLoad
    annotation (Placement(transformation(extent={{24,-108},{44,-88}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature
    outdoorTemperature annotation (Placement(transformation(
        extent={{-7,-7},{7,7}},
        rotation=270,
        origin={-45,51})));
  Components.RadOnTitledSurfaceIBPSA radOnTitledSurfaceAdaptor[SOD.nSurfaces](
    final til=SOD.Tilt .* Modelica.Constants.pi ./ 180,
    each final rho=GroundReflectance,
    final azi=SOD.Azimut .* Modelica.Constants.pi ./ 180)
    "Adapt weather bus to HOM "
    annotation (Placement(transformation(extent={{0,40},{20,60}})));
equation
  connect(convRadToCombPort.portConv, heatPortCon) annotation (Line(points={{-60,-7},
          {-72,-7},{-72,-6},{-104,-6},{-104,46},{-86,46},{-86,60},{-100,60}},
                                                color={191,0,0}));
  connect(convRadToCombPort.portRad, heatPortRad) annotation (Line(points={{-60,-17},
          {-86,-17},{-86,-60},{-100,-60}},      color={0,0,0}));
  connect(HOMBuiEnv.heatingToRooms1, convRadToCombPort.portConvRadComb)
    annotation (Line(points={{-21.4,-1},{-32,-1},{-32,-12},{-40,-12}}, color={191,
          0,0}));
  connect(HOMBuiEnv.groundTemp, preTSoi.port)
    annotation (Line(points={{8,-36},{8,-90},{0,-90}}, color={191,0,0}));
  connect(HOMBuiEnv.portVent_in, portVent_in) annotation (Line(points={{38,-23.4},
          {74,-23.4},{74,38},{100,38}}, color={0,127,255}));
  connect(HOMBuiEnv.portVent_out, portVent_out) annotation (Line(points={{38,-31.8},
          {74,-31.8},{74,-40},{100,-40}}, color={0,127,255}));

        // Connecting n RadOnTiltedSurf
  for i in 1:SOD.nSurfaces loop
    connect(weaBus, radOnTitledSurfaceAdaptor[i].weaBus) annotation (Line(
      points={{-47,98},{-47,76},{-26,76},{-26,50},{-0.2,50}},
      color={255,204,51},
      thickness=0.5));
  end for;

connect(weaBus.winSpe, HOMBuiEnv.WindSpeedPort) annotation (Line(
      points={{-46.895,98.11},{-50,98.11},{-50,76},{-64,76},{-64,22},{-36,22},{
          -36,20.7},{-23.8,20.7}},
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

  connect(weaBus.TDryBul, outdoorTemperature.T) annotation (Line(
      points={{-46.895,98.11},{-45,98.11},{-45,59.4}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(outdoorTemperature.port, HOMBuiEnv.thermOutside)
    annotation (Line(points={{-45,44},{-45,34},{-21.4,34}}, color={191,0,0}));

  connect(radOnTitledSurfaceAdaptor[1].radOnTiltedSurf, HOMBuiEnv.North) annotation (Line(points={{21,49.9},
          {52,49.9},{52,13},{40.4,13}},
                                      color={255,128,0}));
  connect(radOnTitledSurfaceAdaptor[2].radOnTiltedSurf, HOMBuiEnv.East) annotation (Line(points={{21,49.9},
          {52,49.9},{52,3.9},{40.4,3.9}},
                                       color={255,128,0}));
  connect(radOnTitledSurfaceAdaptor[3].radOnTiltedSurf, HOMBuiEnv.South) annotation (Line(points={{21,49.9},
          {52,49.9},{52,-5.2},{40.4,-5.2}},
                                          color={255,128,0}));
  connect(radOnTitledSurfaceAdaptor[4].radOnTiltedSurf, HOMBuiEnv.West) annotation (Line(points={{21,49.9},
          {52,49.9},{52,-14.3},{40.4,-14.3}},
                                           color={255,128,0}));
  connect(radOnTitledSurfaceAdaptor[5].radOnTiltedSurf, HOMBuiEnv.SolarRadiationPort_RoofN) annotation (
      Line(points={{21,49.9},{52,49.9},{52,30.5},{40.4,30.5}},
                                                           color={255,128,0}));
  connect(radOnTitledSurfaceAdaptor[6].radOnTiltedSurf, HOMBuiEnv.SolarRadiationPort_RoofS) annotation (
      Line(points={{21,49.9},{52,49.9},{52,21.4},{40.4,21.4}},
                                                           color={255,128,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end AixLibHighOrder;
