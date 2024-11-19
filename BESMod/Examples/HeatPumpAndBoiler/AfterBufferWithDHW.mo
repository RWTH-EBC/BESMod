within BESMod.Examples.HeatPumpAndBoiler;
model AfterBufferWithDHW
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
      redeclare Systems.Hydraulical.Distribution.TwoStoragesBoilerWithDHW
        distribution(
        redeclare
          BESMod.Systems.RecordsCollection.TemperatureSensors.DefaultSensor
          parTemSen,
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
        "Simulate and plot"), Documentation(info="<html>
<h4>Information</h4>
<p>
This model represents a bivalent heat pump system with boiler integration after the buffer tank including domestic hot water (DHW) support. It extends the <a href=\"modelica://BESMod.Examples.HeatPumpAndBoiler.BaseClasses.PartialHybridSystem\">PartialHybridSystem</a> base class.
</p>

<h4>System Description</h4>
<p>
Key components:
<ul>
  <li>Heat pump with vapor injection phase separator using propane refrigerant</li>
  <li>Boiler integrated after buffer storage tank</li>
  <li>Two storage system with buffer tank and DHW storage</li>
  <li>Bivalent-parallel configuration for heat generation</li>
</ul>
</p>

<h4>Important Parameters</h4>
<p>
<ul>
  <li>TBiv: Bivalence temperature for heat pump operation</li>
  <li>VPerQFlow: Buffer storage volume per nominal heat flow rate</li>
  <li>dTLoadingHC1: Temperature difference for DHW loading (10K)</li>
  <li>dTBoiDHWLoa: Temperature difference for boiler DHW loading (10K)</li>
</ul>
</p>
</html>"));
end AfterBufferWithDHW;
