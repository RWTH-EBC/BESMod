within BESMod.Utilities.TimeConstantEstimation.Radiator;
model SmartThermostat "Smart thermotat PI control estimation"
  extends Partial(
    QBuiNoRetrofit_flow_nominal=systemParameters.QBui_flow_nominal*3,
    dTStepSet=2,  hydraulic(
      T_start=333.15,
      control(
        useOpeTemCtrl=true,
        redeclare
          BESMod.Systems.Hydraulical.Control.Components.ThermostaticValveController.ConstantOpening
          valCtrl,
        redeclare
          BESMod.Systems.Hydraulical.Control.Components.BuildingSupplyTemperatureSetpoints.SingleZonePID
          supTSet(redeclare
            BESMod.Systems.Hydraulical.Control.RecordsCollection.SmartThermostatPI
            parPID(
            yMax=273.15 + 75,
            P=P,
            timeInt=timeInt))), transfer(rad(use_dynamicFraRad=false), parRad(
            nEle=4))),           systemParameters(QBui_flow_nominal={11000},
        THydSup_nominal={343.15}));
  parameter Modelica.Units.SI.Time timeInt=400
    "Time constant of Integrator block";
  parameter Real P=0.03
                       "Gain of PID-controller";
  annotation (experiment(
      StopTime=864000,
      Interval=60,
      __Dymola_Algorithm="Dassl"));
end SmartThermostat;
