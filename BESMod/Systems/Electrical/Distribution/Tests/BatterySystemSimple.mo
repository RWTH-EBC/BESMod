within BESMod.Systems.Electrical.Distribution.Tests;
model BatterySystemSimple
  extends Modelica.Icons.Example;
  BESMod.Systems.Electrical.Distribution.BatterySystemSimple
    batterySystemSimple(nSubsysLoads=1,
                        redeclare
      BuildingSystems.Technologies.ElectricalStorages.Data.LithiumIon.LithiumIonTeslaPowerwall1
      batteryParameters)
    annotation (Placement(transformation(extent={{-32,-36},{40,38}})));
  Utilities.Electrical.RealToElecCon realToElecCon(reverse=false)
    annotation (Placement(transformation(extent={{-44,50},{-24,70}})));
  Utilities.Electrical.RealToElecCon realToElecCon1(reverse=false)
    annotation (Placement(transformation(extent={{58,50},{38,70}})));
  Utilities.Electrical.ElecConToReal elecConToReal
    annotation (Placement(transformation(extent={{44,-76},{74,-46}})));
  Modelica.Blocks.Sources.Sine ElectricalLoad(
    amplitude=3000,
    freqHz=1/86400,
    phase=1.5707963267949,
    offset=3000)
    annotation (Placement(transformation(extent={{92,48},{68,72}})));
  Modelica.Blocks.Sources.Sine PGeneration(
    amplitude=2000,
    freqHz=1/86400,
    phase=4.7123889803847,
    offset=2000)
    annotation (Placement(transformation(extent={{-78,48},{-54,72}})));
  Modelica.Blocks.Interfaces.RealOutput SOC
    annotation (Placement(transformation(extent={{54,-98},{74,-78}})));
  Interfaces.DistributionOutputs OutputDistr1
    annotation (Placement(transformation(extent={{-6,-70},{14,-50}})));
  Modelica.Blocks.Interfaces.RealOutput PGrid "Electrical power"
    annotation (Placement(transformation(extent={{88,-72},{108,-52}})));
equation
  connect(realToElecCon.internalElectricalPin, batterySystemSimple.internalElectricalPinFromGeneration)
    annotation (Line(
      points={{-23.8,60.2},{-14,60.2},{-14,38}},
      color={0,0,0},
      thickness=1));
  connect(batterySystemSimple.externalElectricalPin, elecConToReal.internalElectricalPin)
    annotation (Line(
      points={{22,-35.26},{22,-60.7},{44.3,-60.7}},
      color={0,0,0},
      thickness=1));
  connect(ElectricalLoad.y, realToElecCon1.PEleLoa)
    annotation (Line(points={{66.8,60},{58.6,60}}, color={0,0,127}));
  connect(PGeneration.y, realToElecCon.PEleLoa)
    annotation (Line(points={{-52.8,60},{-44.6,60}}, color={0,0,127}));
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
  connect(elecConToReal.PElec, PGrid)
    annotation (Line(points={{75.8,-61},{98,-61},{98,-62}}, color={0,0,127}));
  connect(realToElecCon1.internalElectricalPin, batterySystemSimple.internalElectricalPin[
    1]) annotation (Line(
      points={{37.8,60.2},{22,60.2},{22,38}},
      color={0,0,0},
      thickness=1));
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
