within BESMod.Systems.Hydraulical.Control.Components;
model SetAndMeasuredValueSelector
  "Model to select the measured value and add to the set value accordingly"
  parameter BESMod.Systems.Hydraulical.Control.Components.MeasuredValue meaVal
    "Type of measurement to use in control";

  parameter Modelica.Units.SI.TemperatureDifference dTTraToDis_nominal
    "Nominal temperature difference between transfer and distribution system";
  parameter Modelica.Units.SI.TemperatureDifference dTDisToGen_nominal
    "Nominal temperature difference between distribution and generation system";
  parameter Modelica.Units.SI.TemperatureDifference dTDHWToGen_nominal
    "Nominal temperature difference between DHW and generation system";
  parameter Modelica.Units.SI.TemperatureDifference dTHysDHW
    "DHW hysteresis to ensure control completes DHW charging as quickly as possible";

  Interfaces.DistributionControlBus sigBusDistr
    "Necessary to control DHW temperatures"
    annotation (Placement(transformation(extent={{-116,-36},{-84,-6}}),
        iconTransformation(extent={{-116,-36},{-84,-6}})));
  Interfaces.GenerationControlBus
    sigBusGen
    annotation (Placement(transformation(extent={{-116,-98},{-84,-66}}),
        iconTransformation(extent={{-116,-98},{-84,-66}})));
  Modelica.Blocks.Interfaces.BooleanInput  DHW "=true for DHW loading"
    annotation (Placement(transformation(extent={{-120,50},{-100,70}})));
  Modelica.Blocks.Interfaces.RealInput  TBuiSet(unit="K", displayUnit="degC")
    "Building supply set temperature"
    annotation (Placement(transformation(extent={{-120,18},{-100,38}})));
  Modelica.Blocks.Interfaces.RealInput  TDHWSet(unit="K", displayUnit="degC")
    "DHW supply set temperature"
    annotation (Placement(transformation(extent={{-120,78},{-100,98}})));
  BESMod.Systems.Hydraulical.Control.Components.ConstantAdd constAddBuf(
    final k=dTBui_nominal)
    "Add temperature difference in DHW system"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
  Modelica.Blocks.Logical.Switch swiDHWBuiSet "Switch between building and DHW"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-10,60})));
  BESMod.Systems.Hydraulical.Control.Components.ConstantAdd constAddDHW(
    final k=dTTraDHW_nominal + dTHysDHW/2)
    "Add temperature difference in DHW system"
    annotation (Placement(transformation(extent={{-60,70},{-40,90}})));
  Modelica.Blocks.Interfaces.RealOutput TMea(unit="K", displayUnit="degC")
    "Building supply set temperature"
    annotation (Placement(transformation(extent={{100,-50},{120,-30}})));
  Modelica.Blocks.Interfaces.RealOutput TSet(unit="K", displayUnit="degC")
    "Set temperature"
    annotation (Placement(transformation(extent={{100,50},{120,70}})));
  Modelica.Blocks.Logical.Switch swiDHWBuiMea
    if meaVal == BESMod.Systems.Hydraulical.Control.Components.MeasuredValue.DistributionTemperature
    "Switch between building and DHW" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-10,-40})));
  Modelica.Blocks.Routing.RealPassThrough reaPasTrhGenSup if meaVal == BESMod.Systems.Hydraulical.Control.Components.MeasuredValue.GenerationSupplyTemperature
    "Real pass through for conditional option"
    annotation (Placement(transformation(extent={{-20,-92},{0,-72}})));
protected
  parameter Modelica.Units.SI.TemperatureDifference dTTraDHW_nominal=
    if meaVal == BESMod.Systems.Hydraulical.Control.Components.MeasuredValue.GenerationSupplyTemperature
      then dTDHWToGen_nominal else 0
    "Helper for conditional sum in DHW dTs";
  parameter Modelica.Units.SI.TemperatureDifference dTBui_nominal=
    if meaVal == BESMod.Systems.Hydraulical.Control.Components.MeasuredValue.GenerationSupplyTemperature
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
  connect(TSet, swiDHWBuiSet.y)
    annotation (Line(points={{110,60},{1,60}}, color={0,0,127}));
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
  connect(swiDHWBuiMea.u3, sigBusDistr.TStoBufTopMea) annotation (Line(points={{-22,
          -48},{-78,-48},{-78,-24},{-80,-24},{-80,-21},{-100,-21}}, color={0,0,127}),
      Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(reaPasTrhGenSup.y, TMea) annotation (Line(points={{1,-82},{88,-82},{88,-40},
          {110,-40}}, color={0,0,127}));
  connect(reaPasTrhGenSup.u, sigBusGen.TGenOutMea) annotation (Line(points={{-22,-82},
          {-100,-82}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end SetAndMeasuredValueSelector;
