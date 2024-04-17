within BESMod.Systems.Hydraulical.Control.Components;
model SetTemperatureSGReady "Model for SG-Ready temperature setpoint"
  parameter Boolean useSGReady=true "=true to use SG Ready";
  parameter Modelica.Units.SI.TemperatureDifference TAddSta3=5 "Increase for SG-Ready state 3";
  parameter Modelica.Units.SI.TemperatureDifference TAddSta4=10 "Increase for SG-Ready state 4";
  parameter Boolean useExtSGSig = false "=true to use external SG ready signal";
  parameter String filNam=ModelicaServices.ExternalReferences.loadResource("modelica://BESMod/Resources/EVU_Sperre_EON.txt")
    "Name of SG Ready scenario input file"
    annotation (Dialog(enable=not useExtSGSig and useSGReady));

  Modelica.Blocks.Interfaces.RealInput TSetLocCtrl(unit="K")
    "Set temperature of local control"
    annotation (Placement(transformation(extent={{-140,30},{-100,70}})));
  Modelica.Blocks.Interfaces.RealOutput TSet(unit="K") "Set temperature"
    annotation (Placement(transformation(extent={{100,30},{140,70}})));
  Modelica.Blocks.Interfaces.IntegerInput signal(final max=4, final min=1)
    if useExtSGSig and useSGReady
    "SG Ready signal"
    annotation (Placement(transformation(extent={{-140,-90},{-100,-50}})));
  Modelica.Blocks.Routing.IntegerPassThrough internalSignal
    "Internal SG Ready signal applied"
    annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));
  Modelica.Blocks.Interfaces.BooleanOutput canRun
    "If SG Ready blocks operation"
    annotation (Placement(transformation(extent={{100,-90},{140,-50}})));
  Modelica.Blocks.Math.RealToInteger realToInteger if not useExtSGSig and useSGReady
                                                   annotation(Placement(transformation(extent={{-60,-20},
            {-40,0}})));
  Modelica.Blocks.Sources.CombiTimeTable
                                       datRea(
    final tableOnFile=true,
    final tableName="SGReady",
    final fileName=filNam,
    verboseRead=false,
    columns={2},
    final smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic)
    if not useExtSGSig
    "Data reader"
    annotation (Placement(transformation(extent={{-90,-20},{-70,0}})));
  Modelica.Blocks.Sources.IntegerConstant conIntSig2(final k=2)
    if not useSGReady "Constant integer signal for normal operation"
    annotation (Placement(transformation(extent={{-60,-82},{-40,-62}})));
equation
  if internalSignal.y == 4 then
    TSet = TSetLocCtrl + TAddSta4;
  elseif internalSignal.y == 3 then
    TSet = TSetLocCtrl + TAddSta3;
  else
    TSet = TSetLocCtrl;
  end if;
  canRun = internalSignal.y <> 1;

  connect(internalSignal.u, signal) annotation (Line(points={{-22,-50},{-94,-50},
          {-94,-70},{-120,-70}}, color={255,127,0}));
  connect(datRea.y[1], realToInteger.u)
    annotation (Line(points={{-69,-10},{-62,-10}}, color={0,0,127}));
  connect(realToInteger.y, internalSignal.u) annotation (Line(points={{-39,-10},
          {-32,-10},{-32,-50},{-22,-50}}, color={255,127,0}));
  connect(conIntSig2.y, internalSignal.u) annotation (Line(points={{-39,-72},{-32,
          -72},{-32,-50},{-22,-50}}, color={255,127,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end SetTemperatureSGReady;
