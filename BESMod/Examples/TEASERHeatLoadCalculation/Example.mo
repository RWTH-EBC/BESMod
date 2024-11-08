within BESMod.Examples.TEASERHeatLoadCalculation;
model Example "Simple example"
  extends PartialCalculation(building(redeclare
        HeatLoadEstimations.B1970_standard_o0w0r0.B1970_standard_o0w0r0_DataBase.B1970_standard_o0w0r0_SingleDwelling
        oneZoneParam(lightingPowerSpecific=0.5, baseACH=0.3),
                      energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial),
                                                  userProfiles(dTSetBack=2,
        hoursSetBack=5));
  extends Modelica.Icons.Example;

  annotation (
    experiment(
      StopTime=31536000,
      Interval=600,
      Tolerance=1e-06,
      __Dymola_Algorithm="Dassl"),
   __Dymola_Commands(file="modelica://BESMod/Resources/Scripts/Dymola/Examples/TEASERHeatLoadCalculation/Example.mos"
        "Simulate and plot"));
end Example;
