within BESMod.Systems.Hydraulical.Control.Components.PumpController;
model PumpPIControlled
  extends
    BESMod.Systems.Hydraulical.Control.Components.PumpController.BaseClasses.PartialPumpController;
  parameter Real conSpeedGenOff=0.1 "Constant speed when generation is off";
  parameter Real k=0.2
                     "Gain of controller";
  parameter Modelica.Units.SI.Time Ti=1800
    "Time constant of Integrator block";
  Modelica.Blocks.Continuous.LimPID PI(
    final controllerType=Modelica.Blocks.Types.SimpleController.PI,
    final k=k,
    final Ti=Ti,
    final yMax=1 - minSpeed,
    final yMin=0)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  Modelica.Blocks.Math.Add dTMea(k2=-1)
    annotation (Placement(transformation(extent={{-40,-64},{-20,-44}})));
  Modelica.Blocks.Logical.Switch switch1
    annotation (Placement(transformation(extent={{40,26},{60,6}})));
  Modelica.Blocks.Sources.Constant const1(k=dTSet)
    annotation (Placement(transformation(extent={{-46,-10},{-26,10}})));
  Modelica.Blocks.Math.Add add(k1=-1)
    annotation (Placement(transformation(extent={{28,-30},{48,-10}})));
protected
  Modelica.Blocks.Sources.Constant const(each final k=conSpeedGenOff)
    annotation (Placement(transformation(extent={{-10,32},{10,52}})));
protected
  Modelica.Blocks.Sources.Constant const2(each final k=1)
    annotation (Placement(transformation(extent={{12,-68},{32,-48}})));
equation
  connect(TSup, dTMea.u1) annotation (Line(points={{-120,60},{-52,60},{-52,-48},
          {-42,-48}}, color={0,0,127}));
  connect(TRet, dTMea.u2)
    annotation (Line(points={{-120,-60},{-42,-60}}, color={0,0,127}));
  connect(dTMea.y, PI.u_m)
    annotation (Line(points={{-19,-54},{0,-54},{0,-12}}, color={0,0,127}));
  connect(const1.y, PI.u_s)
    annotation (Line(points={{-25,0},{-12,0}}, color={0,0,127}));
  connect(GenOn, switch1.u2) annotation (Line(points={{-120,0},{-50,0},{-50,16},
          {38,16}}, color={255,0,255}));
  connect(const.y, switch1.u3) annotation (Line(points={{11,42},{30,42},{30,24},
          {38,24}}, color={0,0,127}));
  connect(switch1.y, yPum) annotation (Line(points={{61,16},{84,16},{84,0},{120,
          0}}, color={0,0,127}));
  connect(PI.y, add.u1) annotation (Line(points={{11,0},{16,0},{16,-14},{26,
          -14}}, color={0,0,127}));
  connect(const2.y, add.u2) annotation (Line(points={{33,-58},{38,-58},{38,
          -34},{20,-34},{20,-26},{26,-26}}, color={0,0,127}));
  connect(add.y, switch1.u1) annotation (Line(points={{49,-20},{54,-20},{54,2},
          {38,2},{38,8}}, color={0,0,127}));
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
end PumpPIControlled;
