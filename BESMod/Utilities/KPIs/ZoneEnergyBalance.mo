within BESMod.Utilities.KPIs;
model ZoneEnergyBalance
  "Model for energy KPIs relevant for a single zone"
  parameter Boolean with_ventilation=true "=false to disable ventilation values";
  BaseClasses.SplitGainAndLoss tra
    "KPIs for energy flow through transfer systems"
    annotation (Placement(transformation(extent={{-10,-170},{10,-150}})));
  BaseClasses.SplitGainAndLoss floor "KPIs for energy flow through floor"
    annotation (Placement(transformation(extent={{-10,110},{10,130}})));
  BaseClasses.SplitGainAndLoss win "KPIs for energy flow through window"
    annotation (Placement(transformation(extent={{-10,70},{10,90}})));
  BaseClasses.SplitGainAndLoss roof "KPIs for energy flow through roof"
    annotation (Placement(transformation(extent={{-10,150},{10,170}})));
  BaseClasses.SplitGainAndLoss extWall
    "KPIs for energy flow through external walls"
    annotation (Placement(transformation(extent={{-10,190},{10,210}})));
  BaseClasses.SplitGainAndLoss airExc
    "KPIs for energy flow through air exchange"
    annotation (Placement(transformation(extent={{-10,30},{10,50}})));
  Utilities.KPIs.EnergyKPICalculator intGaiLight(final use_inpCon=true)
    "Internal gains for light" annotation (Placement(transformation(extent={{-10,-50},
            {10,-30}},     rotation=0)));
  Utilities.KPIs.EnergyKPICalculator intGaiPer(final use_inpCon=true)
    "Internal gains for persons" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={0,-80})));
  Utilities.KPIs.EnergyKPICalculator intGaiMac(final use_inpCon=true)
    "Internal gains for machines" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={0,-120})));
  Utilities.KPIs.EnergyKPICalculator sol(final use_inpCon=true)
    "Internal gains through solar" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0)));
  Modelica.Blocks.Interfaces.RealInput QExtWall_flow(unit="W", displayUnit="kW")
    "Heat flow through external wall"
    annotation (Placement(transformation(extent={{-140,180},{-100,220}})));
  Modelica.Blocks.Interfaces.RealInput QRoof_flow(unit="W", displayUnit="kW")
    "Heat flow through roof"
    annotation (Placement(transformation(extent={{-140,140},{-100,180}})));
  Modelica.Blocks.Interfaces.RealInput QFloor_flow(unit="W", displayUnit="kW")
    "Heat flow through floor"
    annotation (Placement(transformation(extent={{-140,100},{-100,140}})));
  Modelica.Blocks.Interfaces.RealInput QWin_flow(unit="W", displayUnit="kW")
    "Heat flow through window"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
  Modelica.Blocks.Interfaces.RealInput QAirExc_flow(unit="W", displayUnit="kW")
    "Heat flow through air exchange"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}})));
  Modelica.Blocks.Interfaces.RealInput QSol_flow(unit="W", displayUnit="kW")
    "Heat flow through solar"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealInput QLig_flow(unit="W", displayUnit="kW")
    "Heat flow through lights"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));
  Modelica.Blocks.Interfaces.RealInput QMac_flow(unit="W", displayUnit="kW")
    "Heat flow through machines"
    annotation (Placement(transformation(extent={{-140,-140},{-100,-100}})));
  Modelica.Blocks.Interfaces.RealInput QPer_flow(unit="W", displayUnit="kW")
    "Heat flow through persons"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}})));
  Modelica.Blocks.Interfaces.RealInput QTra_flow(unit="W", displayUnit="kW")
    "Heat flow through heat transfer"
    annotation (Placement(transformation(extent={{-140,-180},{-100,-140}})));
  BaseClasses.ZoneEnergyBalanceBus zoneEneBal "Zone energy balance"
    annotation (Placement(transformation(extent={{82,-20},{122,20}})));
  Modelica.Blocks.Interfaces.RealInput QVen_flow(unit="W", displayUnit="kW")
    if with_ventilation
    "Heat flow through ventilation system"
    annotation (Placement(transformation(extent={{-140,-220},{-100,-180}})));
  BaseClasses.SplitGainAndLoss ven if with_ventilation
    "KPIs for energy flow through ventilation system"
    annotation (Placement(transformation(extent={{-10,-210},{10,-190}})));
equation
  connect(extWall.u, QExtWall_flow)
    annotation (Line(points={{-12,200},{-120,200}}, color={0,0,127}));
  connect(QTra_flow, tra.u)
    annotation (Line(points={{-120,-160},{-12,-160}}, color={0,0,127}));
  connect(QMac_flow, intGaiMac.u)
    annotation (Line(points={{-120,-120},{-11.8,-120}}, color={0,0,127}));
  connect(QPer_flow, intGaiPer.u)
    annotation (Line(points={{-120,-80},{-11.8,-80}},   color={0,0,127}));
  connect(QLig_flow, intGaiLight.u)
    annotation (Line(points={{-120,-40},{-11.8,-40}}, color={0,0,127}));
  connect(QSol_flow, sol.u)
    annotation (Line(points={{-120,0},{-11.8,0}},     color={0,0,127}));
  connect(QAirExc_flow, airExc.u)
    annotation (Line(points={{-120,40},{-12,40}}, color={0,0,127}));
  connect(QWin_flow, win.u)
    annotation (Line(points={{-120,80},{-12,80}}, color={0,0,127}));
  connect(QFloor_flow, floor.u)
    annotation (Line(points={{-120,120},{-12,120}}, color={0,0,127}));
  connect(QRoof_flow, roof.u)
    annotation (Line(points={{-120,160},{-12,160}}, color={0,0,127}));
  connect(extWall.gain, zoneEneBal.extWallGain) annotation (Line(points={{11.2,205},
          {76,205},{76,0},{102,0}}, color={135,135,135}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(extWall.loss, zoneEneBal.extWallLoss) annotation (Line(points={{11.2,195},
          {76,195},{76,0},{102,0}}, color={135,135,135}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(roof.gain, zoneEneBal.roofGain) annotation (Line(points={{11.2,165},{76,
          165},{76,0},{102,0}}, color={135,135,135}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(roof.loss, zoneEneBal.roofLoss) annotation (Line(points={{11.2,155},{76,
          155},{76,0},{102,0}}, color={135,135,135}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(floor.gain, zoneEneBal.floorGain) annotation (Line(points={{11.2,125},
          {76,125},{76,0},{102,0}}, color={135,135,135}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(floor.loss, zoneEneBal.floorLoss) annotation (Line(points={{11.2,115},
          {76,115},{76,0},{102,0}},
                                  color={135,135,135}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(win.gain, zoneEneBal.winGain) annotation (Line(points={{11.2,85},{76,85},
          {76,0},{102,0}}, color={135,135,135}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(win.loss, zoneEneBal.winLoss) annotation (Line(points={{11.2,75},{76,75},
          {76,0},{102,0}}, color={135,135,135}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(airExc.gain, zoneEneBal.airExcGain) annotation (Line(points={{11.2,45},
          {76,45},{76,0},{102,0}}, color={135,135,135}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(airExc.loss, zoneEneBal.airExcLoss) annotation (Line(points={{11.2,35},
          {76,35},{76,0},{102,0}}, color={135,135,135}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(sol.KPI, zoneEneBal.solGain) annotation (Line(points={{12.2,0},{102,0}},
                           color={135,135,135}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(intGaiLight.KPI, zoneEneBal.lightGain) annotation (Line(points={{12.2,
          -40},{76,-40},{76,0},{102,0}}, color={135,135,135}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(intGaiPer.KPI, zoneEneBal.perGain) annotation (Line(points={{12.2,-80},
          {76,-80},{76,0},{102,0}},  color={135,135,135}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(intGaiMac.KPI, zoneEneBal.macGain) annotation (Line(points={{12.2,-120},
          {76,-120},{76,0},{102,0}},                           color={135,135,135}),
      Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(tra.gain, zoneEneBal.traGain) annotation (Line(points={{11.2,-155},{11.2,
          -156},{76,-156},{76,0},{102,0}},           color={135,135,135}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(tra.loss, zoneEneBal.traLoss) annotation (Line(points={{11.2,-165},{11.2,
          -166},{76,-166},{76,0},{102,0}},           color={135,135,135}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(ven.gain, zoneEneBal.venGain) annotation (Line(points={{11.2,-195},{11.2,
          -196},{76,-196},{76,0},{102,0}},
                                 color={135,135,135}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(ven.loss, zoneEneBal.venLoss) annotation (Line(points={{11.2,-205},{11.2,
          -206},{76,-206},{76,0},{102,0}},
                                 color={135,135,135}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(ven.u, QVen_flow)
    annotation (Line(points={{-12,-200},{-120,-200}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-200},
            {100,200}}),                                        graphics={
          Rectangle(
          extent={{-100,202},{102,-200}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
                              Text(
          extent={{-104,182},{100,86}},
          lineColor={0,0,0},
          textString="%name%")}), Diagram(coordinateSystem(preserveAspectRatio=false, extent={
            {-100,-200},{100,200}})), Documentation(info="<html>
<p>Model for calculating energy key performance indicators (KPIs) for a single thermal zone. 
The model splits energy flows through different building components (walls, roof, floor, windows) and 
systems (ventilation, heating/cooling) into gains and losses. 
It also accounts for internal gains from lights, people, machines and solar radiation.
</p>

<h4>Structure</h4>
<p>The model contains several instances of <a href=\"modelica://BESMod.Utilities.KPIs.BaseClasses.SplitGainAndLoss\">BESMod.Utilities.KPIs.BaseClasses.SplitGainAndLoss</a> 
for splitting energy flows into gains and losses for:</p>
<ul>
<li>External walls</li>
<li>Roof</li>
<li>Floor</li>
<li>Windows</li>
<li>Air exchange</li>
<li>Transfer systems (heating/cooling)</li>
<li>Ventilation system (optional)</li>
</ul>

<p>Internal gains are calculated using <a href=\"modelica://BESMod.Utilities.KPIs.EnergyKPICalculator\">BESMod.Utilities.KPIs.EnergyKPICalculator</a> for:</p>
<ul>
<li>Lighting</li>
<li>People</li>
<li>Machines</li>
<li>Solar gains</li>
</ul>

<h4>Important Parameters</h4>
<ul>
<li><code>with_ventilation</code> (boolean): Enable/disable ventilation system calculations. Default: true</li>
</ul>

<h4>Interfaces</h4>
<p>The model has Real inputs for heat flows through all components (in W) and outputs the calculated KPIs through a <code>zoneEneBal</code> bus connector of type <a href=\"modelica://BESMod.Utilities.KPIs.BaseClasses.ZoneEnergyBalanceBus\">ZoneEnergyBalanceBus</a>.</p>
</html>"));
end ZoneEnergyBalance;
