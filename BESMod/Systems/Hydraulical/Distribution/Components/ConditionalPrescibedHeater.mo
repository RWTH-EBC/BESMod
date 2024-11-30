within BESMod.Systems.Hydraulical.Distribution.Components;
model ConditionalPrescibedHeater
  "Utility prescribed heater for storages"
  parameter Real Q_flow_nominal "Nominal heat flow rate";
  parameter Boolean useHeater=true
                              "=false to disable heater";
  Modelica.Blocks.Math.Gain gainHea(k=Q_flow_nominal) if useHeater
    "Scale relative signal"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow preHea(final T_ref=293.15,
      final alpha=0) if useHeater        "Prescribed heater" annotation (
      Placement(transformation(extent={{-6,-10},{14,10}}, rotation=0)));
  Modelica.Blocks.Interfaces.RealInput uHea if useHeater
                                            "Relative input signal" annotation (
     Placement(transformation(
        origin={-118,0},
        extent={{20,-20},{-20,20}},
        rotation=180), iconTransformation(
        extent={{20,-20},{-20,20}},
        rotation=180,
        origin={-118,0})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b
                        port if useHeater
                             annotation (Placement(transformation(extent={{90,
            -10},{110,10}}), iconTransformation(extent={{90,-10},{110,10}})));

  Modelica.Blocks.Interfaces.RealOutput PEleHea
    "Electricity demand heater (100 % efficiency in storage)"
    annotation (Placement(transformation(extent={{100,-80},{120,-60}})));
  Modelica.Blocks.Sources.Constant const(final k=0) if not useHeater
    "No electricity demand in case no heater"
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));
equation
  connect(gainHea.y, preHea.Q_flow)
    annotation (Line(points={{-39,0},{-6,0}}, color={0,0,127}));
  connect(gainHea.y, PEleHea) annotation (Line(points={{-39,0},{-20,0},{-20,-70},
          {110,-70}}, color={0,0,127}));
  connect(gainHea.u, uHea)
    annotation (Line(points={{-62,0},{-118,0}}, color={0,0,127}));
  connect(preHea.port, port)
    annotation (Line(points={{14,0},{100,0}}, color={191,0,0}));
  connect(const.y, PEleHea)
    annotation (Line(points={{-39,-70},{110,-70}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                                Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Line(
          visible=useHeater,
          points={{-60,-20},{40,-20}},
          color={191,0,0},
          thickness=0.5),
        Line(
          visible=useHeater,
          points={{-80,0},{-60,-20}},
          color={191,0,0},
          thickness=0.5),
        Line(
          visible=useHeater,
          points={{-80,0},{-60,20}},
          color={191,0,0},
          thickness=0.5),
        Polygon(
          visible=useHeater,
          points={{40,0},{40,40},{70,20},{40,0}},
          lineColor={191,0,0},
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          visible=useHeater,
          points={{40,-40},{40,0},{70,-20},{40,-40}},
          lineColor={191,0,0},
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          visible=useHeater,
          extent={{70,40},{90,-40}},
          lineColor={191,0,0},
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid),
        Line(
          visible=useHeater,
          points={{-60,20},{40,20}},
          color={191,0,0},
          thickness=0.5),
        Text(
          extent={{-68,100},{64,-100}},
          textColor={28,108,200},
          textString="0 W"),            Text(
        extent={{-154,138},{146,98}},
        textString="%name",
        textColor={0,0,255})}),
                            Diagram(coordinateSystem(preserveAspectRatio=false)));
end ConditionalPrescibedHeater;
