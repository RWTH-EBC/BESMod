within BESMod.Systems.Electrical.Transfer;
model IdealHeater "Ideal heater as in reduced order model"
  extends BESMod.Systems.Electrical.Transfer.BaseClasses.PartialTransfer;
  parameter Real KR_heater=1000 "Gain of the heating controller";
  parameter Modelica.Units.SI.Time TN_heater=1
    "Time constant of the heating controller";
  Utilities.Electrical.RealToElecCon   realToElecCon(use_souGen=false)
    annotation (Placement(transformation(extent={{20,60},{40,80}})));
  Examples.TEASERHeatLoadCalculation.HeaterCoolerPIFraRad
                                                       heaterCooler[nParallelDem](
    h_heater=Q_flow_nominal .* 1.5,
    each final l_heater=0,
    each final KR_heater=KR_heater,
    each final TN_heater=TN_heater,
    each final zoneParam=AixLib.DataBase.ThermalZones.ZoneRecordDummy(),
    each recOrSep=false,
    each Heater_on=true,
    each Cooler_on=false,
    fraCooRad=0,
    fraHeaRad=0.35,
    each final staOrDyn=false) "Heater Cooler with PI control"
    annotation (Placement(transformation(extent={{-62,0},{-20,40}})));
  Modelica.Blocks.Sources.BooleanConstant booCooAct[nParallelDem](each final k=
       false) "Cooling active"
    annotation (Placement(transformation(extent={{-82,-40},{-62,-20}})));
  Modelica.Blocks.Sources.BooleanConstant booHeaAct[nParallelDem](each final k=
       true) "Heating active"
    annotation (Placement(transformation(extent={{-82,-80},{-62,-60}})));
  Utilities.KPIs.EnergyKPICalculator heaKPI[nParallelDem](each final use_inpCon=
        true) "Heating power KPI" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,-40})));
  Modelica.Blocks.Math.Sum sum1
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
equation
  connect(realToElecCon.internalElectricalPin, internalElectricalPin)
    annotation (Line(
      points={{40.2,70.2},{48,70.2},{48,100}},
      color={0,0,0},
      thickness=1));
  connect(booCooAct.y, heaterCooler.coolerActive)
    annotation (Line(points={{-61,-30},{-54,-30},{-54,-32},{-55.7,-32},{-55.7,
          5.6}},                                            color={255,0,255}));
  connect(heaterCooler.heaterActive, booHeaAct.y) annotation (Line(points={{-26.72,
          5.6},{-26.72,-70},{-61,-70}}, color={255,0,255}));
  connect(heaterCooler.heatCoolRoom, heatPortCon) annotation (Line(points={{-22.1,
          12},{86,12},{86,38},{100,38}},
                                     color={191,0,0}));
  connect(heaterCooler.setPointHeat, transferControlBus.TZoneSet) annotation (
      Line(points={{-36.38,5.6},{-36.38,-10},{-90,-10},{-90,90},{1.77636e-15,90},
          {1.77636e-15,98}},
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
          2.10942e-15,-28.2},{2.10942e-15,28},{-20,28}}, color={0,0,127}));
  connect(heaterCooler.heatingPower, sum1.u) annotation (Line(points={{-20,28},
          {0,28},{0,54},{-52,54},{-52,70},{-42,70}}, color={0,0,127}));
  connect(sum1.y, realToElecCon.PEleLoa) annotation (Line(points={{-19,70},{6,
          70},{6,74},{18,74}}, color={0,0,127}));
  connect(heaterCooler.heaPorRad, heatPortRad) annotation (Line(points={{-22.1,
          2},{-22.1,-8},{78,-8},{78,-30},{80,-30},{80,-38},{100,-38}}, color={
          191,0,0}));
  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end IdealHeater;
