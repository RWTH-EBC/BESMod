within BESMod.Utilities.TimeConstantEstimation.Radiator;
model HeatingCurve
  extends Partial(
    dTStepSet=0,
    TOda_start=273.15,
    dTStepOda=5,
    QBuiNoRetrofit_flow_nominal=systemParameters.QBui_flow_nominal,
                  hydraulic(T_start=293.15,
                            control(
        useOpeTemCtrl=true,
        redeclare
          BESMod.Systems.Hydraulical.Control.Components.ThermostaticValveController.ThermostaticValvePIControlled
          valCtrl(Ti={200}),
        redeclare
          BESMod.Systems.Hydraulical.Control.Components.BuildingSupplyTemperatureSetpoints.IdealHeatingCurve
          supTSet(dTAddCon=dTAddCon))),
    systemParameters(QBui_flow_nominal={11000}, THydSup_nominal={312.15}));
  parameter Modelica.Units.SI.TemperatureDifference dTAddCon=5
    "Constant supply temperature" annotation (Evaluate=false);
end HeatingCurve;
