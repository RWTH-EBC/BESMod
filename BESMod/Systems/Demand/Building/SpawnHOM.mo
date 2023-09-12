within BESMod.Systems.Demand.Building;
model SpawnHOM
  extends BaseClasses.PartialDemand(
    use_ventilation=true,
    ARoo=129.95,
    hBui=10.2,
    ABui=249.02,
    hZone={2.6,2.6,2.6,2.6,2.6,2.6,2.6,2.6,2.6,2.6,4.252},
    AZone={23.07,12.94,15.35,12.94,18.72,23.07,12.94,15.35,12.94,18.72,83.01},
                                    nZones=11);
  parameter String idf_name = Modelica.Utilities.Files.loadResource("modelica://BESMod/Resources/Data/ThermalZones/EnergyPlus_9_6_0/HOM/ExampleHOM_V960.idf");
  parameter String epw_name = Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.epw");
  parameter String wea_name = Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos");
  Spawn.GroundFloor3 groundFloor3_1
    annotation (Placement(transformation(extent={{-34,-70},{30,-34}})));
  Spawn.FirstFloor3 firstFloor3_1
    annotation (Placement(transformation(extent={{-34,-14},{30,22}})));
  Spawn.Attic attic
    annotation (Placement(transformation(extent={{-34,36},{30,70}})));
  Utilities.Electrical.ZeroLoad zeroLoad
    annotation (Placement(transformation(extent={{6,-96},{26,-76}})));
  inner Buildings.ThermalZones.EnergyPlus_9_6_0.Building building(
    idfName=idf_name,
    epwName=epw_name,
    weaName=wea_name)
    annotation (Placement(transformation(extent={{-90,-4},{-70,16}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow[
    nZones] annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-56,-84})));
equation
  connect(heatPortRad[1:5],groundFloor3_1. GroundFloor) annotation (Line(points={{-100,
          -60.9091},{-40,-60.9091},{-40,-50.2},{-34.3556,-50.2}},       color={
          191,0,0}));
  connect(heatPortRad[6:10],firstFloor3_1. FirstFloor) annotation (Line(points={{-100,
          -56.3636},{-40,-56.3636},{-40,5.8},{-34.3556,5.8}},        color={191,
          0,0}));
  connect(heatPortRad[11], attic.attic) annotation (Line(points={{-100,-55.4545},
          {-40,-55.4545},{-40,53.34},{-33.36,53.34}}, color={191,0,0}));
  connect(heatPortCon[1:5],groundFloor3_1. GroundFloor) annotation (Line(points={{-100,
          59.0909},{-44,59.0909},{-44,-50.2},{-34.3556,-50.2}},       color={
          191,0,0}));
  connect(heatPortCon[6:10],firstFloor3_1. FirstFloor) annotation (Line(points={{-100,
          63.6364},{-44,63.6364},{-44,5.8},{-34.3556,5.8}},        color={191,0,
          0}));
  connect(heatPortCon[11], attic.attic) annotation (Line(points={{-100,64.5455},
          {-44,64.5455},{-44,53.34},{-33.36,53.34}}, color={191,0,0}));
  connect(weaBus,groundFloor3_1. weaBus) annotation (Line(
      points={{-47,98},{-47,-32},{-38,-32},{-38,-26},{-8.75556,-26},{-8.75556,-34}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));

  connect(weaBus,firstFloor3_1. weaBus) annotation (Line(
      points={{-47,98},{-47,22},{-38,22},{-38,26},{-8.75556,26},{-8.75556,22}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));

  connect(weaBus, attic.weaBus) annotation (Line(
      points={{-47,98},{-47,72},{-22,72},{-22,70},{-2,70}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(portVent_in[1:5],groundFloor3_1. port_a) annotation (Line(points={{100,
          37.0909},{38,37.0909},{38,-65.3714},{29.6444,-65.3714}},     color={0,
          127,255}));
  connect(portVent_out[1:5],groundFloor3_1. port_b) annotation (Line(points={{100,
          -40.9091},{40,-40.9091},{40,-68.7143},{29.6444,-68.7143}},     color=
          {0,127,255}));
  connect(portVent_in[6:10],firstFloor3_1. port_a) annotation (Line(points={{100,
          41.6364},{38,41.6364},{38,-9.37143},{29.6444,-9.37143}},     color={0,
          127,255}));
  connect(portVent_out[6:10],firstFloor3_1. port_b) annotation (Line(points={{100,
          -36.3636},{36,-36.3636},{36,-12.7143},{29.6444,-12.7143}},     color=
          {0,127,255}));
  connect(portVent_in[11], attic.port_a) annotation (Line(points={{100,42.5455},
          {96,42.5455},{96,41.78},{30,41.78}}, color={0,127,255}));
  connect(portVent_out[11], attic.port_b) annotation (Line(points={{100,
          -35.4545},{40,-35.4545},{40,-36},{36,-36},{36,32},{30,32},{30,38.04}},
                                                                       color={0,
          127,255}));
  connect(groundFloor3_1.TZoneMea, buiMeaBus.TZoneMea[1:5]) annotation (Line(
        points={{31.7778,-50.4571},{42,-50.4571},{42,74},{0,74},{0,99}}, color=
          {0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(firstFloor3_1.TZoneMea, buiMeaBus.TZoneMea[6:10]) annotation (Line(
        points={{31.7778,5.54286},{31.7778,4},{42,4},{42,74},{0,74},{0,99}},
        color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(attic.TZoneMea, buiMeaBus.TZoneMea[11]) annotation (Line(points={{31.92,
          53},{31.92,52},{42,52},{42,74},{0,74},{0,99}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(zeroLoad.internalElectricalPin, internalElectricalPin) annotation (
      Line(
      points={{26,-86},{56,-86},{56,-82},{70,-82},{70,-96}},
      color={0,0,0},
      thickness=1));
  connect(useProBus.intGains, prescribedHeatFlow.Q_flow) annotation (Line(
      points={{51,101},{50,101},{50,-100},{-38,-100},{-38,-84},{-46,-84}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(prescribedHeatFlow.port, heatPortCon) annotation (Line(points={{-66,
          -84},{-114,-84},{-114,46},{-86,46},{-86,60},{-100,60}}, color={191,0,
          0}));
end SpawnHOM;
