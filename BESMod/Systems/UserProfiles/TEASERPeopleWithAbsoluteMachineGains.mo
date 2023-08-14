within BESMod.Systems.UserProfiles;
model TEASERPeopleWithAbsoluteMachineGains
  "Combination of absolute electrical gains and specific people as in TEASER"
  extends BaseClasses.PartialUserProfiles;
  parameter String fileNameIntGains=Modelica.Utilities.Files.loadResource("modelica://BESMod/Resources/InternalGains.txt")
    "File where matrix is stored";
  parameter String fileNameAbsGai=Modelica.Utilities.Files.loadResource("modelica://BESMod/Resources/InternalGains.txt")
    "File where matrix is stored";

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

  Modelica.Blocks.Math.Gain gainIntGai[3](k={1,0,0})
                                                  "Gain for internal gains"
    annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={30,30})));

  Modelica.Blocks.Sources.Constant conTSetZone[nZones](k=TSetZone_nominal)
    "Constant room set temperature" annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-10,-50})));
  Modelica.Blocks.Sources.CombiTimeTable tabGaiLigMach(
    final tableOnFile=true,
    final extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    final tableName="MachinesAndLight",
    final fileName=fileNameIntGains,
    columns={2}) "Profiles for internal gains of machines and lights in W"
    annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-10,-10})));
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
  connect(tabGaiLigMach.y[1], useProBus.absIntGaiCon) annotation (Line(points={{1,
          -10},{74,-10},{74,-1},{115,-1}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(tabGaiLigMach.y[2], useProBus.absIntGaiRad) annotation (Line(points={{1,-10},
          {74,-10},{74,-1},{115,-1}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
end TEASERPeopleWithAbsoluteMachineGains;
