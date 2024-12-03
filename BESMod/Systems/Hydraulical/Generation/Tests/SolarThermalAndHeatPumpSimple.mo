within BESMod.Systems.Hydraulical.Generation.Tests;
model SolarThermalAndHeatPumpSimple "Test for SolarThermalAndHeatPumpSimple"
  extends PartialTest(redeclare
      BESMod.Systems.Hydraulical.Generation.SimpleSolarThermalWithHeatPump
      generation(
      redeclare model RefrigerantCycleHeatPumpHeating =
          AixLib.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.TableData2D
          (redeclare
            AixLib.Fluid.HeatPumps.ModularReversible.Data.TableData2D.EN14511.Vitocal251A08
            datTab),
      redeclare
        AixLib.Fluid.HeatPumps.ModularReversible.Controls.Safety.Data.Wuellhorst2021
        safCtrPar,
      redeclare
        BESMod.Systems.Hydraulical.Generation.RecordsCollection.HeatPumps.DefaultHP
        parHeaPum,
      redeclare package MediumEva = IBPSA.Media.Air,
      redeclare
        BESMod.Systems.RecordsCollection.TemperatureSensors.DefaultSensor
        parTemSen,
      redeclare BESMod.Systems.RecordsCollection.Movers.DefaultMover parPum,
      redeclare BESMod.Systems.RecordsCollection.Movers.DefaultMover
        parPumSolThe,
      redeclare
        BESMod.Systems.Hydraulical.Generation.RecordsCollection.SolarThermal.DefaultSolarThermal
        parSolThe,
      redeclare
        BESMod.Systems.Hydraulical.Generation.RecordsCollection.ElectricHeater.DefaultElectricHeater
        parEleHea));

  extends Modelica.Icons.Example;

  Modelica.Blocks.Sources.Constant     const1(k=0)
    annotation (Placement(transformation(extent={{-100,40},{-80,60}})));
  Modelica.Blocks.Sources.Pulse        pulse(period=1800)
    annotation (Placement(transformation(extent={{-40,80},{-20,100}})));
equation
  connect(pulse.y, genControlBus.yHeaPumSet) annotation (Line(points={{-19,90},
          {-14,90},{-14,98},{10,98},{10,74}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(pulse.y, genControlBus.uPump) annotation (Line(points={{-19,90},{-14,
          90},{-14,98},{10,98},{10,74}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(const1.y, genControlBus.uEleHea) annotation (Line(points={{-79,50},{
          -32,50},{-32,48},{10,48},{10,74}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  annotation (Documentation(info="<html>
<p>Test model for a combined solar thermal and heat pump system using a simple control strategy.
The model extends the partial test model and uses a modular heat pump from AixLib combined 
with a solar thermal collector.</p>
</html>"));
end SolarThermalAndHeatPumpSimple;
