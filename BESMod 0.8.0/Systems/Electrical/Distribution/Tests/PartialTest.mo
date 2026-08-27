within BESMod.Systems.Electrical.Distribution.Tests;
partial model PartialTest

  replaceable BaseClasses.PartialDistribution dis constrainedby
    BaseClasses.PartialDistribution(final nSubSys=2)
                                    annotation (Placement(transformation(extent=
           {{-32,-36},{40,38}})), choicesAllMatching=true);
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
  Interfaces.DistributionOutputs outputsDis if not dis.use_openModelica
    annotation (Placement(transformation(extent={{-6,-84},{14,-64}})));
  Modelica.Blocks.Interfaces.RealOutput PGrid "Electrical power"
    annotation (Placement(transformation(extent={{100,-70},{120,-50}})));
equation
  connect(dis.externalElectricalPin, elecConToReal.internalElectricalPin)
    annotation (Line(
      points={{22,-35.26},{22,-60.7},{44.3,-60.7}},
      color={0,0,0},
      thickness=1));
  connect(dis.OutputDistr, outputsDis) annotation (Line(
      points={{4,-35.26},{4,-74}},
      color={255,204,51},
      thickness=0.5));
  connect(elecConToReal.PElecLoa, PGrid)
    annotation (Line(points={{77,-55},{94,-55},{94,-60},{110,-60}},
                                                            color={0,0,127}));
  connect(realToElecCon1.internalElectricalPin, dis.internalElectricalPin[1])
    annotation (Line(
      points={{37.8,60.2},{22,60.2},{22,38}},
      color={0,0,0},
      thickness=1));
  connect(realToElecCon.internalElectricalPin, dis.internalElectricalPin[2])
    annotation (Line(
      points={{-23.8,60.2},{22,60.2},{22,38}},
      color={0,0,0},
      thickness=1));
  connect(PGeneration.y, realToElecCon.PEleGen) annotation (Line(points={{-59,70},
          {-54,70},{-54,56},{-46,56}},     color={0,0,127}));
  connect(ElectricalLoad.y, realToElecCon1.PEleLoa) annotation (Line(points={{79,70},
          {68,70},{68,64},{60,64}},          color={0,0,127}));
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
end PartialTest;
