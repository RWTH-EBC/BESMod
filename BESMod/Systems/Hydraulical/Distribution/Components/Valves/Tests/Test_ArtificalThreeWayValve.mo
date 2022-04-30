within BESMod.Systems.Hydraulical.Distribution.Components.Valves.Tests;
model Test_ArtificalThreeWayValve
  extends Modelica.Icons.Example;

  /******************************* Parameters *******************************/
  replaceable package Medium = IBPSA.Media.Water;

  /******************************* Components *******************************/

  Modelica.Blocks.Sources.BooleanPulse booleanPulse(period=100)
    annotation (Placement(transformation(extent={{-44,40},{-24,60}})));
  Modelica.Fluid.Sources.MassFlowSource_T boundary(          redeclare package
              Medium =                                                                Medium,
    m_flow=0.2,
    T=313.15,
    nPorts=1)
    annotation (Placement(transformation(extent={{-84,0},{-64,20}})));
  ArtificialThreeWayValve artificialThreeWayValve(redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{-22,-22},{18,18}})));
  Modelica.Fluid.Sources.Boundary_ph boundary2(redeclare package Medium =
        Medium, nPorts=1)
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-74,-12})));
  IBPSA.Fluid.MixingVolumes.MixingVolume demandDHW(
    each V=0.005,
    redeclare package Medium = Medium,
    each nPorts=2,
    each m_flow_nominal=0.01) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={52,-14})));
  IBPSA.Fluid.MixingVolumes.MixingVolume demandBui(
    each V=0.005,
    redeclare package Medium = Medium,
    each nPorts=2,
    each m_flow_nominal=0.01) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={54,10})));
equation
  connect(boundary2.ports[1], artificialThreeWayValve.port_b) annotation (Line(
        points={{-64,-12},{-46,-12},{-46,-10},{-22,-10}}, color={0,127,255}));
  connect(boundary.ports[1], artificialThreeWayValve.port_a) annotation (Line(
        points={{-64,10},{-46,10},{-46,6},{-22,6}}, color={0,127,255}));
  connect(demandDHW.ports[1], artificialThreeWayValve.port_dhw_b) annotation (
      Line(points={{42,-13},{30,-13},{30,-10},{18,-10}}, color={0,127,255}));
  connect(demandDHW.ports[2], artificialThreeWayValve.port_dhw_a) annotation (
      Line(points={{42,-15},{32,-15},{32,-18},{18,-18}}, color={0,127,255}));
  connect(demandBui.ports[1], artificialThreeWayValve.port_buf_b) annotation (
      Line(points={{44,11},{32,11},{32,13.2},{18,13.2}}, color={0,127,255}));
  connect(demandBui.ports[2], artificialThreeWayValve.port_buf_a) annotation (
      Line(points={{44,9},{32,9},{32,5.2},{18,5.2}}, color={0,127,255}));
  connect(booleanPulse.y, artificialThreeWayValve.dhw_on)
    annotation (Line(points={{-23,50},{-2,50},{-2,22}}, color={255,0,255}));
  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(graphics,
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=1000, __Dymola_Algorithm="Dassl"));
end Test_ArtificalThreeWayValve;
