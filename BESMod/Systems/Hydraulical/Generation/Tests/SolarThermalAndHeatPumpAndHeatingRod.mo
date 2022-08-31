within BESMod.Systems.Hydraulical.Generation.Tests;
model SolarThermalAndHeatPumpAndHeatingRod
  extends PartialTest(   redeclare
      BESMod.Systems.Hydraulical.Generation.SolarThermalBivHP
      generation(
      redeclare model PerDataMainHP =
          AixLib.DataBase.HeatPump.PerformanceData.VCLibMap,
      redeclare
        BESMod.Systems.Hydraulical.Generation.RecordsCollection.DefaultHP
        heatPumpParameters,
      redeclare
        BESMod.Systems.Hydraulical.Generation.RecordsCollection.DefaultHR
        heatingRodParameters,
      redeclare
        BESMod.Systems.RecordsCollection.Movers.DefaultMover
        pumpData,
      redeclare package Medium_eva = IBPSA.Media.Air,
      redeclare
        BESMod.Systems.Hydraulical.Generation.RecordsCollection.DefaultSolarThermal
        solarThermalParas,
      redeclare
        BESMod.Systems.RecordsCollection.Movers.DefaultMover
        pumpSTData));
  extends Modelica.Icons.Example;

  Modelica.Blocks.Sources.Constant     const1(k=0)
    annotation (Placement(transformation(extent={{-140,40},{-120,60}})));
  Modelica.Blocks.Sources.BooleanConstant
                                       booleanConstant(k=true)
    annotation (Placement(transformation(extent={{-100,40},{-80,60}})));
  Modelica.Blocks.Sources.Pulse        pulse(period=1800)
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  Modelica.Blocks.Sources.Constant     const(k=1)
    annotation (Placement(transformation(extent={{-140,80},{-120,100}})));
equation
  connect(const.y, genControlBus.hp_bus.iceFacMea) annotation (Line(points={{-119,
          90},{-119,92},{-104,92},{-104,74},{10,74}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(booleanConstant.y, genControlBus.hp_bus.modeSet) annotation (Line(
        points={{-79,50},{-52,50},{-52,46},{10,46},{10,74}}, color={255,0,255}),
      Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(pulse.y, genControlBus.hp_bus.nSet) annotation (Line(points={{-79,90},
          {-16,90},{-16,74},{10,74}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(const1.y, genControlBus.hr_on) annotation (Line(points={{-119,50},{-119,
          74},{10,74}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
end SolarThermalAndHeatPumpAndHeatingRod;
