within BESMod.Examples.SolarThermalSystem;
model SolarThermalAixLib "Solar thermal collector from AixLib"
  extends BESMod.Examples.SolarThermalSystem.PartialSolarThermalHPS(redeclare
      model hydGeneration =
        BESMod.Systems.Hydraulical.Generation.SimpleSolarThermalWithHeatPump (
        use_eleHea=false,
        genDesTyp=BESMod.Systems.Hydraulical.Generation.Types.GenerationDesign.Monovalent,
        redeclare
          BESMod.Systems.Hydraulical.Generation.RecordsCollection.HeatPumps.DefaultHP
          parHeaPum,
        redeclare model RefrigerantCycleHeatPumpHeating =
            AixLib.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.TableData3D
            (y_nominal=0.8, redeclare
              AixLib.Fluid.HeatPumps.ModularReversible.Data.TableDataSDF.TableData3D.VCLibPy.VCLibVaporInjectionPhaseSeparatorPropane
              datTab),

        redeclare
          BESMod.Systems.Hydraulical.Generation.RecordsCollection.ElectricHeater.DefaultElectricHeater
          parEleHea,
        redeclare BESMod.Systems.RecordsCollection.Movers.DPVar parPum,
        redeclare package MediumEva = AixLib.Media.Air,
        redeclare
          BESMod.Systems.RecordsCollection.TemperatureSensors.DefaultSensor
          parTemSen,
        redeclare BESMod.Examples.SolarThermalSystem.SolarCollector parSolThe(
          final A=parameterStudy.A,
          final eta_zero=parameterStudy.eta_zero,
          final c1=parameterStudy.c1,
          final c2=parameterStudy.c2),
        redeclare BESMod.Systems.RecordsCollection.Movers.DPVar parPumSolThe));

  extends Modelica.Icons.Example;
  annotation (
    experiment(StopTime=172800,
     Interval=600,
     Tolerance=1e-06),
   __Dymola_Commands(file="modelica://BESMod/Resources/Scripts/Dymola/Examples/SolarThermalSystem/SolarThermalAixLib.mos"
        "Simulate and plot"));
end SolarThermalAixLib;
