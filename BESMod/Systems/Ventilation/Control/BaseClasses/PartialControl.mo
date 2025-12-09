within BESMod.Systems.Ventilation.Control.BaseClasses;
partial model PartialControl
  extends BESMod.Utilities.Icons.ControlIcon;
  parameter Boolean use_openModelica=false
    "=true to disable features which 
    are not available in open modelica" annotation(Dialog(tab="Advanced"));
  replaceable parameter
    BESMod.Systems.RecordsCollection.TwoSideSubsystemControlBaseDataDefinition
    parDis constrainedby
    BESMod.Systems.RecordsCollection.TwoSideSubsystemControlBaseDataDefinition
    annotation (Placement(transformation(extent={{-94,-100},{-74,-80}})),
      choicesAllMatching=true);
  replaceable parameter
    BESMod.Systems.RecordsCollection.SingleSideSubsystemControlBaseDataDefinition
    parGen constrainedby
    BESMod.Systems.RecordsCollection.SingleSideSubsystemControlBaseDataDefinition
    annotation (Placement(transformation(extent={{30,-100},{50,-80}})),
      choicesAllMatching=true);
  Interfaces.ControlOutputs outBusCtrl if not use_openModelica
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Interfaces.GenerationControlBus sigBusGen
    annotation (Placement(transformation(extent={{50,-110},{70,-90}})));
  Interfaces.DistributionControlBus sigBusDistr
    annotation (Placement(transformation(extent={{-70,-108},{-50,-88}})));
  IBPSA.BoundaryConditions.WeatherData.Bus
      weaBus "Weather data bus" annotation (Placement(transformation(extent={{-20,76},
            {22,120}}),          iconTransformation(extent={{-8,90},{12,
            110}})));
  BESMod.Systems.Interfaces.BuiMeaBus buiMeaBus annotation (
      Placement(transformation(extent={{-116,66},{-88,92}}), iconTransformation(
          extent={{-114,46},{-92,70}})));
  BESMod.Systems.Interfaces.UseProBus useProBus annotation (
      Placement(transformation(extent={{-120,-78},{-86,-42}}),
        iconTransformation(extent={{-118,-72},{-92,-42}})));
  Interfaces.SystemControlBus sigBusVen annotation (Placement(transformation(
          extent={{-124,-20},{-84,22}}), iconTransformation(extent={{-124,-20},
            {-84,22}})));

  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(graphics,
        coordinateSystem(preserveAspectRatio=false)));
end PartialControl;
