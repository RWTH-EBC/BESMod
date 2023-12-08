within BESMod.Systems.Hydraulical.Components.Frosting;
model CICOIceFacCalculation "IceFac based on CICO"
  extends BaseClasses.partialIceFac;

  /*
  
  parameter Modelica.SIunits.Area A=parameterAssumptions.A_eva
                                    "Area of heat exchanger (All fins from both sides, as the growth rate is specific for the area of the HE";
  parameter Modelica.SIunits.Density density=918
                                             "Density of ice";
  parameter Real minIceFac=parameterAssumptions.minIceFac
                           "Minimal allowed icing Factor to trigger the defrost";
  parameter Modelica.SIunits.Mass m_ice_max=density*A*d/2
                                            "Maximal possible mass of ice on HE surface. This value is limited by the volume between the fin tube";
  parameter Modelica.SIunits.Distance d=parameterAssumptions.d_fins
                                        "Distance between two fins. Used to calculate the maximal mass of ice on the HE";
  parameter Modelica.SIunits.Volume V_h=parameterAssumptions.V_h
                                        "Compressor Displacement Volume per rev";
  parameter Modelica.SIunits.Frequency N_max=parameterAssumptions.N_max
                                             "Maximal compressor rotational speed";
  parameter Modelica.SIunits.VolumeFlowRate V_flow_air=parameterAssumptions.V_flow_air
                                                       "Volume flow rate over outdoor air coil";
  parameter Real natConvCoeff(unit="m/(s*K)")=parameterAssumptions.natConvCoeff
                                              "Parameter to be calibrated for natural defrost";
                                              
  */

  parameter Modelica.SIunits.Area A=15
                                    "Area of heat exchanger (All fins from both sides, as the growth rate is specific for the area of the HE";
  parameter Modelica.SIunits.Density density=918
                                             "Density of ice";
  parameter Real minIceFac=0.5
                           "Minimal allowed icing Factor to trigger the defrost";
  parameter Modelica.SIunits.Mass m_ice_max=density*A*d/2
                                            "Maximal possible mass of ice on HE surface. This value is limited by the volume between the fin tube";
  parameter Modelica.SIunits.Distance d=3e-3
                                        "Distance between two fins. Used to calculate the maximal mass of ice on the HE";
  parameter Modelica.SIunits.Volume V_h=19e-6
                                        "Compressor Displacement Volume per rev";
  parameter Modelica.SIunits.Frequency N_max=120
                                             "Maximal compressor rotational speed";
  parameter Modelica.SIunits.VolumeFlowRate V_flow_air=0.001
                                                       "Volume flow rate over outdoor air coil";
  parameter Real natConvCoeff(unit="m/(s*K)")=1e-7
                                              "Parameter to be calibrated for natural defrost";

  Modelica.Blocks.Sources.RealExpression       P_el_internal(y=P_el)         "Additional power from internal calculations" annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=0,
        origin={-30,-80})));
  Modelica.Blocks.Sources.RealExpression iceFac_internal(y=iceFac)
    "iceFac from internal calculations" annotation (Placement(transformation(
        extent={{-18,15},{18,-15}},
        rotation=180,
        origin={-60,33})));
  Modelica.Blocks.Sources.BooleanExpression mode_internal(y=mode_hp)
    "Mode from internal calcuations"                   annotation (Placement(
        transformation(
        extent={{-18,15},{18,-15}},
        rotation=180,
        origin={-60,1})));

  Boolean mode_hp(start=false) "Heat pump heating mode";
  Real iceFac(start=1) "Icing Factor";
  Modelica.SIunits.MassFlowRate m_flow_ice(start=0) "Current mass of ice on evaporator surface";
  Modelica.SIunits.Mass m_ice(start=0) "Total mass that was on evaporator surface over whole simulation duration";
  Modelica.SIunits.Power P_el(start=0) "Current power required";
  Modelica.SIunits.HeatFlowRate QDef_flow(start=0) "Input energy to melt the ice";
  Modelica.SIunits.Velocity growth_rate_natural_conv(min=0, start=0) "Growth rate of ice for natural convection (melting)";
  Modelica.SIunits.Velocity growth_rate_forced_conv(min=0, start=0) "Growth rate of ice for forced convection";

  Modelica.SIunits.Time critDefTim
    "Time until next defrost cycle (based on time-method)";
  Real CICO(unit="s/m") "CICO  value";

  replaceable function frostMapFunc =
      BESMod.Systems.Hydraulical.Components.Frosting.Functions.CICOBasedFunction
    constrainedby
    BESMod.Systems.Hydraulical.Components.Frosting.Functions.partialFrostingMap                 annotation(choicesAllMatching=true);

  Modelica.Blocks.Routing.RealPassThrough realPassQEva_flow
    annotation (Placement(transformation(extent={{-90,-42},{-70,-22}})));
  Modelica.Blocks.Routing.RealPassThrough realPassT_Amb
    annotation (Placement(transformation(extent={{-90,-70},{-70,-50}})));

  Modelica.Blocks.Logical.Hysteresis hysteresis(uLow=minIceFac, uHigh=1)
    "For the iceFac control. Output signal is used internally"
    annotation (Placement(transformation(extent={{-20,68},{8,96}})));
  Modelica.Blocks.Logical.Timer timer
    annotation (Placement(transformation(extent={{26,-36},{40,-22}})));
  Modelica.Blocks.Logical.Greater greater
    annotation (Placement(transformation(extent={{56,-46},{68,-34}})));
  Modelica.Blocks.Sources.RealExpression critDefTim_internal(y=critDefTim)
    "Mode from internal calcuations" annotation (Placement(transformation(
        extent={{-18,15},{18,-15}},
        rotation=0,
        origin={30,-63})));
  Modelica.Blocks.Logical.GreaterThreshold greaterThreshold(threshold=Modelica.Constants.eps)
    annotation (Placement(transformation(extent={{-20,-26},{-6,-12}})));
  Modelica.Blocks.Sources.RealExpression growthRateFor_internal(y=
        growth_rate_forced_conv) "growthRate from internal calcuations"
    annotation (Placement(transformation(
        extent={{-13,10},{13,-10}},
        rotation=0,
        origin={-47,-18})));
  Modelica.Blocks.Logical.Not not1
    annotation (Placement(transformation(extent={{22,72},{42,92}})));
  Modelica.Blocks.Logical.Or orDefrost "Either hys or crit min time"
    annotation (Placement(transformation(extent={{54,2},{64,12}})));

  Modelica.Blocks.Logical.And and1
    annotation (Placement(transformation(extent={{2,-36},{16,-22}})));
  Modelica.Blocks.Logical.LessEqualThreshold
                                           lessEqualThreshold(threshold=1 -
        Modelica.Constants.eps)
    annotation (Placement(transformation(extent={{-20,-58},{-6,-44}})));
  Modelica.Blocks.Routing.BooleanPassThrough boolPassHP_on
    annotation (Placement(transformation(extent={{-90,-96},{-70,-76}})));

  Modelica.SIunits.Time totalTimeDefrost "Total time where defrost operation was necessary in the year";

  Modelica.Blocks.Interfaces.BooleanOutput defrost
    "Indicate if we are defrosting (true) or not" annotation (Placement(
        transformation(extent={{100,-20},{140,20}}), iconTransformation(extent={
            {-140,56},{-100,96}})));
  Modelica.Blocks.Logical.And andDefrost
                                       "Either hys or crit min time"
    annotation (Placement(transformation(extent={{76,-6},{86,4}})));
  Modelica.Blocks.Routing.RealPassThrough realPass_n_hp
    annotation (Placement(transformation(extent={{-90,-122},{-70,-102}})));
  Modelica.Blocks.Interfaces.RealOutput growth_rate "Growth rate of ice"
    annotation (Placement(transformation(extent={{100,40},{140,80}}),
        iconTransformation(extent={{-140,56},{-100,96}})));
  Modelica.Blocks.Sources.RealExpression growthRateNat_internal(y=
        growth_rate_natural_conv) "growthRate from internal calcuations"
    annotation (Placement(transformation(
        extent={{-13,10},{13,-10}},
        rotation=0,
        origin={-11,26})));
  Modelica.Blocks.Logical.Switch switchGrowthRate
    annotation (Placement(transformation(extent={{26,24},{40,38}})));
protected
  parameter Modelica.SIunits.Power const_P_el_internal = if use_reverse_cycle then 0 else P_el_hr "Additional power used to defrost";
  parameter Boolean const_mode_hp = not use_reverse_cycle;
  Modelica.Blocks.Sources.RealExpression m_ice_internal(y=m_ice);
  Real Char[2];

initial equation
  assert(A * V_flow_air / (V_h * N_max)^2 > 7e6, "The paper found the correlations for CICOS greater than 7e6. Extrapolation will yield wrong results", AssertionLevel.warning);
equation
  if m_ice > Modelica.Constants.eps then
    growth_rate_natural_conv = min(0, -natConvCoeff * (realPassT_Amb.y - 273.15)) "Simply energy balance with constant Area and constant defrost";
  else
    growth_rate_natural_conv = 0 "Not possible to melt the ice if no ice is present";
  end if;

  Char = frostMapFunc(realPassT_Amb.y, relHum, CICO);
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

  der(m_ice) = m_flow_ice;
  if use_reverse_cycle then
    QDef_flow = realPassQEva_flow.y;
  else
    // No reverse cycle
    QDef_flow = P_el_hr/eta_hr;
  end if;

  // Calculate defrost:
  if defrost then
    m_flow_ice =-(QDef_flow/h_water_fusion);
    P_el = const_P_el_internal;
    mode_hp = const_mode_hp;
    der(totalTimeDefrost) = 1;
  else
    m_flow_ice = A * density * growth_rate;
    P_el = 0;
    mode_hp = true;
    der(totalTimeDefrost) = 0;
  end if;

  iceFac = 1 - (m_ice/m_ice_max);

  connect(P_el_internal.y,P_el_add)  annotation (Line(
      points={{-19,-80},{0,-80},{0,-110}},
      color={0,0,127}));
  connect(mode_internal.y, genConBus.hp_mode) annotation (Line(
      points={{-79.8,1},{-76,1},{-76,0},{-108,0}},
      color={255,0,255}));
  connect(genConBus.QEva_flow, realPassQEva_flow.u) annotation (Line(
      points={{-108,0},{-102,0},{-102,2},{-104,2},{-104,-32},{-92,-32}},
      color={255,204,51},
      thickness=0.5));
  connect(genConBus.T_Amb, realPassT_Amb.u) annotation (Line(
      points={{-108,0},{-106,0},{-106,-66},{-92,-66},{-92,-60}},
      color={255,204,51},
      thickness=0.5));
  connect(genConBus.iceFac, iceFac_internal.y) annotation (Line(
      points={{-108,0},{-94,0},{-94,33},{-79.8,33}},
      color={255,204,51},
      thickness=0.5));
  connect(iceFac_internal.y, hysteresis.u) annotation (Line(points={{-79.8,33},{
          -79.8,82},{-22.8,82}}, color={0,0,127}));
  connect(critDefTim_internal.y, greater.u2) annotation (Line(points={{49.8,-63},
          {53.9,-63},{53.9,-44.8},{54.8,-44.8}}, color={0,0,127}));
  connect(timer.y, greater.u1) annotation (Line(points={{40.7,-29},{40.7,-30.5},
          {54.8,-30.5},{54.8,-40}}, color={0,0,127}));
  connect(greaterThreshold.u, growthRateFor_internal.y) annotation (Line(points=
         {{-21.4,-19},{-21.4,-18},{-32.7,-18}}, color={0,0,127}));
  connect(hysteresis.y, not1.u)
    annotation (Line(points={{9.4,82},{14,82},{14,80},{16,80},{16,82},{20,82}},
                                                color={255,0,255}));
  connect(not1.y, orDefrost.u1) annotation (Line(points={{43,82},{50,82},{50,7},
          {53,7}},   color={255,0,255}));
  connect(greater.y, orDefrost.u2) annotation (Line(points={{68.6,-40},{74,-40},
          {74,-24},{54,-24},{54,-10},{53,-10},{53,3}},
                     color={255,0,255}));
  connect(greaterThreshold.y,and1. u1) annotation (Line(points={{-5.3,-19},{-2.65,
          -19},{-2.65,-29},{0.6,-29}}, color={255,0,255}));
  connect(iceFac_internal.y, lessEqualThreshold.u) annotation (Line(points={{-79.8,
          33},{-86,33},{-86,48},{-30,48},{-30,-51},{-21.4,-51}}, color={0,0,127}));
  connect(lessEqualThreshold.y,and1. u2) annotation (Line(points={{-5.3,-51},{-5.3,
          -36.5},{0.6,-36.5},{0.6,-34.6}}, color={255,0,255}));
  connect(and1.y, timer.u) annotation (Line(points={{16.7,-29},{16.7,-30.5},{24.6,
          -30.5},{24.6,-29}}, color={255,0,255}));
  connect(genConBus.hp_on, boolPassHP_on.u) annotation (Line(
      points={{-108,0},{-106,0},{-106,-88},{-92,-88},{-92,-86}},
      color={255,204,51},
      thickness=0.5));
  connect(defrost, andDefrost.y) annotation (Line(points={{120,0},{104,0},{104,-1},
          {86.5,-1}}, color={255,0,255}));
  connect(orDefrost.y, andDefrost.u1) annotation (Line(points={{64.5,7},{69.25,7},
          {69.25,-1},{75,-1}}, color={255,0,255}));
  connect(greaterThreshold.y, andDefrost.u2) annotation (Line(points={{-5.3,-19},
          {-5.3,-4},{-4,-4},{-4,-6},{36,-6},{36,-5},{75,-5}}, color={255,0,255}));
  connect(genConBus.n_hp, realPass_n_hp.u) annotation (Line(
      points={{-108,0},{-106,0},{-106,-112},{-92,-112}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(greaterThreshold.y, switchGrowthRate.u2) annotation (Line(points={{-5.3,
          -19},{8,-19},{8,31},{24.6,31}}, color={255,0,255}));
  connect(growthRateNat_internal.y, switchGrowthRate.u3) annotation (Line(
        points={{3.3,26},{14,26},{14,25.4},{24.6,25.4}}, color={0,0,127}));
  connect(growthRateFor_internal.y, switchGrowthRate.u1) annotation (Line(
        points={{-32.7,-18},{-26,-18},{-26,36.6},{24.6,36.6}}, color={0,0,127}));
  connect(switchGrowthRate.y, growth_rate) annotation (Line(points={{40.7,31},{74,
          31},{74,60},{120,60}}, color={0,0,127}));
  annotation (Icon(graphics={Text(
          extent={{-64,46},{78,-56}},
          lineColor={0,0,0},
          textString="f(CICO)")}), experiment(StopTime=2592000, Interval=500));
end CICOIceFacCalculation;
