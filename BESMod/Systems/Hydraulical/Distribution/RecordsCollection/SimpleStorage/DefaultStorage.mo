within BESMod.Systems.Hydraulical.Distribution.RecordsCollection.SimpleStorage;
record DefaultStorage "Default storage data"
  extends SimpleStorageBaseDataDefinition(
    energyLabel=BESMod.Systems.Hydraulical.Distribution.Types.EnergyLabel.B,
    kappa=0.4,
    beta=350e-6);
  annotation (Documentation(info="<html>
<p>Default storage model that extends the 
<a href=\"modelica://BESMod.Systems.Hydraulical.Distribution.RecordsCollection.SimpleStorage.SimpleStorageBaseDataDefinition\">SimpleStorageBaseDataDefinition</a> 
with predefined values for:
</p>
<ul>
  <li>Energy efficiency label: B</li>
  <li>Heat transfer coefficient (kappa): 0.4 W/(m^2K)</li>
  <li>Volume expansion coefficient (beta): 350e-6 1/K</li>
</ul>
</html>"));
end DefaultStorage;
