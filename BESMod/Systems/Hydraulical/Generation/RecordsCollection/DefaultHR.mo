within BESMod.Systems.Hydraulical.Generation.RecordsCollection;
record DefaultHR
  extends
    Systems.Hydraulical.Generation.RecordsCollection.HeatingRodBaseDataDefinition(
    discretizationSteps=0,
    V_hr=0.001,
    eta_hr=0.97,
    dp_nominal(displayUnit="Pa") = 1000);
end DefaultHR;
