within BESMod.Systems.Hydraulical.Components;
model ResistanceCoefficientHydraulicDiameter
  extends IBPSA.Fluid.FixedResistances.HydraulicDiameter(
    dp(start=dp_nominal),
    final fac=1 + (resCoe*rho_default/2*v_nominal^2)/dpStraightPipe_nominal);
  parameter Real resCoe "Resistance coefficient due to pipe bends or similar";
  parameter Modelica.Units.SI.PressureDifference dp_start=dp_nominal
    "Guess value for initial state of pressure drop"
    annotation(Dialog(tab="Initialization"));
  annotation (                              Documentation(info="<html>
  <p>
  This model adds a typical parameter, the resistance coefficient 
  <code>resCoe</code> to enable an easier parameterization of the 
  factor for straight pipes. Source: 
  <a href=\"https://www.pressure-drop.com/help/resistance-coefficient.html\">
  https://www.pressure-drop.com/help/resistance-coefficient.html</a>
  </p>
</html>"));
end ResistanceCoefficientHydraulicDiameter;
