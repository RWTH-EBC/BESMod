within BESMod.Examples.SolarThermalSystem;
model SolarThermalBuildings
  "HPS which is supported by a solar thermal collector"
  extends BESMod.Examples.SolarThermalSystem.PartialSolarThermalHPS(redeclare
      model hydGeneration =
        BESMod.Systems.Hydraulical.Generation.DetailedSolarThermalWithHeatPump
        (
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
        redeclare BESMod.Systems.RecordsCollection.Movers.DefaultMover parPum,
        redeclare package MediumEva = AixLib.Media.Air,
        redeclare
          BESMod.Systems.RecordsCollection.TemperatureSensors.DefaultSensor
          parTemSen,
        redeclare BESMod.Examples.SolarThermalSystem.SolarCollector
          solarThermalParas(
          final A=parameterStudy.A,
          final eta_zero=parameterStudy.eta_zero,
          final c1=parameterStudy.c1,
          final c2=parameterStudy.c2),
        redeclare BESMod.Systems.RecordsCollection.Movers.DefaultMover
          parPumSolThe));

  extends Modelica.Icons.Example;
  annotation (
    experiment(StopTime=172800,
     Interval=600,
     Tolerance=1e-06),
   __Dymola_Commands(file="modelica://BESMod/Resources/Scripts/Dymola/Examples/SolarThermalSystem/SolarThermalBuildings.mos"
        "Simulate and plot"), Documentation(info="<html>
<h4>Information</h4>
<p>Model of a heat pump system (HPS) supported by a solar thermal collector. 
This model extends a partial model for solar thermal heat pump systems and 
uses a detailed solar thermal system with heat pump for the hydraulic generation subsystem.
</p>

<h4>Important Parameters</h4>
<ul>
  <li>Solar collector parameters (configurable via parameterStudy record):
    <ul>
      <li>A - Collector area </li>
      <li>eta_zero - Peak collector efficiency</li>
      <li>c1 - Linear heat loss coefficient</li>
      <li>c2 - Quadratic heat loss coefficient</li> 
    </ul>
  </li>
</ul>

<p>Uses components from:</p>
<ul>
  <li><a href=\"modelica://BESMod.Systems.Hydraulical.Generation.DetailedSolarThermalWithHeatPump\">BESMod.Systems.Hydraulical.Generation.DetailedSolarThermalWithHeatPump</a></li>
  <li><a href=\"modelica://AixLib.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.TableData3D\">AixLib.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.TableData3D</a></li>
</ul>
</html>"));
end SolarThermalBuildings;
