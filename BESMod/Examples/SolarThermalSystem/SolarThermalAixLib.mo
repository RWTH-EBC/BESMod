within BESMod.Examples.SolarThermalSystem;
model SolarThermalAixLib "Solar thermal collector from AixLib"
  extends BESMod.Examples.SolarThermalSystem.PartialSolarThermalHPS(hydraulic(
        redeclare BESMod.Systems.Hydraulical.Generation.SolarThermalBivHP
        generation(
        redeclare model PerDataMainHP =
            AixLib.DataBase.HeatPump.PerformanceData.VCLibMap (refrigerant=
                "Propane", flowsheet="VIPhaseSeparatorFlowsheet"),
        redeclare
          BESMod.Systems.Hydraulical.Generation.RecordsCollection.DefaultHP
          heatPumpParameters(genDesTyp=BESMod.Systems.Hydraulical.Generation.Types.GenerationDesign.BivalentParallel),

        redeclare
          BESMod.Systems.Hydraulical.Generation.RecordsCollection.DefaultHR
          heatingRodParameters,
        redeclare BESMod.Systems.RecordsCollection.Movers.DefaultMover pumpData,

        redeclare package Medium_eva = AixLib.Media.Air,
        redeclare BESMod.Examples.SolarThermalSystem.SolarCollector
          solarThermalParas(
          final A=parameterStudy.A,
          final eta_zero=parameterStudy.eta_zero,
          final c1=parameterStudy.c1,
          final c2=parameterStudy.c2),
        redeclare BESMod.Systems.RecordsCollection.Movers.DefaultMover
          pumpSTData)));
  extends Modelica.Icons.Example;

  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(graphics,
        coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=31536000,
      Interval=600,
      __Dymola_Algorithm="Dassl"));
end SolarThermalAixLib;
