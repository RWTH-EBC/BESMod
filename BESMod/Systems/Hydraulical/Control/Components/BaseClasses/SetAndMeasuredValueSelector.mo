within BESMod.Systems.Hydraulical.Control.Components.BaseClasses;
model SetAndMeasuredValueSelector
  "Model to select the measured value and add to the set value accordingly"
  parameter
    BESMod.Systems.Hydraulical.Control.Components.BaseClasses.MeasuredValue
    meaVal "Type of measurement to use in control";
  parameter Boolean use_dhw = true "=false to disable DHW";

  parameter Modelica.Units.SI.TemperatureDifference dTTraToDis_nominal
    "Nominal temperature difference between transfer and distribution system";
  parameter Modelica.Units.SI.TemperatureDifference dTDisToGen_nominal
    "Nominal temperature difference between distribution and generation system";
  parameter Modelica.Units.SI.TemperatureDifference dTDHWToGen_nominal
    "Nominal temperature difference between DHW and generation system";
  parameter Modelica.Units.SI.TemperatureDifference dTHysDHW
    "DHW hysteresis to ensure control completes DHW charging as quickly as possible";
  parameter Boolean use_opeEncControl=false
    "Use operational envelope limit control"
    annotation (Dialog(tab="Operational Envelope Control"));
  parameter Modelica.Units.SI.Temperature tabUppHea[:,2]=[233.15,373.15; 333.15,373.15]
    "Upper temperature boundary for heating with second column as useful temperature side"
    annotation (Dialog(tab="Operational Envelope Control", enable=use_opeEncControl));
  parameter Modelica.Units.SI.TemperatureDifference dTOpeEnv=2 "Extra temperature difference until limit when bivalent device is turned on"
  annotation (Dialog(tab="Operational Envelope Control", enable=use_opeEncControl));
  BESMod.Systems.Hydraulical.Interfaces.DistributionControlBus sigBusDistr
    "Necessary to control DHW temperatures"
    annotation (Placement(transformation(extent={{-116,-36},{-84,-6}}),
        iconTransformation(extent={{-116,-36},{-84,-6}})));
  Interfaces.GenerationControlBus
    sigBusGen
    annotation (Placement(transformation(extent={{-116,-98},{-84,-66}}),
        iconTransformation(extent={{-116,-98},{-84,-66}})));
  Modelica.Blocks.Interfaces.BooleanInput  DHW if use_dhw
                                               "=true for DHW loading"
    annotation (Placement(transformation(extent={{-120,50},{-100,70}})));
  Modelica.Blocks.Interfaces.RealInput  TBuiSet(unit="K", displayUnit="degC")
    "Building supply set temperature"
    annotation (Placement(transformation(extent={{-120,18},{-100,38}})));
  Modelica.Blocks.Interfaces.RealInput  TDHWSet(unit="K", displayUnit="degC")
    if use_dhw
    "DHW supply set temperature"
    annotation (Placement(transformation(extent={{-120,78},{-100,98}})));
  BESMod.Systems.Hydraulical.Control.Components.BaseClasses.ConstantAdd
    constAddBuf(final k=dTBui_nominal) "Add temperature difference in DHW system"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
  Modelica.Blocks.Logical.Switch swiDHWBuiSet if use_dhw
                                              "Switch between building and DHW"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-10,60})));
  BESMod.Systems.Hydraulical.Control.Components.BaseClasses.ConstantAdd
    constAddDHW(final k=dTTraDHW_nominal + dTHysDHW/2) if use_dhw
    "Add temperature difference in DHW system"
    annotation (Placement(transformation(extent={{-60,70},{-40,90}})));
  Modelica.Blocks.Interfaces.RealOutput TMea(unit="K", displayUnit="degC")
    "Building supply set temperature"
    annotation (Placement(transformation(extent={{100,-50},{120,-30}})));
  Modelica.Blocks.Interfaces.RealOutput TSet(unit="K", displayUnit="degC")
    "Set temperature"
    annotation (Placement(transformation(extent={{100,50},{120,70}})));
  Modelica.Blocks.Logical.Switch swiDHWBuiMea if meaVal == BESMod.Systems.Hydraulical.Control.Components.BaseClasses.MeasuredValue.DistributionTemperature
     and use_dhw
    "Switch between building and DHW" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-10,-40})));
  Modelica.Blocks.Routing.RealPassThrough reaPasTrhGenSup if meaVal == BESMod.Systems.Hydraulical.Control.Components.BaseClasses.MeasuredValue.
     GenerationSupplyTemperature "Real pass through for conditional option"
    annotation (Placement(transformation(extent={{-20,-90},{0,-70}})));
  OperationalEnvelopeLimitControl opeEnvLimCtrl(final dTOpeEnv=max(
        dTTraDHW_nominal, dTBui_nominal) + dTOpeEnv,
      final tabUppHea=tabUppHea) if use_opeEncControl
    "Operational envelope limit control"
    annotation (Placement(transformation(extent={{40,50},{60,70}})));
  Modelica.Blocks.Interfaces.BooleanOutput bivOn if use_opeEncControl
    "Bivalent device should turn on"
    annotation (Placement(transformation(extent={{100,10},{120,30}})));

  Modelica.Blocks.Interfaces.RealInput TEvaIn if use_opeEncControl
                                              "Evaporator inlet temperature"
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}}),
        iconTransformation(extent={{-120,-10},{-100,10}})));
  Modelica.Blocks.Routing.RealPassThrough reaPasTrhDisTemNoDHW if meaVal ==
    BESMod.Systems.Hydraulical.Control.Components.BaseClasses.MeasuredValue.DistributionTemperature and not use_dhw
    "Real pass through for conditional option"
    annotation (Placement(transformation(extent={{40,-70},{60,-50}})));
  Modelica.Blocks.Routing.RealPassThrough reaPasTrhNoDHW if not use_dhw
    "Real pass through for conditional option"
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));
  Modelica.Blocks.Routing.RealPassThrough reaPasTrhNoDHW1
    if not use_opeEncControl
    "Real pass through for conditional option"
    annotation (Placement(transformation(extent={{40,20},{60,40}})));
protected
  parameter Modelica.Units.SI.TemperatureDifference dTTraDHW_nominal=
    if meaVal ==BESMod.Systems.Hydraulical.Control.Components.BaseClasses.MeasuredValue.GenerationSupplyTemperature
      then dTDHWToGen_nominal else 0
    "Helper for conditional sum in DHW dTs";
  parameter Modelica.Units.SI.TemperatureDifference dTBui_nominal=
    if meaVal ==BESMod.Systems.Hydraulical.Control.Components.BaseClasses.MeasuredValue.GenerationSupplyTemperature
      then dTTraToDis_nominal + dTDisToGen_nominal else dTTraToDis_nominal
    "Helper for conditional sum in building dTs";
equation
  connect(constAddDHW.y, swiDHWBuiSet.u1) annotation (Line(points={{-39,80},{-28,80},
          {-28,68},{-22,68}}, color={0,0,127}));
  connect(constAddBuf.y, swiDHWBuiSet.u3) annotation (Line(points={{-39,40},{-28,40},
          {-28,52},{-22,52}}, color={0,0,127}));
  connect(constAddDHW.u, TDHWSet) annotation (Line(points={{-62,80},{-94,80},{-94,
          88},{-110,88}}, color={0,0,127}));
  connect(constAddBuf.u, TBuiSet) annotation (Line(points={{-62,40},{-94,40},{-94,
          28},{-110,28}}, color={0,0,127}));
  connect(swiDHWBuiSet.u2, DHW)
    annotation (Line(points={{-22,60},{-110,60}}, color={255,0,255}));
  connect(DHW, swiDHWBuiMea.u2) annotation (Line(points={{-110,60},{-32,60},{-32,-40},
          {-22,-40}}, color={255,0,255}));
  connect(swiDHWBuiMea.y, TMea)
    annotation (Line(points={{1,-40},{110,-40}}, color={0,0,127}));
  connect(swiDHWBuiMea.u1, sigBusDistr.TStoDHWTopMea) annotation (Line(points={{-22,
          -32},{-78,-32},{-78,-21},{-100,-21}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(reaPasTrhGenSup.y, TMea) annotation (Line(points={{1,-80},{88,-80},{88,
          -40},{110,-40}},
                      color={0,0,127}));
  connect(reaPasTrhGenSup.u, sigBusGen.TGenOutMea) annotation (Line(points={{-22,-80},
          {-62,-80},{-62,-82},{-100,-82}},
                       color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(opeEnvLimCtrl.TSet, swiDHWBuiSet.y) annotation (Line(points={{39,56},{
          20,56},{20,60},{1,60}}, color={0,0,127}));
  connect(opeEnvLimCtrl.TSetOut, TSet) annotation (Line(points={{61,66},{94,66},
          {94,60},{110,60}}, color={0,0,127}));
  connect(opeEnvLimCtrl.bivOn, bivOn) annotation (Line(points={{61,57},{80,57},{
          80,20},{110,20}}, color={255,0,255}));
  connect(opeEnvLimCtrl.TEvaIn, TEvaIn) annotation (Line(points={{39,64},{26,64},
          {26,0},{-110,0}}, color={0,0,127}));
  connect(reaPasTrhDisTemNoDHW.y, TMea) annotation (Line(points={{61,-60},{88,-60},
          {88,-40},{110,-40}}, color={0,0,127}));
  connect(reaPasTrhNoDHW.u, constAddBuf.y) annotation (Line(points={{-22,30},{-34,
          30},{-34,40},{-39,40}}, color={0,0,127}));
  connect(reaPasTrhNoDHW.y, opeEnvLimCtrl.TSet) annotation (Line(points={{1,30},
          {20,30},{20,56},{39,56}}, color={0,0,127}));
  connect(reaPasTrhNoDHW1.u, reaPasTrhNoDHW.y)
    annotation (Line(points={{38,30},{1,30}}, color={0,0,127}));
  connect(reaPasTrhNoDHW1.u, swiDHWBuiSet.y) annotation (Line(points={{38,30},{20,
          30},{20,60},{1,60}}, color={0,0,127}));
  connect(reaPasTrhNoDHW1.y, TSet) annotation (Line(points={{61,30},{92,30},{92,
          60},{110,60}}, color={0,0,127}));
  connect(swiDHWBuiMea.u3, sigBusDistr.TBuiSupMea) annotation (Line(points={{
          -22,-48},{-94,-48},{-94,-21},{-100,-21}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(reaPasTrhDisTemNoDHW.u, sigBusDistr.TBuiSupMea) annotation (Line(
        points={{38,-60},{-100,-60},{-100,-21}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                                        Text(
        extent={{-150,138},{150,98}},
        textString="%name",
        textColor={0,0,255}),   Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid)}),                        Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end SetAndMeasuredValueSelector;
