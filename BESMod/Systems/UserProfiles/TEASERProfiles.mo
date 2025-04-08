within BESMod.Systems.UserProfiles;
model TEASERProfiles "TEASER Profiles with possible set-back temperature"
  extends BaseClasses.PartialUserProfiles;
  parameter String fileNameIntGains=Modelica.Utilities.Files.loadResource("modelica://BESMod/Resources/InternalGains.txt")
    "File where matrix is stored";
  parameter Real gain[3]=fill(1, 3) "Gain value multiplied with internal gains. Used to e.g. disable single gains.";

  parameter Modelica.Units.SI.TemperatureDifference dTSetBack=0
    "Temperature difference of set-back";
  parameter Modelica.Units.SI.Time startTimeSetBack(displayUnit="h")=79200
                                                      "Start time of set back";
  parameter Real hoursSetBack(max=24, min=0)=8
                                             "Number of hours the set-back lasts, maximum 24";
  parameter Modelica.Units.SI.Temperature TOdaMin=253.15
    "Minimal outdoor air temperature below which no setback is performed";

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
    each dTSetBack=dTSetBack,
    each final startTimeSetBack=startTimeSetBack,
    each final timeSetBack=hoursSetBack*3600,
    final TZone_nominal=TSetZone_nominal,
    TOdaMin=TOdaMin)
    "Room set temperature with set-back option"
    annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));
  Modelica.Blocks.Routing.Replicator repTDryBul(final nout=nZones)
    "Match temperature to number of zones"
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));

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
end TEASERProfiles;
