within BESMod.BESRules.PVAndHPDesignAndControlOptimization;
model PythonAPICtrlOpt
  "Model for the python API for Optimization of SupControl"
  extends BaseAPI(redeclare SupControlOverheatingPV control(
      DHWOverheatTemp=parameterStudy.DHWOverheatTemp,
      BufOverheatdT=parameterStudy.BufOverheatdT,
      PEleHys_nominal=parameterStudy.ShareOfPEleNominal*PEle_A2W35),
      hydraulic(redeclare
        BESMod.Systems.Hydraulical.Control.MonoenergeticHeatPumpSystem control(
        redeclare
          BESMod.Systems.Hydraulical.Control.Components.ThermostaticValveController.ThermostaticValvePIControlled
          valCtrl,
        dTHysBui=5,
        dTHysDHW=5,
        supCtrHeaCurTyp=BESMod.Utilities.SupervisoryControl.Types.SupervisoryControlType.Internal,
        supCtrDHWTyp=BESMod.Utilities.SupervisoryControl.Types.SupervisoryControlType.Internal,
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

    annotation (Dialog(tab="Advanced"),
              experiment(
      StartTime=7776000,
      StopTime=8640000,
      Interval=600.001344,
      __Dymola_Algorithm="Dassl"));
end PythonAPICtrlOpt;
