within BESMod.Utilities.TimeConstantEstimation.Radiator;
model ConstantSupply "Smart thermotat PI control estimation"
  extends Partial(
    QBuiNoRetrofit_flow_nominal=systemParameters.QBui_flow_nominal*3,
    dTStepSet=0,  hydraulic(control(
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
  parameter Modelica.Units.SI.Time timeInt=1200
    "Time constant of Integrator block";
  parameter Real P=0.3 "Gain of PID-controller";
  parameter Modelica.Units.SI.Temperature TConSup=273.15 + 40
    "Constant supply temperature" annotation (Dialog(tab="Advanced"));
  annotation (experiment(
      StopTime=864000,
      Interval=60,
      __Dymola_Algorithm="Dassl"));
end ConstantSupply;
