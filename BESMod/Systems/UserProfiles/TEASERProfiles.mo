within BESMod.Systems.UserProfiles;
model TEASERProfiles "Standard TEASER Profiles"
  extends BaseClasses.PartialUserProfiles;
  parameter String fileNameIntGains=Modelica.Utilities.Files.loadResource("modelica://BESMod/Resources/InternalGains.txt")
    "File where matrix is stored";
  parameter Real gain[3]=fill(1, 3) "Gain value multiplied with internal gains. Used to e.g. disable single gains.";


  Modelica.Blocks.Sources.CombiTimeTable tableInternalGains(
    final tableOnFile=true,
    final extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    final tableName="Internals",
    final fileName=fileNameIntGains,
    columns=2:4) "Profiles for internal gains"
    annotation (Placement(transformation(extent={{23,23},{-23,-23}},
        rotation=180,
        origin={-27,1})));

  Modelica.Blocks.Math.Gain gainIntGains[3](k=gain)
    "Profiles for internal gains" annotation (Placement(transformation(
        extent={{23,23},{-23,-23}},
        rotation=180,
        origin={45,1})));

  Modelica.Blocks.Sources.Constant const[nZones](k=
        TSetZone_nominal) "Profiles for internal gains"
    annotation (Placement(transformation(
        extent={{23,23},{-23,-23}},
        rotation=180,
        origin={-87,-45})));
equation
  connect(tableInternalGains.y, gainIntGains.u) annotation (Line(points={{-1.7,1},
          {-1.7,0.5},{17.4,0.5},{17.4,1}},    color={0,0,127}));
  connect(gainIntGains.y, useProBus.intGains) annotation (Line(points={{70.3,1},
          {79.15,1},{79.15,-1},{115,-1}},             color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(const.y, useProBus.TZoneSet) annotation (Line(points={{-61.7,-45},{
          115,-45},{115,-1}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
end TEASERProfiles;
