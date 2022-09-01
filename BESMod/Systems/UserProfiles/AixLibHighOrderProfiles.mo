within BESMod.Systems.UserProfiles;
model AixLibHighOrderProfiles "Standard TEASER Profiles"
  extends BaseClasses.RecordBasedDHWUser;
  parameter String fileNameIntGains=Modelica.Utilities.Files.loadResource("modelica://BESMod/Resources/InternalGainsHOM.txt")
    "File where matrix is stored"
    annotation (Dialog(tab="Inputs", group="Internal Gains"));

  parameter AixLib.DataBase.Profiles.ProfileBaseDataDefinition VentilationProfile = AixLib.DataBase.Profiles.Ventilation2perDayMean05perH();
  parameter AixLib.DataBase.Profiles.ProfileBaseDataDefinition TSetProfile = AixLib.DataBase.Profiles.SetTemperaturesVentilation2perDay();
  parameter Real gain=1 "Gain value multiplied with internal gains. Used to e.g. disable single gains."          annotation (Dialog(group=
          "Internal Gains",                                                                                                 tab="Inputs"));

  Modelica.Blocks.Sources.CombiTimeTable tableInternalGains(
    final tableOnFile=true,
    final extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    final tableName="Internals",
    final fileName=fileNameIntGains,
    columns=2:nZones + 1)
                 "Profiles for internal gains"
    annotation (Placement(transformation(extent={{23,23},{-23,-23}},
        rotation=180,
        origin={-27,1})));

  Modelica.Blocks.Math.Gain gainIntGains[nZones](each k=gain)
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
  Modelica.Blocks.Sources.Constant const1[nZones](k=293.15)
    annotation (Placement(transformation(extent={{-94,-70},{-74,-50}})));
  Modelica.Blocks.Sources.Constant const2[nZones](k=0.1)
    annotation (Placement(transformation(extent={{-102,84},{-82,104}})));
  Modelica.Blocks.Interfaces.RealOutput y1[size(TSet.y, 1)]
                     "Connector of Real output signals"
    annotation (Placement(transformation(extent={{-22,-116},{-2,-96}})));
  Modelica.Blocks.Interfaces.RealOutput y2[size(NaturalVentilation.y, 1)]
                     "Connector of Real output signals"
    annotation (Placement(transformation(extent={{-58,48},{-38,68}})));
equation
  //for i in nZones loop
  //end for;
  connect(tableInternalGains.y, gainIntGains.u) annotation (Line(points={{-1.7,1},
          {-1.7,0.5},{17.4,0.5},{17.4,1}},    color={0,0,127}));
  connect(gainIntGains.y, useProBus.intGains) annotation (Line(points={{70.3,1},
          {79.15,1},{79.15,-1},{115,-1}},             color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));


  connect(const1.y, useProBus.TZoneSet) annotation (Line(points={{-73,-60},{115,
          -60},{115,-1}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(const2.y, useProBus.NaturalVentilation) annotation (Line(points={{-81,
          94},{-56,94},{-56,92},{-36,92},{-36,44},{115,44},{115,-1}}, color={0,0,
          127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(TSet.y, y1) annotation (Line(points={{-71,-108},{-44,-108},{-44,-112},
          {-12,-112},{-12,-106}}, color={0,0,127}));
  connect(NaturalVentilation.y, y2) annotation (Line(points={{-80,59},{-64,59},
          {-64,58},{-48,58}}, color={0,0,127}));
end AixLibHighOrderProfiles;
