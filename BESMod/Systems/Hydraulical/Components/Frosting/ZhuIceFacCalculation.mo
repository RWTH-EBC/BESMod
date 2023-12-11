within BESMod.Systems.Hydraulical.Components.Frosting;
model ZhuIceFacCalculation "IceFac based on Zhus Frosting Map"
    extends BaseClasses.PartialFrosting;
  parameter Modelica.Units.SI.SpecificEnthalpy h_water_fusion=333.5e3 "Fusion enthalpy of water (Schmelzenthalpie)";

  parameter Modelica.Units.SI.Area A=15
                                    "Area of heat exchanger (All fins from both sides, as the growth rate is specific for the area of the HE";
  parameter Modelica.Units.SI.Density density=918
                                             "Density of ice";
  parameter Real minIceFac=0.5
                           "Minimal allowed icing Factor to trigger the defrost";
  parameter Modelica.Units.SI.Mass m_ice_max=density*A*d/2
                                            "Maximal possible mass of ice on HE surface. This value is limited by the volume between the fin tube";
  parameter Modelica.Units.SI.Distance d=3e-3
                                        "Distance between two fins. Used to calculate the maximal mass of ice on the HE";
  parameter Modelica.Units.SI.Volume V_h=19e-6
                                        "Compressor Displacement Volume per rev";
  parameter Modelica.Units.SI.Frequency N_max=120
                                             "Maximal compressor rotational speed";
  parameter Modelica.Units.SI.VolumeFlowRate V_flow_air=0.001
                                                       "Volume flow rate over outdoor air coil";
  parameter Real natConvCoeff(unit="m/(s.K)")=1e-7
                                              "Parameter to be calibrated for natural defrost";

  Modelica.Blocks.Sources.RealExpression iceFac_internal(y=iceFac)
    "iceFac from internal calculations" annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=0,
        origin={-62,80})));
  Modelica.Blocks.Sources.BooleanExpression mode_internal(y=mode_hp)
    "Mode from internal calcuations"                   annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=0,
        origin={70,-90})));

  Boolean mode_hp(start=false) "Heat pump heating mode";
  Real iceFac(start=1) "Icing Factor";
  Modelica.Units.SI.MassFlowRate m_flow_ice(start=0) "Current mass of ice on evaporator surface";
  Modelica.Units.SI.Mass m_ice(start=0) "Total mass that was on evaporator surface over whole simulation duration";
  Modelica.Units.SI.Velocity growth_rate_natural_conv(min=0, start=0) "Growth rate of ice for natural convection (melting)";
  Modelica.Units.SI.Velocity growth_rate_forced_conv(min=0, start=0) "Growth rate of ice for forced convection";
  Real densityCoeff(start=1) "density coefficient";
  Modelica.Units.SI.Time critDefTim
    "Time until next defrost cycle (based on time-method)";
  Real CICO(unit="s/m") "CICO  value";

  replaceable function frostMapFunc =
      BESMod.Systems.Hydraulical.Components.Frosting.Functions.partialFrostingMap
                                                                                                annotation(choicesAllMatching=true);

  Modelica.Blocks.Logical.Hysteresis hys(uLow=minIceFac, uHigh=1)
    "For the iceFac control. Output signal is used internally"
    annotation (Placement(transformation(extent={{-30,70},{-10,90}})));
  Modelica.Blocks.Logical.Timer timer
    annotation (Placement(transformation(extent={{30,-40},{50,-20}})));
  Modelica.Blocks.Logical.Greater greater
    annotation (Placement(transformation(extent={{60,-60},{80,-40}})));
  Modelica.Blocks.Sources.RealExpression critDefTim_internal(y=critDefTim)
    "Mode from internal calcuations" annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=0,
        origin={30,-70})));
  Modelica.Blocks.Logical.GreaterThreshold greaterThreshold(threshold=Modelica.Constants.eps)
    annotation (Placement(transformation(extent={{-30,-20},{-10,0}})));
  Modelica.Blocks.Sources.RealExpression growthRateFor_internal(y=
        growth_rate_forced_conv) "growthRate from internal calcuations"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=0,
        origin={-50,30})));
  Modelica.Blocks.Logical.Not not1
    annotation (Placement(transformation(extent={{0,70},{20,90}})));
  Modelica.Blocks.Logical.Or orDefrost "Either hys or crit min time"
    annotation (Placement(transformation(extent={{40,0},{60,20}})));

  Modelica.Blocks.Logical.And and1
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));
  Modelica.Blocks.Logical.LessEqualThreshold lesEquThr(threshold=1 - Modelica.Constants.eps)
    annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));
  Modelica.Blocks.Routing.BooleanPassThrough boolPassHP_on
    annotation (Placement(transformation(extent={{-90,-78},{-70,-58}})));

  Modelica.Units.SI.Time totalTimeDefrost "Total time where defrost operation was necessary in the year";

  Modelica.Blocks.Interfaces.BooleanOutput defrost
    "Indicate if we are defrosting (true) or not" annotation (Placement(
        transformation(extent={{100,-12},{124,12}}), iconTransformation(extent={
            {-140,56},{-100,96}})));
  Modelica.Blocks.Logical.And andDefrost
                                       "Either hys or crit min time"
    annotation (Placement(transformation(extent={{72,-10},{92,10}})));
  Modelica.Blocks.Routing.RealPassThrough realPass_n_hp
    annotation (Placement(transformation(extent={{-90,-102},{-70,-82}})));
  Modelica.Blocks.Interfaces.RealOutput growth_rate "Growth rate of ice"
    annotation (Placement(transformation(extent={{100,20},{124,44}}),
        iconTransformation(extent={{-140,56},{-100,96}})));
  Modelica.Blocks.Sources.RealExpression growthRateNat_internal(y=
        growth_rate_natural_conv) "growthRate from internal calcuations"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=0,
        origin={-10,30})));
  Modelica.Blocks.Logical.Switch switchGrowthRate
    annotation (Placement(transformation(extent={{58,40},{78,60}})));
protected
  Modelica.Blocks.Sources.RealExpression m_ice_internal(y=m_ice);
  Real Char[2];

initial equation
  assert(A * V_flow_air / (V_h * N_max)^2 > 7e6, "The paper found the correlations for CICOS greater than 7e6. Extrapolation will yield wrong results", AssertionLevel.warning);
equation
  if m_ice > Modelica.Constants.eps then
    growth_rate_natural_conv = min(0, -natConvCoeff * (TOda - 273.15)) "Simply energy balance with constant Area and constant defrost";
  else
    growth_rate_natural_conv = 0 "Not possible to melt the ice if no ice is present";
  end if;

  Char = frostMapFunc(TOda, relHum, CICO);
  // Only vaild if the hp is turned on
  if boolPassHP_on.y then
    critDefTim = Char[1];
    // Build a forced convection velocity to ensure the growth rate matches the timing in the map.
    growth_rate_forced_conv = Char[2];
    CICO = A * V_flow_air / (V_h * N_max * realPass_n_hp.y)^2;
  else
    critDefTim = Modelica.Constants.inf;
    growth_rate_forced_conv = 0;
    CICO = 8e-6 "Only used to avoid log(0) as CICO is not defined for n_hp = 0";
  end if;

  // TODO: Check if necessary
  if growth_rate >= 3.6e-7 then
    densityCoeff = 1;
  elseif growth_rate >= 2.5e-7 then
    densityCoeff = 150/190;
  elseif growth_rate >= 0.7e-7 then
    densityCoeff = 150/310;
  else
    densityCoeff = 1;
  end if;

  der(m_ice) = m_flow_ice;

  // Calculate defrost:
  if defrost then
    m_flow_ice =-(QEva_flow/h_water_fusion)*densityCoeff;
    mode_hp = false;
    der(totalTimeDefrost) = 1;
  else
    m_flow_ice = A * density * growth_rate;
    mode_hp = true;
    der(totalTimeDefrost) = 0;
  end if;

  iceFac = 1 - (m_ice/m_ice_max);

  connect(iceFac_internal.y, hys.u)
    annotation (Line(points={{-51,80},{-32,80}}, color={0,0,127}));
  connect(critDefTim_internal.y, greater.u2) annotation (Line(points={{41,-70},{
          53.9,-70},{53.9,-58},{58,-58}},        color={0,0,127}));
  connect(timer.y, greater.u1) annotation (Line(points={{51,-30},{51,-30.5},{58,
          -30.5},{58,-50}},         color={0,0,127}));
  connect(greaterThreshold.u, growthRateFor_internal.y) annotation (Line(points={{-32,-10},
          {-32,30},{-39,30}},                   color={0,0,127}));
  connect(hys.y, not1.u)
    annotation (Line(points={{-9,80},{-2,80}}, color={255,0,255}));
  connect(not1.y, orDefrost.u1) annotation (Line(points={{21,80},{34,80},{34,10},
          {38,10}},  color={255,0,255}));
  connect(greater.y, orDefrost.u2) annotation (Line(points={{81,-50},{86,-50},{86,
          -20},{34,-20},{34,2},{38,2}},
                     color={255,0,255}));
  connect(greaterThreshold.y,and1. u1) annotation (Line(points={{-9,-10},{-2.65,
          -10},{-2.65,-30},{-2,-30}},  color={255,0,255}));
  connect(iceFac_internal.y, lesEquThr.u) annotation (Line(points={{-51,80},{-48,
          80},{-48,-50},{-42,-50}}, color={0,0,127}));
  connect(lesEquThr.y, and1.u2) annotation (Line(points={{-19,-50},{-19,-50.5},{
          -2,-50.5},{-2,-38}}, color={255,0,255}));
  connect(and1.y, timer.u) annotation (Line(points={{21,-30},{21,-30.5},{28,-30.5},
          {28,-30}},          color={255,0,255}));
  connect(defrost, andDefrost.y) annotation (Line(points={{112,0},{93,0}},
                      color={255,0,255}));
  connect(orDefrost.y, andDefrost.u1) annotation (Line(points={{61,10},{69.25,10},
          {69.25,0},{70,0}},   color={255,0,255}));
  connect(greaterThreshold.y, andDefrost.u2) annotation (Line(points={{-9,-10},{
          70,-10},{70,-8}},                                   color={255,0,255}));
  connect(greaterThreshold.y, switchGrowthRate.u2) annotation (Line(points={{-9,-10},
          {8,-10},{8,50},{56,50}},        color={255,0,255}));
  connect(growthRateNat_internal.y, switchGrowthRate.u3) annotation (Line(
        points={{1,30},{14,30},{14,42},{56,42}},         color={0,0,127}));
  connect(growthRateFor_internal.y, switchGrowthRate.u1) annotation (Line(
        points={{-39,30},{-26,30},{-26,58},{56,58}},           color={0,0,127}));
  connect(switchGrowthRate.y, growth_rate) annotation (Line(points={{79,50},{96,50},
          {96,32},{112,32}},     color={0,0,127}));
  connect(boolPassHP_on.u, genConBus.onOffMea) annotation (Line(points={{-92,-68},
          {-102,-68},{-102,-59.9},{-107.9,-59.9}},
                                               color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(realPass_n_hp.u, genConBus.nSet) annotation (Line(points={{-92,-92},{-102,
          -92},{-102,-59.9},{-107.9,-59.9}},  color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(growth_rate, growth_rate)
    annotation (Line(points={{112,32},{112,32}}, color={0,0,127}));
  connect(mode_internal.y, modeHeaPum) annotation (Line(points={{81,-90},{90,-90},
          {90,-60},{110,-60}}, color={255,0,255}));
  connect(iceFac_internal.y, iceFacMea) annotation (Line(points={{-51,80},{-48,80},
          {-48,60},{110,60}}, color={0,0,127}));
  annotation (Icon(graphics={Text(
          extent={{-64,46},{78,-56}},
          lineColor={0,0,0},
          textString="f(CICO)")}), experiment(StopTime=2592000, Interval=500));
end ZhuIceFacCalculation;
