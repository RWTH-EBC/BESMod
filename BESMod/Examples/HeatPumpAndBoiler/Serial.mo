within BESMod.Examples.HeatPumpAndBoiler;
model Serial "Bivalent Heat Pump Systems with serial heat generation"
  extends BaseClasses.PartialHybridSystem(redeclare
      BESMod.Systems.Hydraulical.HydraulicSystem hydraulic(redeclare
        Systems.Hydraulical.Generation.HeatPumpAndGasBoilerSerial generation(
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
          parTemSen), redeclare
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
   __Dymola_Commands(file="modelica://BESMod/Resources/Scripts/Dymola/Examples/HeatPumpAndBoiler/Serial.mos"
        "Simulate and plot"), Documentation(info="<html>
<h4>Information</h4>
<p>
This model represents a bivalent heating system with serial arrangement of a heat pump and gas boiler. The system uses modular components for modeling the heating supply system with two storages in parallel arrangement for both buffer and domestic hot water storage.
</p>

<h4>Important Parameters</h4>
<ul>
<li>TBiv: Bivalence temperature for heat pump operation</li>
<li>VPerQFlow: Storage volume per nominal heat flow for buffer storage dimensioning</li>
<li>dTLoadingHC1: Temperature difference for DHW loading (10K)</li>
</ul>

<p>Key components:</p>
<ul>
<li>Heat pump model using <a href=\"modelica://AixLib.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.TableData3D\">AixLib table-based heat pump</a> with vapor injection</li>
<li>Two storage system: Buffer storage and DHW storage arranged in parallel</li>

</ul>
</html>"));
end Serial;
