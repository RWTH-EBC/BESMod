within BESMod.Systems.Hydraulical.Control.Components.BuildingSupplyTemperatureSetpoints.BaseClasses.Functions;
function ConstantGradientHeatCurve "Linear heating curve"
  extends BESMod.Systems.Hydraulical.Control.Components.BuildingSupplyTemperatureSetpoints.BaseClasses.Functions.PartialHeatingCurve;
protected
  Real graTSupAtTOda_nominal =  (1/nHeaTra * ((TSup_nominal + TRet_nominal)/2 - TRoom) + (
    TSup_nominal - TRet_nominal)/2) / (THeaThr - TOda_nominal);
algorithm
  TSup := TSup_nominal - graTSupAtTOda_nominal * (TOda - TOda_nominal);
end ConstantGradientHeatCurve;
