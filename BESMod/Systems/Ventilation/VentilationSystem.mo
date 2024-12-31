within BESMod.Systems.Ventilation;
model VentilationSystem "Build your custom ventilation system"
  extends BaseClasses.PartialVentilationSystem(generation(dp_design=fill(0,
          generation.nParallelDem)));

end VentilationSystem;
