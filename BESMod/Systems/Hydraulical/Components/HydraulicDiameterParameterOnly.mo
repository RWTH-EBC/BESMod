within BESMod.Systems.Hydraulical.Components;
model HydraulicDiameterParameterOnly
  "Fixed flow resistance with hydraulic diameter and m_flow as parameter"
  extends BESMod.Systems.Hydraulical.Components.ResistanceCoefficientHydraulicDiameter(
    disableComputeFlowResistance=true,
    dp_start=0);


annotation (
Documentation(info="<html>
<p>
This model indicates that the pressure loss is not calculated but propagated to another dpFixed_nominal in a valve.
</p>
</html>", revisions="<html>
<ul>
<li>
July 29, 2025, by Fabian Wuellhorst:<br/>
First implementation for
<a href=\"https://github.com/RWTH-EBC/BESMod/issues/77\">#77</a>.
</li>
</ul>
</html>"));
end HydraulicDiameterParameterOnly;
