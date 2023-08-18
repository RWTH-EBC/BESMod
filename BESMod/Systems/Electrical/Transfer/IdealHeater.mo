within BESMod.Systems.Electrical.Transfer;
model IdealHeater "Ideal heater as in reduced order model"
  extends BESMod.Systems.Electrical.Transfer.BaseClasses.PartialTransfer;
  parameter Real KR_heater=1000 "Gain of the heating controller";
  parameter Modelica.Units.SI.Time TN_heater=1
    "Time constant of the heating controller";
  BESMod.Utilities.Electrical.ZeroLoad zeroLoad
    annotation (Placement(transformation(extent={{16,64},{36,84}})));
  AixLib.Utilities.Sources.HeaterCooler.HeaterCoolerPI heaterCooler[nParallelDem](
    h_heater=Q_flow_nominal .* 1.5,
    each final l_heater=0,
    each final KR_heater=KR_heater,
    each final TN_heater=TN_heater,
    each final zoneParam=AixLib.DataBase.ThermalZones.ZoneRecordDummy(),
    each recOrSep=false,
    each Heater_on=true,
    each Cooler_on=false,
    each final staOrDyn=false) "Heater Cooler with PI control"
    annotation (Placement(transformation(extent={{-62,18},{-22,58}})));
  Modelica.Blocks.Sources.BooleanConstant booCooAct[nParallelDem](each final k=
       false) "Cooling active"
    annotation (Placement(transformation(extent={{-98,0},{-78,20}})));
  Modelica.Blocks.Sources.BooleanConstant booHeaAct[nParallelDem](each final k=
       true) "Heating active"
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixHeaFlo[nParallelDem](
      each final Q_flow=0)
    annotation (Placement(transformation(extent={{40,-48},{60,-28}})));
  Utilities.KPIs.EnergyKPICalculator heaKPI[nParallelDem](each final use_inpCon=
        true) "Heating power KPI" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,-40})));
equation
  connect(zeroLoad.internalElectricalPin, internalElectricalPin) annotation (
      Line(
      points={{36,74},{48,74},{48,100}},
      color={0,0,0},
      thickness=1));
  connect(booCooAct.y, heaterCooler.coolerActive)
    annotation (Line(points={{-77,10},{-56,10},{-56,23.6}}, color={255,0,255}));
  connect(heaterCooler.heaterActive, booHeaAct.y) annotation (Line(points={{-28.4,
          23.6},{-28.4,-30},{-79,-30}}, color={255,0,255}));
  connect(heaterCooler.heatCoolRoom, heatPortCon) annotation (Line(points={{-24,30},
          {84,30},{84,38},{100,38}}, color={191,0,0}));
  connect(fixHeaFlo.port, heatPortRad)
    annotation (Line(points={{60,-38},{100,-38}}, color={191,0,0}));
  connect(heaterCooler.setPointHeat, transferControlBus.TZoneSet) annotation (
      Line(points={{-37.6,23.6},{-37.6,-6},{1.77636e-15,-6},{1.77636e-15,98}},
        color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  connect(heaKPI.KPI, transferOutputs.PHea) annotation (Line(points={{
          -2.22045e-15,-52.2},{0,-52.2},{0,-99}}, color={135,135,135}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(heaKPI.u, heaterCooler.heatingPower) annotation (Line(points={{
          2.22045e-15,-28.2},{2.22045e-15,46},{-22,46}}, color={0,0,127}));
  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end IdealHeater;
