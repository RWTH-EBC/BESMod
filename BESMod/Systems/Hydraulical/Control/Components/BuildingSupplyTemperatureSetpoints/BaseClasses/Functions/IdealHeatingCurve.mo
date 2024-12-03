within BESMod.Systems.Hydraulical.Control.Components.BuildingSupplyTemperatureSetpoints.BaseClasses.Functions;
function IdealHeatingCurve "Ideal heating curve with no linearization"
  extends BESMod.Systems.Hydraulical.Control.Components.BuildingSupplyTemperatureSetpoints.BaseClasses.Functions.PartialHeatingCurve;
protected
  Real QRel = (THeaThr - TOda)/(THeaThr - TOda_nominal);

algorithm
  TSup := TRoom + ((TSup_nominal + TRet_nominal)/2 - TRoom) * QRel^(1/nHeaTra) + (
    TSup_nominal - TRet_nominal)/2*QRel;
  annotation (Documentation(info="<html>
<p>The IdealHeatingCurve function calculates a heating supply temperature setpoint 
based on the outdoor temperature. 
The curve represents an ideal heating curve without any linearization. 
The heat transfer from the heating system to the room is modeled using a power law.
</p>
</html>"));
end IdealHeatingCurve;
