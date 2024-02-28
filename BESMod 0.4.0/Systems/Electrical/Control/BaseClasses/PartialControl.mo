within BESMod.Systems.Electrical.Control.BaseClasses;
partial model PartialControl "Partial electrical control model"
  parameter Boolean use_openModelica=false
    "=true to disable features which 
    are not available in open modelica" annotation(Dialog(tab="Advanced"));
  parameter Integer nParallelDem(min=1)
    "Number of parallel demand systems of this system" annotation (Dialog(group=
          "Design - Top Down: Parameters are given by the parent system"));
  parameter Modelica.Units.SI.HeatFlowRate Q_flow_nominal[nParallelDem](each min=Modelica.Constants.eps)
    "Nominal heat flow rate" annotation (Dialog(group=
          "Design - Top Down: Parameters are given by the parent system"));
  Interfaces.GenerationControlBus generationControlBus annotation (Placement(
        transformation(extent={{-182,-118},{-158,-78}}),
                                                       iconTransformation(
          extent={{-182,-118},{-158,-78}})));
  Interfaces.DistributionControlBus distributionControlBus annotation (
      Placement(transformation(extent={{0,-118},{22,-80}}),
        iconTransformation(extent={{0,-118},{22,-80}})));
  Interfaces.ControlOutputs controlOutputs if not use_openModelica
                                           annotation (Placement(transformation(
          extent={{228,-18},{250,20}}), iconTransformation(extent={{228,-18},{
            250,20}})));
  Interfaces.TransferControlBus transferControlBus annotation (Placement(
        transformation(extent={{166,-116},{188,-82}}), iconTransformation(
          extent={{166,-116},{188,-82}})));
  BESMod.Systems.Interfaces.UseProBus useProBus annotation (
      Placement(transformation(extent={{-112,80},{-70,126}}),
        iconTransformation(extent={{-138,80},{-88,124}})));
  BESMod.Systems.Interfaces.BuiMeaBus buiMeaBus annotation (
      Placement(transformation(extent={{70,84},{116,122}}),iconTransformation(
          extent={{42,84},{88,122}})));
  IBPSA.BoundaryConditions.WeatherData.Bus
      weaBus "Weather data bus" annotation (Placement(transformation(extent={{-260,18},
            {-218,62}}),         iconTransformation(extent={{-250,8},{-230,28}})));
  Interfaces.SystemControlBus systemControlBus annotation (Placement(
        transformation(extent={{-20,80},{20,120}}), iconTransformation(extent={
            {-20,80},{20,120}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-240,
            -100},{240,100}}), graphics={
        Rectangle(
          extent={{-240,100},{240,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5), Text(
          extent={{-88,-76},{116,-172}},
          lineColor={0,0,0},
          textString="%name%"),
        Rectangle(
          extent={{-228,70},{232,52}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-230,10},{230,-8}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-230,-48},{230,-66}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-84,80},{-36,44}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{124,18},{172,-18}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-164,-40},{-116,-76}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid)}),                      Diagram(graphics,
        coordinateSystem(preserveAspectRatio=false, extent={{-240,-100},{240,
            100}})));
end PartialControl;
