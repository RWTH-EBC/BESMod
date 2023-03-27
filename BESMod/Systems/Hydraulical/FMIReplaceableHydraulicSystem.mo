within BESMod.Systems.Hydraulical;
model FMIReplaceableHydraulicSystem
  "FMI export container for a hydraulic system"
  extends Utilities.FMI.PartialHeatPorts;

    replaceable package MediumDHW = IBPSA.Media.Water
      constrainedby Modelica.Media.Interfaces.PartialMedium
                                            "Medium in the DHW"
                                            annotation (
      __Dymola_choicesAllMatching=true);

  parameter Boolean allowFlowReversal = hydraulic.allowFlowReversal
    "= true to allow flow reversal, false restricts to design direction (inlet -> outlet)
    Adds an input to specify the Temperatur of the backwards flow."
    annotation(Dialog(tab="Assumptions"), Evaluate=true);

  parameter Boolean use_p_in_DHW=true
    "= true to use a pressure from connector, false to output Medium.p_default"
    annotation(Evaluate=true);

  parameter Boolean use_dhw=hydraulic.use_dhw;

  replaceable BaseClasses.PartialHydraulicSystem hydraulic
    constrainedby BaseClasses.PartialHydraulicSystem(final subsystemDisabled=false)
    annotation (Placement(transformation(extent={{-82,-16},{40,76}})));
  IBPSA.Fluid.FMI.Adaptors.Inlet bouInlDHW(
    redeclare each final package Medium = MediumDHW,
    each final allowFlowReversal=allowFlowReversal,
    each final use_p_in=use_p_in_DHW) if use_dhw
    annotation (Placement(transformation(extent={{80,-74},{60,-94}})));
  IBPSA.Fluid.FMI.Adaptors.Outlet bouOutDHW(
    redeclare each final package Medium = MediumDHW,
    each final allowFlowReversal=allowFlowReversal,
    each final use_p_in=use_p_in_DHW) if use_dhw
    annotation (Placement(transformation(extent={{60,-40},{80,-20}})));
  Modelica.Blocks.Sources.RealExpression dpDisDHW(y=hydraulic.portDHW_in.p -
        hydraulic.portDHW_out.p)                            if use_p_in_DHW and use_dhw
    "Pressure drop of the component"
    annotation (Placement(transformation(extent={{-14,-68},{6,-48}})));
  Modelica.Blocks.Math.Feedback pOutDHW if use_p_in_DHW and use_dhw
    "Pressure at component outlet" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={70,-58})));
  IBPSA.Fluid.FMI.Interfaces.Inlet portDHW_in(
    redeclare each final package Medium = MediumDHW,
    each final allowFlowReversal=allowFlowReversal,
    each final use_p_in=use_p_in_DHW) if use_dhw
    "Inet for the hydraulic from the DHW"
    annotation (Placement(transformation(extent={{120,-94},{100,-74}}),
        iconTransformation(extent={{120,-94},{100,-74}})));
  IBPSA.Fluid.FMI.Interfaces.Outlet portDHW_out(
    redeclare each final package Medium = MediumDHW,
    each final allowFlowReversal=allowFlowReversal,
    each final use_p_in=use_p_in_DHW) if use_dhw
    "Outlet for the hydraulic to the DHW"
    annotation (Placement(transformation(extent={{100,-40},{120,-20}}),
        iconTransformation(extent={{100,-40},{120,-20}})));
  BESMod.Systems.Interfaces.UseProBus useProBus annotation (Placement(
        transformation(extent={{-60,92},{-40,112}}), iconTransformation(extent=
            {{-60,92},{-40,112}})));
  Interfaces.SystemControlBus sigBusHyd annotation (Placement(transformation(
          extent={{-24,92},{-4,112}}), iconTransformation(extent={{-24,92},{-4,
            112}})));
  BESMod.Systems.Interfaces.BuiMeaBus buiMeaBus annotation (Placement(
        transformation(extent={{12,92},{32,112}}), iconTransformation(extent={{
            12,92},{32,112}})));
  IBPSA.BoundaryConditions.WeatherData.Bus weaBus "Weather data bus"
    annotation (Placement(transformation(extent={{-110,20},{-90,40}}),
        iconTransformation(extent={{-110,20},{-90,40}})));
  BESMod.Systems.Interfaces.HydraulicOutputs outBusHyd annotation (Placement(
        transformation(extent={{-80,-114},{-60,-94}}), iconTransformation(
          extent={{-80,-114},{-60,-94}})));
  Electrical.Interfaces.InternalElectricalPinOut internalElectricalPin
    annotation (Placement(transformation(extent={{20,-112},{40,-92}}),
        iconTransformation(extent={{20,-112},{40,-92}})));
equation
  connect(hydraulic.heatPortCon, heatPortCon_TtoQ.heatPort) annotation (Line(
        points={{40,55.6286},{40,56},{62,56},{62,70},{76,70}}, color={191,0,0}));
  connect(hydraulic.heatPortRad, heatPortRad_TtoQ.heatPort) annotation (Line(
        points={{40,30},{62,30},{62,10},{76,10}}, color={191,0,0}));
  connect(bouOutDHW.outlet,portDHW_out)
    annotation (Line(points={{81,-30},{110,-30}}, color={0,0,255}));
  connect(bouInlDHW.inlet,portDHW_in)
    annotation (Line(points={{81,-84},{110,-84}}, color={0,0,255}));
  connect(bouInlDHW.p,pOutDHW. u1)
    annotation (Line(points={{70,-73},{70,-66}}, color={0,127,127}));
  connect(pOutDHW.y,bouOutDHW. p)
    annotation (Line(points={{70,-49},{70,-42}}, color={0,0,127}));
  connect(bouOutDHW.port_a, hydraulic.portDHW_out) annotation (Line(points={{60,
          -30},{54,-30},{54,8},{40,8},{40,8.31429},{39.3579,8.31429}}, color={0,
          127,255}));
  connect(bouInlDHW.port_b, hydraulic.portDHW_in) annotation (Line(points={{60,-84},
          {46,-84},{46,-4.82857},{39.3579,-4.82857}}, color={0,127,255}));
  connect(dpDisDHW.y, pOutDHW.u2)
    annotation (Line(points={{7,-58},{62,-58}}, color={0,0,127}));
  connect(hydraulic.useProBus, useProBus) annotation (Line(
      points={{-50.2158,76},{-50,76},{-50,102}},
      color={255,204,51},
      thickness=0.5));
  connect(hydraulic.sigBusHyd, sigBusHyd) annotation (Line(
      points={{-12.9737,76},{-14,76},{-14,102}},
      color={255,204,51},
      thickness=0.5));
  connect(hydraulic.buiMeaBus, buiMeaBus) annotation (Line(
      points={{5.00526,75.6714},{4,75.6714},{4,86},{22,86},{22,102}},
      color={255,204,51},
      thickness=0.5));
  connect(hydraulic.weaBus, weaBus) annotation (Line(
      points={{-81.3579,30},{-100,30}},
      color={255,204,51},
      thickness=0.5));
  connect(hydraulic.outBusHyd, outBusHyd) annotation (Line(
      points={{-24.5316,-16.6571},{-70,-16.6571},{-70,-104}},
      color={255,204,51},
      thickness=0.5));
  connect(hydraulic.internalElectricalPin, internalElectricalPin) annotation (
      Line(
      points={{30.3684,-16},{30,-16},{30,-102}},
      color={0,0,0},
      thickness=1));
  annotation (Icon(graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={28,108,200},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
          Rectangle(
          extent={{-86,90},{88,-30}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
                 Bitmap(extent={{-66,-96},{54,-34}},fileName=
            "modelica://IBPSA/Resources/Images/Fluid/FMI/FMI_icon.png"),
        Rectangle(
          extent={{74,82},{82,20}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{62,82},{70,20}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{50,82},{58,20}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{38,82},{46,20}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{26,82},{34,20}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-26,54},{-26,-14},{88,-14}},
          color={0,0,0},
          thickness=0.5),
        Ellipse(
          extent={{-48,82},{-78,52}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-4,74},{20,58},{20,74},{-4,58},{-4,74}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{8,66},{8,80}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{4,80},{12,80}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{-72,80},{-48,70}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{-74,56},{-50,60}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{20,66},{26,66}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{-38,74},{-14,58},{-14,74},{-38,58},{-38,74}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{-14,66},{-4,66}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{-48,66},{-38,66}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{-26,66},{-32,54},{-20,54},{-26,66}},
          color={0,0,0},
          thickness=0.5)}));
end FMIReplaceableHydraulicSystem;
