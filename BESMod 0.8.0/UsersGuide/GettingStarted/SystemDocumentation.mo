within BESMod.UsersGuide.GettingStarted;
model SystemDocumentation "Aggregation to a system"

  annotation(Documentation(info="<html>
<p>If you want to compose an aggregated subsystem, e.g. a hydraulic subsystem:</p>
<p>1. Extend the Partial subsystem</p>
<p>2. Redeclare the replaceable modules with your choices</p>
<p>3. Propagate parameters if necessary</p>
<p>4. Link parameters between subsystems. For instance, the bivalence temperature of the generation system may be set equal to the control temperature.</p>
<p>5. Use your own system in the overall building energy simulation.</p>
</html>"));
end SystemDocumentation;
