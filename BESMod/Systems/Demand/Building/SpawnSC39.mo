within BESMod.Systems.Demand.Building;
model SpawnSC39
  "Spawn model of the Smart City Haus 39 (Viebrockhaus Maxime 300 mit ELW)"
  extends BESMod.Systems.Demand.Building.BaseClasses.PartialDemand(
    use_hydraulic = true,
    use_ventilation = false,
    ARoo=108.03,
    hBui=7.55,
    ABui=165.52,
    hZone={2.51,2.51,2.51,2.51,2.51,2.51,2.32,2.32,2.35,2.35,2.35},
    AZone={41.14,9.51,4.45,5.06,19.67,2.93,19.79,18.37,15.23,13.15,16.22},
    nZones=11);
  parameter Modelica.Units.SI.Volume VZone[nZones + nZonesNonHeated]={103.26,
      23.86,11.17,12.71,49.38,7.35,45.92,42.62,35.74,30.86,38.09,60.38}
    "Volume of all (heated and unheated) zones"
    annotation (Dialog(group="Geometry"));
  parameter Integer nZonesNonHeated = 1 "Non heated rooms of the building";
  parameter Boolean useConstVentRate=false;
  parameter Real ventRate[nZones]=fill(0, nZones) if useConstVentRate
    "Constant mechanical ventilation rate"
    annotation (Dialog(enable=useConstVentRate));
  parameter String idf_name=Modelica.Utilities.Files.loadResource(
      "modelica://BESMod/Resources/Spawn/SC39_M300_ELW_Spawn.idf")
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
  BESMod.Systems.Demand.Building.Components.SpawnSC39OFD.GroundFloor groundFloor(
      redeclare package Medium = MediumZone, VZones=VZone[1:6])
    annotation (Placement(transformation(extent={{-30,-88},{26,-40}})));
  BESMod.Systems.Demand.Building.Components.SpawnSC39OFD.UpperFloor upperFloor(
      redeclare package Medium = MediumZone, VZones=VZone[7:11])
    annotation (Placement(transformation(extent={{-30,-20},{24,28}})));
  BESMod.Systems.Demand.Building.Components.SpawnSC39OFD.Attic attic(
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
  connect(heatPortRad[1:6], groundFloor.heatPortRad);
  connect(heatPortRad[7:11], upperFloor.heatPortRad);
  connect(heatPortCon[1:6], groundFloor.heatPortCon);
  connect(heatPortCon[7:11], upperFloor.heatPortCon);
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
  connect(portVent_in[1:6], groundFloor.portVent_in);
  connect(portVent_in[7:11], upperFloor.portVent_in);
  connect(portVent_out[1:6], groundFloor.portVent_out);
  connect(portVent_out[7:11], upperFloor.portVent_out);
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
  connect(constVentRate[1:6].y, groundFloor.AirExchangePort);
  connect(constVentRate[7:11].y, upperFloor.AirExchangePort);
  connect(intGainConvRatio.y, intGainConvAreaSpec.u1)
    annotation (Line(points={{69.5,-53},{65,-53},{65,-50}}, color={0,0,127}));
  connect(intGainRadRatio.y, intGainRadAreaSpec.u1)
    annotation (Line(points={{69.5,-71},{65,-71},{65,-68}}, color={0,0,127}));
  connect(roomArea.y, intGainConvAreaSpec.u2) annotation (Line(points={{91.5,-61},
          {65,-61},{65,-56}}, color={0,0,127}));
  connect(roomArea.y, intGainRadAreaSpec.u2) annotation (Line(points={{91.5,-61},
          {88,-61},{88,-80},{65,-80},{65,-74}}, color={0,0,127}));
  connect(intGainRadAreaSpec[1:6].y, groundFloor.IntGainsRad);
  connect(intGainRadAreaSpec[7:11].y, upperFloor.IntGainsRad);
  connect(intGainConvAreaSpec[1:6].y, groundFloor.IntGainsConv);
  connect(intGainConvAreaSpec[7:11].y, upperFloor.IntGainsConv);
  connect(reaPasThrNatVen[1:6].y, groundFloor.AirExchangePort);
  connect(reaPasThrNatVen[7:11].y, upperFloor.AirExchangePort);
  connect(groundFloor.TZoneMea, reaPasThrTZoneMea[1:6].u);
  connect(upperFloor.TZoneMea, reaPasThrTZoneMea[7:11].u);
  connect(reaPasThrTZoneMea.y, reaPasThrTZoneMeaOut[1:11].u);
  connect(attic.TZoneMea, reaPasThrTZoneMeaOut[12].u);
  connect(groundFloor.TZoneOpeMea, reaPasThrTZoneOpeMea[1:6].u);
  connect(upperFloor.TZoneOpeMea, reaPasThrTZoneOpeMea[7:11].u);
  connect(reaPasThrTZoneOpeMea.y, reaPasThrTZoneOpeMeaOut[1:11].u);
  connect(attic.TZoneOpeMea, reaPasThrTZoneOpeMeaOut[12].u);
  connect(groundFloor.TZoneRadMea, reaPasThrTZoneRadMeaOut[1:6].u);
  connect(upperFloor.TZoneRadMea, reaPasThrTZoneRadMeaOut[7:11].u);
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
  Spawn-Modell des Smart City Hauses 39 (Viebrockhaus Maxime 300 mit
  Einliegerwohnung, Satteldach 40&deg;), Weissdornweg 39, 21698 Harsefeld,
  Service-Nr. 90210. Grundlage: Bauplan SC_39_M300_ELW_A1_BAU vom 07.07.2023 und
  Heizlastberechnung nach DIN/TS 12831-1 (Roth/LINEAR, Projekt 280098).
</p>
<p>
  Zonenreihenfolge (Index im Bus / in AZone, hZone, VZone):
</p>
<ol>
  <li>EG_WohnenKochenEssen</li>
  <li>EG_Windfang (mit Treppe)</li>
  <li>EG_Diele</li>
  <li>EG_HTR (Hausanschlussraum, 15 &deg;C)</li>
  <li>ELW_PantryEssenSchlafen (Einliegerwohnung)</li>
  <li>ELW_DuWC (Einliegerwohnung)</li>
  <li>DG_SchlafenAnkleide</li>
  <li>DG_Kind1</li>
  <li>DG_Kind2</li>
  <li>DG_Bad</li>
  <li>DG_Empore</li>
  <li>DA_Spitzboden - unbeheizt (nZonesNonHeated)</li>
</ol>
<p>
  Die Zonen 5 und 6 bilden die Einliegerwohnung. Sie haengen im Modell thermisch
  wie jede andere Zone am selben Gebaeude; wer die ELW als eigene Nutzungseinheit
  regeln will, kann die Indizes 5 und 6 im Bus getrennt ansprechen.
</p>
<p>
  <b>Luftwechsel:</b> Unter Spawn loest Modelica die Luftbilanz. Die Infiltration
  aus dem IDF (0,05 1/h) wirkt nicht; der Luftwechsel kommt ueber
  <code>AirExchangePort</code>. Das Haus hat eine Abluftanlage mit 180 m&sup3;/h
  (150 Hauptwohnung, 30 ELW) ohne Waermerueckgewinnung.
</p>
<p>
  <b>Treppenaufgang:</b> Das IDF enthaelt eine Luftoeffnung
  (<code>Construction:AirBoundary</code>) zwischen EG_Windfang und DG_Empore. Der
  Luftaustausch dieser Oeffnung wird unter Spawn nicht an Modelica uebergeben;
  bei Bedarf ueber <code>Buildings.Airflow.Multizone</code> ergaenzen.
</p>
<p>
  Hinweise zu Spawn-Fehlermeldungen (64-Bit-Flag, PATH, keine Leerzeichen im
  Bibliothekspfad, Zeitschritt mindestens 6 - hier 12, Solver Cvode) gelten
  unveraendert wie bei <code>SpawnHighOrder</code>.
</p></html>"));
end SpawnSC39;
