within BESMod.BESRules.DesignOptimization;
model MonoenergeticOptiHorst "Model for the python API"
  extends BESMod.BESRules.DesignOptimization.BaseAPI(
      QPriAtTOdaNom_flow_nominal_internal=QPriAtTOdaNom_flow_nominal, hydraulic(
        generation(redeclare model RefrigerantCycleHeatPumpHeating =
            AixLib.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.TableData4DDeltaT (
            redeclare iceFacModel iceFacCal,
            redeclare
              AixLib.Fluid.HeatPumps.ModularReversible.Data.TableDataSDF.VCLibPy4DDeltaT.EN_MEN412_Linear
              datTab,
            dTCon_nominal=if hydraulic.generation.TSupAtBiv >= 273.15 + 55
                 then 10 elseif hydraulic.generation.TSupAtBiv >= 45 + 273.15
                 then 8 else 5), safCtrPar(tabUppHea=[253.15,323.15; 263.15,333.15;
              303.15,333.15; 308.15,328.15]))));
  replaceable model iceFacModel =
      AixLib.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.Frosting.NoFrosting
    constrainedby
    AixLib.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.Frosting.BaseClasses.PartialIcingFactor
    "Replaceable model to calculate the icing factor"
    annotation(choicesAllMatching=true);

  extends Modelica.Icons.Example;
  extends BESMod.BESRules.BaseClasses.PartialHeatPumpDesign4D(
    TBiv=parameterStudy.TBiv,
    tableOpeEnv=hydraulic.generation.heatPump.safCtrPar.tabUppHea,
    interpMethod=hydraulic.generation.heatPump.refCyc.refCycHeaPumHea.interpMethod,
    extrapMethod=hydraulic.generation.heatPump.refCyc.refCycHeaPumHea.extrapMethod,
    extTabPEle=hydraulic.generation.heatPump.refCyc.refCycHeaPumHea.extTabPEle,
    extTabQUse_flow=hydraulic.generation.heatPump.refCyc.refCycHeaPumHea.extTabQUse_flow,
    scalingFactor=hydraulic.generation.heatPump.refCyc.refCycHeaPumHea.scaFac,
    TOda_nominal=systemParameters.TOda_nominal,
    TSupAtOda_nominal=THyd_nominal);

  annotation (experiment(
      StopTime=31536000,
      Interval=600,
      __Dymola_Algorithm="Dassl"));
end MonoenergeticOptiHorst;
