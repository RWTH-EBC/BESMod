within BESMod.Tutorial;
model MyOwnModule "My module can do this and that"
  extends BESMod.Tutorial.BaseClasses.PartialModule(timePeriod=1/myComponentParameters.f);
  parameter Boolean use_lim "=false to disable the limiter to yMax"
    annotation (Dialog(group="Component Choices"));
  replaceable parameter BESMod.Tutorial.RecordsCollection.MyComponentBaseDataDefinition
    myComponentParameters constrainedby
    BESMod.Tutorial.RecordsCollection.MyComponentBaseDataDefinition(final amplitude=yMax)
                                                    annotation (
    choicesAllMatching=true,
    Dialog(group="Component Records"),
    Placement(transformation(extent={{-98,62},{-64,98}})));
  Modelica.Blocks.Sources.Sine sine(
    amplitude=myComponentParameters.amplitude,
    f=myComponentParameters.f,
    phase=myComponentParameters.phase,
    offset=myComponentParameters.offset,
    startTime=myComponentParameters.startTime)
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Modelica.Blocks.Nonlinear.Limiter
                            limiter(final uMax=yMax, final uMin=-yMax)
    if use_lim
    annotation (Placement(transformation(extent={{6,4},{26,24}})));
  Modelica.Blocks.Interfaces.RealOutput y "Output signal connector"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Routing.RealPassThrough realPassThrough if not use_lim
    annotation (Placement(transformation(extent={{6,-26},{26,-6}})));

equation
  connect(sine.y, limiter.u)
    annotation (Line(points={{-39,0},{-8,0},{-8,14},{4,14}}, color={0,0,127}));
  connect(limiter.y, y) annotation (Line(points={{27,14},{42,14},{42,0},{110,0}},
        color={0,0,127}));
  connect(sine.y, realPassThrough.u) annotation (Line(points={{-39,0},{-8,0},{-8,
          -16},{4,-16}},  color={0,0,127}));
  connect(realPassThrough.y, y) annotation (Line(points={{27,-16},{42,-16},{42,0},
          {110,0}}, color={0,0,127}));
end MyOwnModule;
