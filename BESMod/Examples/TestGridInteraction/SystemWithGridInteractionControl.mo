within BESMod.Examples.TestGridInteraction;
partial model SystemWithGridInteractionControl
  extends Systems.Hydraulical.Control.BaseClasses.PartialControl;
  parameter Modelica.Units.SI.Temperature T_lim(displayUnit="K")=288.15;
  parameter Modelica.Units.SI.Temperature delta_T_lim(displayUnit="K")=0.1; //Temperature difference allowed in Hysteresis implementation
  replaceable
    BESMod.Systems.Hydraulical.Control.Components.ThermostaticValveController.BaseClasses.PartialThermostaticValveController
    thermostaticValveController constrainedby
    BESMod.Systems.Hydraulical.Control.Components.ThermostaticValveController.BaseClasses.PartialThermostaticValveController(
      final nZones=transferParameters.nParallelDem, final leakageOpening=
        thermostaticValveParameters.leakageOpening) annotation (
      choicesAllMatching=true, Placement(transformation(extent={{112,-94},{138,
            -64}})));
  replaceable parameter
    BESMod.Systems.Hydraulical.Control.RecordsCollection.ThermostaticValveDataDefinition
    thermostaticValveParameters annotation (choicesAllMatching=true, Placement(
        transformation(extent={{178,-80},{198,-60}})));
  Modelica.Blocks.Logical.LogicalSwitch HP_EVU_Sperre
    annotation (Placement(transformation(extent={{164,-26},{180,-10}})));
  Modelica.Blocks.Math.RealToBoolean realToBoolean(threshold=1)
    annotation (Placement(transformation(extent={{124,-22},{132,-14}})));
  Modelica.Blocks.Sources.BooleanConstant hp_Off(final k=false) annotation (
      Placement(transformation(
        extent={{-3,-3},{3,3}},
        rotation=0,
        origin={145,-29})));
  Modelica.Blocks.Logical.Timer timer
    annotation (Placement(transformation(extent={{-102,-68},{-82,-48}})));
  GreaterThresholdInit greaterThresholdInit(threshold=259200)
    annotation (Placement(transformation(extent={{-72,-68},{-52,-48}})));
  Modelica.Blocks.Logical.LogicalSwitch logicalSwitch
    annotation (Placement(transformation(extent={{-40,-68},{-20,-48}})));
  Modelica.Blocks.Logical.Hysteresis hysteresis(uLow=T_lim - delta_T_lim, uHigh=
        T_lim + delta_T_lim)
    annotation (Placement(transformation(extent={{-144,-66},{-128,-50}})));
  Modelica.Blocks.Logical.Not reverse
    annotation (Placement(transformation(extent={{-120,-62},{-110,-52}})));
equation
  connect(thermostaticValveController.opening, sigBusTra.opening) annotation (
      Line(points={{140.6,-79},{174,-79},{174,-100}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(thermostaticValveController.TZoneMea, buiMeaBus.TZoneMea) annotation (
     Line(points={{109.4,-70},{104,-70},{104,-42},{238,-42},{238,103},{65,103}},
        color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(thermostaticValveController.TZoneSet, useProBus.TZoneSet) annotation (
     Line(points={{109.4,-88},{102,-88},{102,-40},{236,-40},{236,103},{-119,103}},
        color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(realToBoolean.y,HP_EVU_Sperre. u2) annotation (Line(points={{132.4,-18},
          {162.4,-18}},                      color={255,0,255}));
  connect(hp_Off.y, HP_EVU_Sperre.u3) annotation (Line(points={{148.3,-29},{156,
          -29},{156,-24.4},{162.4,-24.4}}, color={255,0,255}));
  connect(realToBoolean.u, sigBusHyd.HP_mode_EVU_Sperre) annotation (Line(
        points={{123.2,-18},{-28,-18},{-28,101}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(timer.y, greaterThresholdInit.u)
    annotation (Line(points={{-81,-58},{-74,-58}}, color={0,0,127}));
  connect(greaterThresholdInit.y, logicalSwitch.u2)
    annotation (Line(points={{-51,-58},{-42,-58}}, color={255,0,255}));
  connect(timer.u, reverse.y) annotation (Line(points={{-104,-58},{-106,-58},{
          -106,-57},{-109.5,-57}}, color={255,0,255}));
  connect(hysteresis.y, reverse.u) annotation (Line(points={{-127.2,-58},{
          -127.2,-57},{-121,-57}}, color={255,0,255}));
  connect(hysteresis.u, weaBus.TDryBul) annotation (Line(points={{-145.6,-58},{
          -210,-58},{-210,2},{-237,2}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  annotation (Diagram(graphics={
        Rectangle(
          extent={{74,-58},{206,-100}},
          lineColor={162,29,33},
          lineThickness=1),
        Text(
          extent={{76,-100},{180,-120}},
          lineColor={162,29,33},
          lineThickness=1,
          textString="Thermostatic Valve"),
        Rectangle(
          extent={{72,0},{204,-42}},
          lineColor={162,29,33},
          lineThickness=1),
        Text(
          extent={{48,-44},{152,-64}},
          lineColor={162,29,33},
          lineThickness=1,
          textString="EVU Sperre
"),     Rectangle(
          extent={{-148,-40},{-10,-80}},
          lineColor={162,29,33},
          lineThickness=1),
        Text(
          extent={{-126,-82},{-22,-102}},
          lineColor={162,29,33},
          lineThickness=1,
          textString="Summer switch

",        fontSize=12)}));
end SystemWithGridInteractionControl;
