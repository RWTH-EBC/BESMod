within BESMod.Systems.Hydraulical.Transfer.Tests;
model TestOpenModelica
  extends Modelica.Icons.Example;
  extends Systems.BaseClasses.PartialBESExample;
  BESMod.Systems.Hydraulical.Transfer.RadiatorPressureBased transfer(
    redeclare Systems.Hydraulical.Transfer.RecordsCollection.RadiatorTransferData parRad, dTTra_nominal = {15}, dTTra_design = {15}, dTTraOld_design = {15}, m_flow_nominal = {0.16941387735728294}, mOld_flow_design = {0.16941387735728294}, QSup_flow_nominal = {10632.4149429430780}, QSupOld_flow_design = {10632.4149429430780}, mSup_flow_nominal = {0.16941387735728294}, mSup_flow_design = {0.16941387735728294}, mSupOld_flow_design = {0.16941387735728294},dpSup_nominal(each displayUnit = "Pa") = {1000},dpSup_design(each displayUnit = "Pa") = {1000},dpSupOld_design(each displayUnit = "Pa") = {1000}, Q_flow_design = {10632.4149429430780}, m_flow_design = {0.16941387735728294}, use_oldRad_design = {true}, TSup_nominal = {328.15}, TSupOld_design = {328.15}, TTra_design = {328.15}, dpOld_design(each displayUnit = "Pa") = {1000}, dp_nominal = {1000}, dpPipSca_design = {1000},
    dpFixedTotal_nominal={1100}, dpPipSupSca_design = {1000}, dpPipSupSca_nominal = {1100},  
  nParallelDem = 1, redeclare package Medium = IBPSA.Media.Water, energyDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial, Q_flow_nominal = systemParameters.QBui_flow_nominal, TOda_nominal = systemParameters.TOda_nominal, TDem_nominal = systemParameters.TSetZone_nominal, TAmb = systemParameters.TAmbHyd, TTra_nominal = {328.15}, TTraOld_design = {328.15}, AZone = {100}, hZone = {2.6}, ABui = 100, hBui = 2.6) annotation(
     choicesAllMatching = true,
     Placement(transformation(extent = {{-32, -26}, {36, 44}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixTZone[transfer.nParallelDem](T = systemParameters.TSetZone_nominal) annotation(
    Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 180, origin = {70, 8})));
  IBPSA.Fluid.Sources.Boundary_pT bou1[transfer.nParallelSup](redeclare package Medium = IBPSA.Media.Water, each final p = 200000, each nPorts = 1) annotation(
    Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 0, origin = {-70, -50})));
  Interfaces.TransferControlBus traControlBus annotation(
    Placement(transformation(extent = {{0, 60}, {20, 80}}), iconTransformation(extent = {{0, 60}, {20, 80}})));
  Modelica.Blocks.Sources.Ramp ramp[1](each duration = 100, each startTime = 250) annotation(
    Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 0, origin = {-90, 70})));
  Modelica.Blocks.Sources.RealExpression Q_flow[transfer.nParallelDem](y = fixTZone.port.Q_flow) "Difference between trajectory and nominal heat flow rate" annotation(
    Placement(transformation(extent = {{60, 80}, {80, 100}})));
  IBPSA.Fluid.Sources.MassFlowSource_T boundary[1](redeclare package Medium = IBPSA.Media.Water, m_flow = {0.16941387735728294}, T = {328.15}, each nPorts = 1)  annotation(
    Placement(transformation(origin = {-74, 40}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(traControlBus, transfer.traControlBus) annotation(
    Line(points = {{10, 70}, {10, 50}, {2, 50}, {2, 44}}, color = {255, 204, 51}, thickness = 0.5),
    Text(string = "%first", index = -1, extent = {{-3, 6}, {-3, 6}}, horizontalAlignment = TextAlignment.Right));
  connect(ramp.y, traControlBus.opening) annotation(
    Line(points = {{-79, 70}, {10, 70}}, color = {0, 0, 127}),
    Text(string = "%second", index = 1, extent = {{6, 3}, {6, 3}}, horizontalAlignment = TextAlignment.Left));
  connect(fixTZone.port, transfer.heatPortCon) annotation(
    Line(points = {{60, 8}, {46, 8}, {46, 23}, {36, 23}}, color = {191, 0, 0}));
  connect(fixTZone.port, transfer.heatPortRad) annotation(
    Line(points = {{60, 8}, {46, 8}, {46, -5}, {36, -5}}, color = {191, 0, 0}));
  connect(bou1.ports[1], transfer.portTra_out) annotation(
    Line(points = {{-60, -50}, {-46, -50}, {-46, -6}, {-32, -6}, {-32, -6}}, color = {0, 127, 255}, thickness = 0.5));
  connect(boundary.ports[1], transfer.portTra_in) annotation(
    Line(points = {{-64, 40}, {-32, 40}, {-32, 24}}, color = {0, 127, 255}, thickness = 0.5));
  annotation(
    Documentation(info = "<html>
<p>This test sets the nominal zone and supply temperature to check if heat and mass flow rates as well as pressure drops are match the design conditions.</p>
</html>"));
end TestOpenModelica;
