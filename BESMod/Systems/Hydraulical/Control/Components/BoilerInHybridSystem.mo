within BESMod.Systems.Hydraulical.Control.Components;
model BoilerInHybridSystem "Decides when to use the boiler"

  parameter Modelica.Units.SI.Temperature TBiv "Bivalence temperature";
  parameter Modelica.Units.SI.Temperature TCutOff "Cutoff temperature";

  Modelica.Blocks.Logical.LessThreshold lesTBiv(threshold=TBiv)
    "Checks, if Toda is below Tbiv"
    annotation (Placement(transformation(extent={{-60,80},{-40,100}})));
  Modelica.Blocks.Logical.Or or1
    "entweder WP im Sperrmodus oder voll ausgelastet"
    annotation (Placement(transformation(extent={{-12,-30},{8,-10}})));
  Modelica.Blocks.MathBoolean.And allConMet(nu=3)
    "If all 3 conditions are met, turn secondary heater on"
    annotation (Placement(transformation(extent={{22,-10},{42,10}})));
  Modelica.Blocks.Logical.Or or2
    "if Toda is smaller than TCutOff, activate Boiler"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Modelica.Blocks.Logical.LessThreshold lesTCutOff(threshold=TCutOff)
    "Checks if Toda is below TCutOff"
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
  Modelica.Blocks.Logical.And safCtrOn
    "=true if the primary devices is blocked due to safety issues"
    annotation (Placement(transformation(extent={{-52,-30},{-32,-50}})));
  Modelica.Blocks.Logical.Not not2
    annotation (Placement(transformation(extent={{-92,-70},{-72,-50}})));
  Modelica.Blocks.Logical.Hysteresis hysPriGenAtMax(uLow=0.85, uHigh=0.9)
    "Hysteresis in to check if primary device runs at full load"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  Modelica.Blocks.Interfaces.BooleanInput secGen
    "=true if secondary generator should be used"
    annotation (Placement(transformation(extent={{-138,20},{-98,60}})));
  Modelica.Blocks.Interfaces.RealInput TOda(unit="K", displayUnit="degC")
    "Outdoor air temperature"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
  Modelica.Blocks.Interfaces.BooleanInput priGenSetOn
    "=true if primary generator should be on"
    annotation (Placement(transformation(extent={{-140,-44},{-100,-4}})));
  Modelica.Blocks.Interfaces.BooleanInput priGenIsOn
    "=true if primary generator is on"
    annotation (Placement(transformation(extent={{-138,-80},{-98,-40}})));
  Modelica.Blocks.Interfaces.RealInput ySetPriGen "Primary generator set speed"
    annotation (Placement(transformation(extent={{-140,-10},{-100,30}})));
  Modelica.Blocks.Interfaces.BooleanOutput secGenOn "Turn secondary generator on"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Logical.Hysteresis hysBoiToHot(uLow=273.15 + 90, uHigh=273.15
         + 95) "Hysteresis in to check if primary device runs at full load"
    annotation (Placement(transformation(extent={{-30,-76},{-10,-56}})));
  Modelica.Blocks.Logical.And safCtrBoi
    "=true if the primary devices is blocked due to safety issues"
    annotation (Placement(transformation(extent={{40,-34},{60,-54}})));
  Modelica.Blocks.Logical.Not notBoiToHot
    annotation (Placement(transformation(extent={{2,-62},{22,-42}})));
  Modelica.Blocks.Interfaces.RealInput Tboi(unit="K", displayUnit="degC")
    "Outdoor air temperature" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={0,-112})));
equation
  connect(lesTBiv.y, allConMet.u[1]) annotation (Line(points={{-39,90},{-24,90},
          {-24,40},{4,40},{4,-2.33333},{22,-2.33333}},color={255,0,255}));
  connect(or1.y, allConMet.u[2]) annotation (Line(points={{9,-20},{22,-20},{22,
          0}},                 color={255,0,255}));
  connect(allConMet.y, or2.u2) annotation (Line(points={{43.5,0},{58,0},{58,-8}},
                   color={255,0,255}));
  connect(lesTCutOff.y, or2.u1) annotation (Line(points={{-39,60},{58,60},{58,0}},
                   color={255,0,255}));
  connect(not2.y, safCtrOn.u1) annotation (Line(points={{-71,-60},{-54,-60},{
          -54,-40}},       color={255,0,255}));
  connect(safCtrOn.y, or1.u2) annotation (Line(points={{-31,-40},{-14,-40},{-14,
          -28}},          color={255,0,255}));
  connect(hysPriGenAtMax.y, or1.u1) annotation (Line(points={{-39,10},{-14,10},
          {-14,-20}},     color={255,0,255}));
  connect(allConMet.u[3], secGen) annotation (Line(points={{22,2.33333},{22,-2},
          {4,-2},{4,40},{-118,40}},color={255,0,255}));
  connect(lesTBiv.u, TOda) annotation (Line(points={{-62,90},{-92,90},{-92,80},{
          -120,80}}, color={0,0,127}));
  connect(lesTCutOff.u, TOda) annotation (Line(points={{-62,60},{-88,60},{-88,80},
          {-120,80}}, color={0,0,127}));
  connect(priGenIsOn, not2.u)
    annotation (Line(points={{-118,-60},{-94,-60}}, color={255,0,255}));
  connect(safCtrOn.u2, priGenSetOn) annotation (Line(points={{-54,-32},{-94,-32},
          {-94,-24},{-120,-24}}, color={255,0,255}));
  connect(hysPriGenAtMax.u, ySetPriGen)
    annotation (Line(points={{-62,10},{-120,10}}, color={0,0,127}));
  connect(safCtrBoi.y, secGenOn) annotation (Line(points={{61,-44},{96,-44},{96,
          0},{110,0}}, color={255,0,255}));
  connect(or2.y, safCtrBoi.u2) annotation (Line(points={{81,0},{86,0},{86,-28},
          {38,-28},{38,-36}}, color={255,0,255}));
  connect(notBoiToHot.y, safCtrBoi.u1) annotation (Line(points={{23,-52},{28,
          -52},{28,-44},{38,-44}}, color={255,0,255}));
  connect(hysBoiToHot.y, notBoiToHot.u) annotation (Line(points={{-9,-66},{30,
          -66},{30,-38},{0,-38},{0,-52}}, color={255,0,255}));
  connect(hysBoiToHot.u, Tboi) annotation (Line(points={{-32,-66},{-40,-66},{
          -40,-86},{0,-86},{0,-112}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(extent={{-100,-100},{100,100}})), Icon(
        coordinateSystem(extent={{-100,-100},{80,100}})));
end BoilerInHybridSystem;
