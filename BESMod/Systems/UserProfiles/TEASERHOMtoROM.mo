within BESMod.Systems.UserProfiles;
model TEASERHOMtoROM
  "Profiles for high order model in the AixLib convertet to the single zone ROM"
  extends BESMod.Systems.UserProfiles.BaseClasses.PartialUserProfiles(nZones=1);

  parameter Integer nRooms = 10;
  parameter Real fac_conv = 1 "AixLib HOM assumes only convection";
  parameter Real facRoomTSet[nRooms] = fill(1/nRooms, nRooms);
  parameter Real facRoomNatVent[nRooms] = fill(1/nRooms, nRooms);

  parameter String fileNameIntGains=Modelica.Utilities.Files.loadResource("modelica://BESMod/Resources/InternalGainsHOM.txt")
    "File where matrix is stored" annotation (Dialog(tab="Inputs", group="Internal Gains"));
  replaceable parameter BESMod.Systems.UserProfiles.RecordsCollectionHOM.Ventilation.Const0_5
    venPro
    constrainedby BESMod.Systems.UserProfiles.RecordsCollectionHOM.RoomWiseProfileBaseDataDefinition
    "Ventilation profile"
    annotation(choicesAllMatching=true);
  replaceable parameter BESMod.Systems.UserProfiles.RecordsCollectionHOM.SetTemperatures.ConstRoomNom
    TSetProfile constrainedby
    BESMod.Systems.UserProfiles.RecordsCollectionHOM.RoomWiseProfileBaseDataDefinition
    "Temperature profile"
    annotation(choicesAllMatching=true);
  parameter Real gain=1 "Gain value multiplied with internal gains. Used to e.g. disable single gains."          annotation (Dialog(group=
          "Internal Gains",                                                                                                 tab="Inputs"));

  Modelica.Blocks.Sources.CombiTimeTable tabIntGai(
    final tableOnFile=true,
    final extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    final tableName="Internals",
    final fileName=fileNameIntGains,
    columns=2:nRooms + 1) "Profiles for internal gains" annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-96,10})));

  Modelica.Blocks.Math.Gain gainIntGains[nRooms](each k=gain)
    "Profiles for internal gains" annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-46,10})));

  Modelica.Blocks.Sources.CombiTimeTable tabNatVen(
    columns=2:nRooms + 1,
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    tableOnFile=false,
    table=venPro.Profile)
    annotation (Placement(transformation(extent={{-104,44},{-84,64}})));
  Modelica.Blocks.Sources.CombiTimeTable TSet(
    columns=2:nRooms + 1,
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    tableOnFile=false,
    table=TSetProfile.Profile)                                                                                                                                                              annotation(Placement(transformation(extent={{-106,
            -42},{-86,-22}})));
  Modelica.Blocks.Math.Gain gainElePro[2](k={fac_conv,1 - fac_conv})
    "Gain for electricity profiles, (convective, radiative)" annotation (
      Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={28,10})));
  Modelica.Blocks.Math.Sum sum1(nin=nRooms)
    annotation (Placement(transformation(extent={{-18,0},{2,20}})));
  Modelica.Blocks.Math.Gain TSetWeights[nRooms](k=facRoomTSet)
    annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-46,-32})));
  Modelica.Blocks.Math.Sum sum2[nZones](nin=nRooms)
    annotation (Placement(transformation(extent={{-16,-42},{4,-22}})));
  Modelica.Blocks.Math.Gain natVentWeights[nRooms](k=facRoomNatVent) annotation (
      Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-44,52})));
  Modelica.Blocks.Sources.Constant zeroDummyGains[3](each final k=0)
    annotation (Placement(transformation(extent={{60,70},{80,90}})));
  Modelica.Blocks.Math.Sum sum3(nin=nRooms)
    annotation (Placement(transformation(extent={{-10,36},{10,56}})));
equation

  connect(tabIntGai.y, gainIntGains.u) annotation (Line(points={{-85,10},{-58,10}},
                                  color={0,0,127}));
  connect(gainIntGains.y, sum1.u)
    annotation (Line(points={{-35,10},{-20,10}}, color={0,0,127}));
  connect(sum1.y, gainElePro[1].u)
    annotation (Line(points={{3,10},{16,10}}, color={0,0,127}));
  connect(sum1.y, gainElePro[2].u)
    annotation (Line(points={{3,10},{16,10}}, color={0,0,127}));
  connect(gainElePro[1].y, useProBus.absIntGaiConv) annotation (Line(points={{39,
          10},{74,10},{74,0},{78,0},{78,-1},{115,-1}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(gainElePro[2].y, useProBus.absIntGaiRad) annotation (Line(points={{39,
          10},{74,10},{74,0},{78,0},{78,-1},{115,-1}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(TSet.y, TSetWeights.u)
    annotation (Line(points={{-85,-32},{-58,-32}}, color={0,0,127}));
  connect(zeroDummyGains.y, useProBus.intGains) annotation (Line(points={{81,80},
          {88,80},{88,36},{72,36},{72,-4},{78,-4},{78,-1},{115,-1}}, color={0,0,
          127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(TSetWeights.y, sum2[1].u)
    annotation (Line(points={{-35,-32},{-18,-32}}, color={0,0,127}));
  connect(sum2.y, useProBus.TZoneSet) annotation (Line(points={{5,-32},{74,-32},
          {74,-1},{115,-1}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(tabNatVen.y, natVentWeights.u) annotation (Line(points={{-83,54},{-64,
          54},{-64,52},{-56,52}}, color={0,0,127}));
  connect(natVentWeights.y, sum3.u) annotation (Line(points={{-33,52},{-20,52},{
          -20,46},{-12,46}}, color={0,0,127}));
  connect(sum3.y, useProBus.natVent[1]) annotation (Line(points={{11,46},{74,46},
          {74,12},{76,12},{76,-1},{115,-1}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  annotation (Documentation(info="<html>
<p>Uses room-wise periodic table profiles room temperature setpoints in K, air exchange rate in 1/h and internal gains in W. </p>
<p>Columes</p>
<p>1        Time</p>
<p>2        Livingroom</p>
<p>3        Hobby</p>
<p>4        Corridor_gf</p>
<p>5         WC_Storage</p>
<p>6        Kitchen</p>
<p>7        Bedroom</p>
<p>8        Children1</p>
<p>9        Corridor_upp</p>
<p>10        Bath</p>
<p>11        Children2</p>
<p>12        Attic (only interal gains)</p>
</html>"));
end TEASERHOMtoROM;
