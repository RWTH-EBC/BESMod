within BESMod.Systems.RecordsCollection.Movers;
record DefaultMover
  extends MoverBaseDataDefinition(
    tau=1,
    riseTimeInpFilter=30,
    use_inputFilter=false,
    addPowerToMedium=false);
  annotation (Documentation(info="<html>
<p>Default record for mover/pump characteristics in BESMod.</p>

<h4>Important Parameters</h4>
<ul>
  <li><code>tau</code>: Time constant (1 s) of motor</li>
  <li><code>riseTimeInpFilter</code>: Rise time of the filter (30 s)</li>
  <li><code>use_inputFilter</code>: False - input filter not activated</li>
  <li><code>addPowerToMedium</code>: False - pump power not added to medium</li>
</ul>
</html>"));
end DefaultMover;
