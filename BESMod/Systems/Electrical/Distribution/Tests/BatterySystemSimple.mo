within BESMod.Systems.Electrical.Distribution.Tests;
model BatterySystemSimple
  extends Modelica.Icons.Example;
  BESMod.Systems.Electrical.Distribution.BatterySystemSimple
    batterySystemSimple(nSubSys=2,
                        redeclare
      BuildingSystems.Technologies.ElectricalStorages.Data.LithiumIon.LithiumIonTeslaPowerwall1
      batteryParameters)
    annotation (Placement(transformation(extent={{-32,-36},{40,38}})));
  Utilities.Electrical.RealToElecCon realToElecCon(use_souLoa=false)
    annotation (Placement(transformation(extent={{-44,50},{-24,70}})));
  Utilities.Electrical.RealToElecCon realToElecCon1(use_souGen=false)
    annotation (Placement(transformation(extent={{58,50},{38,70}})));
  Utilities.Electrical.ElecConToReal elecConToReal
    annotation (Placement(transformation(extent={{44,-76},{74,-46}})));
  Modelica.Blocks.Sources.Sine ElectricalLoad(
    amplitude=3000,
    f=1/86400,
    phase=1.5707963267949,
    offset=3000)
    annotation (Placement(transformation(extent={{98,48},{74,72}})));
  Modelica.Blocks.Sources.Sine PGeneration(
    amplitude=2000,
    f=1/86400,
    phase=4.7123889803847,
    offset=2000)
    annotation (Placement(transformation(extent={{-86,48},{-62,72}})));
  Modelica.Blocks.Interfaces.RealOutput SOC
    annotation (Placement(transformation(extent={{54,-98},{74,-78}})));
  Interfaces.DistributionOutputs OutputDistr1
    annotation (Placement(transformation(extent={{-6,-70},{14,-50}})));
  Modelica.Blocks.Interfaces.RealOutput PGrid "Electrical power"
    annotation (Placement(transformation(extent={{88,-72},{108,-52}})));
equation
  connect(batterySystemSimple.externalElectricalPin, elecConToReal.internalElectricalPin)
    annotation (Line(
      points={{22,-35.26},{22,-60.7},{44.3,-60.7}},
      color={0,0,0},
      thickness=1));
  connect(batterySystemSimple.OutputDistr, OutputDistr1.SOCBat) annotation (
      Line(
      points={{4,-35.26},{4,-60}},
      color={255,204,51},
      thickness=0.5));
  connect(OutputDistr1.SOCBat.SOCBat, SOC) annotation (Line(
      points={{4,-60},{4,-88},{64,-88}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(elecConToReal.PElecLoa, PGrid)
    annotation (Line(points={{77,-55},{98,-55},{98,-62}},   color={0,0,127}));
  connect(realToElecCon1.internalElectricalPin, batterySystemSimple.internalElectricalPin[
    1]) annotation (Line(
      points={{37.8,60.2},{22,60.2},{22,36.15}},
      color={0,0,0},
      thickness=1));
  connect(realToElecCon.internalElectricalPin, batterySystemSimple.internalElectricalPin[
    2]) annotation (Line(
      points={{-23.8,60.2},{22,60.2},{22,39.85}},
      color={0,0,0},
      thickness=1));
  connect(PGeneration.y, realToElecCon.PEleGen) annotation (Line(points={{-60.8,
          60},{-54,60},{-54,56},{-46,56}}, color={0,0,127}));
  connect(ElectricalLoad.y, realToElecCon1.PEleLoa) annotation (Line(points={{
          72.8,60},{68,60},{68,64},{60,64}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
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
