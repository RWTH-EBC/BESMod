within BESMod.Systems.Demand.Building.HeatDemand;
model CalcHeaDemV62Spawn
  "Calculate the heat demand for the Spawn model of the Viebrockhaus V62"
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
    redeclare BESMod.Examples.ViebrockhausV62.V62System systemParameters(
      QBui_flow_nominal={1479.0,400.2,186.8,150.0,10.0,542.0,525.0,493.0,392.0,
          265.0,10.0},
      TOda_nominal=265.05,
      TSetZone_nominal(each displayUnit="K") = {293.15,293.15,293.15,293.15,
        288.15,293.15,293.15,293.15,297.15,293.15,293.15},
      THydSup_nominal=fill(273.15 + 35, building.nZones),
      filNamWea=Modelica.Utilities.Files.loadResource(
          "modelica://BESMod/Resources/Spawn/Harsefeld_HeatLoad_m8_1.mos")),
    redeclare BESMod.Systems.Demand.Building.SpawnV62 building(
      nZones=systemParameters.nZones,
      TOda_nominal=systemParameters.TOda_nominal,
      useConstVentRate=true,
      ventRate={1.013,0.711,0.711,0.210,0.189,0.858,1.233,1.243,0.186,0.858,
          0.071},
      idf_name=Modelica.Utilities.Files.loadResource(
          "modelica://BESMod/Resources/Spawn/V62_Satteldach40_Heizlast.idf"),
      epw_name=Modelica.Utilities.Files.loadResource(
          "modelica://BESMod/Resources/Spawn/Harsefeld_HeatLoad_m8_1.epw"),
      wea_name=systemParameters.filNamWea),
    heaterCooler(each Heater_on=true));

  annotation (Documentation(info="<html>
<p>
  Berechnet die Heizlast des Viebrockhauses V62, analog zu
  <a href=\"modelica://BESMod.Systems.Demand.Building.HeatDemand.CalcHeaDemHOMSpawn\">
  CalcHeaDemHOMSpawn</a>. Saemtliche Randbedingungen sind aus der
  Heizlastberechnung nach DIN/TS 12831-1 uebernommen (Roth Werke /
  LINEAR Building 23, Projekt 278384, 04.08.2023), damit die Ergebnisse direkt
  mit dieser Berechnung verglichen werden koennen.
</p>
<h4>Uebernommene Randbedingungen</h4>
<ul>
  <li>Auslegungsaussentemperatur <b>-8,1 &deg;C</b> (Formblatt G1)</li>
  <li>Auslegungsinnentemperaturen je Raum (Formblatt V1):
      Wohnen/Kochen/Essen, Diele, Home-Office, Dusche/WC, Schlafen, Kind 1,
      Kind 2, Ankleide und Empore 20 &deg;C, Bad 24 &deg;C, HTR 15 &deg;C.
      Achtung: Dusche/WC steht in der Berechnung auf 20 &deg;C, nicht auf 24 &deg;C.</li>
  <li>Luftwechsel je Zone aus den Aussenluft-Volumenstroemen der Berechnung
      (Formblatt Z3, Spalte q<sub>v,env,i</sub>): 92,7 m&sup3;/h Wohnen,
      31,0 Diele/Home-Office, 33,5 Kind 1, 33,3 Kind 2, 42,6 Schlafen/Ankleide,
      3,1 HTR, 2,9 Dusche/WC, 4,9 Bad, 1,2 Empore. Umgerechnet auf die
      Zonenvolumina des Modells ergeben sich die eingetragenen Werte in 1/h -
      es ist also der <i>Volumenstrom</i> uebernommen, nicht der Luftwechsel.
      Das Gebaeude hat eine Abluftanlage mit 210 m&sup3;/h ohne
      Waermerueckgewinnung; die Zuluft stroemt ueber Aussenluftdurchlaesse in
      Wohn- und Schlafraeume nach, die Ablufraeume (HTR, Dusche/WC, Bad)
      erhalten nur Leckageluft und Ueberstroemluft.</li>
  <li>Erdreichtemperatur 9,2 &deg;C (Jahresmittel der Aussentemperatur)</li>
  <li>U-Werte aller Bauteile inklusive Waermebrueckenzuschlag 0,02 W/(m&sup2;K)
      - siehe <code>V62_Satteldach40_Heizlast.idf</code></li>
</ul>
<h4>Benoetigte Wetterdateien</h4>
<p>
  Wie beim HOM-Modell wird eine Wetterdatei mit konstanter Aussentemperatur
  gebraucht, hier <b>-8,1 &deg;C</b> statt -12 &deg;C. Erzeugen Sie
  <code>Harsefeld_HeatLoad_m8_1.epw</code> und <code>.mos</code> aus den
  vorhandenen Dateien mit
  <code>BESMod/Resources/Spawn/HeatLoad_Tamb_Replacement.py</code> bzw. per
  Suchen und Ersetzen.
</p>
<h4>Vergleichswerte der Berechnung</h4>
<table border=\"1\">
<tr><th>Raum</th><th>&theta;int</th><th>&Phi;HL</th></tr>
<tr><td>00/01 Wohnen/Kochen/Essen</td><td>20 &deg;C</td><td>1479 W</td></tr>
<tr><td>00/02 HTR</td><td>15 &deg;C</td><td>-42 W</td></tr>
<tr><td>00/03 Diele/Home-Office</td><td>20 &deg;C</td><td>587 W</td></tr>
<tr><td>00/04 Dusche/WC</td><td>20 &deg;C</td><td>150 W</td></tr>
<tr><td>01/01 Kind 1</td><td>20 &deg;C</td><td>525 W</td></tr>
<tr><td>01/02 Kind 2</td><td>20 &deg;C</td><td>493 W</td></tr>
<tr><td>01/03 Bad</td><td>24 &deg;C</td><td>392 W</td></tr>
<tr><td>01/04 Empore</td><td>20 &deg;C</td><td>-14 W</td></tr>
<tr><td>01/05 Schlafen/Ankleide</td><td>20 &deg;C</td><td>807 W</td></tr>
<tr><td><b>Gebaeudeheizlast</b></td><td></td><td><b>4306 W</b> (34,3 W/m&sup2;)</td></tr>
</table>
<p>
  Hinweise zu Spawn-Fehlermeldungen und zum Profil-Redeclare stehen in
  <a href=\"modelica://BESMod.Systems.Demand.Building.SpawnV62\">SpawnV62</a>.
</p>
</html>"), experiment(
      StopTime=25920000,
      Interval=600,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"));
end CalcHeaDemV62Spawn;
