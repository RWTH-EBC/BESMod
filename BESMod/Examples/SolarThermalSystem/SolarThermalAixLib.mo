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
        redeclare BESMod.Systems.RecordsCollection.Movers.DefaultMover parPum,
        redeclare package MediumEva = AixLib.Media.Air,
        redeclare
          BESMod.Systems.RecordsCollection.TemperatureSensors.DefaultSensor
          parTemSen,
        redeclare BESMod.Examples.SolarThermalSystem.SolarCollector parSolThe(
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
   __Dymola_Commands(file="modelica://BESMod/Resources/Scripts/Dymola/Examples/SolarThermalSystem/SolarThermalAixLib.mos"
        "Simulate and plot"), Documentation(info="<html>
<h4>Information</h4>
<p>Model of a solar thermal system coupled with a heat pump system using components from the AixLib library. 
The model uses a modular reversible heat pump with vapor injection and phase separation using propane as refrigerant. 
The solar thermal collector parameters can be adjusted through the parameterStudy record.</p>

<h4>Important Parameters</h4>
<ul>
  <li>A: Collector area [m²]</li>
  <li>eta_zero: Zero-loss efficiency [-]</li>
  <li>c1: First order heat loss coefficient [W/(m²K)]</li>
  <li>c2: Second order heat loss coefficient [W/(m²K²)]</li>
</ul>

<h4>Model Dependencies</h4>
<ul>
  <li><a href=\"modelica://BESMod.Examples.SolarThermalSystem.PartialSolarThermalHPS\">BESMod.Examples.SolarThermalSystem.PartialSolarThermalHPS</a></li>
  <li><a href=\"modelica://BESMod.Systems.Hydraulical.Generation.SimpleSolarThermalWithHeatPump\">BESMod.Systems.Hydraulical.Generation.SimpleSolarThermalWithHeatPump</a></li>
  <li><a href=\"modelica://AixLib.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.TableData3D\">AixLib.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.TableData3D</a></li>
  <li><a href=\"modelica://BESMod.Examples.SolarThermalSystem.SolarCollector\">BESMod.Examples.SolarThermalSystem.SolarCollector</a></li>
</ul></html>"));
end SolarThermalAixLib;
