within BESMod.Systems.UserProfiles;
model TEASERProfiles "Standard TEASER Profiles"
  extends BaseClasses.PartialUserProfiles;
  parameter String fileNameIntGains=Modelica.Utilities.Files.loadResource("modelica://BESMod/Resources/InternalGains.txt")
    "File where matrix is stored";
  parameter Real gain[3]=fill(1, 3) "Gain value multiplied with internal gains. Used to e.g. disable single gains.";


  Modelica.Blocks.Sources.CombiTimeTable tabIntGai(
    final tableOnFile=true,
    final extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    final tableName="Internals",
    final fileName=fileNameIntGains,
    columns=2:4) "Profiles for internal gains" annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-10,30})));

  Modelica.Blocks.Math.Gain gainIntGai[3](k=gain) "Gain for internal gains"
    annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={30,30})));

  Modelica.Blocks.Sources.Constant conTSetZone[nZones](
    k(each unit="K", each displayUnit="K")=TSetZone_nominal,
    y(each unit="K", each displayUnit="K"))
    "Constant room set temperature" annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-10,-50})));
equation
  connect(tabIntGai.y, gainIntGai.u)
    annotation (Line(points={{1,30},{18,30}}, color={0,0,127}));
  connect(gainIntGai.y, useProBus.intGains) annotation (Line(points={{41,30},{
          74,30},{74,-1},{115,-1}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(conTSetZone.y, useProBus.TZoneSet) annotation (Line(points={{1,-50},{
          115,-50},{115,-1}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
end TEASERProfiles;
