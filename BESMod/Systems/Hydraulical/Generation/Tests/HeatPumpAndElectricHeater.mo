within BESMod.Systems.Hydraulical.Generation.Tests;
model HeatPumpAndElectricHeater "Test for HeatPumpAndElectricHeater"
  extends PartialTest(redeclare
      BESMod.Systems.Hydraulical.Generation.HeatPumpAndElectricHeater
      generation(
      use_eleHea=true,
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
      redeclare
        BESMod.Systems.Hydraulical.Generation.RecordsCollection.ElectricHeater.DefaultElectricHeater
        parEleHea));
   extends Modelica.Icons.Example;

  Modelica.Blocks.Sources.Constant     const1(k=0)
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
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
  connect(const1.y, genControlBus.uEleHea) annotation (Line(points={{-59,50},{
          -24,50},{-24,48},{10,48},{10,74}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  annotation (Documentation(info="<html>
<p>Test model for a heat generation system combining a heat pump with 
an electric heater as backup. The heat pump is a reversible modular 
heat pump using the Vitocal 251-A 08 parametrization based on EN14511 measurement data. 
The safety control parameters are taken from Wuellhorst 2021.</p>
</html>"));
end HeatPumpAndElectricHeater;
