within BESMod.Examples.HeatPumpAndBoiler;
model AfterBufferWithDHW
  "Bivalent Heat Pump System with boiler integration after buffer tank without DHW support"
  extends BaseClasses.PartialHybridSystem(
    redeclare BESMod.Systems.Hydraulical.HydraulicSystem hydraulic(
      redeclare Systems.Hydraulical.Generation.HeatPump
        generation(
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
            AixLib.DataBase.HeatPump.PerformanceData.VCLibMap (
            QCon_flow_nominal=hydraulic.generation.parHeaPum.QPri_flow_nominal,
            refrigerant="Propane",
            flowsheet="VIPhaseSeparatorFlowsheet"),
        redeclare
          BESMod.Systems.RecordsCollection.TemperatureSensors.DefaultSensor
          parTemSen),
      control(boiInGeneration=false),
      redeclare Systems.Hydraulical.Distribution.TwoStoragesBoilerWithDHW
        distribution(
        redeclare
          BESMod.Systems.RecordsCollection.TemperatureSensors.DefaultSensor
          parTemSen(initType=Modelica.Blocks.Types.Init.InitialOutput),
        redeclare
          BESMod.Systems.Hydraulical.Distribution.RecordsCollection.BufferStorage.DefaultDetailedStorage
          parStoBuf(VPerQ_flow=parameterStudy.VPerQFlow),
        redeclare
          BESMod.Systems.Hydraulical.Distribution.RecordsCollection.BufferStorage.DefaultDetailedStorage
          parStoDHW(dTLoadingHC1=10),
        redeclare BESMod.Systems.RecordsCollection.Valves.DefaultThreeWayValve
          parThrWayVal,
        dTBoiDHWLoa=10,
        redeclare BESMod.Systems.RecordsCollection.Movers.DefaultMover parPum,
        redeclare BESMod.Systems.RecordsCollection.Valves.DefaultThreeWayValve
          parThrWayValBoi,
        redeclare
          BESMod.Systems.Hydraulical.Distribution.RecordsCollection.BufferStorage.DefaultDetailedStorage
          parHydSep)));

  extends Modelica.Icons.Example;

  annotation (experiment(StopTime=172800,
     Interval=600,
     Tolerance=1e-06),
   __Dymola_Commands(file="modelica://BESMod/Resources/Scripts/Dymola/Examples/HeatPumpAndBoiler/AfterBufferWithDHW.mos"
        "Simulate and plot"));
end AfterBufferWithDHW;
