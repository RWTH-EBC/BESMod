within BESMod.Systems.Hydraulical.Control.Components;
model BoilerInHybridSystem "Decides when to use the boiler"

  parameter Modelica.Units.SI.Temperature TBiv "Bivalence temperature";
  parameter Modelica.Units.SI.Temperature TCutOff "Cutoff temperature";

  Modelica.Blocks.Logical.LessThreshold lesTBiv(threshold=TBiv)
    "Checks, if Toda is below Tbiv"
    annotation (Placement(transformation(extent={{-60,80},{-40,100}})));
  Modelica.Blocks.Logical.Or or1
    "entweder WP im Sperrmodus oder voll ausgelastet"
    annotation (Placement(transformation(extent={{0,-30},{20,-10}})));
  Modelica.Blocks.MathBoolean.And allConMet(nu=3)
    "If all 3 conditions are met, turn secondary heater on"
    annotation (Placement(transformation(extent={{34,-10},{54,10}})));
  Modelica.Blocks.Logical.Or or2
    "if Toda is smaller than TCutOff, activate Boiler"
    annotation (Placement(transformation(extent={{72,-10},{92,10}})));
  Modelica.Blocks.Logical.LessThreshold lesTCutOff(threshold=TCutOff)
    "Checks if Toda is below TCutOff"
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
  Modelica.Blocks.Logical.And safCtrOn
    "=true if the primary devices is blocked due to safety issues"
    annotation (Placement(transformation(extent={{-40,-30},{-20,-50}})));
  Modelica.Blocks.Logical.Not not2
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));
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
equation
  connect(lesTBiv.y, allConMet.u[1]) annotation (Line(points={{-39,90},{-24,90},{
          -24,40},{4,40},{4,-2.33333},{34,-2.33333}}, color={255,0,255}));
  connect(or1.y, allConMet.u[2]) annotation (Line(points={{21,-20},{30,-20},{30,
          -2},{34,-2},{34,0}}, color={255,0,255}));
  connect(allConMet.y, or2.u2) annotation (Line(points={{55.5,0},{62,0},{62,-8},{
          70,-8}}, color={255,0,255}));
  connect(lesTCutOff.y, or2.u1) annotation (Line(points={{-39,60},{64,60},{64,0},
          {70,0}}, color={255,0,255}));
  connect(not2.y, safCtrOn.u1) annotation (Line(points={{-59,-60},{-48,-60},{-48,
          -40},{-42,-40}}, color={255,0,255}));
  connect(safCtrOn.y, or1.u2) annotation (Line(points={{-19,-40},{-10,-40},{-10,
          -28},{-2,-28}}, color={255,0,255}));
  connect(hysPriGenAtMax.y, or1.u1) annotation (Line(points={{-39,10},{-8,10},{-8,
          -20},{-2,-20}}, color={255,0,255}));
  connect(allConMet.u[3], secGen) annotation (Line(points={{34,2.33333},{34,-2},{
          4,-2},{4,40},{-118,40}}, color={255,0,255}));
  connect(lesTBiv.u, TOda) annotation (Line(points={{-62,90},{-92,90},{-92,80},{
          -120,80}}, color={0,0,127}));
  connect(lesTCutOff.u, TOda) annotation (Line(points={{-62,60},{-88,60},{-88,80},
          {-120,80}}, color={0,0,127}));
  connect(priGenIsOn, not2.u)
    annotation (Line(points={{-118,-60},{-82,-60}}, color={255,0,255}));
  connect(safCtrOn.u2, priGenSetOn) annotation (Line(points={{-42,-32},{-94,-32},
          {-94,-24},{-120,-24}}, color={255,0,255}));
  connect(hysPriGenAtMax.u, ySetPriGen)
    annotation (Line(points={{-62,10},{-120,10}}, color={0,0,127}));
  connect(or2.y, secGenOn)
    annotation (Line(points={{93,0},{110,0}}, color={255,0,255}));
  annotation (Diagram(coordinateSystem(extent={{-100,-100},{100,100}})), Icon(
        coordinateSystem(extent={{-100,-100},{80,100}})), Documentation(info="<html><p>
  Model for controlling the boiler operation in a hybrid system with
  primary and secondary generator. The model decides when to operate
  the boiler based on outdoor temperature conditions and primary
  generator status.
</p>
<h4>
  Important Parameters
</h4>
<ul>
  <li>
    <code>TBiv</code>: Bivalence temperature - Temperature threshold
    below which secondary heating is allowed
  </li>
  <li>
    <code>TCutOff</code>: Cut-off temperature - Temperature threshold
    below which boiler operation is always enabled
  </li>
</ul>
<h4>
  Control Logic
</h4>
<p>
  The boiler is turned on if any of these conditions are met:
</p>
<ul>
  <li>Outdoor temperature is below cut-off temperature (TCutOff)
  </li>
  <li>All of the following conditions are true:
    <ul>
      <li>Outdoor temperature is below bivalence temperature (TBiv)
      </li>
      <li>Secondary generator use is requested
      </li>
      <li>Either:
        <ul>
          <li>Primary generator is blocked due to safety issues, or
          </li>
          <li>Primary generator is running at maximum capacity
          (&gt;85-90% load)
          </li>
        </ul>
      </li>
    </ul>
  </li>
</ul>
</html>"));
end BoilerInHybridSystem;
