within BESMod.Systems.Hydraulical.Generation.RecordsCollection;
record DefaultElectricHeater
  extends
    BESMod.Systems.Hydraulical.Generation.RecordsCollection.EletricHeaterBaseDataDefinition(
    discretizationSteps=0,
    V_hr=0.001,
    eta_hr=0.97,
    dp_nominal(displayUnit="Pa") = 1000);
end DefaultElectricHeater;
