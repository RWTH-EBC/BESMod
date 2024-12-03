within BESMod.Systems.Hydraulical.Generation.RecordsCollection.HeatPumps;
record DefaultHP "No heat loss, standard pressure loss"
  extends BESMod.Systems.Hydraulical.Generation.RecordsCollection.HeatPumps.Generic(
    GEvaIns=0,
    GEvaOut=0,
    CEva=0,
    use_evaCap=false,
    tauEva=30,
    dpEva_nominal=0,
    dTEva_nominal=3,
    GConIns=0,
    GConOut=0,
    CCon=0,
    use_conCap=false,
    tauCon=30,
    dpCon_nominal(displayUnit="Pa") = 125);

  annotation (Documentation(info="<html>
<p>Record with default parameters for a heat pump model without heat losses and standard pressure losses.</p>

<h4>Important Parameters</h4>
<ul>
  <li><code>GEvaIns</code>, <code>GEvaOut</code>: Thermal conductance at evaporator insulation (inner/outer) set to 0</li>
  <li><code>GConIns</code>, <code>GConOut</code>: Thermal conductance at condenser insulation (inner/outer) set to 0</li>
  <li><code>CEva</code>, <code>CCon</code>: Heat capacity of evaporator/condenser set to 0</li>
  <li><code>use_evaCap</code>, <code>use_conCap</code>: Flags to enable thermal capacity for evaporator/condenser set to false</li>
  <li><code>tauEva</code>, <code>tauCon</code>: Time constant of evaporator/condenser set to 30s</li>
  <li><code>dpEva_nominal</code>: Nominal pressure drop at evaporator set to 0 Pa</li>
  <li><code>dpCon_nominal</code>: Nominal pressure drop at condenser set to 125 Pa</li>
  <li><code>dTEva_nominal</code>: Nominal temperature drop at evaporator set to 3 K</li>
</ul>
</html>"));
end DefaultHP;
