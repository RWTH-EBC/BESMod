within BESMod.Systems.Hydraulical.Distribution.Components.Valves.Tests;
model TestThreeWayValve
  extends Modelica.Icons.Example;

  /******************************* Parameters *******************************/
  replaceable package Medium = IBPSA.Media.Water;

  /******************************* Components *******************************/

  Modelica.Blocks.Sources.Pulse        pulse(       period=100)
    annotation (Placement(transformation(extent={{-44,40},{-24,60}})));
  Modelica.Fluid.Sources.Boundary_ph boundary2(redeclare package Medium =
        Medium,
    p=200000,
    nPorts=1)
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-112,-28})));
  IBPSA.Fluid.MixingVolumes.MixingVolume demandBui(
    each V=0.005,
    redeclare package Medium = Medium,
    each m_flow_nominal=0.01,
    nPorts=2)                 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={84,6})));
  ThreeWayValveWithFlowReturn threeWayValveWithFlowReturn(redeclare package
      Medium = Medium, redeclare
      BESMod.Systems.RecordsCollection.Valves.DefaultThreeWayValve
      parameters(
      m_flow_nominal=m_flow_nominal,
      dp_nominal={dpValve_nominal, dpValve_nominal},
      dpFixed_nominal={0,0},
      fraK=1,
      riseTime=50))
    annotation (Placement(transformation(extent={{-46,-40},{24,20}})));
  IBPSA.Fluid.Movers.FlowControlled_m_flow
                                        pumpHP(
    redeclare final package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    redeclare Systems.RecordsCollection.Movers.AutomaticConfigurationData per(
      final m_flow_nominal=m_flow_nominal,
      final dp_nominal=2*(threeWayValveWithFlowReturn.parameters.dpValve_nominal
           + threeWayValveWithFlowReturn.parameters.dpFixed_nominal[1]) + dpRes,
      final rho(displayUnit="kg/m3") = 1000,
      V_flowCurve={0,0.99,1,1.01},
      dpCurve={2,1,0.5,0}),
    final inputType=IBPSA.Fluid.Types.InputType.Continuous,
    final addPowerToMedium=false,
    final use_inputFilter=false)
                     annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=270,
        origin={-80,-12})));

  Modelica.Blocks.Sources.SawTooth     sawTooth(amplitude=m_flow_nominal,
      period=pulse.period*pulse.width/100)
    annotation (Placement(transformation(extent={{-132,6},{-112,26}})));
  IBPSA.Fluid.FixedResistances.PressureDrop res(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal(displayUnit="bar") = dpRes)
    annotation (Placement(transformation(extent={{42,18},{62,38}})));
  IBPSA.Fluid.FixedResistances.PressureDrop res1(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal(displayUnit="bar") = 2*dpRes)
    annotation (Placement(transformation(extent={{50,-26},{70,-6}})));
  parameter Modelica.SIunits.PressureDifference dpValve_nominal=10000
    "Nominal pressure drop of fully open valve, used if CvData=IBPSA.Fluid.Types.CvTypes.OpPoint";
  parameter Modelica.SIunits.PressureDifference dpRes=3000
    "Pressure drop at nominal mass flow rate";
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal=1
    "Nominal mass flow rate";
equation
  connect(pulse.y, threeWayValveWithFlowReturn.uBuf)
    annotation (Line(points={{-23,50},{-11,50},{-11,26}}, color={0,0,127}));
  connect(threeWayValveWithFlowReturn.portBui_a, demandBui.ports[1])
    annotation (Line(points={{24,2},{38,2},{38,7},{74,7}}, color={0,127,255}));
  connect(threeWayValveWithFlowReturn.portGen_b, pumpHP.port_a) annotation (
      Line(points={{-46,-20.8},{-64,-20.8},{-64,-24},{-80,-24},{-80,-22}},
        color={0,127,255}));
  connect(pumpHP.port_b, threeWayValveWithFlowReturn.portGen_a) annotation (
      Line(points={{-80,-2},{-66,-2},{-66,3.2},{-46,3.2}}, color={0,127,255}));
  connect(boundary2.ports[1], pumpHP.port_a) annotation (Line(points={{-102,-28},
          {-80,-28},{-80,-22}}, color={0,127,255}));
  connect(threeWayValveWithFlowReturn.portBui_b, res.port_a) annotation (Line(
        points={{24,14},{34,14},{34,28},{42,28}}, color={0,127,255}));
  connect(demandBui.ports[2], res.port_b) annotation (Line(points={{74,5},{68,5},
          {68,28},{62,28}}, color={0,127,255}));
  connect(threeWayValveWithFlowReturn.portDHW_b, res1.port_a) annotation (Line(
        points={{24,-20.8},{38,-20.8},{38,-16},{50,-16}}, color={0,127,255}));
  connect(res1.port_b, threeWayValveWithFlowReturn.portDHW_a) annotation (Line(
        points={{70,-16},{82,-16},{82,-32.8},{24,-32.8}}, color={0,127,255}));
  connect(sawTooth.y, pumpHP.m_flow_in) annotation (Line(points={{-111,16},{-98,
          16},{-98,-12},{-92,-12}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=1000, __Dymola_Algorithm="Dassl"));
end TestThreeWayValve;
