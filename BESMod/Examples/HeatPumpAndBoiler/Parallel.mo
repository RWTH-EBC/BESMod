within BESMod.Examples.HeatPumpAndBoiler;
model Parallel
  "Bivalent Heat Pump Systems with parallel heat generation"
  extends BaseClasses.PartialHybridSystem(redeclare
      BESMod.Systems.Hydraulical.HydraulicSystem hydraulic(redeclare
        Systems.Hydraulical.Generation.HeatPumpAndGasBoilerParallel generation(
        redeclare BESMod.Systems.RecordsCollection.Movers.DefaultMover parPum,
        redeclare
          BESMod.Systems.Hydraulical.Generation.RecordsCollection.DefaultHP
          parHeaPum(
          genDesTyp=BESMod.Systems.Hydraulical.Generation.Types.GenerationDesign.BivalentPartParallel,

          TBiv=parameterStudy.TBiv,
          scalingFactor=hydraulic.generation.parHeaPum.QPri_flow_nominal/
              parameterStudy.QHP_flow_biv,
          dpCon_nominal=0,
          dpEva_nominal=0,
          use_refIne=false,
          refIneFre_constant=0),
        redeclare model PerDataMainHP =
            AixLib.Obsolete.Year2024.DataBase.HeatPump.PerformanceData.VCLibMap
            (
            QCon_flow_nominal=hydraulic.generation.parHeaPum.QPri_flow_nominal,

            refrigerant="Propane",
            flowsheet="VIPhaseSeparatorFlowsheet"),
        redeclare
          BESMod.Systems.RecordsCollection.TemperatureSensors.DefaultSensor
          parTemSen,
        redeclare BESMod.Systems.RecordsCollection.Valves.DefaultThreeWayValve
          parThrWayVal), redeclare
        Systems.Hydraulical.Distribution.DistributionTwoStorageParallel
        distribution(
        redeclare
          BESMod.Systems.Hydraulical.Distribution.RecordsCollection.SimpleStorage.DefaultStorage
          parStoBuf(VPerQ_flow=parameterStudy.VPerQFlow, dTLoadingHC1=0),
        redeclare
          BESMod.Systems.Hydraulical.Distribution.RecordsCollection.SimpleStorage.DefaultStorage
          parStoDHW(dTLoadingHC1=10),
        redeclare BESMod.Systems.RecordsCollection.Valves.DefaultThreeWayValve
          parThrWayVal)));

  extends Modelica.Icons.Example;

  annotation (experiment(StopTime=172800,
     Interval=600,
     Tolerance=1e-06),
   __Dymola_Commands(file="modelica://BESMod/Resources/Scripts/Dymola/Examples/HeatPumpAndBoiler/Parallel.mos"
        "Simulate and plot"));
end Parallel;
