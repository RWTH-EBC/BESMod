within BESMod.Systems.Demand.Building.Components;
model AixLibHighOrderOFD "High order OFD"
  extends Building.BaseClasses.PartialAixLibHighOrder(
  final nZones=nZonesHeated);

  parameter Integer nZonesHeated = 10 "Heated rooms of the building";
  parameter Integer nZonesNonHeated = 1 "Non heated rooms of the building";

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
      (windowarea=2)
    constrainedby
    AixLib.ThermalZones.HighOrder.Components.WindowsDoors.BaseClasses.PartialWindow  annotation (Dialog(tab="Outer walls", group="Windows"), choicesAllMatching = true);
  replaceable parameter AixLib.DataBase.WindowsDoors.Simple.OWBaseDataDefinition_Simple Type_Win "Window parametrization" annotation (Dialog(tab="Outer walls", group="Windows"), choicesAllMatching = true);
  replaceable model CorrSolarGainWin =
      AixLib.ThermalZones.HighOrder.Components.WindowsDoors.BaseClasses.CorrectionSolarGain.PartialCorG
    constrainedby
    AixLib.ThermalZones.HighOrder.Components.WindowsDoors.BaseClasses.CorrectionSolarGain.PartialCorG                 "Correction model for solar irradiance as transmitted radiation" annotation (choicesAllMatching=true, Dialog(tab="Outer walls", group="Windows", enable = withWindow and outside));
  parameter Boolean use_sunblind=false
    "Will sunblind become active automatically?" annotation (Dialog(tab="Outer walls", group="Sunblind"));
  parameter Modelica.Units.SI.CoefficientOfHeatTransfer UValOutDoors=2.5
    "U-value (thermal transmittance) of doors in outer walls"  annotation (Dialog(tab="Outer walls", group="Doors"));

  //Infiltration
  parameter Boolean use_infiltEN12831=true
    "Use model to exchange room air with outdoor air acc. to standard" annotation (Dialog(tab="Infiltration acc. to EN 12831", group="X"));
  parameter Real n50=4 "Air exchange rate at 50 Pa pressure difference" annotation (Dialog(tab="Infiltration acc. to EN 12831", group="X"));
  parameter Real e=0.03 "Coefficient of windshield" annotation (Dialog(tab="Infiltration acc. to EN 12831", group="X"));

  // Rooms:
  //Groundfloor -  1:LivingRoom_GF, 2:Hobby_GF, 3: Corridor_GF, 4: WC_Storage_GF, 5: Kitchen_GF,
  //Upperfloor -  6: Bedroom_UF, 7: Child1_UF, 8: Corridor_UF, 9: Bath_UF, 10: Child2_UF, 11: Attic
  final parameter Modelica.Units.SI.Area ABui = sum(AZone) "Total area of all zones";
  final parameter Modelica.Units.SI.Length hBui = hZone[1] + hZone[6] + hZone[11] "Total hight of building";
  final parameter Modelica.Units.SI.Area ARoof = sum(ARoofZone) "Total area of roof";
  final parameter Modelica.Units.SI.Area AZone[nZonesHeated+nZonesNonHeated]=
  {wholeHouseBuildingEnvelope.groundFloor_Building.Livingroom.room_length *
   wholeHouseBuildingEnvelope.groundFloor_Building.Livingroom.room_width,
   wholeHouseBuildingEnvelope.groundFloor_Building.Hobby.room_length *
   wholeHouseBuildingEnvelope.groundFloor_Building.Hobby.room_width,
   wholeHouseBuildingEnvelope.groundFloor_Building.Corridor.room_length *
   wholeHouseBuildingEnvelope.groundFloor_Building.Corridor.room_width,
   wholeHouseBuildingEnvelope.groundFloor_Building.WC_Storage.room_length *
   wholeHouseBuildingEnvelope.groundFloor_Building.WC_Storage.room_width,
   wholeHouseBuildingEnvelope.groundFloor_Building.Kitchen.room_length *
   wholeHouseBuildingEnvelope.groundFloor_Building.Kitchen.room_width,
   wholeHouseBuildingEnvelope.upperFloor_Building.Bedroom.room_length *
   wholeHouseBuildingEnvelope.upperFloor_Building.Bedroom.room_width_long,
   wholeHouseBuildingEnvelope.upperFloor_Building.Children1.room_length *
   wholeHouseBuildingEnvelope.upperFloor_Building.Children1.room_width_long,
   wholeHouseBuildingEnvelope.upperFloor_Building.Corridor.room_length *
   wholeHouseBuildingEnvelope.upperFloor_Building.Corridor.room_width_long,
   wholeHouseBuildingEnvelope.upperFloor_Building.Bath.room_length *
   wholeHouseBuildingEnvelope.upperFloor_Building.Bath.room_width_long,
   wholeHouseBuildingEnvelope.upperFloor_Building.Children2.room_length *
   wholeHouseBuildingEnvelope.upperFloor_Building.Children2.room_width_long,
   wholeHouseBuildingEnvelope.attic_2Ro_5Rooms.length*
   wholeHouseBuildingEnvelope.attic_2Ro_5Rooms.width};
  final parameter Modelica.Units.SI.Length hZone[nZonesHeated+nZonesNonHeated]=
  {wholeHouseBuildingEnvelope.groundFloor_Building.Livingroom.room_height,
   wholeHouseBuildingEnvelope.groundFloor_Building.Hobby.room_height,
   wholeHouseBuildingEnvelope.groundFloor_Building.Corridor.room_height,
   wholeHouseBuildingEnvelope.groundFloor_Building.WC_Storage.room_height,
   wholeHouseBuildingEnvelope.groundFloor_Building.Kitchen.room_height,
   wholeHouseBuildingEnvelope.upperFloor_Building.Bedroom.room_height_long,
   wholeHouseBuildingEnvelope.upperFloor_Building.Children1.room_height_long,
   wholeHouseBuildingEnvelope.upperFloor_Building.Corridor.room_height_long,
   wholeHouseBuildingEnvelope.upperFloor_Building.Bath.room_height_long,
   wholeHouseBuildingEnvelope.upperFloor_Building.Children2.room_height_long,
   wholeHouseBuildingEnvelope.attic_2Ro_5Rooms.room_V/AZone[11]};
  final parameter Modelica.Units.SI.Area ARoofZone[nZonesHeated+nZonesNonHeated]=
  {0,0,0,0,0,
  wholeHouseBuildingEnvelope.upperFloor_Building.Bedroom.roof_width*
  wholeHouseBuildingEnvelope.upperFloor_Building.Bedroom.room_length,
  wholeHouseBuildingEnvelope.upperFloor_Building.Children1.roof_width*
  wholeHouseBuildingEnvelope.upperFloor_Building.Children1.room_length,
  wholeHouseBuildingEnvelope.upperFloor_Building.Corridor.roof_width*
  wholeHouseBuildingEnvelope.upperFloor_Building.Corridor.room_length,
  wholeHouseBuildingEnvelope.upperFloor_Building.Bath.roof_width*
  wholeHouseBuildingEnvelope.upperFloor_Building.Bath.room_length,
  wholeHouseBuildingEnvelope.upperFloor_Building.Children2.roof_width*
  wholeHouseBuildingEnvelope.upperFloor_Building.Children2.room_length,
  wholeHouseBuildingEnvelope.attic_2Ro_5Rooms.roof_width1*
  wholeHouseBuildingEnvelope.attic_2Ro_5Rooms.length+
  wholeHouseBuildingEnvelope.attic_2Ro_5Rooms.roof_width2*
  wholeHouseBuildingEnvelope.attic_2Ro_5Rooms.length};

  AixLib.ThermalZones.HighOrder.House.OFD_MiddleInnerLoadWall.BuildingEnvelope.WholeHouseBuildingEnvelope
    wholeHouseBuildingEnvelope(
    wallTypes=wallTypes,
    energyDynamicsWalls=energyDynamicsWalls,
    T0_air=T0_air,
    TWalls_start=TWalls_start,
    redeclare model WindowModel = WindowModel (windowarea=2),
    Type_Win = Type_Win,
    redeclare model CorrSolarGainWin = CorrSolarGainWin,
    use_sunblind=use_sunblind,
    use_infiltEN12831=use_infiltEN12831,
    n50=n50,
    energyDynamics=energyDynamics,
    redeclare package Medium = MediumZone,
    UValOutDoors=UValOutDoors,
    useVentAirPort=true)
    annotation (Placement(transformation(extent={{-44,-40},{50,72}})));

  AixLib.Utilities.Interfaces.Adaptors.ConvRadToCombPort convRadToCombPort
    annotation (Placement(transformation(extent={{-46,-48},{-26,-64}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow InternalGains(Q_flow=0)
    annotation (Placement(transformation(
        extent={{7,-7},{-7,7}},
        rotation=0,
        origin={-9,-51})));
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow InternalGains1(Q_flow=0)
    annotation (Placement(transformation(
        extent={{7,-7},{-7,7}},
        rotation=0,
        origin={-9,-61})));
  AixLib.Fluid.Sources.Boundary_pT bou(redeclare package Medium = MediumZone, nPorts=2)
                                       annotation (Placement(transformation(extent={{28,-64},{40,-52}})));
equation
    // Romm Temperatures

  TZoneMea[1]=Modelica.Units.Conversions.to_degC(wholeHouseBuildingEnvelope.groundFloor_Building.Livingroom.airload.heatPort.T);
  TZoneMea[2]=Modelica.Units.Conversions.to_degC(wholeHouseBuildingEnvelope.groundFloor_Building.Hobby.airload.heatPort.T);
  TZoneMea[3]=Modelica.Units.Conversions.to_degC(wholeHouseBuildingEnvelope.groundFloor_Building.Corridor.airload.heatPort.T);
  TZoneMea[4]=Modelica.Units.Conversions.to_degC(wholeHouseBuildingEnvelope.groundFloor_Building.WC_Storage.airload.heatPort.T);
  TZoneMea[5]=Modelica.Units.Conversions.to_degC(wholeHouseBuildingEnvelope.groundFloor_Building.Kitchen.airload.heatPort.T);
  TZoneMea[6]=Modelica.Units.Conversions.to_degC(wholeHouseBuildingEnvelope.upperFloor_Building.Bedroom.airload.heatPort.T);
  TZoneMea[7]=Modelica.Units.Conversions.to_degC(wholeHouseBuildingEnvelope.upperFloor_Building.Children1.airload.heatPort.T);
  TZoneMea[8]=Modelica.Units.Conversions.to_degC(wholeHouseBuildingEnvelope.upperFloor_Building.Corridor.airload.heatPort.T);
  TZoneMea[9]=Modelica.Units.Conversions.to_degC(wholeHouseBuildingEnvelope.upperFloor_Building.Bath.airload.heatPort.T);
  TZoneMea[10]=Modelica.Units.Conversions.to_degC(wholeHouseBuildingEnvelope.upperFloor_Building.Children2.airload.heatPort.T);


  connect(wholeHouseBuildingEnvelope.groPlateUp, wholeHouseBuildingEnvelope.groFloDown)
    annotation (Line(points={{-44,-28.8},{-54,-28.8},{-54,-15.36},{-44,-15.36}},
        color={191,0,0}));
  connect(wholeHouseBuildingEnvelope.groFloUp, wholeHouseBuildingEnvelope.uppFloDown)
    annotation (Line(points={{-44,16},{-54,16},{-54,29.44},{-44,29.44}}, color={
          191,0,0}));
  connect(wholeHouseBuildingEnvelope.WindSpeedPort, WindSpeedPort) annotation (
      Line(points={{-48.7,55.2},{-72,55.2},{-72,62},{-106,62}}, color={0,0,127}));
  connect(wholeHouseBuildingEnvelope.thermOutside, thermOutside) annotation (
      Line(points={{-44,70.88},{-60,70.88},{-60,90},{-98,90}}, color={191,0,0}));

  connect(wholeHouseBuildingEnvelope.West, West) annotation (Line(points={{52.82,
          -5.28},{76,-5.28},{76,-38},{108,-38}}, color={255,128,0}));
  connect(wholeHouseBuildingEnvelope.South, South) annotation (Line(points={{52.82,
          8.16},{86,8.16},{86,-12},{108,-12}}, color={255,128,0}));
  connect(wholeHouseBuildingEnvelope.East, East) annotation (Line(points={{52.82,
          22.72},{80,22.72},{80,14},{108,14}}, color={255,128,0}));
  connect(wholeHouseBuildingEnvelope.North, North) annotation (Line(points={{52.82,
          37.28},{78,37.28},{78,40},{108,40}}, color={255,128,0}));
  connect(wholeHouseBuildingEnvelope.SolarRadiationPort_RoofS,
    SolarRadiationPort_RoofS) annotation (Line(points={{52.82,51.84},{76,51.84},
          {76,64},{108,64}}, color={255,128,0}));
  connect(wholeHouseBuildingEnvelope.SolarRadiationPort_RoofN,
    SolarRadiationPort_RoofN) annotation (Line(points={{52.82,66.4},{64,66.4},{64,
          90},{108,90}}, color={255,128,0}));


  for i in 1:size(wholeHouseBuildingEnvelope.groundTemp, 1) loop
      connect(groundTemp, wholeHouseBuildingEnvelope.groundTemp[i]) annotation (
      Line(points={{0,-100},{0,-44},{3,-44},{3,-40}},    color={191,0,0}));
  end for;

  for i in 1:nZonesHeated loop
    connect(heatingToRooms1[i], wholeHouseBuildingEnvelope.heatingToRooms[i]) annotation (Line(points={{-98,0},{-52,0},{-52,0.32},{-44,0.32}}, color={191,0,0}));
    connect(wholeHouseBuildingEnvelope.portVent_out[i], portVent_out[i]) annotation (
      Line(points={{51.41,-31.6},{56,-31.6},{56,-92},{100,-92}}, color={0,127,255}));
    connect(wholeHouseBuildingEnvelope.portVent_in[i], portVent_in[i]) annotation (Line(
        points={{50.47,-19.28},{68,-19.28},{68,-66},{100,-66}}, color={0,127,255}));
    connect(wholeHouseBuildingEnvelope.AirExchangePort[i], AirExchangePort[i])
    annotation (Line(points={{-48.7,44},{-80,44},{-80,34},{-106,34}}, color={0,0,
          127}));
  end for;

  connect(wholeHouseBuildingEnvelope.portVent_out[11], bou.ports[1]) annotation (
      Line(points={{51.41,-28.0364},{56,-28.0364},{56,-56.8},{40,-56.8}},
                                                                 color={0,127,255}));
  connect(wholeHouseBuildingEnvelope.portVent_in[11], bou.ports[2]) annotation (Line(
        points={{50.47,-15.7164},{68,-15.7164},{68,-59.2},{40,-59.2}},
                                                                color={0,127,255}));
  connect(convRadToCombPort.portConvRadComb, wholeHouseBuildingEnvelope.heatingToRooms[11]) annotation (Line(points={{-46,-56},{-72,-56},{-72,5.41091},{-44,5.41091}},
        color={191,0,0}));
  connect(InternalGains1.port, convRadToCombPort.portRad) annotation (Line(points={{-16,-61},{-26,-61}}, color={191,0,0}));
  connect(InternalGains.port, convRadToCombPort.portConv) annotation (Line(points={{-16,-51},{-26,-51}}, color={191,0,0}));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end AixLibHighOrderOFD;
