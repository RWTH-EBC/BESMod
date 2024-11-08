within BESMod.Systems.Demand.Building;
model SpawnHighOrder "Spawn model of the AixLib High Order Model"
  extends BaseClasses.PartialDemand(
    use_ventilation=true,
    ARoo=129.95,
    hBui=10.2,
    ABui=249.02,
    hZone={2.6,2.6,2.6,2.6,2.6,2.6,2.6,2.6,2.6,2.6},
    AZone={23.07,12.94,15.35,12.94,18.72,23.07,12.94,15.35,12.94,18.72},
    nZones=10);
  parameter Integer nZonesNonHeated = 1 "Non heated rooms of the building";
  parameter Integer nZones = 10 "Heated rooms of the building";
  parameter Boolean useConstVentRate=false;
  parameter Real ventRate[nZones]=fill(0, nZones) if useConstVentRate "Constant mechanical ventilation rate" annotation (Dialog(enable=useConstVentRate));
  parameter String idf_name=Modelica.Utilities.Files.loadResource("modelica://BESMod/Resources/Spawn/AixLib_HOM_in_EnergyPlus.idf")        "Name of the IDF file";
  parameter String epw_name=Modelica.Utilities.Files.loadResource("modelica://BESMod/Resources/Spawn/Potsdam_TRY2015_normal.epw")        "Name of the weather file, in .epw format and with .epw extension";
  parameter String wea_name=Modelica.Utilities.Files.loadResource("modelica://BESMod/Resources/Spawn/Potsdam_TRY2015_normal.mos")        "Name of the weather file, in .mos format and with .mos extension";
  inner Buildings.ThermalZones.EnergyPlus_9_6_0.Building building(
    idfName=idf_name,
    epwName=epw_name,
    weaName=wea_name)
    annotation (Placement(transformation(extent={{-94,-10},{-74,10}})));
  Components.SpawnHighOrderOFD.GroundFloor groundFloor(redeclare package Medium =
        MediumZone)
    annotation (Placement(transformation(extent={{-24,-88},{32,-40}})));
  Components.SpawnHighOrderOFD.UpperFloor upperFloor(redeclare package Medium =
        MediumZone)
    annotation (Placement(transformation(extent={{-24,-20},{30,28}})));
  Modelica.Blocks.Math.Add TZoneOpeMeaKelvin[nZones + nZonesNonHeated](each k1=0.5,
      each k2=0.5) "Operative room temperature"
    annotation (Placement(transformation(extent={{52,-8},{66,6}})));
  Components.SpawnHighOrderOFD.Attic attic_unheated(redeclare package Medium =
        MediumZone)
    annotation (Placement(transformation(extent={{-14,36},{18,66}})));
  Modelica.Blocks.Sources.Constant constVenRatAtt(final k=1)
    "Constant ventilation rate of attic"
    annotation (Placement(transformation(extent={{-86,36},{-70,52}})));
  Modelica.Blocks.Math.Gain InternalGainsConvRatio[nZones](each k=0.6)
    annotation (Placement(transformation(extent={{80,-58},{70,-48}})));
  Modelica.Blocks.Math.Gain InternalGainsRadRatio[nZones](each k=0.4)
    annotation (Placement(transformation(extent={{80,-76},{70,-66}})));
  Utilities.Electrical.ZeroLoad zeroLoad
    annotation (Placement(transformation(extent={{30,-108},{50,-88}})));
  Modelica.Blocks.Sources.Constant constVentRate[nZones](final k=ventRate)
    if useConstVentRate "Only used when \"useConstVentRate = true\""
                                      annotation (Placement(transformation(
          extent={{10,-10},{-10,10}}, rotation=180,
        origin={-84,-30})));
  Modelica.Thermal.HeatTransfer.Celsius.FromKelvin TZoneOpeMea[nZones +
    nZonesNonHeated]
    annotation (Placement(transformation(extent={{60,22},{68,30}})));
  Modelica.Blocks.Math.Division InternalGainsRadAreaSpecific[nZones]
    "Spawn needs the internal gains in W/m²"
    annotation (Placement(transformation(extent={{64,-76},{54,-66}})));
  Modelica.Blocks.Math.Division InternalGainsConvAreaSpecific[nZones]
    "Spawn needs the internal gains in W/m²"
    annotation (Placement(transformation(extent={{64,-58},{54,-48}})));
  Modelica.Blocks.Sources.Constant RoomArea[nZones](k=AZone)
    "Area of the rooms"
    annotation (Placement(transformation(extent={{102,-66},{92,-56}})));
equation
  connect(heatPortRad[1:5], groundFloor.heatPortRad) annotation (Line(points={{-100,
          -60.5},{-34,-60.5},{-34,-76},{-24,-76}}, color={191,0,0}));
  connect(heatPortRad[6:10], upperFloor.heatPortRad) annotation (Line(points={{-100,
          -55.5},{-34,-55.5},{-34,-8},{-24,-8}}, color={191,0,0}));
  connect(heatPortCon[1:5], groundFloor.heatPortCon) annotation (Line(points={{-100,
          59.5},{-38,59.5},{-38,-48.64},{-24.56,-48.64}}, color={191,0,0}));
  connect(heatPortCon[6:10], upperFloor.heatPortCon) annotation (Line(points={{-100,
          64.5},{-38,64.5},{-38,19.36},{-24.54,19.36}}, color={191,0,0}));
  connect(weaBus, groundFloor.weaBus) annotation (Line(
      points={{-47,98},{-48,98},{-48,-32},{-12.24,-32},{-12.24,-39.52}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(weaBus, upperFloor.weaBus) annotation (Line(
      points={{-47,98},{-47,96},{-48,96},{-48,32},{-12,32},{-12,28},{-12.66,28},
          {-12.66,28.48}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(portVent_in[1:5], groundFloor.portVent_in) annotation (Line(points={{100,
          37.5},{42,37.5},{42,-57.76},{32,-57.76}}, color={0,127,255}));
  connect(portVent_in[6:10], upperFloor.portVent_in) annotation (Line(points={{100,
          42.5},{42,42.5},{42,10.24},{30,10.24}}, color={0,127,255}));
  connect(portVent_out[1:5], groundFloor.portVent_out) annotation (Line(points={
          {100,-40.5},{46,-40.5},{46,-65.92},{32,-65.92}}, color={0,127,255}));
  connect(portVent_out[6:10], upperFloor.portVent_out) annotation (Line(points={
          {100,-35.5},{78,-35.5},{78,-40},{46,-40},{46,-14},{30,-14},{30,2.08}},
        color={0,127,255}));
  connect(groundFloor.TZoneMea, buiMeaBus.TZoneMea[1:5]) annotation (Line(
        points={{33.4,-48.4},{40,-48.4},{40,88},{0,88},{0,99}}, color={0,0,127}));
  connect(upperFloor.TZoneMea, buiMeaBus.TZoneMea[6:10]) annotation (Line(
        points={{31.35,19.6},{31.35,22},{40,22},{40,88},{0,88},{0,99}}, color={0,
          0,127}));
  connect(groundFloor.TZoneMea, TZoneOpeMeaKelvin[1:5].u1) annotation (Line(
        points={{33.4,-48.4},{40,-48.4},{40,3.2},{50.6,3.2}}, color={0,0,127}));
  connect(upperFloor.TZoneMea, TZoneOpeMeaKelvin[6:10].u1) annotation (Line(
        points={{31.35,19.6},{31.35,22},{40,22},{40,3.2},{50.6,3.2}}, color={0,0,
          127}));
  connect(groundFloor.TZoneRadMea, TZoneOpeMeaKelvin[1:5].u2) annotation (Line(
        points={{33.4,-75.76},{33.4,-76},{44,-76},{44,-5.2},{50.6,-5.2}}, color=
         {0,0,127}));
  connect(upperFloor.TZoneRadMea, TZoneOpeMeaKelvin[6:10].u2) annotation (Line(
        points={{31.35,-7.76},{31.35,-8},{44,-8},{44,-5.2},{50.6,-5.2}}, color={
          0,0,127}));
  connect(attic_unheated.TZoneMea, buiMeaBus.TZoneMea[11]) annotation (Line(
        points={{18.8,60.75},{22,60.75},{22,60},{26,60},{26,74},{0,74},{0,99}},
                                                                color={0,0,127}));
  connect(attic_unheated.TZoneMea, TZoneOpeMeaKelvin[11].u1) annotation (Line(
        points={{18.8,60.75},{18,60.75},{18,60},{40,60},{40,3.2},{50.6,3.2}},
        color={0,0,127}));
  connect(attic_unheated.TZoneRadMea, TZoneOpeMeaKelvin[11].u2) annotation (
      Line(points={{18.8,43.65},{18.8,42},{44,42},{44,-5.2},{50.6,-5.2}}, color=
         {0,0,127}));
  connect(constVenRatAtt.y, attic_unheated.AirExchangePort) annotation (Line(
        points={{-69.2,44},{-20,44},{-20,52.05},{-15.12,52.05}}, color={0,0,127}));
  connect(weaBus, attic_unheated.weaBus) annotation (Line(
      points={{-47,98},{-47,96},{-48,96},{-48,70},{-7.28,70},{-7.28,66.3}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(useProBus.intGains, InternalGainsConvRatio.u) annotation (Line(
      points={{51,101},{84,101},{84,-53},{81,-53}},
      color={0,0,127}));
  connect(useProBus.intGains, InternalGainsRadRatio.u) annotation (Line(
      points={{51,101},{86,101},{86,-71},{81,-71}},
      color={0,0,127}));
  connect(zeroLoad.internalElectricalPin, internalElectricalPin) annotation (
      Line(
      points={{50,-98},{54,-98},{54,-80},{70,-80},{70,-96}},
      color={0,0,0},
      thickness=1));
  connect(constVentRate[1:5].y, groundFloor.AirExchangePort) annotation (Line(
        points={{-73,-30},{-66,-30},{-66,-41.68},{-24.84,-41.68}}, color={0,0,127}));
  connect(constVentRate[6:10].y, upperFloor.AirExchangePort) annotation (Line(
        points={{-73,-30},{-66,-30},{-66,26.32},{-24.81,26.32}}, color={0,0,127}));
  connect(TZoneOpeMeaKelvin.y, TZoneOpeMea.Kelvin) annotation (Line(points={{66.7,
          -1},{70,-1},{70,18},{54,18},{54,26},{59.2,26}}, color={0,0,127}));
  connect(TZoneOpeMea.Celsius, buiMeaBus.TZoneOpeMea) annotation (Line(points={{
          68.4,26},{70,26},{70,88},{0,88},{0,99}}, color={0,0,127}));
  connect(InternalGainsConvRatio.y, InternalGainsConvAreaSpecific.u1)
    annotation (Line(points={{69.5,-53},{65,-53},{65,-50}}, color={0,0,127}));
  connect(InternalGainsRadRatio.y, InternalGainsRadAreaSpecific.u1)
    annotation (Line(points={{69.5,-71},{65,-71},{65,-68}}, color={0,0,127}));
  connect(RoomArea.y, InternalGainsConvAreaSpecific.u2) annotation (Line(points=
         {{91.5,-61},{84,-61},{84,-62},{65,-62},{65,-56}}, color={0,0,127}));
  connect(RoomArea.y, InternalGainsRadAreaSpecific.u2) annotation (Line(points={
          {91.5,-61},{88,-61},{88,-80},{65,-80},{65,-74}}, color={0,0,127}));
  connect(InternalGainsRadAreaSpecific[1:5].y, groundFloor.IntGainsRad)
    annotation (Line(points={{53.5,-71},{48,-71},{48,-86},{26,-86},{26,-98},{-50,
          -98},{-50,-70},{-25.4,-70}}, color={0,0,127}));
  connect(InternalGainsRadAreaSpecific[6:10].y, upperFloor.IntGainsRad)
    annotation (Line(points={{53.5,-71},{48,-71},{48,-86},{26,-86},{26,-98},{-50,
          -98},{-50,-2},{-25.35,-2}}, color={0,0,127}));
  connect(InternalGainsConvAreaSpecific[1:5].y, groundFloor.IntGainsConv)
    annotation (Line(points={{53.5,-53},{50,-53},{50,-70},{46,-70},{46,-84},{24,
          -84},{24,-96},{-44,-96},{-44,-59.44},{-25.96,-59.44}}, color={0,0,127}));
  connect(InternalGainsConvAreaSpecific[6:10].y, upperFloor.IntGainsConv)
    annotation (Line(points={{53.5,-53},{50,-53},{50,-70},{46,-70},{46,-84},{24,
          -84},{24,-96},{-44,-96},{-44,8},{-34,8},{-34,8.56},{-25.89,8.56}},
        color={0,0,127}));
  if not useConstVentRate then
    connect(useProBus.natVent[1:5], groundFloor.AirExchangePort) annotation (Line(
      points={{51,101},{-62,101},{-62,-41.68},{-24.84,-41.68}},
      color={0,0,127}));
    connect(useProBus.natVent[6:10], upperFloor.AirExchangePort) annotation (Line(
      points={{51,101},{-62,101},{-62,26.32},{-24.81,26.32}},
      color={0,0,127}));
  end if;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html><p>
  <span style=\"font-size: 8.25pt;\">This is the Spawn model
  corresponding to the High Order Model (HOM) contained in the AixLib
  library. The AixLib-HOM offers the possibility to select a specific
  amount of windows, outer doors and inner doors. The Spawn-HOM
  contains no inner doors, two outer doors and a specific amount of
  windows (see floor plans of the ground floor and the upper floor in
  the icon view).</span>
</p>
<p>
  <span style=\"font-size: 8.25pt;\">Dependent on the version of the
  Buidlings library, some errors may occur:</span>
</p>
<ol>
  <li>
    <span style=\"font-size: 8.25pt;\">error: Compilation failed because
    Spawn needs a 64 bit system<br/>
    solution: Set the flag \"Advanced.CompileWith64 = 2\" in the
    Commands</span>
  </li>
  <li>
    <span style=\"font-size: 8.25pt;\">error: Compilation/Simulation
    failed due to a missing PATH environment variable<br/>
    solution: Follow the instructions in
    \"Buildings.ThermalZones.EnergyPlus_9_6_0.UsersGuide.Installation\"</span>
  </li>
  <li>
    <span style=\"font-size: 8.25pt;\">error: Integrator failed to start
    model<br/>
    solution: Be aware of having no spaces in the Buildings library
    installation folder (full path), see</span> <span style=
    \"font-size: 8.25pt;\"><a href=
    \"https://github.com/lbl-srg/modelica-buildings/issues/3993\">https://github.com/lbl-srg/modelica-buildings/issues/3993</a></span><span style=\"font-size: 8.25pt;\">.</span>
  </li>
  <li>
    <span style=\"font-size: 8.25pt;\">error: Simulation failed, e.g.
    room temperatures exceed the bounds due to divergence<br/>
    solution 1: The timestep in the IDF-File needs to be increased (at
    least 6, better 12). This is already done for this model.<br/>
    solution 2: The tolerance of the solver in dymola needs to be
    increased (e.g. 0.001), see</span> <span style=
    \"font-size: 8.25pt;\"><a href=
    \"https://github.com/lbl-srg/modelica-buildings/issues/3994\">https://github.com/lbl-srg/modelica-buildings/issues/3994</a></span><span style=\"font-size: 8.25pt;\">.</span>
  </li>
</ol>
<p>
  <span style=\"font-size: 8.25pt;\"><br/></span><span style=
  \"font-size: 8.25pt;\">Additionally, be aware of always using the same
  weather data in epw and in mos format when using Spawn because the
  building is simulated in EnergyPlus using the epw weather file. You
  can use the open source tool <a href=
  \"https://github.com/RWTH-EBC/AixWeather\">AixWeather</a></span>
  <span style=\"font-size: 8.25pt;\">to get the weather data in both
  formats.</span>
</p>
</html>"));
end SpawnHighOrder;
