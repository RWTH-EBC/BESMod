within BESMod.Systems.UserProfiles;
model AixLibHighOrderProfiles
  "Profiles for high order model in the AixLib"
  extends BESMod.Systems.UserProfiles.BaseClasses.PartialUserProfiles(nZones=10);
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
    columns=2:nZones + 1) "Profiles for internal gains" annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-30,10})));

  Modelica.Blocks.Math.Gain gainIntGains[nZones](each k=gain)
    "Profiles for internal gains" annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={30,10})));

  Modelica.Blocks.Sources.CombiTimeTable tabNatVen(
    columns={2,3,4,5,6,7,8,9,10,11},
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    tableOnFile=false,
    table=venPro.Profile)
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Modelica.Blocks.Sources.CombiTimeTable TSet(
    columns={2,3,4,5,6,7,8,9,10,11},
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    tableOnFile=false,
    table=TSetProfile.Profile)                                                                                                                                                              annotation(Placement(transformation(extent={{-40,-40},
            {-20,-20}})));
equation

  connect(tabIntGai.y, gainIntGains.u) annotation (Line(points={{-19,10},{-0.5,
          10},{-0.5,10},{18,10}}, color={0,0,127}));
  connect(gainIntGains.y, useProBus.intGains) annotation (Line(points={{41,10},
          {74,10},{74,-1},{115,-1}},                  color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(TSet.y, useProBus.TZoneSet) annotation (Line(points={{-19,-30},{74,-30},
          {74,-1},{115,-1}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(tabNatVen.y, useProBus.natVent) annotation (Line(points={{-19,50},{115,
          50},{115,-1}}, color={0,0,127}), Text(
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
end AixLibHighOrderProfiles;
