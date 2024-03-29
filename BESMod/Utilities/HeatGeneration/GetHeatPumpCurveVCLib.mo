within BESMod.Utilities.HeatGeneration;
model GetHeatPumpCurveVCLib
  extends PartialGetHeatGenerationCurve(
    redeclare
      BESMod.Systems.Hydraulical.Control.RecordsCollection.DefaultBivHPControl
      bivalentHeatPumpControlDataDefinition,
    redeclare Examples.UseCaseDesignOptimization.AachenSystem systemParameters,
    redeclare Systems.Hydraulical.Generation.HeatPumpAndHeatingRod generation(
      redeclare BESMod.Systems.RecordsCollection.Movers.DefaultMover pumpData,
      redeclare package Medium_eva = IBPSA.Media.Air,
      redeclare
        BESMod.Systems.Hydraulical.Generation.RecordsCollection.DefaultHP
        heatPumpParameters,
      redeclare
        BESMod.Systems.Hydraulical.Generation.RecordsCollection.DefaultHR
        heatingRodParameters,
      redeclare model PerDataMainHP =
          AixLib.DataBase.HeatPump.PerformanceData.VCLibMap (refrigerant=
              "Propane", flowsheet="VIPhaseSeparatorFlowsheet"),
      redeclare
        BESMod.Systems.RecordsCollection.TemperatureSensors.DefaultSensor
        temperatureSensorData),
    ramp(
      height=35,
      duration=84400,
      offset=273.15 - 15,
      startTime=1000),
    realExpression(y=generation.heatPump.con.QFlow_in));

  annotation (experiment(StopTime=86400, __Dymola_Algorithm="Dassl"));
end GetHeatPumpCurveVCLib;
