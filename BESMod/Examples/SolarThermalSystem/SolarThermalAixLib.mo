within BESMod.Examples.SolarThermalSystem;
model SolarThermalAixLib "Solar thermal collector from AixLib"
  extends BESMod.Examples.SolarThermalSystem.PartialSolarThermalHPS(redeclare
      model hydGeneration =
        BESMod.Systems.Hydraulical.Generation.SolarThermalBivHPAixLib (
        use_heaRod=false,
        redeclare model PerDataMainHP =
            AixLib.DataBase.HeatPump.PerformanceData.VCLibMap (refrigerant=
                "Propane", flowsheet="VIPhaseSeparatorFlowsheet"),
        redeclare
          BESMod.Systems.Hydraulical.Generation.RecordsCollection.DefaultHP
          heatPumpParameters(genDesTyp=BESMod.Systems.Hydraulical.Generation.Types.GenerationDesign.Monovalent),

        redeclare
          BESMod.Systems.Hydraulical.Generation.RecordsCollection.DefaultHR
          heatingRodParameters,
        redeclare BESMod.Systems.RecordsCollection.Movers.DefaultMover pumpData,

        redeclare package Medium_eva = AixLib.Media.Air,
        redeclare
          BESMod.Systems.RecordsCollection.TemperatureSensors.DefaultSensor
          temperatureSensorData,
        redeclare BESMod.Examples.SolarThermalSystem.SolarCollector
          solarThermalParas(
          final A=parameterStudy.A,
          final eta_zero=parameterStudy.eta_zero,
          final c1=parameterStudy.c1,
          final c2=parameterStudy.c2),
        redeclare BESMod.Systems.RecordsCollection.Movers.DefaultMover
          pumpSTData));

  extends Modelica.Icons.Example;

end SolarThermalAixLib;
