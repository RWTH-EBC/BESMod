within BESMod.Systems.Hydraulical.Control.Components.ThermostaticValveController;
model ConstantOpening "Model with a constant opening of the valves"
  extends BaseClasses.PartialThermostaticValveController;
protected
  Modelica.Blocks.Sources.Constant const[nZones](each final k=conOpe)
    annotation (Placement(transformation(extent={{-8,-10},{12,10}})));
public
  parameter Real conOpe=1 "Constant opening";
equation
  connect(const.y, opening)
    annotation (Line(points={{13,0},{120,0}}, color={0,0,127}));
end ConstantOpening;
