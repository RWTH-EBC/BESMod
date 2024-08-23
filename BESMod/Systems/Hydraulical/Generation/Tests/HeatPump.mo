within BESMod.Systems.Hydraulical.Generation.Tests;
model HeatPump "Heat pump test case"
  extends PartialTest(redeclare BESMod.Systems.Hydraulical.Generation.HeatPump
      generation(
      redeclare
        AixLib.Fluid.HeatPumps.ModularReversible.Controls.Safety.Data.Wuellhorst2021
        safCtrPar,
      heatPump(redeclare model RefrigerantCycleHeatPumpHeating =
          AixLib.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.TableData2D
            (
           redeclare
            AixLib.Fluid.HeatPumps.ModularReversible.Data.TableData2D.EN14511.Vitocal251A08
            datTab)),
      redeclare
        BESMod.Systems.Hydraulical.Generation.RecordsCollection.DefaultHP
        parHeaPum,
      redeclare BESMod.Systems.RecordsCollection.Movers.DefaultMover parPum,
      redeclare
        BESMod.Systems.RecordsCollection.TemperatureSensors.DefaultSensor
        parTemSen));
   extends Modelica.Icons.Example;

  Modelica.Blocks.Sources.Pulse        pulse(period=1800)
    annotation (Placement(transformation(extent={{-40,80},{-20,100}})));
  Modelica.Blocks.Sources.BooleanConstant
                                       booleanConstant
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));
equation
  connect(pulse.y, genControlBus.yHeaPumSet) annotation (Line(points={{-19,90},{
          -14,90},{-14,98},{10,98},{10,74}},  color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(pulse.y, genControlBus.uPump) annotation (Line(points={{-19,90},{-14,90},
          {-14,98},{10,98},{10,74}},     color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(booleanConstant.y, genControlBus.hea) annotation (Line(points={{-19,
          60},{-14,60},{-14,74},{10,74}}, color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
end HeatPump;
