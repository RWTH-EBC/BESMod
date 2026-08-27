within BESMod.Utilities.TimeConstantEstimation.Radiator;
model ConstantSupply "Smart thermotat PI control estimation"
  extends Partial(
    dTStepOda=0,
    QBuiNoRetrofit_flow_nominal=systemParameters.QBui_flow_nominal,
    dTStepSet=2,  hydraulic(control(
        useOpeTemCtrl=false,
        redeclare
          BESMod.Systems.Hydraulical.Control.Components.ThermostaticValveController.ConstantOpening
          valCtrl,
        redeclare
          BESMod.Systems.Hydraulical.Control.Components.BuildingSupplyTemperatureSetpoints.Constant
          supTSet(TConSup=TConSup)), transfer(rad(use_dynamicFraRad=true))),
                                 systemParameters(QBui_flow_nominal={11000},
        THydSup_nominal={343.15}));
  extends Modelica.Icons.Example;
  parameter Modelica.Units.SI.Temperature TConSup=273.15 + 40
    "Constant supply temperature";
  annotation (experiment(
      StopTime=864000,
      Interval=60,
      __Dymola_Algorithm="Dassl"));
end ConstantSupply;
