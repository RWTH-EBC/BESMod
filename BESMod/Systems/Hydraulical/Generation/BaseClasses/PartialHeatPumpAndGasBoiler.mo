within BESMod.Systems.Hydraulical.Generation.BaseClasses;
model PartialHeatPumpAndGasBoiler "Partial heat pump and boiler"
  extends BESMod.Systems.Hydraulical.Generation.BaseClasses.PartialHeatPump(genDesTyp
      =BESMod.Systems.Hydraulical.Generation.Types.GenerationDesign.BivalentPartParallel,
      dp_nominal={heatPump.dpCon_nominal + boi.dp_nominal});
  parameter Real etaTem[:,2]=[293.15,1.09; 303.15,1.08; 313.15,1.05; 323.15,1.; 373.15,
      0.99] "Temperature based efficiency";

  replaceable parameter BESMod.Systems.Hydraulical.Generation.RecordsCollection.AutoparameterBoiler
    parBoi constrainedby AixLib.DataBase.Boiler.General.BoilerTwoPointBaseDataDefinition(
      Q_nom=max(11000, QSec_flow_nominal))
    "Parameters for Boiler"
    annotation(Placement(transformation(extent={{22,62},{38,78}})),
      choicesAllMatching=true);

  AixLib.Fluid.BoilerCHP.BoilerNoControl boi(
    redeclare package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m_flow_nominal[1],
    final m_flow_small=1E-4*abs(m_flow_nominal[1]),
    final show_T=show_T,
    final tau=parTemSen.tau,
    final initType=parTemSen.initType,
    final transferHeat=parTemSen.transferHeat,
    final TAmb=parTemSen.TAmb,
    final tauHeaTra=parTemSen.tauHeaTra,
    final rho_default=rho,
    final p_start=p_start,
    final T_start=T_start,
    final etaLoadBased=parBoi.eta,
    final G=0.003*parBoi.Q_nom/50,
    final C=1.5*parBoi.Q_nom,
    final Q_nom=parBoi.Q_nom,
    final V=parBoi.volume,
    final etaTempBased=etaTem,
    final paramBoiler=parBoi,
    T_out(unit="K", displayUnit="degC"))
                              "Boiler with external control"
    annotation (Placement(transformation(extent={{20,40},{40,60}})));

  Utilities.KPIs.EnergyKPICalculator KPIBoi(use_inpCon=false, y=boi.thermalPower)
    annotation (Placement(transformation(extent={{-140,-110},{-120,-90}})));

  Utilities.KPIs.EnergyKPICalculator KPIBoiFue(use_inpCon=false, y=boi.fuelPower)
    "Fuel consumption"
    annotation (Placement(transformation(extent={{-140,-140},{-120,-120}})));


equation

  connect(boi.T_out, sigBusGen.TBoiOut) annotation (Line(points={{37.2,53.2},{42,53.2},
          {42,78},{2,78},{2,98}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(boi.u_rel, sigBusGen.yBoi) annotation (Line(points={{23,57},{2,57},{2,98}},
        color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(KPIBoiFue.KPI, outBusGen.PBoiFue) annotation (Line(points={{-117.8,-130},
          {0,-130},{0,-100}}, color={135,135,135}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(KPIBoi.KPI, outBusGen.QBoi_flow) annotation (Line(points={{-117.8,-100},
          {-108,-100},{-108,-118},{0,-118},{0,-100}}, color={135,135,135}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  annotation (Line(
      points={{-52.775,-6.78},{-52.775,33.61},{-56,33.61},{-56,74}},
      color={255,204,51},
      thickness=0.5),
              Diagram(coordinateSystem(extent={{-180,-140},{100,100}})));
  annotation (Documentation(info="<html>
<p>Partial model for a bivalent-parallel generation system combining a heat pump 
with a gas boiler. 
The model extends the <a href=\"modelica://BESMod.Systems.Hydraulical.Generation.BaseClasses.PartialHeatPump\">PartialHeatPump</a> base class.</p>

<h4>Important Parameters</h4>
<ul>
  <li><code>etaTem</code>: Matrix of temperature-dependent efficiencies. First column contains temperatures [K], second column contains corresponding efficiency factors.</li>
  <li><code>parBoi</code>: Boiler parameters record inheriting from <a href=\"modelica://AixLib.DataBase.Boiler.General.BoilerTwoPointBaseDataDefinition\">BoilerTwoPointBaseDataDefinition</a></li>
  <li><code>Q_nom</code>: Nominal heating power, automatically sized to at least 11 kW or secondary nominal heat flow rate</li>
</ul>

<h4>Components</h4>
<ul>
  <li>Heat pump (inherited from base class)</li>
  <li>Gas boiler (<a href=\"modelica://AixLib.Fluid.BoilerCHP.BoilerNoControl\">AixLib.Fluid.BoilerCHP.BoilerNoControl</a>)</li>
</ul>
</html>"));
end PartialHeatPumpAndGasBoiler;
