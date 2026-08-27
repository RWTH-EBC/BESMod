within BESMod.BESRules.PVAndHPDesignAndControlOptimization;
model SupControlOverheatingPV
  "Overheating based on PV production"
  extends BESMod.Systems.Control.BaseClasses.PartialControl;
  Modelica.Blocks.Logical.Switch DHWOverheat
    annotation (Placement(transformation(extent={{18,26},{34,42}})));
  Modelica.Blocks.Sources.Constant DHWOverheatValue(k=DHWOverheatTemp)
    annotation (Placement(transformation(extent={{-40,34},{-24,50}})));
  Modelica.Blocks.Logical.Greater greater
    annotation (Placement(transformation(extent={{40,-2},{56,14}})));
  Modelica.Blocks.Logical.Switch BufOverheat
    annotation (Placement(transformation(extent={{70,-48},{86,-32}})));
  Modelica.Blocks.Sources.Constant const(k=BufOverheatdT)
    annotation (Placement(transformation(extent={{-2,-36},{14,-20}})));
  Modelica.Blocks.Sources.Constant NoChange(k=0)
    annotation (Placement(transformation(extent={{-98,-40},{-78,-20}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(T=30)
    annotation (Placement(transformation(extent={{-76,-8},{-60,8}})));

  Modelica.Blocks.Sources.BooleanPulse HeatingSeason(
    width=50,
    period=21024002,
    startTime=0)
    annotation (Placement(transformation(extent={{0,-60},{14,-46}})));
  Modelica.Blocks.MathBoolean.And
                              and1(nu=3)
    annotation (Placement(transformation(extent={{28,-54},{36,-46}})));
  Modelica.Blocks.Logical.Hysteresis hysteresis(uLow=Modelica.Constants.eps, uHigh=
        PEleHys_nominal)
    annotation (Placement(transformation(extent={{-36,-8},{-20,8}})));
  parameter Real DHWOverheatTemp=65 + 273.15 "Constant output value";
  parameter Real BufOverheatdT=10 "Constant output value";
  BESMod.Utilities.KPIs.DeviceKPICalculator BufOverheat_NumSwi
    annotation (Placement(transformation(extent={{70,-82},{86,-66}})));
  BESMod.Utilities.KPIs.DeviceKPICalculator PVHys_KPI_Calc
    annotation (Placement(transformation(extent={{42,84},{58,100}})));
  BESMod.Utilities.KPIs.DeviceKPICalculator DHWOverheat_NumSwi annotation (
      Placement(transformation(
        extent={{-8,-8},{8,8}},
        rotation=0,
        origin={50,70})));
  parameter Modelica.Units.SI.Power PEleHys_nominal
    "If y=false and u>uHigh, switch to y=true";
  Modelica.Blocks.Math.Add         addHeaCur "Add dT to heating curve"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-50,-70})));
equation
  connect(DHWOverheatValue.y, DHWOverheat.u1) annotation (Line(points={{-23.2,
          42},{16.4,42},{16.4,40.4}}, color={0,0,127}));
  connect(greater.u1, sigBusHyd.TStoDHWTop) annotation (Line(points={{38.4,6},{
          -14,6},{-14,-48},{-79,-48},{-79,-101}},
                                                color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(greater.u2, DHWOverheatValue.y) annotation (Line(points={{38.4,-0.4},
          {38.4,-6},{10,-6},{10,42},{-23.2,42}}, color={0,0,127}));
  connect(const.y, BufOverheat.u1) annotation (Line(points={{14.8,-28},{68.4,
          -28},{68.4,-33.6}},       color={0,0,127}));
  connect(NoChange.y, BufOverheat.u3) annotation (Line(points={{-77,-30},{60,-30},
          {60,-46.4},{68.4,-46.4}},color={0,0,127}));
  connect(NoChange.y, DHWOverheat.u3) annotation (Line(points={{-77,-30},{-6,-30},
          {-6,27.6},{16.4,27.6}},
        color={0,0,127}));
  connect(and1.y, BufOverheat.u2) annotation (Line(points={{36.6,-50},{50,-50},
          {50,-40},{68.4,-40}}, color={255,0,255}));
  connect(hysteresis.y, DHWOverheat.u2) annotation (Line(points={{-19.2,0},{4,0},
          {4,34},{16.4,34}},  color={255,0,255}));
  connect(hysteresis.u, firstOrder.y)
    annotation (Line(points={{-37.6,0},{-59.2,0}}, color={0,0,127}));
  connect(firstOrder.u, sigBusEle.PEleGenGrid) annotation (Line(points={{-77.6,0},
          {-100,0}},    color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(PVHys_KPI_Calc.u, hysteresis.y) annotation (Line(points={{40.24,92},{
          -4,92},{-4,0},{-19.2,0}}, color={255,0,255}));
  connect(PVHys_KPI_Calc.KPI, outBusCtrl.PVHys_KPI) annotation (Line(points={{
          59.76,92},{101,92},{101,0}}, color={135,135,135}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(BufOverheat_NumSwi.u, BufOverheat.u2) annotation (Line(points={{68.24,
          -74},{62,-74},{62,-50},{50,-50},{50,-40},{68.4,-40}}, color={255,0,
          255}));
  connect(BufOverheat_NumSwi.KPI, outBusCtrl.BufOverheat_KPI) annotation (Line(
        points={{87.76,-74},{106,-74},{106,-72},{130,-72},{130,0},{101,0}},
        color={135,135,135}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(DHWOverheat_NumSwi.u, DHWOverheat.u2) annotation (Line(points={{40.24,
          70},{6,70},{6,34},{16.4,34}}, color={255,0,255}));
  connect(DHWOverheat_NumSwi.KPI, outBusCtrl.DHWOverheat_KPI) annotation (Line(
        points={{59.76,70},{101,70},{101,0}}, color={135,135,135}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(BufOverheat.y, addHeaCur.u1) annotation (Line(points={{86.8,-40},{90,-40},
          {90,-54},{40,-54},{40,-76},{-38,-76}}, color={0,0,127}));
  connect(addHeaCur.u2, sigBusHyd.TBuiLoc) annotation (Line(points={{-38,-64},{
          -18,-64},{-18,-100},{-79,-100},{-79,-101}},
                                                color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(addHeaCur.y, sigBusHyd.TBuiSupOve) annotation (Line(points={{-61,-70},
          {-79,-70},{-79,-101}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(and1.y, sigBusHyd.oveTBuiSup) annotation (Line(points={{36.6,-50},{46,
          -50},{46,-101},{-79,-101}}, color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(hysteresis.y, sigBusHyd.oveTSetDHW) annotation (Line(points={{-19.2,0},
          {-10,0},{-10,-52},{-79,-52},{-79,-101}}, color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(DHWOverheat.y, sigBusHyd.TSetDHWOve) annotation (Line(points={{34.8,
          34},{122,34},{122,-108},{-79,-108},{-79,-101}}, color={0,0,127}),
      Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(HeatingSeason.y, and1.u[1]) annotation (Line(points={{14.7,-53},{14.7,
          -50.9333},{28,-50.9333}}, color={255,0,255}));
  connect(and1.u[2], greater.y) annotation (Line(points={{28,-50},{24,-50},{24,
          -8},{60,-8},{60,6},{56.8,6}}, color={255,0,255}));
  connect(and1.u[3], hysteresis.y) annotation (Line(points={{28,-49.0667},{24,
          -49.0667},{24,-8},{-4,-8},{-4,0},{-19.2,0}},
                                            color={255,0,255}));
end SupControlOverheatingPV;
