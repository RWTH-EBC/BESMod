within BESMod.Utilities.TimeConstantEstimation.Radiator;
model HeatingCurve
  extends Partial(hydraulic(control(redeclare
          BESMod.Systems.Hydraulical.Control.Components.BuildingSupplyTemperatureSetpoints.IdealHeatingCurve
          supTSet(dTAddCon=dTAddCon))));
  parameter Modelica.Units.SI.TemperatureDifference dTAddCon=5
    "Constant supply temperature" annotation (Evaluate=false);
end HeatingCurve;
