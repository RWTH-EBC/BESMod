within BESMod.Examples.TEASERHeatLoadCalculation;
model Example "Simple example"
  extends PartialCalculation(building(redeclare
        BESMod.Systems.Demand.Building.RecordsCollection.TABULA.B2015_standard_SingleDwelling
        oneZoneParam(
        AFloor=107.79989,
        hConFloor=2.5,
        nFloor=1,
        RFloor={1/(10*187)},
        RFloorRem=1/(0.37*187),
        CFloor={380000*187},
        HeaterOn=true,
        hHeat=100000,
        CoolerOn=false,
        lCool=-100000),
                      energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial),
    systemParameters(
      TOda_nominal=263.15,
      TSetZone_nominal={295.15},
      filNamWea=Modelica.Utilities.Files.loadResource(
          "modelica://BESMod/Resources/WeatherData/TRY2015_Dudenhofen_Jahr.mos"),
      use_elecHeating=false),
    userProfiles(dTSetBack={3}));
  extends Modelica.Icons.Example;

  annotation (
    experiment(
      StopTime=31536000,
      Interval=3600,
      Tolerance=1e-06,
      __Dymola_Algorithm="Dassl"),
   __Dymola_Commands(file="modelica://BESMod/Resources/Scripts/Dymola/Examples/TEASERHeatLoadCalculation/Example.mos"
        "Simulate and plot"));
end Example;
