within BESMod.Utilities.HeatGeneration;
partial model PartialGetHeatGenerationCurve
  extends BESMod.Systems.BaseClasses.PartialBESExample;
  replaceable Systems.Hydraulical.Generation.BaseClasses.PartialGeneration
    generation constrainedby
    Systems.Hydraulical.Generation.BaseClasses.PartialGeneration(
    redeclare final package Medium = IBPSA.Media.Water,
    final Q_flow_nominal={sum(systemParameters.QBui_flow_nominal)},
    final TDem_nominal=systemParameters.THydSup_nominal,
    final TOda_nominal=systemParameters.TOda_nominal,
    final TAmb=systemParameters.TAmbHyd,
    final dpDem_nominal={0})    annotation (choicesAllMatching=true, Placement(
        transformation(extent={{-36,-36},{34,36}})));
  Systems.Hydraulical.Interfaces.GenerationControlBus sigBusGen
    annotation (Placement(transformation(extent={{-72,54},{-52,74}})));
  Modelica.Blocks.Sources.Constant const1(k=0)
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
  Modelica.Blocks.Sources.Constant const2(k=1)
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));
  Modelica.Blocks.Sources.Ramp ramp
    annotation (Placement(transformation(extent={{-100,-70},{-80,-50}})));
  IBPSA.Fluid.MixingVolumes.MixingVolume
                                       vol(
    redeclare package Medium = IBPSA.Media.Water,
    m_flow_nominal=generation.m_flow_nominal[1],
    V=0.01,
    nPorts=2) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={82,10})));
  Systems.Hydraulical.Control.Components.HeatingCurve heatingCurve(
    GraHeaCurve=bivalentHeatPumpControlDataDefinition.gradientHeatCurve,
    THeaThres=systemParameters.TSetZone_nominal[1],
    dTOffSet_HC=bivalentHeatPumpControlDataDefinition.dTOffSetHeatCurve -
        generation.dTTra_nominal[1]) annotation (Placement(transformation(
        extent={{-11,11},{11,-11}},
        rotation=0,
        origin={-9,-71})));
  Modelica.Blocks.Interfaces.RealOutput TOda(unit="K", displayUnit="degC")
    "Connector of Real output signal"
    annotation (Placement(transformation(extent={{100,-50},{120,-30}})));
  Modelica.Blocks.Interfaces.RealOutput QCon_flow(unit="W", displayUnit="kW")
    "Connector of Real output signal"
    annotation (Placement(transformation(extent={{100,50},{120,70}})));
  Modelica.Blocks.Sources.RealExpression
                                   realExpression
    annotation (Placement(transformation(extent={{30,72},{50,92}})));
  replaceable
    Systems.Hydraulical.Control.RecordsCollection.BivalentHeatPumpControlDataDefinition
    bivalentHeatPumpControlDataDefinition(
    TOda_nominal=systemParameters.TOda_nominal,
    TSup_nominal=systemParameters.THydSup_nominal[1],
    TSetRoomConst=systemParameters.TSetZone_nominal[1])
    annotation (choicesAllMatching=true,Placement(transformation(extent={{-100,82},{-80,102}})));
  Modelica.Blocks.Sources.Constant const3(k=max(systemParameters.TSetZone_nominal))
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
  IBPSA.BoundaryConditions.WeatherData.Bus weaBus "Weather data bus"
    annotation (Placement(transformation(extent={{-46,66},{-26,86}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature
    prescribedTemperature
    annotation (Placement(transformation(extent={{40,-80},{60,-60}})));
equation
  connect(sigBusGen, generation.sigBusGen) annotation (Line(
      points={{-62,64},{-0.3,64},{-0.3,35.28}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(const1.y, sigBusGen.hr_on) annotation (Line(points={{-79,30},{-62,30},
          {-62,64}},          color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(generation.portGen_in, vol.ports[1:1]) annotation (Line(points={{34,14.4},
          {62,14.4},{62,20},{83,20}},       color={0,127,255}));
  connect(heatingCurve.TOda, ramp.y) annotation (Line(points={{-22.2,-71},{-26,
          -71},{-26,-92},{-79,-92},{-79,-60}},
                                 color={0,0,127}));
  connect(ramp.y, TOda) annotation (Line(points={{-79,-60},{-79,-92},{-26,-92},
          {-26,-44},{94,-44},{94,-40},{110,-40}},                  color={0,0,
          127}));
  connect(realExpression.y, QCon_flow) annotation (Line(points={{51,82},{88,82},
          {88,60},{110,60}}, color={0,0,127}));
  connect(const3.y, heatingCurve.TSetRoom) annotation (Line(points={{-79,-90},{
          -78,-90},{-78,-92},{-9,-92},{-9,-84.2}},                  color={0,0,
          127}));
  connect(generation.weaBus, weaBus) annotation (Line(
      points={{-35.3,21.6},{-35.3,76},{-36,76}},
      color={255,204,51},
      thickness=0.5));
  connect(ramp.y, weaBus.TDryBul) annotation (Line(points={{-79,-60},{-44,-60},
          {-44,62},{-36,62},{-36,76}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(prescribedTemperature.port, vol.heatPort) annotation (Line(points={{
          60,-70},{66,-70},{66,-4},{96,-4},{96,10},{92,10}}, color={191,0,0}));
  connect(generation.portGen_out[1], vol.ports[2])
    annotation (Line(points={{34,28.8},{81,28.8},{81,20}}, color={0,127,255}));
  connect(heatingCurve.TSet, prescribedTemperature.T) annotation (Line(points={
          {3.1,-71},{20.55,-71},{20.55,-70},{38,-70}}, color={0,0,127}));
  connect(const2.y, sigBusGen.yHeaPumSet) annotation (Line(points={{-79,-30},{
          -72,-30},{-72,64},{-62,64}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialGetHeatGenerationCurve;
