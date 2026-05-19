within BESMod.Systems.Hydraulical.Control.Components.PumpController;
model ConstantSpeed "Model with a constant speed of the pump"
  extends
    BESMod.Systems.Hydraulical.Control.Components.PumpController.BaseClasses.PartialPumpController;
protected
  Modelica.Blocks.Sources.Constant const(each final k=conSpeed)
    annotation (Placement(transformation(extent={{-8,-10},{12,10}})));
public
  parameter Real conSpeed=1 "Constant speed";
equation
  connect(const.y, yPum)
    annotation (Line(points={{13,0},{120,0}}, color={0,0,127}));
end ConstantSpeed;
