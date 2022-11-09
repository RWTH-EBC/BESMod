within BESMod.Systems.Electrical.Distribution.Tests;
model BatterySystemSimple
  extends Modelica.Icons.Example;
  BESMod.Systems.Electrical.Distribution.BatterySystemSimple
    batterySystemSimple(nSubSys=2,
                        redeclare
      BuildingSystems.Technologies.ElectricalStorages.Data.LithiumIon.LithiumIonTeslaPowerwall1
      batteryParameters)
    annotation (Placement(transformation(extent={{-32,-36},{40,38}})));
  BESMod.Utilities.Electrical.RealToElecCon realToElecCon(use_souLoa=false)
    annotation (Placement(transformation(extent={{-44,50},{-24,70}})));
  BESMod.Utilities.Electrical.RealToElecCon realToElecCon1(use_souGen=false)
    annotation (Placement(transformation(extent={{58,50},{38,70}})));
  BESMod.Utilities.Electrical.ElecConToReal elecConToReal
    annotation (Placement(transformation(extent={{44,-76},{74,-46}})));
  Modelica.Blocks.Sources.Sine ElectricalLoad(
    amplitude=3000,
    f=1/86400,
    phase=1.5707963267949,
    offset=3000)
    annotation (Placement(transformation(extent={{100,60},{80,80}})));
  Modelica.Blocks.Sources.Sine PGeneration(
    amplitude=2000,
    f=1/86400,
    phase=4.7123889803847,
    offset=2000)
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Modelica.Blocks.Interfaces.RealOutput SOC
    if not batterySystemSimple.use_openModelica
    annotation (Placement(transformation(extent={{100,-100},{120,-80}})));
  Interfaces.DistributionOutputs OutputDistr1
    if not batterySystemSimple.use_openModelica
    annotation (Placement(transformation(extent={{-6,-70},{14,-50}})));
  Modelica.Blocks.Interfaces.RealOutput PGrid "Electrical power"
    annotation (Placement(transformation(extent={{100,-70},{120,-50}})));
equation
  connect(batterySystemSimple.externalElectricalPin, elecConToReal.internalElectricalPin)
    annotation (Line(
      points={{22,-35.26},{22,-60.7},{44.3,-60.7}},
      color={0,0,0},
      thickness=1));
  connect(batterySystemSimple.OutputDistr, OutputDistr1) annotation (
      Line(
      points={{4,-35.26},{4,-60}},
      color={255,204,51},
      thickness=0.5));
  connect(elecConToReal.PElecLoa, PGrid)
    annotation (Line(points={{77,-55},{94,-55},{94,-60},{110,-60}},
                                                            color={0,0,127}));
  connect(realToElecCon1.internalElectricalPin, batterySystemSimple.internalElectricalPin[
    1]) annotation (Line(
      points={{37.8,60.2},{22,60.2},{22,37.075}},
      color={0,0,0},
      thickness=1));
  connect(realToElecCon.internalElectricalPin, batterySystemSimple.internalElectricalPin[
    2]) annotation (Line(
      points={{-23.8,60.2},{22,60.2},{22,38.925}},
      color={0,0,0},
      thickness=1));
  connect(PGeneration.y, realToElecCon.PEleGen) annotation (Line(points={{-59,70},
          {-54,70},{-54,56},{-46,56}},     color={0,0,127}));
  connect(ElectricalLoad.y, realToElecCon1.PEleLoa) annotation (Line(points={{79,70},
          {68,70},{68,64},{60,64}},          color={0,0,127}));
  connect(SOC, OutputDistr1.SOCBat) annotation (Line(points={{110,-90},{4,-90},
          {4,-60}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=86400,
      Interval=900,
      __Dymola_Algorithm="Dassl"),
    __Dymola_experimentSetupOutput,
    __Dymola_experimentFlags(
      Advanced(
        EvaluateAlsoTop=true,
        GenerateVariableDependencies=false,
        OutputModelicaCode=false),
      Evaluate=true,
      OutputCPUtime=false,
      OutputFlatModelica=false));
end BatterySystemSimple;
