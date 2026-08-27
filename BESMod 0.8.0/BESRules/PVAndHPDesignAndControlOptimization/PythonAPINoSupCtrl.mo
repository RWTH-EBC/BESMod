within BESMod.BESRules.PVAndHPDesignAndControlOptimization;
model PythonAPINoSupCtrl "Model for the python API No Sup Ctrl"
  extends BaseAPI(redeclare BESMod.Systems.Control.NoControl control, hydraulic(
        redeclare
        BESMod.Systems.Hydraulical.Control.MonoenergeticHeatPumpSystem control(
        redeclare
          BESMod.Systems.Hydraulical.Control.Components.ThermostaticValveController.ThermostaticValvePIControlled
          valCtrl,
        dTHysBui=5,
        dTHysDHW=5,
        redeclare model BuildingSupplySetTemperature =
            BESMod.Systems.Hydraulical.Control.Components.BuildingSupplyTemperatureSetpoints.IdealHeatingCurve
            (THeaThr=parameterStudy.THeaThr),
        redeclare model DHWSetTemperature =
            BESMod.Systems.Hydraulical.Control.Components.DHWSetControl.ConstTSet_DHW,
        redeclare model DHWHysteresis =
            BESMod.Systems.Hydraulical.Control.Components.BivalentOnOffControllers.TimeBasedElectricHeater,
        redeclare model BuildingHysteresis =
            BESMod.Systems.Hydraulical.Control.Components.BivalentOnOffControllers.TimeBasedElectricHeater,
        redeclare model SummerMode =
            BESMod.Systems.Hydraulical.Control.Components.SummerMode.No,
        redeclare
          BESMod.Systems.Hydraulical.Control.RecordsCollection.BasicHeatPumpPI
          parPIDHeaPum)));

  annotation (experiment(
      StopTime=31536000,
      Interval=599.999616,
      __Dymola_Algorithm="Dassl"));
end PythonAPINoSupCtrl;
