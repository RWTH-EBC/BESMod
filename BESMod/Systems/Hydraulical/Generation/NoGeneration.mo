within BESMod.Systems.Hydraulical.Generation;
model NoGeneration "No heat generation at all"
  extends BaseClasses.PartialGeneration(
    dp_nominal={0},
    dTTra_nominal={10},
    final nParallelDem=1);
  BESMod.Utilities.Electrical.ZeroLoad zeroLoad
    annotation (Placement(transformation(extent={{32,-108},{52,-88}})));
equation
  connect(portGen_out, portGen_in) annotation (Line(points={{100,80},{78,80},{
          78,-2},{100,-2}}, color={0,127,255}));
  connect(zeroLoad.internalElectricalPin, internalElectricalPin) annotation (
      Line(
      points={{52,-98},{62,-98},{62,-100},{72,-100}},
      color={0,0,0},
      thickness=1));
  annotation (Documentation(info="<html>
<p>This class is meant to be selected, when no heat generation is needed. </p>
</html>"));
end NoGeneration;
