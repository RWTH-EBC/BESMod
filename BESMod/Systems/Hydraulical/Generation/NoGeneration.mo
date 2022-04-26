within BESMod.Systems.Hydraulical.Generation;
model NoGeneration "No heat generation at all"
  extends BaseClasses.PartialGeneration(
    dp_nominal={0},
    dTTra_nominal={10},
    final nParallelDem=1);
equation
  connect(portGen_out, portGen_in) annotation (Line(points={{100,80},{78,80},{
          78,-2},{100,-2}}, color={0,127,255}));
end NoGeneration;
