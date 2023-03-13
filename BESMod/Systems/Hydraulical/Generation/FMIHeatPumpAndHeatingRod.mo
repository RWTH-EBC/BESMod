within BESMod.Systems.Hydraulical.Generation;
model FMIHeatPumpAndHeatingRod
  "FMU of the HeatPumpAndHeatingRod model"
  extends FMIReplaceableGeneration(
    allowFlowReversal=false,
    redeclare replaceable package Medium = IBPSA.Media.Water,
    use_p_in=false,
    redeclare final BESMod.Systems.Hydraulical.Generation.HeatPumpAndHeatingRod
      generation(
      allowFlowReversal=true,
      dTTra_nominal={10},
      Q_flow_nominal={13570.5},
      TOda_nominal(displayUnit="K") = 265.35,
      TDem_nominal(displayUnit="K") = {328.15},
      TAmb(displayUnit="K") = 293.15,
      dpDem_nominal(displayUnit="Pa") = {4000},
      redeclare BESMod.Systems.RecordsCollection.Movers.DefaultMover pumpData,
      redeclare package Medium_eva = AixLib.Media.Air,
      redeclare
        BESMod.Systems.Hydraulical.Generation.RecordsCollection.DefaultHP
        heatPumpParameters(
        genDesTyp=BESMod.Systems.Hydraulical.Generation.Types.GenerationDesign.BivalentPartParallel,
        TBiv=271.15,
        scalingFactor=scalingFactorHP,
        dpCon_nominal=0,
        dpEva_nominal=0,
        use_refIne=false,
        refIneFre_constant=0),
      redeclare
        BESMod.Systems.Hydraulical.Generation.RecordsCollection.DefaultHR
        heatingRodParameters,
      redeclare model PerDataMainHP =
          AixLib.DataBase.HeatPump.PerformanceData.LookUpTable2D (dataTable=
              AixLib.DataBase.HeatPump.EN255.Vitocal350AWI114()),
      redeclare
        BESMod.Systems.RecordsCollection.TemperatureSensors.DefaultSensor
        temperatureSensorData));
  parameter Real scalingFactorHP=generation.heatPumpParameters.QPri_flow_nominal
      /13000 "May be overwritten to avoid warnings and thus a fail in the CI";
  extends Modelica.Icons.Example;
end FMIHeatPumpAndHeatingRod;
