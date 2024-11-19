within BESMod.Examples.TEASERHeatLoadCalculation;
model Example "Simple example"
  extends PartialCalculation(building(redeclare
        BESMod.Systems.Demand.Building.RecordsCollection.ACoolHeadAndBEStPar.Retrofit1983_SingleDwelling
        oneZoneParam, energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial),
                                                  userProfiles(dTSetBack=3));
  extends Modelica.Icons.Example;

  annotation (
    experiment(StopTime=172800,
     Interval=600,
     Tolerance=1e-06),
   __Dymola_Commands(file="modelica://BESMod/Resources/Scripts/Dymola/Examples/TEASERHeatLoadCalculation/Example.mos"
        "Simulate and plot"), Documentation(info="<html>
<h4>Information</h4>
<p>Simple example model for the heat load calculation. 
Extends from <a href=\"modelica://BESMod.Examples.TEASERHeatLoadCalculation.PartialCalculation\">BESMod.Examples.TEASERHeatLoadCalculation.PartialCalculation</a> 
and uses a single dwelling building model that represents a retrofitted 1983 building.</p>

<h4>Important Parameters</h4>
<ul>
  <li>dTSetBack = 3 K (Night setback temperature difference)</li>
  <li>energyDynamics = FixedInitial (Fixed initialization for energy balance)</li>
</ul>
</html>"));
end Example;
