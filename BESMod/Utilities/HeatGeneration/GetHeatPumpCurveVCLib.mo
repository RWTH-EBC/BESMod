within BESMod.Utilities.HeatGeneration;
model GetHeatPumpCurveVCLib
  extends PartialGetHeatGenerationCurve(
    redeclare
      BESMod.Systems.Hydraulical.Control.RecordsCollection.DefaultBivHPControl
      bivalentHeatPumpControlDataDefinition,
    redeclare Examples.UseCaseAachen.AachenSystem systemParameters(
        QDHW_flow_nomial=0),            redeclare
      Systems.Hydraulical.Generation.HeatPumpAndHeatingRod generation(
      redeclare
        BESMod.Systems.RecordsCollection.Movers.DefaultMover
        pumpData,
      redeclare package Medium_eva = IBPSA.Media.Air,
      use_pressure=false,
      redeclare
        BESMod.Systems.Hydraulical.Generation.RecordsCollection.DefaultHP
        heatPumpParameters,
      redeclare
        BESMod.Systems.Hydraulical.Generation.RecordsCollection.DefaultHR
        heatingRodParameters,
      redeclare model PerDataMainHP =
          AixLib.DataBase.HeatPump.PerformanceData.VCLibMap (refrigerant=
              "Propane", flowsheet="VIPhaseSeparatorFlowsheet")),  ramp(
      height=35,
      duration=84400,
      offset=273.15 - 15,
      startTime=1000),
    realExpression(y=generation.heatPump.con.QFlow_in));
  annotation (experiment(StopTime=86400, __Dymola_Algorithm="Dassl"));
end GetHeatPumpCurveVCLib;
