within BESMod.Examples.SolarThermalSystem;
model SolarThermalAixLib "Solar thermal collector from AixLib"
  extends BESMod.Examples.SolarThermalSystem.PartialSolarThermalHPS(redeclare
      model hydGeneration =
        BESMod.Systems.Hydraulical.Generation.SimpleSolarThermalWithHeatPump (
        use_heaRod=false,
        redeclare model PerDataMainHP =
            AixLib.DataBase.HeatPump.PerformanceData.VCLibMap (refrigerant=
                "Propane", flowsheet="VIPhaseSeparatorFlowsheet"),
        redeclare
          BESMod.Systems.Hydraulical.Generation.RecordsCollection.DefaultHP
          parHeaPum(genDesTyp=BESMod.Systems.Hydraulical.Generation.Types.GenerationDesign.Monovalent),
        redeclare
          BESMod.Systems.Hydraulical.Generation.RecordsCollection.DefaultHR
          parHeaRod,
        redeclare BESMod.Systems.RecordsCollection.Movers.DefaultMover parPum,
        redeclare package Medium_eva = AixLib.Media.Air,
        redeclare
          BESMod.Systems.RecordsCollection.TemperatureSensors.DefaultSensor
          parTemSen,
        redeclare BESMod.Examples.SolarThermalSystem.SolarCollector parSolThe(
          final A=parameterStudy.A,
          final eta_zero=parameterStudy.eta_zero,
          final c1=parameterStudy.c1,
          final c2=parameterStudy.c2),
        redeclare BESMod.Systems.RecordsCollection.Movers.DefaultMover
          parPumSolThe));

  extends Modelica.Icons.Example;

end SolarThermalAixLib;
