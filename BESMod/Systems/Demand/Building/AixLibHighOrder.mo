within BESMod.Systems.Demand.Building;
model AixLibHighOrder "High order building model from AixLib library"

  extends BaseClasses.PartialDemand(
  nZones = aixLiBHighOrderOFD.nZones,
  final AZone=aixLiBHighOrderOFD.AZone,
  final hZone=aixLiBHighOrderOFD.hZone,
  final ABui=aixLiBHighOrderOFD.ABui,
  final hBui=aixLiBHighOrderOFD.hBui,
  final ARoo=aixLiBHighOrderOFD.ARoof);



  final parameter AixLib.DataBase.Weather.SurfaceOrientation.SurfaceOrientationBaseDataDefinition  SOD=
  AixLib.DataBase.Weather.SurfaceOrientation.SurfaceOrientationData_N_E_S_W_RoofN_Roof_S()
    "Surface orientation data"  annotation(Dialog(group = "Solar radiation on oriented surfaces", descriptionLabel = true), choicesAllMatching = true);

  parameter Boolean useConstNatVentRate = false;
  parameter Real ventRate[nZones]=fill(0, nZones) "Constant mechanical ventilation rate";
  parameter Modelica.Units.SI.Temperature TSoil=281.65     "Temperature of soil";
  parameter Modelica.Units.NonSI.Angle_deg Latitude "latitude of location";
  parameter Modelica.Units.NonSI.Angle_deg Longitude "longitude of location in";
  parameter Real TimeCorrection=0 "for TRY = 0.5, for TMY = 0";
  parameter Modelica.Units.NonSI.Time_hour DiffWeatherDataTime=1 "difference between local time and UTC, e.g. +1 for MET";
  parameter Real GroundReflection "ground reflection coefficient";

  // Dynamics
  parameter Modelica.Fluid.Types.Dynamics energyDynamicsWalls=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Type of energy balance for wall capacities: dynamic (3 initialization options) or steady state" annotation (Dialog(tab="Dynamics"));
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state" annotation (Dialog(tab="Dynamics"));

  // Initialization
  parameter Modelica.Units.SI.Temperature T0_air=273.15 + 22
                                                           "Initial temperature of air" annotation (Dialog(tab="Initialization"));
  parameter Modelica.Units.SI.Temperature TWalls_start=273.15 + 16
                                                                  "Initial temperature of all walls" annotation (Dialog(tab="Initialization"));

  //Outer walls
  replaceable parameter AixLib.DataBase.Walls.Collections.OFD.EnEV2009Light
    wallTypes constrainedby
    AixLib.DataBase.Walls.Collections.BaseDataMultiWalls
    "Types of walls (contains multiple records)"
     annotation (Dialog(tab="Outer walls", group="Wall"), choicesAllMatching = true);
  replaceable model WindowModel =
      AixLib.ThermalZones.HighOrder.Components.WindowsDoors.BaseClasses.PartialWindow
    constrainedby AixLib.ThermalZones.HighOrder.Components.WindowsDoors.BaseClasses.PartialWindow   annotation (Dialog(tab="Outer walls", group="Windows"), choicesAllMatching = true);
  replaceable parameter AixLib.DataBase.WindowsDoors.Simple.OWBaseDataDefinition_Simple Type_Win "Window parametrization" annotation (Dialog(tab="Outer walls", group="Windows"), choicesAllMatching = true);
  replaceable model CorrSolarGainWin =
      AixLib.ThermalZones.HighOrder.Components.WindowsDoors.BaseClasses.CorrectionSolarGain.PartialCorG
    constrainedby AixLib.ThermalZones.HighOrder.Components.WindowsDoors.BaseClasses.CorrectionSolarGain.PartialCorG   "Correction model for solar irradiance as transmitted radiation" annotation (choicesAllMatching=true, Dialog(tab="Outer walls", group="Windows", enable = withWindow and outside));
  parameter Boolean use_sunblind=false
    "Will sunblind become active automatically?" annotation (Dialog(tab="Outer walls", group="Sunblind"));
  parameter Modelica.Units.SI.CoefficientOfHeatTransfer UValOutDoors=2.5
    "U-value (thermal transmittance) of doors in outer walls"  annotation (Dialog(tab="Outer walls", group="Doors"));

  //Infiltration
  parameter Boolean use_infiltEN12831=true
    "Use model to exchange room air with outdoor air acc. to standard" annotation (Dialog(tab="Infiltration acc. to EN 12831", group="X"));
  parameter Real n50=4 "Air exchange rate at 50 Pa pressure difference" annotation (Dialog(tab="Infiltration acc. to EN 12831", group="X"));
  parameter Real e=0.03 "Coefficient of windshield" annotation (Dialog(tab="Infiltration acc. to EN 12831", group="X"));


  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature tempOutside
    annotation (Placement(transformation(extent={{4,4},{-4,-4}},
        rotation=90,
        origin={-18,48})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature prescrTGround(T=TSoil)
    annotation (Placement(transformation(extent={{-13.5,-90},{-1,-77}})));
  AixLib.Utilities.Interfaces.Adaptors.ConvRadToCombPort convRadToCombPort[nZones]
    annotation (Placement(transformation(extent={{-46,-14},{-66,-30}})));
  replaceable Components.AixLibHighOrderOFD aixLiBHighOrderOFD(
    use_ventilation=use_ventilation,
    redeclare package MediumZone = MediumZone,
    energyDynamicsWalls=energyDynamicsWalls,
    energyDynamics=energyDynamics,
    T0_air=T0_air,
    TWalls_start=TWalls_start,
    redeclare model WindowModel = WindowModel,
    redeclare model CorrSolarGainWin = CorrSolarGainWin,
    use_sunblind=use_sunblind,
    UValOutDoors=UValOutDoors,
    use_infiltEN12831=use_infiltEN12831,
    n50=n50,
    e=e,
    Type_Win= Type_Win,
    wallTypes=wallTypes)
    annotation (Placement(transformation(extent={{-22,-36},{38,34}})));
  AixLib.BoundaryConditions.WeatherData.Old.WeatherTRY.BaseClasses.Sun
                  Sun(
    TimeCorrection=TimeCorrection,
    Longitude=Longitude,
    Latitude=Latitude,
    DiffWeatherDataTime=DiffWeatherDataTime) annotation (Placement(
        transformation(extent={{-6,50},{8,64}})));
  AixLib.BoundaryConditions.WeatherData.Old.WeatherTRY.RadiationOnTiltedSurface.RadOnTiltedSurf_Liu
                     RadOnTiltedSurf[SOD.nSurfaces](
    each Latitude=Latitude,
    each GroundReflection=GroundReflection,
    Azimut=SOD.Azimut,
    Tilt=SOD.Tilt,
    each WeatherFormat=1)                                                                                                                                                           annotation(Placement(transformation(extent={{18,48},
            {40,68}})));

  Modelica.Blocks.Math.Add add(k1=+1, k2=-1)
    annotation (Placement(transformation(extent={{4,68},{14,78}})));
  Modelica.Blocks.Sources.Constant constVentRate[nZones](final k=ventRate)
    if useConstNatVentRate                                    "Transform Volume l to massflowrate"
                                         annotation (Placement(transformation(
          extent={{5,-5},{-5,5}},     rotation=180,
        origin={-59,-1})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow InternalGains[nZones]
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-52,-60})));


equation
  connect(weaBus.TDryBul, tempOutside.T) annotation (Line(
      points={{-47,98},{-47,58},{-18,58},{-18,52.8}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  connect(convRadToCombPort.portConv, heatPortCon) annotation (Line(points={{-66,-17},
          {-80,-17},{-80,60},{-100,60}},        color={191,0,0}));
  connect(convRadToCombPort.portRad, heatPortRad) annotation (Line(points={{-66,-27},
          {-80,-27},{-80,-60},{-100,-60}},      color={0,0,0}));
  connect(aixLiBHighOrderOFD.heatingToRooms1, convRadToCombPort.portConvRadComb)
    annotation (Line(points={{-21.4,-1},{-36,-1},{-36,-22},{-46,-22}}, color={191,
          0,0}));
  connect(aixLiBHighOrderOFD.thermOutside, tempOutside.port) annotation (Line(
        points={{-21.4,30.5},{-18,30.5},{-18,44}},          color={191,0,0}));
  connect(aixLiBHighOrderOFD.groundTemp, prescrTGround.port) annotation (Line(
        points={{8,-36},{8,-83.5},{-1,-83.5}},             color={191,0,0}));
  connect(aixLiBHighOrderOFD.portVent_in, portVent_in) annotation (Line(points={{38,
          -23.4},{74,-23.4},{74,38},{100,38}},     color={0,127,255}));
  connect(aixLiBHighOrderOFD.portVent_out, portVent_out) annotation (Line(
        points={{38,-31.8},{74,-31.8},{74,-40},{100,-40}},
        color={0,127,255}));

        // Connecting n RadOnTiltedSurf
  for i in 1:SOD.nSurfaces loop
    connect(Sun.OutDayAngleSun, RadOnTiltedSurf[i].InDayAngleSun)       annotation (
      Line(points={{7.3,57.42},{14,57.42},{14,55.9},{20.31,55.9}},color={0,0,127}));
    connect(Sun.OutHourAngleSun, RadOnTiltedSurf[i].InHourAngleSun) annotation (
      Line(points={{7.3,55.18},{14,55.18},{14,53.9},{20.31,53.9}},color={0,0,127}));
    connect(Sun.OutDeclinationSun, RadOnTiltedSurf[i].InDeclinationSun) annotation (Line(points={{7.3,
            53.08},{14,53.08},{14,51.9},{20.31,51.9}},
        color={0,0,127}));
    connect(add.y, RadOnTiltedSurf[i].solarInput1) annotation (Line(points={{14.5,
          73},{22.29,73},{22.29,65.3}}, color={0,0,127}));
    connect(weaBus.HDifHor, RadOnTiltedSurf[i].solarInput2) annotation (Line(
      points={{-47,98},{-30,98},{-30,84},{33.07,84},{33.07,65.3}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  end for;

  connect(aixLiBHighOrderOFD.SolarRadiationPort_RoofN, RadOnTiltedSurf[5].OutTotalRadTilted)
    annotation (Line(points={{40.4,30.5},{52,30.5},{52,62},{38.9,62}}, color={255,
          128,0}));
  connect(aixLiBHighOrderOFD.SolarRadiationPort_RoofS, RadOnTiltedSurf[6].OutTotalRadTilted)
    annotation (Line(points={{40.4,21.4},{52,21.4},{52,62},{38.9,62}}, color={255,
          128,0}));
  connect(aixLiBHighOrderOFD.North, RadOnTiltedSurf[1].OutTotalRadTilted)
    annotation (Line(points={{40.4,13},{52,13},{52,62},{38.9,62}}, color={255,128,
          0}));
  connect(aixLiBHighOrderOFD.East, RadOnTiltedSurf[2].OutTotalRadTilted)
    annotation (Line(points={{40.4,3.9},{52,3.9},{52,62},{38.9,62}}, color={255,
          128,0}));
  connect(aixLiBHighOrderOFD.South, RadOnTiltedSurf[3].OutTotalRadTilted)
    annotation (Line(points={{40.4,-5.2},{52,-5.2},{52,62},{38.9,62}}, color={255,
          128,0}));
  connect(aixLiBHighOrderOFD.West, RadOnTiltedSurf[4].OutTotalRadTilted)
    annotation (Line(points={{40.4,-14.3},{52,-14.3},{52,62},{38.9,62}}, color={
          255,128,0}));
  connect(weaBus.HGloHor, add.u1) annotation (Line(
      points={{-47,98},{-47,76},{3,76}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(weaBus.HDifHor, add.u2) annotation (Line(
      points={{-47,98},{-47,70},{3,70}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(weaBus.winSpe, aixLiBHighOrderOFD.WindSpeedPort) annotation (Line(
      points={{-47,98},{-47,20.7},{-23.8,20.7}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(aixLiBHighOrderOFD.AirExchangePort, useProBus.NaturalVentilation)
    annotation (Line(points={{-23.8,10.9},{-64,10.9},{-64,88},{51,88},{51,101}},
        color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  if useConstNatVentRate == false then
      connect(constVentRate.y, aixLiBHighOrderOFD.AirExchangePort)  annotation (Line(
        points={{-53.5,-1},{-44,-1},{-44,10.9},{-23.8,10.9}},
                                                            color={0,0,127}));
  end if;
  connect(InternalGains.port, convRadToCombPort.portConv) annotation (Line(
        points={{-62,-60},{-72,-60},{-72,-17},{-66,-17}},
                                                        color={191,0,0}));
  connect(InternalGains.Q_flow, useProBus.intGains) annotation (Line(points={{-42,-60},
          {-30,-60},{-30,-60},{66,-60},{66,78},{51,78},{51,101}},      color={0,
          0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end AixLibHighOrder;
