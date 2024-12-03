within BESMod.Systems.Electrical;
model DirectGridConnectionSystem
  "Direct grid connection only, no generation or transfer"
  extends BaseClasses.PartialElectricalSystem(
    redeclare final BESMod.Systems.Electrical.Generation.NoGeneration
      generation,
    redeclare final BESMod.Systems.Electrical.Control.NoControl control,
    redeclare final BESMod.Systems.Electrical.Transfer.NoElectricalTransfer
      transfer,
    redeclare final BESMod.Systems.Electrical.Distribution.DirectlyToGrid
      distribution);
  annotation (Documentation(info="<html>
<div>
<p>A simple electrical system model that represents a direct grid 
connection without any local generation, control, storage/transfer 
capabilities or complex distribution. 
All electricity is drawn directly from the power grid.</p>

<h4>Models used</h4>
<p>This model uses default parameters from the following base components:</p>
<ul>
  <li>Generation: <a href=\"modelica://BESMod.Systems.Electrical.Generation.NoGeneration\">BESMod.Systems.Electrical.Generation.NoGeneration</a></li>
  <li>Control: <a href=\"modelica://BESMod.Systems.Electrical.Control.NoControl\">BESMod.Systems.Electrical.Control.NoControl</a></li>
  <li>Transfer: <a href=\"modelica://BESMod.Systems.Electrical.Transfer.NoElectricalTransfer\">BESMod.Systems.Electrical.Transfer.NoElectricalTransfer</a></li>
  <li>Distribution: <a href=\"modelica://BESMod.Systems.Electrical.Distribution.DirectlyToGrid\">BESMod.Systems.Electrical.Distribution.DirectlyToGrid</a></li>
</ul>
</div>
</html>"));
end DirectGridConnectionSystem;
