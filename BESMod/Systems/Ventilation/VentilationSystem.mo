within BESMod.Systems.Ventilation;
model VentilationSystem
  extends BaseClasses.PartialVentilationSystem(distribution(
      dTTra_nominal=fill(0, distribution.nParallelDem),
      m_flow_nominal=fill(0, distribution.nParallelDem),
      dp_nominal=fill(0, distribution.nParallelDem)), generation(
      TSup_nominal=fill(293.15, generation.nParallelDem),
      dTTra_nominal=fill(1, generation.nParallelDem),
      m_flow_nominal=fill(1, generation.nParallelDem),
      dp_nominal=fill(0, generation.nParallelDem)));
  Utilities.Electrical.MultiSumElec multiSumElec
    annotation (Placement(transformation(extent={{-204,-146},{-178,-120}})));
end VentilationSystem;
