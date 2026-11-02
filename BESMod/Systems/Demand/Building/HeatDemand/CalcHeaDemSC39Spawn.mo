within BESMod.Systems.Demand.Building.HeatDemand;
model CalcHeaDemSC39Spawn
  "Calculate the heat demand for the Spawn model of the Smart City Haus 39"
  extends Modelica.Icons.Example;
  extends PartialCalcHeatingDemand(
    redeclare BESMod.Systems.UserProfiles.AixLibHighOrderProfiles heaDemSce(
      redeclare AixLib.DataBase.Profiles.Ventilation2perDayMean05perH venPro,
      redeclare AixLib.DataBase.Profiles.SetTemperaturesVentilation2perDay
        TSetProfile,
      gain=0),
    TN_heater=1,
    KR_heater=10000,
    h_heater=fill(100000, building.nZones),
    redeclare BESMod.Examples.SmartCityHaus39.SC39System systemParameters(
      QBui_flow_nominal={1231.0,68.0,177.0,10.0,669.0,128.0,567.0,549.0,534.0,
          495.0,99.0},
      TOda_nominal=265.75,
      TSetZone_nominal(each displayUnit="K") = {293.15,293.15,293.15,288.15,
        293.15,293.15,293.15,293.15,293.15,297.15,293.15},
      THydSup_nominal=fill(273.15 + 35, building.nZones),
      filNamWea=Modelica.Utilities.Files.loadResource(
          "modelica://BESMod/Resources/Spawn/Harsefeld_HeatLoad_m7_4.mos")),
    redeclare BESMod.Systems.Demand.Building.SpawnSC39 building(
      nZones=systemParameters.nZones,
      TOda_nominal=systemParameters.TOda_nominal,
      useConstVentRate=true,
      ventRate={0.595,0.054,0.179,0.252,0.614,0.367,0.767,0.793,0.932,0.272,
          0.121},
      idf_name=Modelica.Utilities.Files.loadResource(
          "modelica://BESMod/Resources/Spawn/SC39_M300_ELW_Heizlast.idf"),
      epw_name=Modelica.Utilities.Files.loadResource(
          "modelica://BESMod/Resources/Spawn/Harsefeld_HeatLoad_m7_4.epw"),
      wea_name=systemParameters.filNamWea),
    heaterCooler(each Heater_on=true));

  annotation (Documentation(info="<html>
<p>
  Berechnet die Heizlast des Smart City Hauses 39 nach EN 12831, analog zu
  <a href=\"modelica://BESMod.Systems.Demand.Building.HeatDemand.CalcHeaDemHOMSpawn\">
  CalcHeaDemHOMSpawn</a>. Alle Randbedingungen stammen aus der Heizlastberechnung
  nach DIN/TS 12831-1 (Roth/LINEAR, Projekt 280098 vom 01.09.2023).
</p>
<h4>Uebernommene Randbedingungen</h4>
<ul>
  <li>Auslegungsaussentemperatur <b>-7,4 &deg;C</b></li>
  <li>Auslegungsinnentemperaturen: alle Raeume 20 &deg;C, Bad 24 &deg;C,
      HTR 15 &deg;C (Formblatt V1)</li>
  <li>Luftwechsel je Zone aus den Aussenluft-Volumenstroemen (Formblatt Z3,
      q<sub>v,env,i</sub>): 61,4 m&sup3;/h Wohnen, 35,2 Schlafen/Ankleide,
      33,8 Kind 1, 33,3 Kind 2, 30,3 ELW, 8,4 Bad, 4,6 Empore, 3,2 HTR,
      2,7 ELW-Dusche/WC, 2,0 Diele, 1,3 Windfang. Uebernommen ist der
      <i>Volumenstrom</i>, umgerechnet auf die Zonenvolumina des Modells.</li>
  <li>Erdreichtemperatur 9,2 &deg;C (Jahresmittel)</li>
  <li>U-Werte aller Bauteile inklusive Waermebrueckenzuschlag 0,01 W/(m&sup2;K)</li>
</ul>
<h4>Benoetigte Wetterdateien</h4>
<p>
  Wetterdatei mit konstant <b>-7,4 &deg;C</b>:
  <code>Harsefeld_HeatLoad_m7_4.epw</code> und <code>.mos</code>, zu erzeugen mit
  <code>BESMod/Resources/Spawn/HeatLoad_Tamb_Replacement.py</code>.
</p>
<h4>Vergleichswerte der Berechnung</h4>
<table border=\"1\">
<tr><th>Raum</th><th>&theta;int</th><th>&Phi;HL</th></tr>
<tr><td>Wohnen/Kochen/Essen</td><td>20 &deg;C</td><td>1231 W</td></tr>
<tr><td>Windfang</td><td>20 &deg;C</td><td>68 W</td></tr>
<tr><td>Diele</td><td>20 &deg;C</td><td>177 W</td></tr>
<tr><td>HTR</td><td>15 &deg;C</td><td>-48 W</td></tr>
<tr><td>ELW Pantry/Essen/Schlafen</td><td>20 &deg;C</td><td>669 W</td></tr>
<tr><td>ELW Dusche/WC</td><td>20 &deg;C</td><td>128 W</td></tr>
<tr><td>Schlafen/Ankleide</td><td>20 &deg;C</td><td>567 W</td></tr>
<tr><td>Kind 1</td><td>20 &deg;C</td><td>549 W</td></tr>
<tr><td>Kind 2</td><td>20 &deg;C</td><td>534 W</td></tr>
<tr><td>Bad</td><td>24 &deg;C</td><td>495 W</td></tr>
<tr><td>Empore</td><td>20 &deg;C</td><td>99 W</td></tr>
<tr><td><b>Gebaeudeheizlast</b></td><td></td><td><b>4132 W</b> (26,9 W/m&sup2;)</td></tr>
</table>
<p>
  Eigene Nachrechnung mit denselben Randbedingungen: 3827 W. Die Abweichung von
  rund 10 % gegenueber der Gebaeudeheizlast entsteht vor allem dadurch, dass
  DIN/TS 12831 mit Aussenmaassen rechnet (Huellflaeche 345,3 m&sup2;) und das
  Modell mit Innenmaassen, und dass die Ueberstroemung zwischen den Raeumen
  (HTR -84 W, Bad +67 W) unter Spawn nicht abgebildet wird.
</p>
<p>
  Hinweis: <code>AixLibHighOrderProfiles</code> enthaelt fest dimensionierte
  Felder mit 10 Elementen; mit <code>nZones = 11</code> kann das einen
  Dimensionsfehler geben - siehe die Dokumentation zu SpawnSC39.
</p>
</html>"), experiment(
      StopTime=25920000,
      Interval=600,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"));
end CalcHeaDemSC39Spawn;
