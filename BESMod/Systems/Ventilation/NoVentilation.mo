within BESMod.Systems.Ventilation;
model NoVentilation
  extends BaseClasses.PartialVentilationSystem(
    redeclare BESMod.Systems.Ventilation.Generation.NoVentilation generation,
    redeclare BESMod.Systems.Ventilation.Distribution.SimpleDistribution distribution(mDem_flow_nominal={1}),
    redeclare BESMod.Systems.Ventilation.Control.NoControl control);
end NoVentilation;
