within BESMod.Systems.UserProfiles;
model TEASERProfiles "Standard TEASER Profiles"
  extends BaseClasses.PartialUserProfiles;

  Modelica.Blocks.Sources.CombiTimeTable tableInternalGains(
    final tableOnFile=true,
    final extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    final tableName="Internals",
    final fileName=systemParameters.fileNameIntGains,
    columns=2:4) "Profiles for internal gains"
    annotation (Placement(transformation(extent={{23,23},{-23,-23}},
        rotation=180,
        origin={-27,1})));

  Modelica.Blocks.Math.Gain gainIntGains[3](each k=systemParameters.intGains_gain)
    "Profiles for internal gains" annotation (Placement(transformation(
        extent={{23,23},{-23,-23}},
        rotation=180,
        origin={45,1})));

  Modelica.Blocks.Sources.CombiTimeTable combiTimeTableDHWInput(
    final tableOnFile=systemParameters.use_dhwCalc,
    final table=systemParameters.DHWProfile.table,
    final tableName=systemParameters.tableName,
    final fileName=systemParameters.fileName,
    final columns=2:5,
    final smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    final extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic)
    "Read the input data from the given file. " annotation (Placement(visible=true,
        transformation(
        extent={{-14,-14},{14,14}},
        rotation=0,
        origin={-106,86})));
  Modelica.Blocks.Sources.Constant const[systemParameters.nZones](k=
        systemParameters.TSetZone_nominal) "Profiles for internal gains"
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
  connect(combiTimeTableDHWInput.y[4], useProBus.TDHWDemand) annotation (Line(
        points={{-90.6,86},{115,86},{115,-1}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(combiTimeTableDHWInput.y[2], useProBus.mDHWDemand_flow) annotation (
      Line(points={{-90.6,86},{116,86},{116,42},{115,42},{115,-1}}, color={0,0,
          127}), Text(
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
