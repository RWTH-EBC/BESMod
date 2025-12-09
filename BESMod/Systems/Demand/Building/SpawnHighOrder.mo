within BESMod.Systems.Demand.Building;
model SpawnHighOrder "Spawn model of the AixLib High Order Model"
  extends BESMod.Systems.Demand.Building.BaseClasses.PartialDemand(
    use_hydraulic = true,
    use_ventilation = false,
    ARoo=129.95,
    hBui=10.2,
    ABui=249.02,
    hZone={2.6,2.6,2.6,2.6,2.6,2.6,2.6,2.6,2.6,2.6},
    AZone={23.07,12.94,15.35,12.94,18.72,23.07,12.94,15.35,12.94,18.72},
    nZones=10);
  parameter Modelica.Units.SI.Height VZone[nZones + nZonesNonHeated]={59.98,33.63,39.9,33.63,48.67,59.98,33.63,39.9,33.63,48.67,199.99} "Volume of all (heated and unheated) zones" annotation(Dialog(group="Geometry"));
  parameter Integer nZonesNonHeated = 1 "Non heated rooms of the building";
  //parameter Integer nZones = 10 "Heated rooms of the building";
  parameter Boolean useConstVentRate=false;
  parameter Real ventRate[nZones]=fill(0, nZones) if useConstVentRate "Constant mechanical ventilation rate" annotation (Dialog(enable=useConstVentRate));
  parameter String idf_name=Modelica.Utilities.Files.loadResource("modelica://BESMod/Resources/Spawn/AixLib_HOM_in_EnergyPlus.idf")        "Name of the IDF file";
  parameter String epw_name=Modelica.Utilities.Files.loadResource("modelica://BESMod/Resources/Spawn/Potsdam_TRY2015_normal.epw")        "Name of the weather file (.epw format)";
  parameter String wea_name=Modelica.Utilities.Files.loadResource("modelica://BESMod/Resources/Spawn/Potsdam_TRY2015_normal.mos")        "Name of the weather file (.mos format)";
  inner Buildings.ThermalZones.EnergyPlus_24_2_0.Building building(
    idfName=idf_name,
    epwName=epw_name,
    weaName=wea_name)
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
  BESMod.Systems.Demand.Building.Components.SpawnHighOrderOFD.GroundFloor groundFloor(redeclare
      package Medium =
        MediumZone, VZones=VZone[1:5])
    annotation (Placement(transformation(extent={{-30,-88},{26,-40}})));
  BESMod.Systems.Demand.Building.Components.SpawnHighOrderOFD.UpperFloor upperFloor(redeclare
      package Medium =
        MediumZone, VZones=VZone[6:10])
    annotation (Placement(transformation(extent={{-30,-20},{24,28}})));
  BESMod.Systems.Demand.Building.Components.SpawnHighOrderOFD.Attic attic(
      redeclare package Medium = MediumZone, VZone=VZone[11])
    annotation (Placement(transformation(extent={{-20,36},{12,66}})));
  Modelica.Blocks.Sources.Constant constVenRatAtt(final k=1)
    "Constant ventilation rate of attic"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Modelica.Blocks.Math.Gain intGainConvRatio[nZones](each k=0.6)
    annotation (Placement(transformation(extent={{80,-58},{70,-48}})));
  Modelica.Blocks.Math.Gain intGainRadRatio[nZones](each k=0.4)
    annotation (Placement(transformation(extent={{80,-76},{70,-66}})));
  BESMod.Utilities.Electrical.ZeroLoad zeroLoad
    annotation (Placement(transformation(extent={{30,-108},{50,-88}})));
  Modelica.Blocks.Sources.Constant constVentRate[nZones](final k=ventRate)
    if useConstVentRate "Only used when \"useConstVentRate = true\""
                                      annotation (Placement(transformation(
          extent={{10,-10},{-10,10}}, rotation=180,
        origin={-90,-30})));
  Modelica.Blocks.Math.Division intGainRadAreaSpec[nZones]
    "Spawn needs the internal gains in W/m²"
    annotation (Placement(transformation(extent={{64,-76},{54,-66}})));
  Modelica.Blocks.Math.Division intGainConvAreaSpec[nZones]
    "Spawn needs the internal gains in W/m²"
    annotation (Placement(transformation(extent={{64,-58},{54,-48}})));
  Modelica.Blocks.Sources.Constant roomArea[nZones](k=AZone)
    "Area of the rooms"
    annotation (Placement(transformation(extent={{102,-66},{92,-56}})));
  Modelica.Blocks.Routing.RealPassThrough reaPasThrTZoneOpeMea[nZones](y(each
        unit="K", each displayUnit="degC"))
    "Pass through for bus of operative room temperature"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={50,70})));
  Modelica.Blocks.Routing.RealPassThrough reaPasThrTZoneMea[nZones](y(each unit
        ="K", each displayUnit="degC"))
    "Pass through for bus of room air temperature"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={92,70})));
  Modelica.Blocks.Routing.RealPassThrough reaPasThrTZoneOpeMeaOut[nZones +
    nZonesNonHeated](y(each unit="K", each displayUnit="degC"))
    "Pass through for bus of operative room temperature for outputs bus"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Modelica.Blocks.Routing.RealPassThrough reaPasThrTZoneMeaOut[nZones +
    nZonesNonHeated](y(each unit="K", each displayUnit="degC"))
    "Pass through for bus of room air temperature"
    annotation (Placement(transformation(extent={{60,20},{80,40}})));
  Modelica.Blocks.Routing.RealPassThrough reaPasThrTZoneRadMeaOut[nZones +
    nZonesNonHeated](y(each unit="K", each displayUnit="degC"))
    "Pass through for bus of room radiative temperature"
    annotation (Placement(transformation(extent={{60,-38},{80,-18}})));
  Modelica.Blocks.Routing.RealPassThrough reaPasThrNatVen[nZones]
    if not useConstVentRate
    "Pass through for bus of natural ventilation"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-90,0})));
equation
  connect(heatPortRad[1:5], groundFloor.heatPortRad) annotation (Line(points={{-100,
          -60.5},{-34,-60.5},{-34,-76},{-30,-76}}, color={191,0,0}));
  connect(heatPortRad[6:10], upperFloor.heatPortRad) annotation (Line(points={{-100,
          -55.5},{-34,-55.5},{-34,-8},{-30,-8}}, color={191,0,0}));
  connect(heatPortCon[1:5], groundFloor.heatPortCon) annotation (Line(points={{-100,
          59.5},{-38,59.5},{-38,-48.64},{-30.56,-48.64}}, color={191,0,0}));
  connect(heatPortCon[6:10], upperFloor.heatPortCon) annotation (Line(points={{-100,
          64.5},{-38,64.5},{-38,19.36},{-30.54,19.36}}, color={191,0,0}));
  connect(weaBus, groundFloor.weaBus) annotation (Line(
      points={{-47,98},{-48,98},{-48,-32},{-18.24,-32},{-18.24,-39.52}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(weaBus, upperFloor.weaBus) annotation (Line(
      points={{-47,98},{-47,96},{-48,96},{-48,32},{-12,32},{-12,28},{-18.66,28},
          {-18.66,28.48}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(portVent_in[1:5], groundFloor.portVent_in) annotation (Line(points={{100,
          37.5},{102,37.5},{102,42},{42,42},{42,-53.44},{26,-53.44}},
                                                    color={0,127,255}));
  connect(portVent_in[6:10], upperFloor.portVent_in) annotation (Line(points={{100,
          42.5},{42,42.5},{42,13.6},{24,13.6}},   color={0,127,255}));
  connect(portVent_out[1:5], groundFloor.portVent_out) annotation (Line(points={{100,
          -40.5},{46,-40.5},{46,-62.08},{26,-62.08}},      color={0,127,255}));
  connect(portVent_out[6:10], upperFloor.portVent_out) annotation (Line(points={{100,
          -35.5},{100,-32},{46,-32},{46,6},{24,6},{24,5.44}},
        color={0,127,255}));
  connect(constVenRatAtt.y, attic.AirExchangePort) annotation (Line(points={{-59,70},
          {-50,70},{-50,66},{-30,66},{-30,52.05},{-21.12,52.05}},
                                                    color={0,0,127}));
  connect(weaBus, attic.weaBus) annotation (Line(
      points={{-47,98},{-47,96},{-48,96},{-48,70},{-13.28,70},{-13.28,66.3}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(useProBus.intGains, intGainConvRatio.u) annotation (Line(points={{51,101},
          {84,101},{84,-53},{81,-53}}, color={0,0,127}));
  connect(useProBus.intGains, intGainRadRatio.u) annotation (Line(points={{51,101},
          {86,101},{86,-71},{81,-71}}, color={0,0,127}));
  connect(zeroLoad.internalElectricalPin, internalElectricalPin) annotation (
      Line(
      points={{50,-98},{54,-98},{54,-80},{70,-80},{70,-96}},
      color={0,0,0},
      thickness=1));
  connect(constVentRate[1:5].y, groundFloor.AirExchangePort) annotation (Line(
        points={{-79,-30},{-66,-30},{-66,-41.68},{-30.84,-41.68}}, color={0,0,127}));
  connect(constVentRate[6:10].y, upperFloor.AirExchangePort) annotation (Line(
        points={{-79,-30},{-66,-30},{-66,26.32},{-30.81,26.32}}, color={0,0,127}));
  connect(intGainConvRatio.y, intGainConvAreaSpec.u1)
    annotation (Line(points={{69.5,-53},{65,-53},{65,-50}}, color={0,0,127}));
  connect(intGainRadRatio.y, intGainRadAreaSpec.u1)
    annotation (Line(points={{69.5,-71},{65,-71},{65,-68}}, color={0,0,127}));
  connect(roomArea.y, intGainConvAreaSpec.u2) annotation (Line(points=
         {{91.5,-61},{84,-61},{84,-62},{65,-62},{65,-56}}, color={0,0,127}));
  connect(roomArea.y, intGainRadAreaSpec.u2) annotation (Line(points={
          {91.5,-61},{88,-61},{88,-80},{65,-80},{65,-74}}, color={0,0,127}));
  connect(intGainRadAreaSpec[1:5].y, groundFloor.IntGainsRad)
    annotation (Line(points={{53.5,-71},{52,-71},{52,-86},{26,-86},{26,-98},{-50,
          -98},{-50,-70},{-31.4,-70}}, color={0,0,127}));
  connect(intGainRadAreaSpec[6:10].y, upperFloor.IntGainsRad)
    annotation (Line(points={{53.5,-71},{52,-71},{52,-86},{26,-86},{26,-98},{-50,
          -98},{-50,-2},{-31.35,-2}}, color={0,0,127}));
  connect(intGainConvAreaSpec[1:5].y, groundFloor.IntGainsConv)
    annotation (Line(points={{53.5,-53},{50,-53},{50,-84},{24,-84},{24,-96},{-44,
          -96},{-44,-59.44},{-31.96,-59.44}},                    color={0,0,127}));
  connect(intGainConvAreaSpec[6:10].y, upperFloor.IntGainsConv)
    annotation (Line(points={{53.5,-53},{50,-53},{50,-84},{24,-84},{24,-96},{-44,
          -96},{-44,8},{-34,8},{-34,8.56},{-31.89,8.56}},
        color={0,0,127}));
  connect(reaPasThrNatVen[1:5].y, groundFloor.AirExchangePort) annotation (Line(
      points={{-79,0},{-52,0},{-52,-41.68},{-30.84,-41.68}},
      color={0,0,127}));
  connect(reaPasThrNatVen[6:10].y, upperFloor.AirExchangePort) annotation (Line(
      points={{-79,0},{-66,0},{-66,26.32},{-30.81,26.32}},
      color={0,0,127}));
  connect(groundFloor.TZoneMea, reaPasThrTZoneMea[1:5].u) annotation (Line(
        points={{27.4,-45.52},{50,-45.52},{50,52},{92,52},{92,58}},
                                                                color={0,0,127}));
  connect(upperFloor.TZoneMea, reaPasThrTZoneMea[6:10].u) annotation (Line(
        points={{25.35,21.04},{50,21.04},{50,52},{92,52},{92,58}},
                                                               color={0,0,127}));
  connect(reaPasThrTZoneMea.y, reaPasThrTZoneMeaOut[1:10].u) annotation (Line(
      points={{92,81},{92,86},{70,86},{70,48},{50,48},{50,30},{58,30}},
                                                             color={0,0,127}));
  connect(attic.TZoneMea, reaPasThrTZoneMeaOut[11].u) annotation (Line(points={{12.8,
          60.75},{24,60.75},{24,52},{50,52},{50,30},{58,30}},
                                                    color={0,0,127}));
  connect(groundFloor.TZoneOpeMea, reaPasThrTZoneOpeMea[1:5].u) annotation (Line(
        points={{27.96,-69.52},{50,-69.52},{50,58}},               color={0,0,127}));
  connect(upperFloor.TZoneOpeMea, reaPasThrTZoneOpeMea[6:10].u) annotation (Line(
        points={{25.89,-1.52},{50,-1.52},{50,58}},               color={0,0,127}));
  connect(attic.TZoneOpeMea, reaPasThrTZoneOpeMeaOut[11].u) annotation (Line(points={{12.8,
          52.35},{32,52.35},{32,52},{50,52},{50,0},{58,0}},
                                                          color={0,0,127}));
  connect(reaPasThrTZoneOpeMea.y, reaPasThrTZoneOpeMeaOut[1:10].u) annotation (Line(points={{50,81},
          {50,86},{70,86},{70,48},{50,48},{50,-28},{58,-28},{58,0}},
                                                          color={0,0,127}));
  connect(groundFloor.TZoneRadMea, reaPasThrTZoneRadMeaOut[1:5].u) annotation (Line(
        points={{27.96,-78.16},{38,-78.16},{38,-78},{50,-78},{50,-28},{58,-28}},
                                                                   color={0,0,127}));
  connect(upperFloor.TZoneRadMea, reaPasThrTZoneRadMeaOut[6:10].u) annotation (Line(
        points={{25.89,-11.12},{50,-11.12},{50,-28},{58,-28}},     color={0,0,127}));
  connect(attic.TZoneRadMea, reaPasThrTZoneRadMeaOut[11].u) annotation (Line(points={{12.8,
          43.65},{50,43.65},{50,-28},{58,-28}},           color={0,0,127}));
  connect(reaPasThrTZoneRadMeaOut.y, outBusDem.TZoneRadMea) annotation (Line(
        points={{81,-28},{98,-28},{98,-2}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(reaPasThrTZoneOpeMeaOut.y, outBusDem.TZoneOpe) annotation (Line(points={{
          81,0},{82,0},{82,-2},{98,-2}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(reaPasThrTZoneMeaOut.y, outBusDem.TZone) annotation (Line(points={{
          81,30},{98,30},{98,-2}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(reaPasThrTZoneOpeMea.y, buiMeaBus.TZoneOpeMea) annotation (Line(
        points={{50,81},{50,84},{0,84},{0,99}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(reaPasThrTZoneMea.y, buiMeaBus.TZoneMea) annotation (Line(points={{92,
          81},{92,84},{0,84},{0,99}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(reaPasThrNatVen.u, useProBus.natVent) annotation (Line(points={{-102,0},
          {-110,0},{-110,120},{52,120},{52,100},{51,100},{51,101}},
                                                                color={0,0,127}),
      Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
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
  Buildings library, some errors may occur:</span>
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
    \"Buildings.ThermalZones.EnergyPlus_24_2_0.UsersGuide.Installation\"</span>
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
    solution 2: Change solver from Dassl to Cvode. However, if Dassl is
    needed, the tolerance of the solver in dymola needs to be
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
