within BESMod.Systems.Hydraulical.Control.Components.ThermostaticValveController;
model ThermostaticValvePIControlledCustom
  extends BaseClasses.PartialThermostaticValveController;

  parameter Real k[nZones]=fill(0.2, nZones)
                     "Gain of controller";
  parameter Modelica.Units.SI.Time Ti[nZones]=fill(1800, nZones)
    "Time constant of Integrator block";
  Modelica.Blocks.Continuous.LimPID PI[nZones](
    each final controllerType=Modelica.Blocks.Types.SimpleController.PI,
    final k=k,
    final Ti=Ti,
    each final yMax=1,
    each final yMin=leakageOpening)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  Modelica.Blocks.Math.Add dTBuffer(k1=+1, k2=-1)
    annotation (Placement(transformation(extent={{-10,-80},{10,-60}})));

  AixLib.Utilities.Logical.SmoothSwitch switch[nZones]
    annotation (Placement(transformation(extent={{62,-10},{82,10}})));
  Modelica.Blocks.Interfaces.RealInput TBufferTop(each final unit="K", each final
            displayUnit="degC") annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-30,-120})));
  Modelica.Blocks.Interfaces.RealInput TBufferBottom(each final unit="K", each final
            displayUnit="degC") annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={30,-120})));
  Modelica.Blocks.Interfaces.RealInput ySetGen annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={70,-120})));
  Modelica.Blocks.Logical.Hysteresis hysteresis(uLow=0.2, uHigh=2)
    annotation (Placement(transformation(extent={{40,-80},{60,-60}})));
  Modelica.Blocks.Math.Min min[nZones]
    annotation (Placement(transformation(extent={{28,-30},{48,-10}})));
equation
  connect(TZoneMea, PI.u_m) annotation (Line(points={{-120,60},{-54,60},{-54,
          -26},{0,-26},{0,-12}}, color={0,0,127}));
  connect(TZoneSet, PI.u_s) annotation (Line(points={{-120,-60},{-40,-60},{-40,
          0},{-12,0}}, color={0,0,127}));
  connect(TBufferTop, dTBuffer.u1) annotation (Line(points={{-30,-120},{-30,-64},
          {-12,-64}}, color={0,0,127}));
  connect(TBufferBottom, dTBuffer.u2) annotation (Line(points={{30,-120},{30,-84},
          {-12,-84},{-12,-76}},           color={0,0,127}));
  connect(switch.y, opening) annotation (Line(points={{83,0},{120,0}},
                   color={0,0,127}));
  connect(PI.y, switch.u1)
    annotation (Line(points={{11,0},{20,0},{20,8},{60,8}}, color={0,0,127}));
  connect(hysteresis.y, switch[1].u2) annotation (Line(points={{61,-70},{64,-70},
          {64,-38},{54,-38},{54,0},{60,0}}, color={255,0,255}));
  connect(dTBuffer.y, hysteresis.u)
    annotation (Line(points={{11,-70},{38,-70}}, color={0,0,127}));
  connect(ySetGen, min[1].u2) annotation (Line(points={{70,-120},{70,-40},{20,
          -40},{20,-26},{26,-26}}, color={0,0,127}));
  connect(PI.y, min.u1) annotation (Line(points={{11,0},{20,0},{20,-14},{26,-14}},
        color={0,0,127}));
  connect(min.y, switch.u3)
    annotation (Line(points={{49,-20},{60,-20},{60,-8}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Polygon(
          points={{-80,90},{-88,68},{-72,68},{-80,90}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-80,78},{-80,-90}}, color={192,192,192}),
        Line(points={{-90,-80},{82,-80}}, color={192,192,192}),
        Polygon(
          points={{90,-80},{68,-72},{68,-88},{90,-80}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-80,-80},{-80,-20},{-80,-20},{52,80}},
                                                           color={0,0,127})}),
                                                                 Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end ThermostaticValvePIControlledCustom;
