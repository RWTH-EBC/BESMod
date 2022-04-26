within BESMod.Systems.Hydraulical;
model HydraulicSystem
  extends BaseClasses.PartialHydraulicSystem;
  Electrical.Interfaces.InternalElectricalPin internalElectricalPin
    annotation (Placement(transformation(extent={{160,-150},{180,-130}})));
equation
  connect(generation.internalElectricalPin, internalElectricalPin) annotation (
      Line(
      points={{-40.24,-102.68},{-40.24,-102},{-40,-102},{-40,-140},{170,-140}},
      color={0,0,0},
      thickness=1));

  connect(distribution.internalElectricalPin, internalElectricalPin)
    annotation (Line(
      points={{74.7,-102.68},{74.7,-140},{170,-140}},
      color={0,0,0},
      thickness=1));
  connect(transfer.internalElectricalPin, internalElectricalPin) annotation (
      Line(
      points={{170.48,-43.28},{170.48,-87.64},{170,-87.64},{170,-140}},
      color={0,0,0},
      thickness=1));
end HydraulicSystem;
