within BESMod.Examples.SolarThermalSystem;
model SolarThermalBuildings
  "HPS which is supported by a solar thermal collector"
  extends BESMod.Examples.SolarThermalSystem.PartialSolarThermalHPS(redeclare
      model hydGeneration =
        BESMod.Systems.Hydraulical.Generation.DetailedSolarThermalWithHeatPump
        (
        use_eleHea=false,
        redeclare model PerDataMainHP =
            AixLib.Obsolete.Year2024.DataBase.HeatPump.PerformanceData.VCLibMap
            (refrigerant="Propane", flowsheet="VIPhaseSeparatorFlowsheet"),
        redeclare
          BESMod.Systems.Hydraulical.Generation.RecordsCollection.DefaultHP
          parHeaPum(genDesTyp=BESMod.Systems.Hydraulical.Generation.Types.GenerationDesign.Monovalent),

        redeclare
          BESMod.Systems.Hydraulical.Generation.RecordsCollection.DefaultElectricHeater
          parEleHea,
        redeclare BESMod.Systems.RecordsCollection.Movers.DefaultMover parPum,
        redeclare package Medium_eva = AixLib.Media.Air,
        redeclare
          BESMod.Systems.RecordsCollection.TemperatureSensors.DefaultSensor
          parTemSen,
        redeclare BESMod.Examples.SolarThermalSystem.SolarCollector
          solarThermalParas(
          final A=parameterStudy.A,
          final eta_zero=parameterStudy.eta_zero,
          final c1=parameterStudy.c1,
          final c2=parameterStudy.c2),
        redeclare BESMod.Systems.RecordsCollection.Movers.DefaultMover
          parPumSolThe));

  extends Modelica.Icons.Example;
  annotation (
    experiment(StopTime=172800,
     Interval=600,
     Tolerance=1e-06),
   __Dymola_Commands(file="modelica://BESMod/Resources/Scripts/Dymola/Examples/SolarThermalSystem/SolarThermalBuildings.mos"
        "Simulate and plot"));
end SolarThermalBuildings;
