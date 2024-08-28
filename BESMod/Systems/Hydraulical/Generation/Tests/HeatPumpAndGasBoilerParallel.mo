within BESMod.Systems.Hydraulical.Generation.Tests;
model HeatPumpAndGasBoilerParallel
  "Test case for parallel heat pump and gas boiler"
  extends PartialTest(redeclare
      BESMod.Systems.Hydraulical.Generation.HeatPumpAndGasBoilerParallel
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
        BESMod.Systems.Hydraulical.Generation.RecordsCollection.DefaultHP
        parHeaPum,
      redeclare BESMod.Systems.RecordsCollection.Movers.DefaultMover parPum,
      redeclare
        BESMod.Systems.RecordsCollection.TemperatureSensors.DefaultSensor
        parTemSen,
      redeclare BESMod.Systems.RecordsCollection.Valves.DefaultThreeWayValve
        parThrWayVal));
   extends Modelica.Icons.Example;

  Modelica.Blocks.Sources.Pulse        pulse(period=1800)
    annotation (Placement(transformation(extent={{-40,80},{-20,100}})));
  Modelica.Blocks.Sources.Constant constThrWayValGen(k=0.5) "Constant source"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={70,88})));
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
  connect(constThrWayValGen.y, genControlBus.uBoiOrHeaPum) annotation (Line(
        points={{59,88},{36,88},{36,74},{10,74}}, color={0,0,127}), Text(
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
end HeatPumpAndGasBoilerParallel;
