within BESMod.Systems.Hydraulical.Control.Components.BuildingSupplyTemperatureSetpoints;
model Constant "Constant supply temperature"
  extends BaseClasses.PartialSetpoint;
  parameter Modelica.Units.SI.Temperature TConSup=TSup_nominal
    "Constant supply temperature";
  Modelica.Blocks.Sources.Constant const(final k=TConSup)
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));

equation
  connect(const.y, TSet)
    annotation (Line(points={{81,0},{94,0},{94,0},{110,0}}, color={0,0,127}));
end Constant;
