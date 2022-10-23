within BESMod.Systems.UserProfiles;
model AixLibHighOrderProfiles "Profiles for high order model in the AixLib"
  extends BaseClasses.PartialUserProfiles(nZones=10);
  parameter String fileNameIntGains=Modelica.Utilities.Files.loadResource("modelica://BESMod/Resources/InternalGainsHOM.txt")
    "File where matrix is stored" annotation (Dialog(tab="Inputs", group="Internal Gains"));
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
    annotation (Placement(transformation(extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-30,10})));

  Modelica.Blocks.Math.Gain gainIntGains[nZones](each k=gain)
    "Profiles for internal gains" annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={50,10})));

  Modelica.Blocks.Sources.CombiTimeTable NaturalVentilation(
    columns={2,3,4,5,7},
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    tableOnFile=false,
    table=VentilationProfile.Profile)                                                                                                                                                                         annotation(Placement(transformation(extent={{-80,60},
            {-60,80}})));
  Modelica.Blocks.Sources.CombiTimeTable TSet(
    columns={2,3,4,5,6,7},
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    tableOnFile=false,
    table=TSetProfile.Profile)                                                                                                                                                              annotation(Placement(transformation(extent={{-102,
            -100},{-82,-80}})));
  Modelica.Blocks.Routing.RealPassThrough realPassThrough[10]
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
  Modelica.Blocks.Routing.RealPassThrough realPassThrough1
                                                         [10]
    annotation (Placement(transformation(extent={{-40,-100},{-20,-80}})));
equation
  connect(TSet.y[1], realPassThrough1[6].u) annotation (Line(points={{-81,-90},
          {-42,-90}},                                                  color={0,
          0,127}));
  connect(TSet.y[1], realPassThrough1[1].u) annotation (Line(points={{-81,-90},
          {-42,-90}},                                                    color={
          0,0,127}));

  connect(TSet.y[2], realPassThrough1[7].u) annotation (Line(points={{-81,-90},
          {-42,-90}},                                                  color={0,
          0,127}));
  connect(TSet.y[2], realPassThrough1[2].u) annotation (Line(points={{-81,-90},
          {-42,-90}},                                                    color={
          0,0,127}));

  connect(TSet.y[6], realPassThrough1[3].u) annotation (Line(points={{-81,-90},
          {-42,-90}},                                                             color={
          0,0,127}));
  connect(TSet.y[6], realPassThrough1[8].u)  annotation (Line(points={{-81,-90},
          {-42,-90}},                                                    color={
          0,0,127}));

  connect(TSet.y[4], realPassThrough1[9].u) annotation (Line(points={{-81,-90},
          {-42,-90}},                                                  color={0,
          0,127}));
  connect(TSet.y[5], realPassThrough1[4].u) annotation (Line(points={{-81,-90},
          {-42,-90}},                                                     color=
         {0,0,127}));

  connect(TSet.y[3], realPassThrough1[10].u) annotation (Line(points={{-81,-90},
          {-42,-90}},
        color={0,0,127}));
  connect(TSet.y[3], realPassThrough1[5].u) annotation (Line(points={{-81,-90},
          {-42,-90}},                                                     color=
         {0,0,127}));


  connect(NaturalVentilation.y[1], realPassThrough[1].u) annotation (Line(
        points={{-59,70},{-42,70}},                                  color={0,0,
          127}));
  connect(NaturalVentilation.y[1], realPassThrough[6].u) annotation (Line(
        points={{-59,70},{-42,70}},                                color={0,0,127}));
  connect(NaturalVentilation.y[2], realPassThrough[2].u) annotation (Line(
        points={{-59,70},{-42,70}},                                color={0,0,127}));
  connect(NaturalVentilation.y[2], realPassThrough[7].u) annotation (Line(  points={{-59,70},
          {-42,70}},                                                                                                                   color={0,0,127}));
  connect(NaturalVentilation.y[3], realPassThrough[4].u) annotation (Line(
        points={{-59,70},{-42,70}},                                color={0,0,127}));
  connect(NaturalVentilation.y[3], realPassThrough[9].u) annotation (Line(
        points={{-59,70},{-42,70}},                                color={0,0,127}));
  connect(NaturalVentilation.y[4], realPassThrough[5].u) annotation (Line(
        points={{-59,70},{-42,70}},                                color={0,0,127}));
  connect(NaturalVentilation.y[4], realPassThrough[10].u) annotation (Line(
        points={{-59,70},{-42,70}},                                color={0,0,127}));
  connect(NaturalVentilation.y[5], realPassThrough[3].u) annotation (Line(
        points={{-59,70},{-42,70}},                                color={0,0,127}));
  connect(NaturalVentilation.y[5], realPassThrough[8].u) annotation (Line(
        points={{-59,70},{-42,70}},                                color={0,0,127}));

  connect(tableInternalGains.y, gainIntGains.u) annotation (Line(points={{-19,10},
          {38,10}},                           color={0,0,127}));
  connect(gainIntGains.y, useProBus.intGains) annotation (Line(points={{61,10},
          {61,12},{60,12},{60,10},{88,10},{88,-0.835},{115.175,-0.835}},
                                                      color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(realPassThrough.y, useProBus.NaturalVentilation) annotation (Line(
        points={{-19,70},{115,70},{115,-1}},                   color={0,0,127}),
      Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(realPassThrough1.y, useProBus.TZoneSet) annotation (Line(points={{-19,-90},
          {115,-90},{115,-1}},      color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
end AixLibHighOrderProfiles;
