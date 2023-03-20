within BESMod.Systems.Ventilation.Distribution;
model FMISimpleDistribution
  extends FMIReplaceableDistribution(
    redeclare package Medium=IBPSA.Media.Air,
    redeclare BESMod.Systems.Ventilation.Distribution.SimpleDistribution distribution(
      nParallelDem=1,
      TSup_nominal={566.3},
      m_flow_nominal={0.08225917194444445},
      Q_flow_nominal={10632.414942943078},
      TOda_nominal(displayUnit="K") = 265.35,
      TDem_nominal(displayUnit="K") = {293.15},
      TAmb(displayUnit="K") = 293.15));
end FMISimpleDistribution;
