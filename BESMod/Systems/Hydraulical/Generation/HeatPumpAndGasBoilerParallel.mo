within BESMod.Systems.Hydraulical.Generation;
model HeatPumpAndGasBoilerParallel
  "Parallel connection of heat pump and gas boiler"
  extends BaseClasses.PartialHeatPumpAndGasBoiler(
    final use_old_design=fill(false, nParallelDem));

  replaceable parameter BESMod.Systems.RecordsCollection.Valves.ThreeWayValve
    parThrWayVal constrainedby
    BESMod.Systems.RecordsCollection.Valves.ThreeWayValve(
    final dp_nominal={parHeaPum.dpCon_nominal,boi.dp_nominal},
    final m_flow_nominal=2*m_flow_nominal[1],
    final fraK=1) "Parameters for three-way-valve" annotation (Placement(
        transformation(extent={{64,4},{78,18}})), choicesAllMatching=true,
        Dialog(group="Component data"));

  Distribution.Components.Valves.ThreeWayValveWithFlowReturn thrWayVal(
    redeclare package Medium = Medium,
    final energyDynamics=energyDynamics,
    final p_start=p_start,
    final T_start=T_start,
    final X_start=X_start,
    final C_start=C_start,
    final C_nominal=C_nominal,
    final mSenFac=mSenFac,
    redeclare BESMod.Systems.RecordsCollection.Valves.DefaultThreeWayValve
      parameters=parThrWayVal)
    "Three-way-valve to either run heat pump or gas boiler"
    annotation (Placement(transformation(extent={{40,20},{20,0}})));

equation
  connect(thrWayVal.portDHW_a, boi.port_b) annotation (Line(points={{20,17.6},{8,17.6},
          {8,26},{44,26},{44,50},{40,50}}, color={0,127,255}));
  connect(thrWayVal.portDHW_b, boi.port_a) annotation (Line(points={{20,13.6},{20,
          14},{6,14},{6,50},{20,50}}, color={0,127,255}));
  connect(heatPump.port_b1, thrWayVal.portBui_a) annotation (Line(points={{-30.5,37},
          {-30.5,42},{-6,42},{-6,6},{20,6}}, color={0,127,255}));
  connect(thrWayVal.portGen_b, senTGenOut.port_a) annotation (Line(points={{40,13.6},
          {54,13.6},{54,80},{60,80}}, color={0,127,255}));
  connect(pump.port_b, thrWayVal.portGen_a) annotation (Line(points={{1.77636e-15,
          -70},{-6,-70},{-6,-34},{50,-34},{50,6},{40,6},{40,5.6}}, color={0,127,255}));
  connect(thrWayVal.portBui_b, heatPump.port_a1) annotation (Line(points={{20,2},{
          -6,2},{-6,-7},{-30.5,-7}}, color={0,127,255}));
  connect(thrWayVal.uBuf, sigBusGen.uPriOrSecGen) annotation (Line(points={{30,-2},
          {30,-16},{2,-16},{2,98}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  annotation (Documentation(info="<html>
<p>
This model implements a parallel connection between a heat pump and a gas boiler. 
The system uses a three-way valve to switch between the heat sources based on control signals.
</p>
<p>
The model extends <a href=\"modelica://BESMod.Systems.Hydraulical.Generation.BaseClasses.PartialHeatPumpAndGasBoiler\">
PartialHeatPumpAndGasBoiler</a> with parallel configuration functionality.
</p>

<h4>Components</h4>
<ul>
<li>Three-way valve with flow return (<a href=\"modelica://BESMod.Systems.Distribution.Components.Valves.ThreeWayValveWithFlowReturn\">BESMod.Systems.Distribution.Components.Valves.ThreeWayValveWithFlowReturn</a>)</li>
<li>Heat pump and gas boiler with parallel hydraulic connection</li>
</ul>

</html>"));
end HeatPumpAndGasBoilerParallel;
