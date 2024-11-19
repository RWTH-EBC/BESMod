within BESMod.Examples.HeatPumpAndBoiler;
model AfterBufferWithoutDHW
  "Bivalent Heat Pump System with boiler integration after buffer tank without DHW support"
  extends BaseClasses.PartialHybridSystem(redeclare
      BESMod.Systems.Hydraulical.HydraulicSystem hydraulic(
      redeclare Systems.Hydraulical.Generation.HeatPump generation(
        redeclare BESMod.Systems.RecordsCollection.Movers.DefaultMover parPum,
        TBiv=parameterStudy.TBiv,
        redeclare
          BESMod.Systems.Hydraulical.Generation.RecordsCollection.HeatPumps.DefaultHP
          parHeaPum,
        redeclare model RefrigerantCycleHeatPumpHeating =
            AixLib.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.TableData3D
            (y_nominal=0.8, redeclare
              AixLib.Fluid.HeatPumps.ModularReversible.Data.TableDataSDF.TableData3D.VCLibPy.VCLibVaporInjectionPhaseSeparatorPropane
              datTab),
        redeclare
          BESMod.Systems.RecordsCollection.TemperatureSensors.DefaultSensor
          parTemSen,
        genDesTyp=BESMod.Systems.Hydraulical.Generation.Types.GenerationDesign.BivalentPartParallel),
      control(boiInGeneration=false),
      redeclare Systems.Hydraulical.Distribution.TwoStoDetailedDirectLoading
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
        heaAftBufTyp=BESMod.Systems.Hydraulical.Distribution.Types.HeaterType.Boiler)));

  extends Modelica.Icons.Example;


  annotation (experiment(StopTime=172800,
     Interval=600,
     Tolerance=1e-06),
   __Dymola_Commands(file="modelica://BESMod/Resources/Scripts/Dymola/Examples/HeatPumpAndBoiler/AfterBufferWithoutDHW.mos"
        "Simulate and plot"), Documentation(info="<html>
<h4>Information</h4>
<p>This model represents a bivalent heat pump system with a boiler integration after the buffer tank. The system does not include domestic hot water (DHW) support by the boiler. It extends from a partial hybrid system base class.</p>

<h4>System Configuration</h4>
<p>The hydraulic system consists of:</p>
<ul>
  <li>Heat pump generation system with:
    <ul>
      <li>Bivalent parallel operation with boiler</li>
      <li>Vapor injection heat pump using propane refrigerant</li>
      <li>Performance based on 3D table data</li>
    </ul>
  </li>
  <li>Distribution system with:
    <ul>
      <li>Detailed buffer storage with direct loading</li>
      <li>Three-way valve control</li>
      <li>Boiler integration after buffer storage</li>
    </ul>
  </li>
</ul>

<h4>Important Parameters</h4>
<ul>
  <li><code>TBiv</code>: Bivalent temperature point</li>
  <li><code>VPerQFlow</code>: Storage volume per heat flow rate</li>
</ul>
</html>"));
end AfterBufferWithoutDHW;
