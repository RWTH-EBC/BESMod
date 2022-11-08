within BESMod.Utilities.HeatGeneration;
model GetHeatPumpCurveVCLib
  extends PartialGetHeatGenerationCurve(
    redeclare
      BESMod.Systems.Hydraulical.Control.RecordsCollection.DefaultBivHPControl
      bivalentHeatPumpControlDataDefinition,
    redeclare Examples.UseCaseAachen.AachenSystem systemParameters,
                                        redeclare
      Systems.Hydraulical.Generation.HeatPumpAndHeatingRod generation(
      redeclare
        BESMod.Systems.RecordsCollection.Movers.DefaultMover
        pumpData,
      redeclare package Medium_eva = IBPSA.Media.Air,
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
equation
  connect(const.y, sigBusGen.uPump) annotation (Line(points={{-79,60},{-70,60},
          {-70,64},{-62,64}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  annotation (experiment(StopTime=86400, __Dymola_Algorithm="Dassl"));
end GetHeatPumpCurveVCLib;
