within BESMod.Systems.UserProfiles;
model TEASERProfiles "TEASER Profiles with possible set-back temperature"
  extends BaseClasses.PartialUserProfiles;
  parameter String fileNameIntGains=Modelica.Utilities.Files.loadResource("modelica://BESMod/Resources/InternalGains.txt")
    "File where three internal gains are stored"
    annotation(Dialog(group="Internal Gains"));
  parameter Real gain[3]=fill(1, 3)
    "Gain value multiplied with internal gains. Used to e.g. disable single gains."
    annotation(Dialog(group="Internal Gains"));

  parameter Modelica.Units.SI.TemperatureDifference dTSetBack[nZones]=fill(0,nZones)
    "Temperature difference of set-back"
    annotation(Dialog(group="Set temperatures", enable=not use_TSetFile));
  parameter Modelica.Units.SI.Time startTimeSetBack[nZones]=fill(79200, nZones)
    "Start time of set back"
    annotation(Dialog(group="Set temperatures", enable=not use_TSetFile));
  parameter Real hoursSetBack[nZones](each max=24, each min=0)=fill(8,nZones)
    "Number of hours the set-back lasts, maximum 24"
    annotation(Dialog(group="Set temperatures", enable=not use_TSetFile));
  parameter Modelica.Units.SI.Temperature TOdaMin[nZones]=fill(253.15,nZones)
    "Minimal outdoor air temperature below which no setback is performed"
    annotation(Dialog(group="Set temperatures", enable=not use_TSetFile));
  parameter Boolean use_TSetFile=false "=true to use a file for room set temperature profiles"
    annotation(Dialog(group="Set temperatures"));
  parameter String fileNameTSet=Modelica.Utilities.Files.loadResource("modelica://BESMod/Resources/InternalGains.txt")
    "File where TSet is stored"
    annotation(Dialog(group="Set temperatures", enable=use_TSetFile));
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

  BaseClasses.NightSetback nigSetBack[nZones](
    final dTSetBack=dTSetBack,
    final startTimeSetBack=startTimeSetBack,
    final timeSetBack=hoursSetBack*3600,
    final TZone_nominal=TSetZone_nominal,
    final TOdaMin=TOdaMin) if not use_TSetFile
    "Room set temperature with set-back option"
    annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));
  Modelica.Blocks.Routing.Replicator repTDryBul(final nout=nZones)
    if not use_TSetFile
    "Match temperature to number of zones"
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));

  Modelica.Blocks.Sources.CombiTimeTable tabTSet(
    final tableOnFile=true,
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    final extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    final tableName="TZoneSet",
    final fileName=fileNameTSet,
    columns=2:(1 + nZones),
    y(each unit="K", each displayUnit="degC"))
                            if use_TSetFile
    "Profiles for internal gains of machines and lights in W" annotation (
      Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={30,-60})));
equation
  connect(tabIntGai.y, gainIntGai.u)
    annotation (Line(points={{1,30},{18,30}}, color={0,0,127}));
  connect(gainIntGai.y, useProBus.intGains) annotation (Line(points={{41,30},{
          74,30},{74,-1},{115,-1}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(nigSetBack.y, useProBus.TZoneSet) annotation (Line(points={{1,-50},{76,
          -50},{76,-1},{115,-1}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));

  connect(repTDryBul.u, weaBus.TDryBul) annotation (Line(points={{-62,-50},{-70,
          -50},{-70,-118.855},{1.175,-118.855}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(repTDryBul.y, nigSetBack.TOda)
    annotation (Line(points={{-39,-50},{-22,-50}}, color={0,0,127}));
  connect(tabTSet.y, useProBus.TZoneSet) annotation (Line(points={{41,-60},{52,
          -60},{52,-2},{72,-2},{72,0},{78,0},{78,-1},{115,-1}},
                             color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
end TEASERProfiles;
