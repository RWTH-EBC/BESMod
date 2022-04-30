within BESMod.Utilities.HeatGeneration;
partial model PartialGetHeatGenerationCurve
  extends BESMod.Systems.BaseClasses.PartialBESExample;
  replaceable Systems.Hydraulical.Generation.BaseClasses.PartialGeneration
    generation constrainedby
    Systems.Hydraulical.Generation.BaseClasses.PartialGeneration(
      redeclare final package Medium = IBPSA.Media.Water,
      final Q_flow_nominal={sum(systemParameters.QBui_flow_nominal)},
      final TDem_nominal=systemParameters.THydSup_nominal,
      final dp_nominal=fill(0, generation.nParallelDem),
      final TOda_nominal=systemParameters.TOda_nominal,
      final TAmb= systemParameters.TAmbHyd,
      final dpDem_nominal={0})  annotation (choicesAllMatching=true, Placement(
        transformation(extent={{-36,-36},{34,36}})));
  Systems.Hydraulical.Interfaces.GenerationControlBus sigBusGen
    annotation (Placement(transformation(extent={{-72,54},{-52,74}})));
  Modelica.Blocks.Sources.Constant const(k=1)
    annotation (Placement(transformation(extent={{-150,54},{-130,74}})));
  Modelica.Blocks.Sources.Constant const1(k=0)
    annotation (Placement(transformation(extent={{-150,22},{-130,42}})));
  Modelica.Blocks.Sources.BooleanConstant booleanConstant(k=true)
    annotation (Placement(transformation(extent={{-148,-8},{-128,12}})));
  Modelica.Blocks.Sources.Constant const2(k=1)
    annotation (Placement(transformation(extent={{-148,-44},{-128,-24}})));
  Modelica.Blocks.Sources.Ramp ramp
    annotation (Placement(transformation(extent={{-150,-80},{-130,-60}})));
  IBPSA.Fluid.Sources.MassFlowSource_T boundary(
    redeclare package Medium = IBPSA.Media.Water,
    m_flow=generation.m_flow_nominal[1],
    use_T_in=true,
    T=313.15,
    nPorts=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={82,10})));
  IBPSA.Fluid.Sources.Boundary_pT bou1(redeclare package Medium =
        IBPSA.Media.Water, nPorts=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={82,54})));
  Systems.Hydraulical.Control.Components.HeatingCurve heatingCurve(
    TRoomSet=systemParameters.TSetZone_nominal[1],
    GraHeaCurve=bivalentHeatPumpControlDataDefinition.gradientHeatCurve,
    THeaThres=systemParameters.TSetZone_nominal[1],
    dTOffSet_HC=bivalentHeatPumpControlDataDefinition.dTOffSetHeatCurve -
        generation.dTTra_nominal[1]) annotation (Placement(transformation(
        extent={{-11,-11},{11,11}},
        rotation=0,
        origin={-7,-71})));
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
equation
  connect(sigBusGen, generation.sigBusGen) annotation (Line(
      points={{-62,64},{-0.3,64},{-0.3,35.28}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(const.y, sigBusGen.hp_bus.iceFacMea) annotation (Line(points={{-129,64},
          {-94,64},{-94,64},{-62,64}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(const1.y, sigBusGen.hr_on) annotation (Line(points={{-129,32},{-96,32},
          {-96,64},{-62,64}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(booleanConstant.y, sigBusGen.hp_bus.modeSet) annotation (Line(points={
          {-127,2},{-98,2},{-98,0},{-62,0},{-62,64}}, color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(const2.y, sigBusGen.hp_bus.nSet) annotation (Line(points={{-127,-34},{
          -62,-34},{-62,64}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(ramp.y, sigBusGen.weaBus.TDryBul) annotation (Line(points={{-129,-70},
          {-62,-70},{-62,64}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(ramp.y, sigBusGen.hp_bus.TOdaMea) annotation (Line(points={{-129,-70},
          {-62,-70},{-62,64}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(generation.portGen_in, boundary.ports[1:1]) annotation (Line(points={{
          34,14.4},{62,14.4},{62,10},{72,10}}, color={0,127,255}));
  connect(generation.portGen_out, bou1.ports[1:1]) annotation (Line(points={{34,
          28.8},{62,28.8},{62,54},{72,54}}, color={0,127,255}));
  connect(boundary.T_in, heatingCurve.TSet) annotation (Line(points={{94,6},{
          100,6},{100,-71},{5.1,-71}},
                                 color={0,0,127}));
  connect(heatingCurve.TOda, ramp.y) annotation (Line(points={{-20.2,-71},{-36,
          -71},{-36,-70},{-129,-70}},
                                 color={0,0,127}));
  connect(ramp.y, TOda) annotation (Line(points={{-129,-70},{-116,-70},{-116,
          -72},{-102,-72},{-102,-90},{62,-90},{62,-40},{110,-40}}, color={0,0,
          127}));
  connect(realExpression.y, QCon_flow) annotation (Line(points={{51,82},{88,82},
          {88,60},{110,60}}, color={0,0,127}));
  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(graphics,
        coordinateSystem(preserveAspectRatio=false)));
end PartialGetHeatGenerationCurve;
