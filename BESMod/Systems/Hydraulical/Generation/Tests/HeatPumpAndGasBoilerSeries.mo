within BESMod.Systems.Hydraulical.Generation.Tests;
model HeatPumpAndGasBoilerSeries
  "Test case for serial heat pump and gas boiler"
  extends PartialTest(redeclare
      BESMod.Systems.Hydraulical.Generation.HeatPumpAndGasBoilerSerial
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
      redeclare BESMod.Systems.RecordsCollection.Movers.DefaultMover parPum,
      redeclare
        BESMod.Systems.RecordsCollection.TemperatureSensors.DefaultSensor
        parTemSen,
      redeclare AixLib.DataBase.Boiler.General.Boiler_Vitogas200F_11kW parBoi));
   extends Modelica.Icons.Example;

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
  connect(pulse.y, genControlBus.yBoi) annotation (Line(points={{-19,90},{-14,90},
          {-14,98},{10,98},{10,74}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  annotation (Documentation(info="<html>
<p>Test model for a serial heat pump and gas boiler system. 
The heat pump is a Vitocal 251-A (8 kW) modular reversible heat pump with 
safety controls parametrized according to W�llhorst (2021). 
The gas boiler is a Vitogas 200-F with 11 kW nominal capacity.</p>
</html>"));
end HeatPumpAndGasBoilerSeries;
