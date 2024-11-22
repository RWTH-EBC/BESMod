within BESMod.Systems.Hydraulical.Control.Components.BuildingSupplyTemperatureSetpoints.BaseClasses.Functions;
function ConstantGradientHeatCurve "Linear heating curve"
  extends BESMod.Systems.Hydraulical.Control.Components.BuildingSupplyTemperatureSetpoints.BaseClasses.Functions.PartialHeatingCurve;
protected
  Real graTSupAtTOda_nominal =  (1/nHeaTra * ((TSup_nominal + TRet_nominal)/2 - TRoom) + (
    TSup_nominal - TRet_nominal)/2) / (THeaThr - TOda_nominal);
algorithm
  TSup := TSup_nominal - graTSupAtTOda_nominal * (TOda - TOda_nominal);
  annotation (Documentation(info="<html>
<p>
  A simple heating curve with a constant gradient based on nominal
  parameters. The gradient is calculated using nominal supply
  temperature <code>TSup_nominal</code>, nominal outdoor temperature
  <code>TOda_nominal</code>, nominal return temperature
  <code>TRet_nominal and heating threshold temperature
  <code>THeaThr</code>.</code>
</p>
<h4>
  Mathematical Description
</h4>
<p>
  The heating curve is defined by the slope
  <code>graTSupAtTOda_nominal</code> which remains constant over the
  whole operating range
</p>
</html>"));
end ConstantGradientHeatCurve;
