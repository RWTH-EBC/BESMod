within BESMod.Examples.SolarThermalSystem;
model SolarThermalHPSBuildingsLib
  "HPS which is supported by a solar thermal collector"
  extends BESMod.Systems.BaseClasses.PartialBuildingEnergySystem(
    redeclare BESMod.Systems.Electrical.DirectGridConnectionSystem electrical,
    redeclare Systems.Demand.Building.TEASERThermalZone building(redeclare
        BESMod.Systems.Demand.Building.RecordsCollection.RefAachen
        oneZoneParam),
    redeclare BESMod.Systems.Control.NoControl control,
    redeclare BESMod.Systems.Hydraulical.HydraulicSystem
      hydraulic(
      redeclare
        BESMod.Systems.Hydraulical.Generation.SolarThermalBivHPBuiLib
        generation(
        redeclare model PerDataMainHP =
            AixLib.DataBase.HeatPump.PerformanceData.VCLibMap (refrigerant=
                "Propane", flowsheet="VIPhaseSeparatorFlowsheet"),
        redeclare
          BESMod.Systems.Hydraulical.Generation.RecordsCollection.DefaultHP
          heatPumpParameters(genDesTyp=BESMod.Systems.Hydraulical.Generation.Types.GenerationDesign.BivalentParallel),
        redeclare
          BESMod.Systems.Hydraulical.Generation.RecordsCollection.DefaultHR
          heatingRodParameters,
        redeclare
          BESMod.Systems.RecordsCollection.Movers.DefaultMover
          pumpData,
        redeclare package Medium_eva = AixLib.Media.Air,
        redeclare
          BESMod.Examples.SolarThermalSystem.SolarCollector
          solarThermalParas(
          final A=parameterStudy.A,
          final eta_zero=parameterStudy.eta_zero,
          final c1=parameterStudy.c1,
          final c2=parameterStudy.c2),
        redeclare
          BESMod.Systems.RecordsCollection.Movers.DefaultMover
          pumpSTData),
      redeclare
        BESMod.Systems.Hydraulical.Control.Biv_PI_ConFlow_HPSController
        control(
        redeclare
          BESMod.Systems.Hydraulical.Control.Components.ThermostaticValveController.ThermostaticValvePIControlled
          thermostaticValveController,
        redeclare
          BESMod.Systems.Hydraulical.Control.RecordsCollection.ThermostaticValveDataDefinition
          thermostaticValveParameters,
        redeclare
          BESMod.Systems.Hydraulical.Control.RecordsCollection.DefaultSafetyControl
          safetyControl,
        redeclare
          BESMod.Systems.Hydraulical.Control.RecordsCollection.DefaultBivHPControl
          bivalentControlData),
      redeclare
        BESMod.Systems.Hydraulical.Distribution.CombiStorage
        distribution(redeclare
          BESMod.Examples.SolarThermalSystem.CombiStorage
          parameters(
          V=parameterStudy.V,
          use_HC1=true,
          dTLoadingHC1=5,
          use_HC2=true,
          dTLoadingHC2=5)),
      redeclare
        BESMod.Systems.Hydraulical.Transfer.RadiatorPressureBased
        transfer(
        redeclare
          BESMod.Systems.Hydraulical.Transfer.RecordsCollection.RadiatorTransferData
          radParameters,
        redeclare
          BESMod.Systems.Hydraulical.Transfer.RecordsCollection.SteelRadiatorStandardPressureLossData
          transferDataBaseDefinition,
        redeclare
          BESMod.Systems.RecordsCollection.Movers.DefaultMover
          pumpData)),
    redeclare Systems.Demand.DHW.DHW DHW(
      final use_pressure=false,
      redeclare
        BESMod.Systems.RecordsCollection.Movers.DefaultMover
        pumpData,
      redeclare Systems.Demand.DHW.TappingProfiles.calcmFlowEquStatic calcmFlow),
    redeclare SolarThermalSystemParameters systemParameters,
    redeclare SolarThermalDesignOptimization parameterStudy(
      A=11,
      V=1.3,
      eta_zero=0.72,
      c1=2.8312,
      c2=0.00119),
    redeclare Systems.UserProfiles.TEASERProfiles userProfiles(redeclare
        BESMod.Systems.Demand.DHW.RecordsCollection.ProfileM DHWProfile),
    redeclare BESMod.Systems.Ventilation.NoVentilation
      ventilation);

  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(graphics,
        coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=31536000,
      Interval=600,
      __Dymola_Algorithm="Dassl"));
end SolarThermalHPSBuildingsLib;
