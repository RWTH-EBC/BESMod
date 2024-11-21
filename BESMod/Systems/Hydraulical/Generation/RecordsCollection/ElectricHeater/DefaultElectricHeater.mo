within BESMod.Systems.Hydraulical.Generation.RecordsCollection.ElectricHeater;
record DefaultElectricHeater "97 % efficiency"
  extends
    BESMod.Systems.Hydraulical.Generation.RecordsCollection.ElectricHeater.Generic(
    discretizationSteps=0,
    V_hr=0.001,
    eta=0.97,
    dp_nominal(displayUnit="Pa") = 1000);
  annotation (Documentation(info="<html>
<p>Record containing default parameters for an electric heating element with 97% efficiency.</p>
<p>The value is based on the assumption in: Vering, C., Maier, L., Breuer, K., Krützfeldt, H., Streblow, R., & Müller, D. (2022). Evaluating heat pump system design methods towards a sustainable heat supply in residential buildings. Applied Energy, 308, 118204.</p>
</html>"));
end DefaultElectricHeater;
