within BESMod.Systems.Demand.Building;
model SpawnV62
  "Spawn model of the Viebrockhaus V62 (Satteldach 40 Grad, Effizienzhaus 40)"
  extends BESMod.Systems.Demand.Building.BaseClasses.PartialDemand(
    use_hydraulic = true,
    use_ventilation = false,
    ARoo=85.96,
    hBui=7.07,
    ABui=131.69,
    hZone={2.51,2.51,2.51,2.51,2.51,2.21,2.17,2.25,2.14,2.25,2.51},
    AZone={36.45,11.34,6.02,5.52,6.52,16.38,12.50,11.90,12.30,6.01,6.76},
    nZones=11);
  parameter Modelica.Units.SI.Volume VZone[nZones + nZonesNonHeated]={91.48,
      28.47,15.10,13.84,16.38,36.15,27.17,26.79,26.31,13.52,16.96,32.50}
    "Volume of all (heated and unheated) zones"
    annotation (Dialog(group="Geometry"));
  parameter Integer nZonesNonHeated = 1 "Non heated rooms of the building";
  parameter Boolean useConstVentRate=false;
  parameter Real ventRate[nZones]=fill(0, nZones) if useConstVentRate
    "Constant mechanical ventilation rate"
    annotation (Dialog(enable=useConstVentRate));
  parameter String idf_name=Modelica.Utilities.Files.loadResource(
      "modelica://BESMod/Resources/Spawn/V62_Satteldach40_Spawn.idf")
    "Name of the IDF file";
  parameter String epw_name=Modelica.Utilities.Files.loadResource(
      "modelica://BESMod/Resources/Spawn/Potsdam_TRY2015_normal.epw")
    "Name of the weather file (.epw format)";
  parameter String wea_name=Modelica.Utilities.Files.loadResource(
      "modelica://BESMod/Resources/Spawn/Potsdam_TRY2015_normal.mos")
    "Name of the weather file (.mos format)";
  inner Buildings.ThermalZones.EnergyPlus_24_2_0.Building building(
    idfName=idf_name,
    epwName=epw_name,
    weaName=wea_name)
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
  BESMod.Systems.Demand.Building.Components.SpawnV62OFD.GroundFloor groundFloor(
      redeclare package Medium = MediumZone, VZones=VZone[1:5])
    annotation (Placement(transformation(extent={{-30,-88},{26,-40}})));
  BESMod.Systems.Demand.Building.Components.SpawnV62OFD.UpperFloor upperFloor(
      redeclare package Medium = MediumZone, VZones=VZone[6:11])
    annotation (Placement(transformation(extent={{-30,-20},{24,28}})));
  BESMod.Systems.Demand.Building.Components.SpawnV62OFD.Attic attic(
      redeclare package Medium = MediumZone, VZone=VZone[12])
    annotation (Placement(transformation(extent={{-20,36},{12,66}})));
  Modelica.Blocks.Sources.Constant constVenRatAtt(final k=3)
    "Constant ventilation rate of the ventilated cold attic (3 1/h, wie im IDF)"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Modelica.Blocks.Math.Gain intGainConvRatio[nZones](each k=0.6)
    annotation (Placement(transformation(extent={{80,-58},{70,-48}})));
  Modelica.Blocks.Math.Gain intGainRadRatio[nZones](each k=0.4)
    annotation (Placement(transformation(extent={{80,-76},{70,-66}})));
  BESMod.Utilities.Electrical.ZeroLoad zeroLoad
    annotation (Placement(transformation(extent={{30,-108},{50,-88}})));
  Modelica.Blocks.Sources.Constant constVentRate[nZones](final k=ventRate)
    if useConstVentRate "Only used when \"useConstVentRate = true\""
    annotation (Placement(transformation(extent={{10,-10},{-10,10}}, rotation=180,
        origin={-90,-30})));
  Modelica.Blocks.Math.Division intGainRadAreaSpec[nZones]
    "Spawn needs the internal gains in W/m2"
    annotation (Placement(transformation(extent={{64,-76},{54,-66}})));
  Modelica.Blocks.Math.Division intGainConvAreaSpec[nZones]
    "Spawn needs the internal gains in W/m2"
    annotation (Placement(transformation(extent={{64,-58},{54,-48}})));
  Modelica.Blocks.Sources.Constant roomArea[nZones](k=AZone) "Area of the rooms"
    annotation (Placement(transformation(extent={{102,-66},{92,-56}})));
  Modelica.Blocks.Routing.RealPassThrough reaPasThrTZoneOpeMea[nZones](y(each
        unit="K", each displayUnit="degC"))
    "Pass through for bus of operative room temperature"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}}, rotation=90,
        origin={50,70})));
  Modelica.Blocks.Routing.RealPassThrough reaPasThrTZoneMea[nZones](y(each unit=
          "K", each displayUnit="degC"))
    "Pass through for bus of room air temperature"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}}, rotation=90,
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
    if not useConstVentRate "Pass through for bus of natural ventilation"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}}, rotation=0,
        origin={-90,0})));
equation
  connect(heatPortRad[1:5], groundFloor.heatPortRad);
  connect(heatPortRad[6:11], upperFloor.heatPortRad);
  connect(heatPortCon[1:5], groundFloor.heatPortCon);
  connect(heatPortCon[6:11], upperFloor.heatPortCon);
  connect(weaBus, groundFloor.weaBus) annotation (Line(
      points={{-47,98},{-48,98},{-48,-32},{-18.24,-32},{-18.24,-39.52}},
      color={255,204,51},
      thickness=0.5));
  connect(weaBus, upperFloor.weaBus) annotation (Line(
      points={{-47,98},{-48,98},{-48,32},{-18.66,32},{-18.66,28.48}},
      color={255,204,51},
      thickness=0.5));
  connect(weaBus, attic.weaBus) annotation (Line(
      points={{-47,98},{-48,98},{-48,70},{-13.28,70},{-13.28,66.3}},
      color={255,204,51},
      thickness=0.5));
  connect(portVent_in[1:5], groundFloor.portVent_in);
  connect(portVent_in[6:11], upperFloor.portVent_in);
  connect(portVent_out[1:5], groundFloor.portVent_out);
  connect(portVent_out[6:11], upperFloor.portVent_out);
  connect(constVenRatAtt.y, attic.AirExchangePort) annotation (Line(points={{-59,
          70},{-50,70},{-50,52.05},{-21.12,52.05}}, color={0,0,127}));
  connect(useProBus.intGains, intGainConvRatio.u) annotation (Line(points={{51,101},
          {84,101},{84,-53},{81,-53}}, color={0,0,127}));
  connect(useProBus.intGains, intGainRadRatio.u) annotation (Line(points={{51,101},
          {86,101},{86,-71},{81,-71}}, color={0,0,127}));
  connect(zeroLoad.internalElectricalPin, internalElectricalPin) annotation (
      Line(points={{50,-98},{54,-98},{54,-80},{70,-80},{70,-96}},
      color={0,0,0},
      thickness=1));
  connect(constVentRate[1:5].y, groundFloor.AirExchangePort);
  connect(constVentRate[6:11].y, upperFloor.AirExchangePort);
  connect(intGainConvRatio.y, intGainConvAreaSpec.u1)
    annotation (Line(points={{69.5,-53},{65,-53},{65,-50}}, color={0,0,127}));
  connect(intGainRadRatio.y, intGainRadAreaSpec.u1)
    annotation (Line(points={{69.5,-71},{65,-71},{65,-68}}, color={0,0,127}));
  connect(roomArea.y, intGainConvAreaSpec.u2) annotation (Line(points={{91.5,-61},
          {65,-61},{65,-56}}, color={0,0,127}));
  connect(roomArea.y, intGainRadAreaSpec.u2) annotation (Line(points={{91.5,-61},
          {88,-61},{88,-80},{65,-80},{65,-74}}, color={0,0,127}));
  connect(intGainRadAreaSpec[1:5].y, groundFloor.IntGainsRad);
  connect(intGainRadAreaSpec[6:11].y, upperFloor.IntGainsRad);
  connect(intGainConvAreaSpec[1:5].y, groundFloor.IntGainsConv);
  connect(intGainConvAreaSpec[6:11].y, upperFloor.IntGainsConv);
  connect(reaPasThrNatVen[1:5].y, groundFloor.AirExchangePort);
  connect(reaPasThrNatVen[6:11].y, upperFloor.AirExchangePort);
  connect(groundFloor.TZoneMea, reaPasThrTZoneMea[1:5].u);
  connect(upperFloor.TZoneMea, reaPasThrTZoneMea[6:11].u);
  connect(reaPasThrTZoneMea.y, reaPasThrTZoneMeaOut[1:11].u);
  connect(attic.TZoneMea, reaPasThrTZoneMeaOut[12].u);
  connect(groundFloor.TZoneOpeMea, reaPasThrTZoneOpeMea[1:5].u);
  connect(upperFloor.TZoneOpeMea, reaPasThrTZoneOpeMea[6:11].u);
  connect(reaPasThrTZoneOpeMea.y, reaPasThrTZoneOpeMeaOut[1:11].u);
  connect(attic.TZoneOpeMea, reaPasThrTZoneOpeMeaOut[12].u);
  connect(groundFloor.TZoneRadMea, reaPasThrTZoneRadMeaOut[1:5].u);
  connect(upperFloor.TZoneRadMea, reaPasThrTZoneRadMeaOut[6:11].u);
  connect(attic.TZoneRadMea, reaPasThrTZoneRadMeaOut[12].u);
  connect(reaPasThrTZoneRadMeaOut.y, outBusDem.TZoneRadMea) annotation (Line(
        points={{81,-28},{98,-28},{98,-2}}, color={0,0,127}), Text(
      string="%second", index=1, extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(reaPasThrTZoneOpeMeaOut.y, outBusDem.TZoneOpe) annotation (Line(
        points={{81,0},{98,0},{98,-2}}, color={0,0,127}), Text(
      string="%second", index=1, extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(reaPasThrTZoneMeaOut.y, outBusDem.TZone) annotation (Line(points={{81,
          30},{98,30},{98,-2}}, color={0,0,127}), Text(
      string="%second", index=1, extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(reaPasThrTZoneOpeMea.y, buiMeaBus.TZoneOpeMea) annotation (Line(
        points={{50,81},{50,84},{0,84},{0,99}}, color={0,0,127}), Text(
      string="%second", index=1, extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(reaPasThrTZoneMea.y, buiMeaBus.TZoneMea) annotation (Line(points={{92,
          81},{92,84},{0,84},{0,99}}, color={0,0,127}), Text(
      string="%second", index=1, extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(reaPasThrNatVen.u, useProBus.natVent) annotation (Line(points={{-102,0},
          {-110,0},{-110,120},{52,120},{52,101},{51,101}}, color={0,0,127}),
      Text(string="%second", index=1, extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html><p>
  Spawn-Modell des Viebrockhauses V62 (gespiegelt, Satteldach 40&deg;,
  Effizienzhaus 40) auf Basis des Bauplans SC_43a_V62_A1_BAU vom 18.07.2023.
</p>
<p>
  Zonenreihenfolge (Index im Bus / in AZone, hZone, VZone):
</p>
<ol>
  <li>EG_WohnenKochen - Kochen/Essen/Wohnen</li>
  <li>EG_Diele - Diele mit Treppe</li>
  <li>EG_HomeOffice - Home-Office</li>
  <li>EG_DuscheWC - Dusche/WC</li>
  <li>EG_HTR - Hausanschluss-/Technikraum</li>
  <li>DG_Schlafen - Schlafen</li>
  <li>DG_Kind1 - Kind 1</li>
  <li>DG_Kind2 - Kind 2</li>
  <li>DG_Bad - Bad</li>
  <li>DG_Ankleide - Ankleide</li>
  <li>DG_Empore - Empore</li>
  <li>DA_Spitzboden - unbeheizter Spitzboden (nZonesNonHeated)</li>
</ol>
<p>
  Anders als beim AixLib-HOM ist das Dachgeschoss hier in sechs Zonen geteilt
  und der Spitzboden ueber der Kehlbalkenlage ist unbeheizt. Die Hinweise zur
  Spawn-Installation und zu moeglichen Fehlern aus
  <code>BESMod.Systems.Demand.Building.SpawnHighOrder</code> gelten unveraendert
  (64-Bit-Flag, PATH, keine Leerzeichen im Pfad der Buildings-Bibliothek,
  Zeitschritt im IDF mindestens 6 - hier 12 - und ggf. Solver Cvode statt Dassl).
</p>
<p>
  <b>Luftwechsel:</b> Unter Spawn wird die Luftbilanz der gekoppelten Zonen in
  Modelica geloest. Die Infiltration aus dem IDF (0,05 1/h) wirkt daher nicht;
  der Luftwechsel der beheizten Zonen kommt ueber <code>AirExchangePort</code>
  aus dem Nutzerprofil (<code>useProBus.natVent</code>) bzw. bei
  <code>useConstVentRate = true</code> aus <code>ventRate</code>. Fuer die
  Annahme des IDF also <code>ventRate = fill(0.05, nZones)</code> setzen.
  Der Spitzboden erhaelt konstant 3 1/h (beluefteter Kaltdachraum, wie im IDF).
</p>
<p>
  <b>Offene Durchgaenge:</b> Das IDF enthaelt vier Luftoeffnungen als
  <code>Construction:AirBoundary</code> (Home-Office/Diele, Diele/Wohnen,
  Schlafen/Ankleide sowie das Treppenloch Diele/Empore). Der Waermedurchgang
  und die gemeinsame Strahlungs-Enclosure rechnet EnergyPlus weiterhin; der
  Luftaustausch dieser Oeffnungen wird unter Spawn jedoch nicht an Modelica
  uebergeben. Wer ihn abbilden will, verbindet die Fluid-Ports der betroffenen
  Zonen zusaetzlich mit Komponenten aus
  <code>Buildings.Airflow.Multizone</code> (z. B. <code>DoorOpen</code>
  oder <code>Orifice</code>) und erhoeht dafuer <code>nPorts</code>.
</p>
<p>
  Wichtig: Immer dieselben Wetterdaten in epw- und mos-Format verwenden.
</p>
</html>"));
end SpawnV62;
