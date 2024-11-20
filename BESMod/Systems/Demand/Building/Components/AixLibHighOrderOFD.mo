within BESMod.Systems.Demand.Building.Components;
model AixLibHighOrderOFD "High order OFD"
  extends BaseClasses.PartialAixLibHighOrder(
    final nZones=10);

  parameter Integer nZonesNonHeated = 1 "Non heated rooms of the building";

  // Rooms:
  //Groundfloor -  1:LivingRoom_GF, 2:Hobby_GF, 3: Corridor_GF, 4: WC_Storage_GF, 5: Kitchen_GF,
  //Upperfloor -  6: Bedroom_UF, 7: Child1_UF, 8: Corridor_UF, 9: Bath_UF, 10: Child2_UF, 11: Attic
  final parameter Modelica.Units.SI.Area ABui = sum(AZone) "Total area of all zones";
  final parameter Modelica.Units.SI.Length hBui = hZone[1] + hZone[6] + hZone[11] "Total hight of building";
  final parameter Modelica.Units.SI.Area ARoof = sum(ARoofZone) "Total area of roof";
  final parameter Modelica.Units.SI.Area AZone[nZones+nZonesNonHeated]=
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
  final parameter Modelica.Units.SI.Length hZone[nZones+nZonesNonHeated]=
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
  final parameter Modelica.Units.SI.Area ARoofZone[nZones+nZonesNonHeated]=
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
    "For attic"
    annotation (Placement(transformation(extent={{-46,-48},{-26,-64}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow intGaiAttCon(
    final Q_flow=0,
    final T_ref=293.15,
    final alpha=0) "No gains in attic" annotation (Placement(transformation(
        extent={{11,-11},{-11,11}},
        rotation=0,
        origin={19,-57})));
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow intGaiAttRad(
    final Q_flow=0,
    final T_ref=293.15,
    final alpha=0) "No gains in attic" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={20,-78})));
  Modelica.Blocks.Sources.Constant constVenRatAtt(final k=1)
    "Constant ventilation rate of attic"
    annotation (Placement(transformation(extent={{-80,8},{-60,28}})));
equation
    // Romm Temperatures

  TZoneMea[1]=wholeHouseBuildingEnvelope.groundFloor_Building.Livingroom.airload.heatPort.T;
  TZoneMea[2]=wholeHouseBuildingEnvelope.groundFloor_Building.Hobby.airload.heatPort.T;
  TZoneMea[3]=wholeHouseBuildingEnvelope.groundFloor_Building.Corridor.airload.heatPort.T;
  TZoneMea[4]=wholeHouseBuildingEnvelope.groundFloor_Building.WC_Storage.airload.heatPort.T;
  TZoneMea[5]=wholeHouseBuildingEnvelope.groundFloor_Building.Kitchen.airload.heatPort.T;
  TZoneMea[6]=wholeHouseBuildingEnvelope.upperFloor_Building.Bedroom.airload.heatPort.T;
  TZoneMea[7]=wholeHouseBuildingEnvelope.upperFloor_Building.Children1.airload.heatPort.T;
  TZoneMea[8]=wholeHouseBuildingEnvelope.upperFloor_Building.Corridor.airload.heatPort.T;
  TZoneMea[9]=wholeHouseBuildingEnvelope.upperFloor_Building.Bath.airload.heatPort.T;
  TZoneMea[10]=wholeHouseBuildingEnvelope.upperFloor_Building.Children2.airload.heatPort.T;


  connect(wholeHouseBuildingEnvelope.groPlateUp, wholeHouseBuildingEnvelope.groFloDown)
    annotation (Line(points={{-44,-28.8},{-54,-28.8},{-54,-15.36},{-44,-15.36}},
        color={191,0,0}));
  connect(wholeHouseBuildingEnvelope.groFloUp, wholeHouseBuildingEnvelope.uppFloDown)
    annotation (Line(points={{-44,16},{-54,16},{-54,29.44},{-44,29.44}}, color={
          191,0,0}));
  connect(wholeHouseBuildingEnvelope.WindSpeedPort, WindSpeedPort) annotation (
      Line(points={{-48.7,55.2},{-72,55.2},{-72,62},{-106,62}}, color={0,0,127}));

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

  for i in 1:nZones loop
    connect(heatingToRooms1[i], wholeHouseBuildingEnvelope.heatingToRooms[i]) annotation (Line(points={{-98,0},{-52,0},{-52,0.32},{-44,0.32}}, color={191,0,0}));
    connect(wholeHouseBuildingEnvelope.portVent_out[i], portVent_out[i]) annotation (
      Line(points={{51.41,-31.6},{56,-31.6},{56,-92},{100,-92}}, color={0,127,255}));
    connect(wholeHouseBuildingEnvelope.portVent_in[i], portVent_in[i]) annotation (Line(
        points={{50.47,-19.28},{68,-19.28},{68,-66},{100,-66}}, color={0,127,255}));
    connect(wholeHouseBuildingEnvelope.AirExchangePort[i], AirExchangePort[i])
    annotation (Line(points={{-48.7,44},{-80,44},{-80,34},{-106,34}}, color={0,0,
          127}));
  end for;

  connect(convRadToCombPort.portConvRadComb, wholeHouseBuildingEnvelope.heatingToRooms[11]) annotation (Line(points={{-46,-56},
          {-72,-56},{-72,2.86545},{-44,2.86545}},
        color={191,0,0}));
  connect(intGaiAttRad.port, convRadToCombPort.portRad) annotation (Line(points=
         {{10,-78},{-20,-78},{-20,-61},{-26,-61}}, color={191,0,0}));
  connect(intGaiAttCon.port, convRadToCombPort.portConv) annotation (Line(
        points={{8,-57},{-20,-57},{-20,-51},{-26,-51}}, color={191,0,0}));

  connect(constVenRatAtt.y, wholeHouseBuildingEnvelope.AirExchangePort[11])
    annotation (Line(points={{-59,18},{-56,18},{-56,46.5455},{-48.7,46.5455}},
        color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
  annotation (Documentation(info="<html>
<p>Model to implement a high-order model of an 
one-family dwelling (OFD) using AixLib building models.</p>

<p>The building consists of:</p>
<ul>
<li>Ground floor: Living room, hobby room, corridor, WC/storage, kitchen</li>
<li>Upper floor: Bedroom, two children's rooms, corridor, bathroom</li>
<li>Non-heated attic</li>
</ul>
</html>"));
end AixLibHighOrderOFD;
