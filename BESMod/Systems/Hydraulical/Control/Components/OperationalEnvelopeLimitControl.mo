within BESMod.Systems.Hydraulical.Control.Components;
model OperationalEnvelopeLimitControl
  "Control which accounts for operational envelope limits"
  parameter Real dTOpeEnv "Constant output value";
  parameter Modelica.Units.SI.Temperature tabUppHea[:,2]
    "Upper temperature boundary for heating with second column as useful temperature side";
  Modelica.Blocks.Tables.CombiTable1Ds uppTabOpeEnv(
    final table=tabUppHea,
    final smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
    final tableOnFile=false)  "2D operational envelope"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Modelica.Blocks.Interfaces.RealOutput TSetOut(unit="K")
    "Corrected heat pump set temperature"
    annotation (Placement(transformation(extent={{100,50},{120,70}})));
  Modelica.Blocks.Interfaces.RealInput TSet(unit="K")
    "Connector of Real output signal containing input signal u in another unit"
    annotation (Placement(transformation(extent={{-120,-50},{-100,-30}}),
        iconTransformation(extent={{-120,-50},{-100,-30}})));
  Modelica.Blocks.Nonlinear.VariableLimiter varLim
    "Limit supply temperature to operational envelope"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.Constant conZerDegC(final k=273.15)
    "Essentially no lower bound" annotation (extent=[-88,38; -76,50], Placement(
        transformation(extent={{-80,-20},{-60,0}})));
  Modelica.Blocks.Logical.Hysteresis hys(
    final uLow=Modelica.Constants.eps*10,
    final uHigh=dTOpeEnv/2)
    "True if operational envelope is violated"
    annotation (Placement(transformation(extent={{60,-40},{80,-20}})));
  Modelica.Blocks.Interfaces.BooleanOutput bivOn
    "Bivalent device should turn on"
    annotation (Placement(transformation(extent={{100,-40},{120,-20}})));
  Modelica.Blocks.Sources.Constant dTOpeEnvConst(final k=dTOpeEnv)
     annotation (extent=[-88,38; -76,50], Placement(
        transformation(extent={{-80,60},{-60,80}})));
  Modelica.Blocks.Math.Add addDTOpeEnv(final k1=-1)
                                              annotation (extent=[-88,38; -76,
        50], Placement(transformation(extent={{-40,40},{-20,60}})));

  Modelica.Blocks.Math.Add dSetLim(final k2=-1)  annotation (
      extent=[-88,38; -76,50], Placement(transformation(extent={{20,-20},{40,-40}})));
  Modelica.Blocks.Interfaces.RealInput TEvaIn(unit="K")
    "Evaporator inlet temperature"
    annotation (Placement(transformation(extent={{-120,30},{-100,50}}),
        iconTransformation(extent={{-120,30},{-100,50}})));
equation
  connect(TSet, varLim.u) annotation (Line(points={{-110,-40},{-22,-40},{-22,0},
          {-12,0}}, color={0,0,127}));
  connect(conZerDegC.y, varLim.limit2) annotation (Line(points={{-59,-10},{-40,-10},
          {-40,-8},{-12,-8}}, color={0,0,127}));
  connect(varLim.y, TSetOut) annotation (Line(points={{11,0},{40,0},{40,60},{110,
          60}}, color={0,0,127}));
  connect(hys.y, bivOn)
    annotation (Line(points={{81,-30},{110,-30}}, color={255,0,255}));
  connect(addDTOpeEnv.y, varLim.limit1)
    annotation (Line(points={{-19,50},{-12,50},{-12,8}}, color={0,0,127}));
  connect(dTOpeEnvConst.y, addDTOpeEnv.u1) annotation (Line(points={{-59,70},{-50,
          70},{-50,56},{-42,56}}, color={0,0,127}));
  connect(hys.u, dSetLim.y)
    annotation (Line(points={{58,-30},{41,-30}}, color={0,0,127}));
  connect(TSet, dSetLim.u1) annotation (Line(points={{-110,-40},{8,-40},{8,-36},
          {18,-36}}, color={0,0,127}));
  connect(varLim.y, dSetLim.u2) annotation (Line(points={{11,0},{14,0},{14,-24},
          {18,-24}}, color={0,0,127}));
  connect(uppTabOpeEnv.u, TEvaIn)
    annotation (Line(points={{-82,30},{-96,30},{-96,40},{-110,40}},
                                                  color={0,0,127}));
  connect(addDTOpeEnv.u2, uppTabOpeEnv.y[1]) annotation (Line(points={{-42,44},{
          -54,44},{-54,30},{-59,30}}, color={0,0,127}));

   annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html><p>
  This control was developed and presented within the publication
  'Integration of Back-Up Heaters in Retrofit Heat Pump Systems: Which
  to Choose, Where to Place, and How to Control?' ( see <a href=
  \"https://doi.org/10.3390/en15197134\">https://doi.org/10.3390/en15197134&lt;\a&gt;)
  and account for limited operational envelope temperatures of heat
  pumps. In case the set temperature exceeds the envelope minus some
  threshold (e.g. due to different set / measurement location in the
  system), the set temperature is limited and a bivalent backup unit
  may turn on. </a>
</p>
</html>"));
end OperationalEnvelopeLimitControl;
