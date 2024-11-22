within BESMod.Systems.Hydraulical.Control.Components.BuildingSupplyTemperatureSetpoints.BaseClasses.Functions;
function IdealHeatingCurve "Ideal heating curve with no linearization"
  extends BESMod.Systems.Hydraulical.Control.Components.BuildingSupplyTemperatureSetpoints.BaseClasses.Functions.PartialHeatingCurve;
protected
  Real QRel = (THeaThr - TOda)/(THeaThr - TOda_nominal);

algorithm
  TSup := TRoom + ((TSup_nominal + TRet_nominal)/2 - TRoom) * QRel^(1/nHeaTra) + (
    TSup_nominal - TRet_nominal)/2*QRel;
end IdealHeatingCurve;
