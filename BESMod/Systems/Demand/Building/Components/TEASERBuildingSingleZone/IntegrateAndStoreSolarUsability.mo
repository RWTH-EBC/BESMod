within BESMod.Systems.Demand.Building.Components.TEASERBuildingSingleZone;
model IntegrateAndStoreSolarUsability
  extends PartialSolarUsability;
  Modelica.Blocks.Nonlinear.VariableDelay variableDelay
    annotation (Placement(transformation(extent={{-4,38},{16,58}})));
  Modelica.Blocks.Continuous.Integrator integrator(use_reset=true)
    annotation (Placement(transformation(extent={{-22,-22},{-2,-2}})));
  Modelica.Blocks.Continuous.LimIntegrator limIntegrator(use_reset=true,
      use_set=true)
    annotation (Placement(transformation(extent={{-4,-66},{16,-46}})));
  Modelica.Blocks.Continuous.Der der1
    annotation (Placement(transformation(extent={{54,6},{74,26}})));
end IntegrateAndStoreSolarUsability;
