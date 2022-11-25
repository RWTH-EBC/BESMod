within BESMod.Systems.UserProfiles;
model TEASERProfiles_nightLowering
  "Standard TEASER Profiles with night lowering of TSet"
  extends
    BaseClasses.PartialUserProfiles_nightLowering;
  parameter String fileNameIntGains=Modelica.Utilities.Files.loadResource("modelica://BESMod/Resources/InternalGains.txt")
    "File where matrix is stored"
    annotation (Dialog(tab="Inputs", group="Internal Gains"));
  parameter Real gain[3]=fill(1, 3) "Gain value multiplied with internal gains. Used to e.g. disable single gains."          annotation (Dialog(group=
          "Internal Gains",                                                                                                 tab="Inputs"));

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

  Modelica.Blocks.Sources.Trapezoid trapezoid[nZones](
    amplitude=dT_night,
    rising=timeRamp*60*60,
    width=(24 - hMorning[1])*60*60,
    falling=0,
    period=24*60*60,
    offset=TSetZone_nominal - dT_night,
    startTime=(hMorning - timeRamp)*60*60)
    annotation (Placement(transformation(extent={{-106,-76},{-70,-40}})));
equation
  connect(tableInternalGains.y, gainIntGains.u) annotation (Line(points={{-1.7,1},
          {-1.7,0.5},{17.4,0.5},{17.4,1}},    color={0,0,127}));
  connect(gainIntGains.y, useProBus.intGains) annotation (Line(points={{70.3,1},
          {79.15,1},{79.15,-1},{115,-1}},             color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(trapezoid.y, useProBus.TZoneSet) annotation (Line(points={{-68.2,
          -58},{115,-58},{115,-1}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
end TEASERProfiles_nightLowering;
