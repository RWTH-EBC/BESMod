within BESMod.Systems.Hydraulical.Control.RecordsCollection;
record DefaultBivHPControl
  extends BivalentHeatPumpControlDataDefinition(
    addSet_dtHeaRodDHW=1,
    dtHeaRodDHW=30*60,
    addSet_dtHeaRodBui=1,
    dtHeaRodBui=30*60,
    dTHysDHW=10,
    dTHysBui=10,
    nMin=0.3,
    dTOffSetHeatCurve=2,
    Ni=0.9,
    T_I=1200,
    k=0.3);
end DefaultBivHPControl;
