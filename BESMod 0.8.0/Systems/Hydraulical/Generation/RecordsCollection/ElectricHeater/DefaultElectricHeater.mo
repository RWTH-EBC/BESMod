within BESMod.Systems.Hydraulical.Generation.RecordsCollection.ElectricHeater;
record DefaultElectricHeater "97 % efficiency"
  extends
    BESMod.Systems.Hydraulical.Generation.RecordsCollection.ElectricHeater.Generic(
    discretizationSteps=0,
    V_hr=0.001,
    eta=0.97,
    dp_nominal(displayUnit="Pa") = 1000);
end DefaultElectricHeater;
