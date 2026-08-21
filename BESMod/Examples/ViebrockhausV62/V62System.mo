within BESMod.Examples.ViebrockhausV62;
record V62System
  "System parameters of the Viebrockhaus V62 (Satteldach 40 Grad, Effizienzhaus 40)"
  extends Systems.RecordsCollection.SystemParametersBaseDataDefinition(
    use_elecHeating=false,
    nZones=11,
    filNamWea=Modelica.Utilities.Files.loadResource(
        "modelica://BESMod/Resources/Spawn/Potsdam_TRY2015_normal.mos"),
    use_ventilation=false,
    QBui_flow_nominal={1479.0,400.2,186.8,150.0,10.0,542.0,525.0,493.0,392.0,
        265.0,10.0},
    THydSup_nominal=fill(308.15, nZones),
    TOda_nominal=265.05);

  annotation (Documentation(info="<html><p>
  Systemparameter des Viebrockhauses V62, analog zu
  <a href=\"modelica://BESMod.Examples.HighOrderModel.HOMSystem\">
  BESMod.Examples.HighOrderModel.HOMSystem</a>.
</p>
<p>
  Zonenreihenfolge wie in
  <a href=\"modelica://BESMod.Systems.Demand.Building.SpawnV62\">SpawnV62</a>:
  1 Kochen/Essen/Wohnen, 2 Diele, 3 Home-Office, 4 Dusche/WC, 5 HTR,
  6 Schlafen, 7 Kind 1, 8 Kind 2, 9 Bad, 10 Ankleide, 11 Empore.
</p>
<p>
  <b>Alle Werte stammen aus der Heizlastberechnung nach DIN/TS 12831-1</b>
  (Roth Werke / LINEAR Building 23, Projekt 278384 vom 04.08.2023):
</p>
<ul>
  <li><code>TOda_nominal</code> = 265,05 K = -8,1 &deg;C - Auslegungstemperatur
      am Gebaeudestandort (Referenzort Harsefeld -9,8 &deg;C, Anpassung
      Zeitkonstante +1,7 K bei &tau; = 158,8 h)</li>
  <li><code>QBui_flow_nominal</code> - Raumheizlasten der Berechnung. Die dort
      zusammengefassten Raeume sind auf die Modellzonen aufgeteilt:
      Diele/Home-Office 587 W und Schlafen/Ankleide 807 W jeweils im Verhaeltnis
      der eigenen Nachrechnung. Fuer HTR (-42 W) und Empore (-14 W) weist die
      Berechnung einen Waermeueberschuss aus; wie im HOM-Vorbild steht dort ein
      Mindestwert von 10 W.</li>
  <li><code>THydSup_nominal</code> = 35 &deg;C (Fussbodenheizung mit
      Waermepumpe laut Bauplan; die Berechnung ist fuer das
      Roth-Flaechentemperierungssystem erstellt)</li>
</ul>
<p>
  Summe der Raumheizlasten 4453 W; die Berechnung nennt 4378 W als Summe der
  Raumheizlasten und 4306 W als Gebaeudeheizlast (34,3 W/m&sup2; NGF).
</p></html>"));
end V62System;
