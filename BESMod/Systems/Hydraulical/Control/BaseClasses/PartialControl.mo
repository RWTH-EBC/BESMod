within BESMod.Systems.Hydraulical.Control.BaseClasses;
partial model PartialControl "Partial controller for HPS"
 extends BESMod.Utilities.Icons.ControlIcon;
 parameter Boolean use_dhw "=false to disable DHW";
  parameter Boolean use_openModelica=false
    "=true to disable features which 
    are not available in open modelica" annotation(Dialog(tab="Advanced"));

  BESMod.Systems.Hydraulical.Interfaces.GenerationControlBus
    sigBusGen
    annotation (Placement(transformation(extent={{-178,-124},{-126,-74}})));
  BESMod.Systems.Hydraulical.Interfaces.DistributionControlBus
    sigBusDistr
    annotation (Placement(transformation(extent={{-22,-128},{24,-72}})));
  BESMod.Systems.Hydraulical.Interfaces.ControlOutputs
    outBusCtrl if not use_openModelica
    annotation (Placement(transformation(extent={{230,-10},{250,10}})));
  IBPSA.BoundaryConditions.WeatherData.Bus
      weaBus "Weather data bus" annotation (Placement(transformation(extent={{-258,
            -20},{-216,24}}),    iconTransformation(extent={{-252,-12},{
            -216,22}})));
  Interfaces.TransferControlBus sigBusTra
    annotation (Placement(transformation(extent={{152,-124},{196,-76}})));
  replaceable parameter BESMod.Systems.RecordsCollection.SubsystemControlBaseDataDefinition
    generationParameters "Parameters of generation subsystem"
    annotation (Placement(transformation(extent={{-194,-106},{-174,-86}})));
  replaceable parameter BESMod.Systems.Hydraulical.Distribution.RecordsCollection.DistributionControlBaseDataDefinition
    distributionParameters "Parameters of distribution subsystem"
    annotation (Placement(transformation(extent={{-36,-108},{-16,-88}})));
  replaceable parameter BESMod.Systems.Hydraulical.Transfer.RecordsCollection.TransferControlBaseDataDefinition
    transferParameters "Parameters of transfer subsystem"
    annotation (Placement(transformation(extent={{138,-108},{158,-88}})));
  BESMod.Systems.Interfaces.UseProBus useProBus annotation (
      Placement(transformation(extent={{-140,80},{-98,126}}),
        iconTransformation(extent={{-138,80},{-88,124}})));
  BESMod.Systems.Interfaces.BuiMeaBus buiMeaBus annotation (
      Placement(transformation(extent={{42,84},{88,122}}), iconTransformation(
          extent={{42,84},{88,122}})));
  Interfaces.SystemControlBus sigBusHyd annotation (Placement(transformation(
          extent={{-48,84},{-8,118}}), iconTransformation(extent={{-48,84},{-8,
            118}})));
equation

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-240,
            -100},{240,100}}), graphics={
        Rectangle(
          extent={{-240,100},{240,-100}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-234,8},{226,-10}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{160,16},{208,-20}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-234,-52},{226,-70}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-234,68},{226,50}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-196,-42},{-148,-78}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-74,76},{-26,40}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid)}),                      Diagram(graphics,
        coordinateSystem(preserveAspectRatio=false, extent={{-240,-100},{240,
            100}})));
end PartialControl;
