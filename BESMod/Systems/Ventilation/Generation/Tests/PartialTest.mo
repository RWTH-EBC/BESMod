within BESMod.Systems.Ventilation.Generation.Tests;
partial model PartialTest
  extends BESMod.Systems.BaseClasses.PartialBESExample;
  replaceable package Medium = IBPSA.Media.Air constrainedby
    Modelica.Media.Interfaces.PartialMedium
    annotation (choicesAllMatching=true);
  IBPSA.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(final filNam=
        systemParameters.filNamWea)
    "Weather data reader"
    annotation (Placement(transformation(extent={{-100,34},{-42,100}})));
  replaceable BaseClasses.PartialGeneration generation constrainedby
    BaseClasses.PartialGeneration(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=fill(0.5*150*2.6/3600*1.225, generation.nParallelDem),
    Q_flow_nominal=fill(sum(systemParameters.QBui_flow_nominal), generation.nParallelDem),
    TOda_nominal=systemParameters.TOda_nominal,
    TDem_nominal=systemParameters.TSetZone_nominal,
    TAmb=systemParameters.TAmbVen,
    dpDem_nominal=fill(0, generation.nParallelDem))
                                   annotation (Placement(transformation(extent=
            {{-20,-68},{68,30}})), choicesAllMatching=true);

  IBPSA.Fluid.MixingVolumes.MixingVolume vol[generation.nParallelDem](
    redeclare final package Medium = Medium,
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
    each V=150*2.6,
    each final use_C_flow=false,
    each final nPorts=2)
                   annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-52,-20})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature[
    generation.nParallelDem](each final T(displayUnit="K") = systemParameters.THydSup_nominal[
      1])                   annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-84,-44})));
equation
  connect(weaDat.weaBus, generation.weaBus) annotation (Line(
      points={{-42,67},{-42,66},{-12,66},{-12,90},{24.88,90},{24.88,30}},
      color={255,204,51},
      thickness=0.5));
  connect(vol.heatPort,fixedTemperature. port)
                                              annotation (Line(points={{-52,-30},
          {-52,-44},{-74,-44}},           color={191,0,0}));
    for i in 1:generation.nParallelDem loop
      connect(vol[i].ports[1], generation.portVent_in[i]) annotation (Line(points={{-42,-21},
              {-42,1.58},{-20,1.58}},       color={0,0,255}));

      connect(vol[i].ports[2], generation.portVent_out[i]) annotation (Line(points={{-42,-19},
              {-42,-38.6},{-20,-38.6}},     color={0,0,255}));
    end for;

    annotation (experiment(StopTime=2592000, __Dymola_Algorithm="Dassl"));
  annotation (Documentation(info="<html>

<p>Partial model for testing ventilation generation systems. 
</p>

<p>The model includes:</p>
<ul>
  <li>Weather data reader using TMY3 format</li>
  <li>Replaceable ventilation generation system</li>
  <li>Mixing volumes representing building air volume</li>
  <li>Fixed temperature boundary condition</li>
</ul>

<h4>Important Parameters</h4>
<ul>
  <li>Medium: Replaceable medium package (defaults to IBPSA.Media.Air)</li>
  <li>m_flow_nominal: Nominal mass flow rate based on room volume (150m³) and air changes</li>
  <li>Q_flow_nominal: Nominal heating/cooling power</li>
  <li>TOda_nominal: Nominal outdoor temperature</li>
  <li>TDem_nominal: Nominal zone temperature setpoint</li>
  <li>V: Room volume (150m³ with 2.6m height)</li>
</ul>

</html>"));
end PartialTest;
