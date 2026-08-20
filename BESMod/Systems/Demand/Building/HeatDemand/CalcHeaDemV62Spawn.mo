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
      QBui_flow_nominal={1206.713,318.291,148.561,354.743,10.0,404.780,350.568,
          334.176,364.559,197.899,100.841},
      TOda_nominal=261.15,
      TSetZone_nominal(each displayUnit="K") = {293.15,293.15,293.15,297.15,
        288.15,293.15,293.15,293.15,297.15,293.15,293.15},
      THydSup_nominal=fill(273.15 + 35, building.nZones),
      filNamWea=Modelica.Utilities.Files.loadResource(
          "modelica://BESMod/Resources/Spawn/Potsdam_HeatLoad.mos")),
    redeclare BESMod.Systems.Demand.Building.SpawnV62 building(
      nZones=systemParameters.nZones,
      TOda_nominal=systemParameters.TOda_nominal,
      useConstVentRate=true,
      ventRate=fill(0.5, systemParameters.nZones),
      epw_name=Modelica.Utilities.Files.loadResource(
          "modelica://BESMod/Resources/Spawn/Potsdam_HeatLoad.epw"),
      wea_name=systemParameters.filNamWea),
    heaterCooler(each Heater_on=true));

  annotation (Documentation(info="<html>
<p>
  Berechnet die Heizlast des Viebrockhauses V62 nach EN 12831, analog zu
  <a href=\"modelica://BESMod.Systems.Demand.Building.HeatDemand.CalcHeaDemHOMSpawn\">
  CalcHeaDemHOMSpawn</a>.
</p>
<p>
  Es werden dieselben Wetterdateien mit konstanter Aussentemperatur verwendet wie
  beim HOM-Modell (<code>Potsdam_HeatLoad.epw</code> / <code>.mos</code>,
  -12&nbsp;&deg;C). Wer eine andere Norm-Aussentemperatur braucht, muss sie auch
  in der epw-Datei aendern - dafuer gibt es
  <code>BESMod/Resources/Spawn/HeatLoad_Tamb_Replacement.py</code>.
</p>
<p>
  Zonenreihenfolge und Sollwerte:
</p>
<ol>
  <li>EG_WohnenKochen - 20 &deg;C</li>
  <li>EG_Diele - 20 &deg;C (offen zum Wohnbereich, daher kein Flurwert von 15 &deg;C)</li>
  <li>EG_HomeOffice - 20 &deg;C</li>
  <li>EG_DuscheWC - 24 &deg;C</li>
  <li>EG_HTR - 15 &deg;C</li>
  <li>DG_Schlafen - 20 &deg;C</li>
  <li>DG_Kind1 - 20 &deg;C</li>
  <li>DG_Kind2 - 20 &deg;C</li>
  <li>DG_Bad - 24 &deg;C</li>
  <li>DG_Ankleide - 20 &deg;C (tuerlos zum Schlafzimmer)</li>
  <li>DG_Empore - 20 &deg;C (offen ueber das Treppenloch)</li>
</ol>
<p>
  Zonen, die im Modell ueber <code>Construction:AirBoundary</code> offen
  miteinander verbunden sind, haben bewusst denselben Sollwert - eine
  Temperaturdifferenz waere dort physikalisch nicht haltbar.
</p>
<p>
  <b>Zu pruefen vor dem ersten Lauf:</b>
  <code>BESMod.Systems.UserProfiles.AixLibHighOrderProfiles</code> enthaelt fuer
  Solltemperatur und Lueftung fest dimensionierte Felder mit 10 Elementen und
  liest die inneren Gewinne mit <code>columns=2:nZones+1</code> aus einer
  Datentabelle des AixLib-HOM. Mit <code>nZones = 11</code> kann das zu einem
  Dimensionsfehler fuehren. Falls die Uebersetzung fehlschlaegt: eine Kopie des
  Profils anlegen, die festen <code>[10]</code> durch <code>[nZones]</code>
  ersetzen und die Gewinn-Tabelle um eine elfte Zonenspalte ergaenzen (die Werte
  sind wegen <code>gain=0</code> ohne Wirkung, nur die Spaltenzahl zaehlt).
</p>
<p>
  Weitere Hinweise zu Spawn-Fehlermeldungen stehen in
  <a href=\"modelica://BESMod.Systems.Demand.Building.SpawnV62\">SpawnV62</a>.
</p>
</html>"), experiment(
      StopTime=25920000,
      Interval=600,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"));
end CalcHeaDemV62Spawn;
