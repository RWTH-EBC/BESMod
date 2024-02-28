within BESMod.Systems.Control.BaseClasses;
partial model PartialControl "Model for a partial HEMS control"
  extends BESMod.Utilities.Icons.ControlIcon;
  parameter Boolean use_openModelica=false
    "=true to disable features which 
    are not available in open modelica" annotation(Dialog(tab="Advanced"));
  Hydraulical.Interfaces.SystemControlBus sigBusHyd annotation (Placement(
        transformation(extent={{-94,-114},{-64,-88}}), iconTransformation(
          extent={{-94,-114},{-64,-88}})));
  Ventilation.Interfaces.SystemControlBus sigBusVen annotation (Placement(
        transformation(extent={{64,-114},{96,-86}}), iconTransformation(extent=
            {{64,-114},{96,-86}})));
  Interfaces.ControlOutputs outBusCtrl if not use_openModelica
                                       annotation (Placement(transformation(
          extent={{84,-16},{118,16}}), iconTransformation(extent={{84,-16},{118,
            16}})));
  Electrical.Interfaces.SystemControlBus sigBusEle annotation (Placement(
        transformation(extent={{-116,-14},{-84,14}}), iconTransformation(extent=
           {{-116,-14},{-84,14}})));
  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(graphics,
        coordinateSystem(preserveAspectRatio=false)));
end PartialControl;
