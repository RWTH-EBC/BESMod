within BESMod.Systems.Hydraulical.Control.Components.RelativeSpeedController;
model PID "PID controller for inverter controlled devices"
  extends BaseClasses.PartialControler;

  BESMod.Systems.Hydraulical.Control.Components.RelativeSpeedController.BaseClasses.LimPID
    PID(
    controllerType=Modelica.Blocks.Types.SimpleController.PID,
    final k=parPID.P,
    Ti=parPID.timeInt,
    Td=parPID.timeDer,
    final yMax=parPID.yMax,
    final yMin=parPID.yMin,
    final wp=1,
    final wd=0,
    Ni=parPID.Ni,
    Nd=parPID.Nd,
    final initType=Modelica.Blocks.Types.Init.InitialState,
    homotopyType=Modelica.Blocks.Types.LimiterHomotopy.NoHomotopy,
    final strict=false,
    final xi_start=0,
    final xd_start=0,
    final y_start=parPID.y_start,
    final limitsAtInit=true)
    annotation (Placement(transformation(extent={{-30,22},{6,58}})));

  Modelica.Blocks.Logical.Switch onOffSwi "Switch on off"
    annotation (Placement(transformation(extent={{38,-14},{68,16}})));
  Modelica.Blocks.Sources.Constant const(final k=parPID.yOff) "HP turned off"
    annotation (Placement(transformation(extent={{-6,-36},{10,-20}})));
  Modelica.Blocks.Logical.And and1
    annotation (Placement(transformation(extent={{-52,-64},{-32,-44}})));

  replaceable record parPID=
      BESMod.Systems.Hydraulical.Control.RecordsCollection.PIDBaseDataDefinition
    constrainedby BESMod.Systems.Hydraulical.Control.RecordsCollection.PIDBaseDataDefinition "PID parameters"
    annotation (choicesAllMatching=true,
                Placement(transformation(extent={{80,-100},{100,-80}})));
equation
  connect(setOn, onOffSwi.u2)
    annotation (Line(points={{-120,0},{34,0},{34,1},{35,1}}, color={255,0,255}));
  connect(onOffSwi.y, ySet)
    annotation (Line(points={{69.5,1},{74,1},{74,0},{110,0}}, color={0,0,127}));
  connect(const.y, onOffSwi.u3)
    annotation (Line(points={{10.8,-28},{35,-28},{35,-11}}, color={0,0,127}));
  connect(PID.y, onOffSwi.u1) annotation (Line(points={{7.8,40},{14,40},{14,13},{35,
          13}}, color={0,0,127}));
  connect(TSet, PID.u_s) annotation (Line(points={{-120,60},{-70,60},{-70,40},{-33.6,
          40}}, color={0,0,127}));
  connect(TMea, PID.u_m) annotation (Line(points={{0,-120},{0,-54},{-12,-54},{-12,
          18.4}}, color={0,0,127}));
  connect(and1.y, PID.IsOn) annotation (Line(points={{-31,-54},{-22.8,-54},{
          -22.8,18.4}}, color={255,0,255}));
  connect(setOn, and1.u1) annotation (Line(points={{-120,0},{-72,0},{-72,-54},{
          -54,-54}}, color={255,0,255}));
  connect(isOn, and1.u2) annotation (Line(points={{-60,-120},{-60,-62},{-54,-62}},
        color={255,0,255}));
end PID;
