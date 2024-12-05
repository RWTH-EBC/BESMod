within BESMod.Examples;
package TEASERExport "Example of a building exported with TEASER."
extends Modelica.Icons.ExamplesPackage;

  annotation (Documentation(info="<html>
<p>
  <a href=\"https://github.com/RWTH-EBC/TEASER\">TEASER</a> (Tool for Energy Analysis and Simulation for Efficient Retrofit) 
  allows a fast generation of archetype buildings with low input requirements.
  These buildings can then be exported to BESMod as a <a href=\"BESMod.Systems.Demand.Building.TEASERThermalZone\">BESMod.Systems.Demand.Building.TEASERThermalZone</a> model and inclued it in a energy system.
  In this example you see a part of the exported package form the TEASER example e11_export_besmod_model.py with only one building included. 
</p>
<p>
  For the inclusion here as a BESMod example and regression testing the resources like weather data, internal gains and .mos sripts are changed here.
</html>"));
end TEASERExport;
