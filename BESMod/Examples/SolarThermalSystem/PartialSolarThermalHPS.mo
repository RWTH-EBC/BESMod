within BESMod.Examples.SolarThermalSystem;
partial model PartialSolarThermalHPS
  "HPS which is supported by a solar thermal collector"
  extends BESMod.Systems.BaseClasses.PartialBuildingEnergySystem(
    redeclare BESMod.Systems.Electrical.DirectGridConnectionSystem electrical,
    redeclare Systems.Demand.Building.TEASERThermalZone building(
      hBui=sum(building.zoneParam.VAir)^(1/3),
      ABui=sum(building.zoneParam.VAir)^(2/3),
      redeclare BESMod.Systems.Demand.Building.RecordsCollection.RefAachen
        oneZoneParam,
      energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial),
    redeclare BESMod.Systems.Control.NoControl control,
    redeclare BESMod.Systems.Hydraulical.HydraulicSystem hydraulic(
      energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
      redeclare hydGeneration generation,
      redeclare BESMod.Systems.Hydraulical.Control.MonoenergeticHeatPumpSystem
        control(
        redeclare
          BESMod.Systems.Hydraulical.Control.Components.ThermostaticValveController.ThermostaticValvePIControlled
          valCtrl,
        redeclare model DHWHysteresis =
            BESMod.Systems.Hydraulical.Control.Components.BivalentOnOffControllers.TimeBasedElectricHeater,
        redeclare model BuildingHysteresis =
            BESMod.Systems.Hydraulical.Control.Components.BivalentOnOffControllers.TimeBasedElectricHeater,
        redeclare
          BESMod.Systems.Hydraulical.Control.RecordsCollection.BasicHeatPumpPI
          parPIDHeaPum,
        redeclare
          BESMod.Systems.Hydraulical.Control.RecordsCollection.DefaultSafetyControl
          safetyControl),
      redeclare BESMod.Systems.Hydraulical.Distribution.CombiStorage distribution(
          redeclare BESMod.Examples.SolarThermalSystem.CombiStorage parameters(
          V=parameterStudy.V,
          use_HC1=true,
          dTLoadingHC1=5,
          use_HC2=true,
          dTLoadingHC2=5)),
      redeclare BESMod.Systems.Hydraulical.Transfer.RadiatorPressureBased
        transfer(
        redeclare
          BESMod.Systems.Hydraulical.Transfer.RecordsCollection.RadiatorTransferData
          parRad,
        redeclare
          BESMod.Systems.Hydraulical.Transfer.RecordsCollection.SteelRadiatorStandardPressureLossData
          parTra,
        redeclare BESMod.Systems.RecordsCollection.Movers.DefaultMover parPum)),
    redeclare Systems.Demand.DHW.StandardProfiles DHW(
      energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
      redeclare BESMod.Systems.Demand.DHW.RecordsCollection.ProfileM DHWProfile,
      redeclare BESMod.Systems.RecordsCollection.Movers.DefaultMover parPum,
      redeclare Systems.Demand.DHW.TappingProfiles.calcmFlowEquStatic calcmFlow),
    redeclare SolarThermalSystemParameters systemParameters,
    redeclare SolarThermalDesignOptimization parameterStudy(
      A=11,
      V=1.3,
      eta_zero=0.72,
      c1=2.8312,
      c2=0.00119),
    redeclare Systems.UserProfiles.TEASERProfiles userProfiles,
    redeclare BESMod.Systems.Ventilation.NoVentilation ventilation);

  replaceable model hydGeneration =
      BESMod.Systems.Hydraulical.Generation.BaseClasses.PartialGeneration(nParallelDem=2)
     constrainedby
    BESMod.Systems.Hydraulical.Generation.BaseClasses.PartialGeneration
     annotation (choicesAllMatching=true);

end PartialSolarThermalHPS;
