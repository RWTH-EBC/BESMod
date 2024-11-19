within BESMod.Examples.HeatPumpAndBoiler;
model Parallel
  "Bivalent Heat Pump Systems with parallel heat generation"
  extends BaseClasses.PartialHybridSystem(redeclare
      BESMod.Systems.Hydraulical.HydraulicSystem hydraulic(redeclare
        Systems.Hydraulical.Generation.HeatPumpAndGasBoilerParallel generation(
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
        "Simulate and plot"), Documentation(info="<html>
<h4>Information</h4>
<p>
This model implements a bivalent heating system with parallel heat generation using a heat pump and gas boiler. The system includes two storage tanks - one buffer storage for heating and one for domestic hot water (DHW).
</p>

<h4>Important Parameters</h4>
<ul>
  <li>TBiv: Bivalence temperature for heat pump operation</li>
  <li>VPerQFlow: Specific storage volume per heat flow rate</li>
  <li>dTLoadingHC1: Temperature difference for loading heating circuit 1
    <ul>
      <li>Buffer storage: 0K</li>
      <li>DHW storage: 10K</li>
    </ul>
  </li>
</ul>

<p>Key components:</p>
<ul>
  <li>Generation: <a href=\"modelica://BESMod.Systems.Hydraulical.Generation.HeatPumpAndGasBoilerParallel\">HeatPumpAndGasBoilerParallel</a></li>
  <li>Distribution: <a href=\"modelica://BESMod.Systems.Hydraulical.Distribution.DistributionTwoStorageParallel\">DistributionTwoStorageParallel</a></li>
  <li>Heat Pump: Uses table-based heat pump model with vapor injection and phase separator using propane as refrigerant</li>
</ul>
</html>"));
end Parallel;
