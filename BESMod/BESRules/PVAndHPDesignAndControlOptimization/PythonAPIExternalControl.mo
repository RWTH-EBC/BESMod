within BESMod.BESRules.PVAndHPDesignAndControlOptimization;
model PythonAPIExternalControl
  "Model for the python API for external control (MPC, RBPC)"
  extends BaseAPI(redeclare BESMod.Systems.Control.NoControl control, hydraulic(
        redeclare
        BESMod.Systems.Hydraulical.Control.MonoenergeticHeatPumpSystem control(
        redeclare
          BESMod.Systems.Hydraulical.Control.Components.ThermostaticValveController.ThermostaticValvePIControlled
          valCtrl,
        dTHysBui=5,
        dTHysDHW=5,
        supCtrHeaCurTyp=BESMod.Utilities.SupervisoryControl.Types.SupervisoryControlType.External,
        supCtrDHWTyp=BESMod.Utilities.SupervisoryControl.Types.SupervisoryControlType.External,
        meaValPriGen=BESMod.Systems.Hydraulical.Control.Components.BaseClasses.MeasuredValue.DistributionTemperature,
        redeclare model BuildingSupplySetTemperature =
            BESMod.Systems.Hydraulical.Control.Components.BuildingSupplyTemperatureSetpoints.IdealHeatingCurve
            (THeaThr=parameterStudy.THeaThr),
        redeclare model DHWHysteresis =
            BESMod.Systems.Hydraulical.Control.Components.BivalentOnOffControllers.TimeBasedElectricHeater,
        redeclare model BuildingHysteresis =
            BESMod.Systems.Hydraulical.Control.Components.BivalentOnOffControllers.TimeBasedElectricHeater,
        redeclare model SummerMode =
            BESMod.Systems.Hydraulical.Control.Components.SummerMode.No,
        redeclare
          BESMod.Systems.Hydraulical.Control.RecordsCollection.BasicHeatPumpPI
          parPIDHeaPum,
        buiAndDHWCtr(supCtrHeaCur(actExt(final y=actExtBufCtrl), uExt(final y=
                  TBufSet)), supCtrDHW(uExt(final y=TDHWSet), actExt(final y=
                  actExtDHWCtrl))))));
  extends BESMod.BESRules.BaseClasses.MPC_API;
    annotation (Dialog(tab="Advanced"),
              experiment(
      StartTime=7776000,
      StopTime=8640000,
      Interval=600.001344,
      __Dymola_Algorithm="Dassl"));
end PythonAPIExternalControl;
