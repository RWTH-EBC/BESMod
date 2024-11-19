within BESMod.Examples.SolarThermalSystem;
record CombiStorage
  extends
    Systems.Hydraulical.Distribution.RecordsCollection.BufferStorage.BufferStorageBaseDataDefinition(
    energyLabel=BESMod.Systems.Hydraulical.Distribution.Types.EnergyLabel.A,
    V(displayUnit="l") = 0.5,
    nLayer=20,
    dTLoadingHC2=5,
    redeclare AixLib.DataBase.Pipes.Copper.Copper_22x1 pipeHC2,
    redeclare AixLib.DataBase.Pipes.Copper.Copper_22x1 pipeHC1);
  annotation (Documentation(info="<html>
<h4>Information</h4>
<p>Base record type for a combined storage tank (combi storage) used in solar thermal systems. The model inherits from <a href=\"modelica://BESMod.Systems.Hydraulical.Distribution.RecordsCollection.BufferStorage.BufferStorageBaseDataDefinition\">BufferStorageBaseDataDefinition</a> which provides the base parameters.</p>
</html>"));
end CombiStorage;
