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

end DefaultHP;
