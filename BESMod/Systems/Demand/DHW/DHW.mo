within BESMod.Systems.Demand.DHW;
model DHW "Standard DHW subsystem"
  extends BaseClasses.PartialDHW;
  Modelica.Blocks.Sources.RealExpression NoElectricalLoad
    annotation (Placement(transformation(extent={{-8,-104},{12,-84}})));
  Utilities.Electrical.RealToElecCon realToElecCon
    annotation (Placement(transformation(extent={{28,-104},{48,-84}})));
equation
  connect(NoElectricalLoad.y, realToElecCon.PElec)
    annotation (Line(points={{13,-94},{27.4,-94}}, color={0,0,127}));
  connect(realToElecCon.internalElectricalPin, internalElectricalPin)
    annotation (Line(
      points={{48.2,-93.8},{61.1,-93.8},{61.1,-98},{70,-98}},
      color={0,0,0},
      thickness=1));
end DHW;
