within BESMod.Examples.ViebrockhausV62;
record V62System
  "System parameters of the Viebrockhaus V62 (Satteldach 40 Grad, Effizienzhaus 40)"
  extends Systems.RecordsCollection.SystemParametersBaseDataDefinition(
    use_elecHeating=false,
    nZones=11,
    filNamWea=Modelica.Utilities.Files.loadResource(
        "modelica://BESMod/Resources/Spawn/Potsdam_TRY2015_normal.mos"),
    use_ventilation=false,
    QBui_flow_nominal={1206.713,318.291,148.561,354.743,10.0,404.780,350.568,
        334.176,364.559,197.899,100.841},
    THydSup_nominal=fill(308.15, nZones),
    TOda_nominal=261.15);

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
  <code>QBui_flow_nominal</code> ist eine Vorabschaetzung der Norm-Heizlast nach
  EN 12831 (Aussentemperatur -12&nbsp;&deg;C, Luftwechsel 0,5&nbsp;1/h, ohne
  Waermebrueckenzuschlag - passend zum Modell, das keine Waermebruecken enthaelt).
  Summe 3,79&nbsp;kW bzw. 28,8&nbsp;W/m&sup2;. Die Werte werden durch das Ergebnis
  von
  <a href=\"modelica://BESMod.Systems.Demand.Building.HeatDemand.CalcHeaDemV62Spawn\">
  CalcHeaDemV62Spawn</a> ersetzt.
</p>
<p>
  Der HTR ist mit 15&nbsp;&deg;C angesetzt und bekommt so viel Waerme aus den
  Nachbarraeumen, dass die rechnerische Heizlast nahezu null ist; wie im
  HOM-Vorbild ist dafuer ein Mindestwert von 10&nbsp;W eingetragen.
</p>
<p>
  <code>THydSup_nominal</code> = 35&nbsp;&deg;C, weil das Haus laut Bauplan eine
  Fussbodenheizung mit Waermepumpe hat (im HOM-Vorbild sind es 55&nbsp;&deg;C
  fuer Heizkoerper im Bestand).
</p></html>"));
end V62System;
