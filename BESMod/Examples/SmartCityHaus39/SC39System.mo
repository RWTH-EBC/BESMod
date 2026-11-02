within BESMod.Examples.SmartCityHaus39;
record SC39System
  "System parameters of the Smart City Haus 39 (Maxime 300 mit ELW)"
  extends Systems.RecordsCollection.SystemParametersBaseDataDefinition(
    use_elecHeating=false,
    nZones=11,
    filNamWea=Modelica.Utilities.Files.loadResource(
        "modelica://BESMod/Resources/Spawn/Potsdam_TRY2015_normal.mos"),
    use_ventilation=false,
    QBui_flow_nominal={1231.0,68.0,177.0,10.0,669.0,128.0,567.0,549.0,534.0,
        495.0,99.0},
    THydSup_nominal=fill(308.15, nZones),
    TOda_nominal=265.75);

  annotation (Documentation(info="<html><p>
  Systemparameter des Smart City Hauses 39, analog zu
  <a href=\"modelica://BESMod.Examples.HighOrderModel.HOMSystem\">HOMSystem</a>.
</p>
<p>
  Alle Werte stammen aus der Heizlastberechnung nach DIN/TS 12831-1
  (Roth Werke / LINEAR Building 23, Projekt 280098 vom 01.09.2023):
</p>
<ul>
  <li><code>TOda_nominal</code> = 265,75 K = -7,4 &deg;C - Auslegungstemperatur am
      Gebaeudestandort (Referenzort Harsefeld -9,8 &deg;C, Anpassung Zeitkonstante
      +2,4 K bei &tau; = 201,7 h)</li>
  <li><code>QBui_flow_nominal</code> - Raumheizlasten der Berechnung, Zone fuer Zone
      uebernommen. Der HTR weist dort -48 W aus (Waermeueberschuss aus den
      Nachbarraeumen); wie im HOM-Vorbild steht ein Mindestwert von 10 W.</li>
  <li><code>THydSup_nominal</code> = 35 &deg;C (Roth-Flaechentemperierung mit
      Waermepumpe)</li>
</ul>
<p>
  Summe der Raumheizlasten 4527 W; die Berechnung nennt 4469 W als Summe der
  Raumheizlasten und <b>4132 W als Gebaeudeheizlast</b> (26,9 W/m&sup2; NGF).
</p></html>"));
end SC39System;
