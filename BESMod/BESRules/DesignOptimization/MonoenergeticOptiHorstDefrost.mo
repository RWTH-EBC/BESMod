within BESMod.BESRules.DesignOptimization;
model MonoenergeticOptiHorstDefrost "Dynamic defrost model"
  import BESRules;
  extends MonoenergeticOptiHorst(hydraulic(generation(
        safCtrPar(tabLowCoo=[233.15,283.15; 333.15,283.15]),
        redeclare replaceable AixLib.Fluid.HeatPumps.ModularReversible.Controls.Defrost.ZhuTimeBasedDefrost defCtrl,
        redeclare model RefrigerantCycleHeatPumpCooling =
             AixLib.Fluid.HeatPumps.ModularReversible.Controls.Defrost.ReverseCycleDefrostHeatPump)),
            redeclare model iceFacModel =
        AixLib.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.Frosting.LiangAndZhuCalibrated (
        A=47 * scalingFactor,
        mIce_max=3.8 * scalingFactor));
end MonoenergeticOptiHorstDefrost;
