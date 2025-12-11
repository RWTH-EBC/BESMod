within BESMod.Examples.TEASERHeatLoadCalculation;
model Example "Simple example"
  extends PartialCalculation(building(redeclare
        BESMod.Systems.Demand.Building.RecordsCollection.ACoolHeadAndBEStPar.Retrofit1983_SingleDwelling
        oneZoneParam, energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial),
                                                  userProfiles(dTSetBack={3}));
  extends Modelica.Icons.Example;

  annotation (
    experiment(StopTime=172800,
     Interval=600,
     Tolerance=1e-06),
   __Dymola_Commands(file="modelica://BESMod/Resources/Scripts/Dymola/Examples/TEASERHeatLoadCalculation/Example.mos"
        "Simulate and plot"));
end Example;
