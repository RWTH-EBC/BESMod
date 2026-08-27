within BESMod.BESRules.DesignOptimization;
model MonoenergeticVitoCal "Model for the python API"

  extends BaseAPI                            (
    QPriAtTOdaNom_flow_nominal_internal=QPriAtTOdaNom_flow_nominal,
    TOpeEnvAtBiv_nominal=TOpeEnvAtBiv_table,
    hydraulic(generation(redeclare model RefrigerantCycleHeatPumpHeating =
            AixLib.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.TableData2D
            (redeclare
              AixLib.Fluid.HeatPumps.ModularReversible.Data.TableData2D.EN14511.Vitocal251A08
              datTab), redeclare
          AixLib.Fluid.HeatPumps.ModularReversible.Controls.Safety.Data.Wuellhorst2021
          safCtrPar(tabUppHea=hydraulic.generation.heatPump.refCyc.refCycHeaPumHea.datTab.tabUppBou))));
  extends Modelica.Icons.Example;

  extends BESMod.BESRules.BaseClasses.PartialHeatPumpDesign2D(
    TBiv=parameterStudy.TBiv,
    tableOpeEnv=hydraulic.generation.heatPump.safCtrPar.tabUppHea,
    tabIdePEle=hydraulic.generation.heatPump.refCyc.refCycHeaPumHea.tabIdePEle,
    tabIdeQUse_flow=hydraulic.generation.heatPump.refCyc.refCycHeaPumHea.tabIdeQUse_flow,
    scalingFactor=hydraulic.generation.heatPump.refCyc.refCycHeaPumHea.scaFac,
    TOda_nominal=systemParameters.TOda_nominal,
    TSupAtOda_nominal=THyd_nominal);

  annotation (experiment(
      StopTime=31536000,
      Interval=600,
      __Dymola_Algorithm="Dassl"));
end MonoenergeticVitoCal;
