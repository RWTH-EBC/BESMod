within BESMod.Systems.Hydraulical.Components;
model ResistanceCoefficientHydraulicDiameterDPFixed
  "Flow resistance to be used in dpFixed_nominal"
  extends BESMod.Systems.Hydraulical.Components.ResistanceCoefficientHydraulicDiameter(
    final disableComputeFlowResistance=true,
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
end ResistanceCoefficientHydraulicDiameterDPFixed;
