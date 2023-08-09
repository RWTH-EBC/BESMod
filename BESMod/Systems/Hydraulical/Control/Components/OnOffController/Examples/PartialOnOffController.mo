within BESMod.Systems.Hydraulical.Control.Components.OnOffController.Examples;
partial model PartialOnOffController
  parameter Real TSetDef=273.15 + 50 "Constant output value";
  parameter Real dTHys "Hysterisis value";
  replaceable BaseClasses.PartialOnOffController onOffController annotation (
      choicesAllMatching=true, Placement(transformation(extent={{-18,-16},{38,
            38}})));
  Modelica.Blocks.Sources.Ramp ramp(
    height=70,
    duration=3600,
    offset=273.15 - 30)
    annotation (Placement(transformation(extent={{-78,58},{-58,78}})));
  Modelica.Blocks.Sources.Pulse pulse(
    amplitude=dTHys + 2,
    period=1800,
    offset=TSetDef - dTHys/2 - 1)
    annotation (Placement(transformation(extent={{-84,2},{-64,22}})));
  Modelica.Blocks.Sources.Constant constTSet(k=TSetDef)
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));

equation
  connect(ramp.y, onOffController.TOda)
    annotation (Line(points={{-57,68},{10,68},{10,41.24}}, color={0,0,127}));
  connect(pulse.y, onOffController.TStoTop) annotation (Line(points={{-63,12},{-56,
          12},{-56,30},{-20.8,30},{-20.8,29.9}}, color={0,0,127}));
  connect(pulse.y, onOffController.TStoBot) annotation (Line(points={{-63,12},{-56,
          12},{-56,-2.5},{-20.8,-2.5}}, color={0,0,127}));
  connect(constTSet.y, onOffController.TSupSet)
    annotation (Line(points={{-39,-50},{10,-50},{10,-18.7}}, color={0,0,127}));
  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(graphics,
        coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=3600,
      Interval=1,
      __Dymola_Algorithm="Dassl"));
end PartialOnOffController;
