within BESMod.Systems.UserProfiles;
model AixLibHighOrderProfiles "Standard TEASER Profiles"
  extends BaseClasses.RecordBasedDHWUser;
  parameter String fileNameIntGains=Modelica.Utilities.Files.loadResource("modelica://BESMod/Resources/InternalGains.txt")
    "File where matrix is stored"
    annotation (Dialog(tab="Inputs", group="Internal Gains"));

  parameter AixLib.DataBase.Profiles.ProfileBaseDataDefinition VentilationProfile = AixLib.DataBase.Profiles.Ventilation2perDayMean05perH();
  parameter AixLib.DataBase.Profiles.ProfileBaseDataDefinition TSetProfile = AixLib.DataBase.Profiles.SetTemperaturesVentilation2perDay();
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

  Modelica.Blocks.Sources.CombiTimeTable NaturalVentilation(
    columns={2,3,4,5,7},
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    tableOnFile=false,
    table=VentilationProfile.Profile)                                                                                                                                                                         annotation(Placement(transformation(extent={{-101,49},
            {-81,69}})));
  Modelica.Blocks.Sources.CombiTimeTable TSet(
    columns={2,3,4,5,6,7},
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    tableOnFile=false,
    table=TSetProfile.Profile)                                                                                                                                                              annotation(Placement(transformation(extent={{-92,
            -118},{-72,-98}})));
equation
  connect(tableInternalGains.y, gainIntGains.u) annotation (Line(points={{-1.7,1},
          {-1.7,0.5},{17.4,0.5},{17.4,1}},    color={0,0,127}));
  connect(gainIntGains.y, useProBus.intGains) annotation (Line(points={{70.3,1},
          {79.15,1},{79.15,-1},{115,-1}},             color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(NaturalVentilation.y, useProBus.NaturalVentilation) annotation (Line(
        points={{-80,59},{-18,59},{-18,50},{110,50},{110,-1},{115,-1}}, color={0,
          0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(TSet.y, useProBus.TZoneSet) annotation (Line(points={{-71,-108},{114,
          -108},{114,-1},{115,-1}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
end AixLibHighOrderProfiles;
