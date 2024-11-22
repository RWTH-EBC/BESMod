within BESMod.Systems.Hydraulical.Generation.Tests;
partial model PartialTest
  "Model for a partial test of hydraulic generation systems"
  extends BESMod.Systems.BaseClasses.PartialBESExample;

  BESMod.Systems.Hydraulical.Interfaces.GenerationControlBus
    genControlBus
    annotation (Placement(transformation(extent={{-10,54},{30,94}})));
  replaceable BESMod.Systems.Hydraulical.Generation.BaseClasses.PartialGeneration generation
    constrainedby BaseClasses.PartialGeneration(
    redeclare package Medium = IBPSA.Media.Water,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    dTTra_nominal=fill(10, generation.nParallelDem),
    m_flow_nominal=fill(0.317, generation.nParallelDem),
    Q_flow_nominal=fill(sum(systemParameters.QBui_flow_nominal), generation.nParallelDem),
    TOda_nominal=systemParameters.TOda_nominal,
    dpDem_nominal=fill(0, generation.nParallelDem),
    TDem_nominal=fill(systemParameters.THydSup_nominal[1], generation.nParallelDem),
    TAmb=systemParameters.TAmbHyd,
    dpDemOld_design=fill(0, generation.nParallelDem))
    annotation (choicesAllMatching=true, Placement(transformation(extent={{-50,-44},{24,28}})));

  IBPSA.Fluid.MixingVolumes.MixingVolume vol[generation.nParallelDem](
    redeclare final package Medium = IBPSA.Media.Water,
    each final energyDynamics=generation.energyDynamics,
    each final massDynamics=generation.massDynamics,
    each final p_start=generation.p_start,
    final T_start=fixedTemperature.T,
    each final X_start=generation.X_start,
    each final C_start=generation.C_start,
    each final C_nominal=generation.C_nominal,
    each final mSenFac=generation.mSenFac,
    final m_flow_nominal=generation.m_flow_nominal,
    final m_flow_small=1E-4*abs(generation.m_flow_nominal),
    each final allowFlowReversal=generation.allowFlowReversal,
    each V=23.5e-6*sum(systemParameters.QBui_flow_nominal),
    each final use_C_flow=false,
    each nPorts=2) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={54,12})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature[
    generation.nParallelDem](each final T(displayUnit="K") = systemParameters.THydSup_nominal[
      1])                                                      annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={90,8})));
  IBPSA.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(final filNam=
        systemParameters.filNamWea)
    "Weather data reader"
    annotation (Placement(transformation(extent={{-102,66},{-66,100}})));
equation
  connect(generation.sigBusGen, genControlBus) annotation (Line(
      points={{-12.26,27.28},{-12.26,49.64},{10,49.64},{10,74}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  for i in 1:generation.nParallelDem loop
  connect(generation.portGen_out[i], vol[i].ports[1]) annotation (Line(points={{24,20.8},
            {36,20.8},{36,6},{44,6},{44,13}},     color={0,127,255}));
  connect(generation.portGen_in[i], vol[i].ports[2])
    annotation (Line(points={{24,6.4},{44,6.4},{44,11}}, color={0,127,255}));
  end for;

  connect(vol.heatPort, fixedTemperature.port) annotation (Line(points={{54,22},
          {54,26},{76,26},{76,8},{80,8}}, color={191,0,0}));
  connect(weaDat.weaBus, generation.weaBus) annotation (Line(
      points={{-66,83},{-66,82},{-58,82},{-58,13.6},{-49.26,13.6}},
      color={255,204,51},
      thickness=0.5));

  annotation (experiment(
      StopTime=864000,
      Interval=600,
      __Dymola_Algorithm="Dassl"), Documentation(info="<html><p>
  This partial model implements a basic test setup for hydraulic
  generation systems. It provides a testing environment with weather
  data, control bus interface, and basic boundary conditions. The model
  uses a replaceable generation model from <a href=
  \"modelica://BESMod.Systems.Hydraulical.Generation.BaseClasses.PartialGeneration\">
  BESMod.Systems.Hydraulical.Generation.BaseClasses.PartialGeneration</a>.
</p>
<h4>
  Structure
</h4>
<p>
  The model contains:
</p>
<ul>
  <li>A replaceable generation system
  </li>
  <li>Mixing volumes as hydraulic loads
  </li>
  <li>Fixed temperature boundary conditions
  </li>
  <li>Weather data reader for ambient conditions
  </li>
</ul>
</html>"));
end PartialTest;
