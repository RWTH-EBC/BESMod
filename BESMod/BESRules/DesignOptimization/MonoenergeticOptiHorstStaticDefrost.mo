within BESMod.BESRules.DesignOptimization;
model MonoenergeticOptiHorstStaticDefrost "Static defrost model"
  extends BESMod.BESRules.DesignOptimization.MonoenergeticOptiHorst(redeclare model iceFacModel =
     AixLib.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.Frosting.Li);
end MonoenergeticOptiHorstStaticDefrost;
