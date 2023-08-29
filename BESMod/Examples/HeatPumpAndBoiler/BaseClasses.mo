within BESMod.Examples.HeatPumpAndBoiler;
package BaseClasses "Contains partial example case"
  extends Modelica.Icons.BasesPackage;
  partial model PartialHybridSystem "Partial bivalent heat pump system"
    extends Systems.BaseClasses.PartialBuildingEnergySystem(
      redeclare BESMod.Systems.Electrical.DirectGridConnectionSystem electrical,
      redeclare Systems.Demand.Building.TEASERThermalZone building(redeclare
          BESMod.Systems.Demand.Building.RecordsCollection.RefAachen oneZoneParam(
            heaLoadFacGrd=0, heaLoadFacOut=0)),
      redeclare BESMod.Systems.Control.NoControl control,
      redeclare BESMod.Systems.Hydraulical.HydraulicSystem hydraulic(redeclare
          Systems.Hydraulical.Control.HybridHeatPumpSystem control(
          redeclare
            BESMod.Systems.Hydraulical.Control.Components.ThermostaticValveController.ThermostaticValvePIControlled
            valCtrl,
          redeclare
            BESMod.Systems.Hydraulical.Control.RecordsCollection.ThermostaticValveDataDefinition
            parTheVal,
          dTHysBui=5,
          dTHysDHW=5,
          meaValPriGen=BESMod.Systems.Hydraulical.Control.Components.MeasuredValue.GenerationSupplyTemperature,

          redeclare model DHWHysteresis =
              BESMod.Systems.Hydraulical.Control.Components.BivalentOnOffControllers.ConstantHysteresisTimeBasedHeatingRod,

          redeclare model BuildingHysteresis =
              BESMod.Systems.Hydraulical.Control.Components.BivalentOnOffControllers.ConstantHysteresisTimeBasedHeatingRod,

          redeclare model DHWSetTemperature =
              BESMod.Systems.Hydraulical.Control.Components.DHWSetControl.ConstTSet_DHW,

          redeclare
            BESMod.Systems.Hydraulical.Control.RecordsCollection.BasicHeatPumpPI
            parPIDHeaPum,
          TBiv=parameterStudy.TBiv,
          boiInGeneration=true,
          redeclare
            BESMod.Systems.Hydraulical.Control.RecordsCollection.DefaultSafetyControl
            safetyControl,
          TCutOff=parameterStudy.TCutOff,
          redeclare
            BESMod.Systems.Hydraulical.Control.RecordsCollection.BasicBoilerPI
            parPIDBoi), redeclare final
          Systems.Hydraulical.Transfer.IdealValveRadiator transfer(redeclare
            BESMod.Systems.Hydraulical.Transfer.RecordsCollection.RadiatorTransferData
            radParameters, redeclare
            BESMod.Systems.RecordsCollection.Movers.DefaultMover parPum)),
      redeclare Systems.Demand.DHW.StandardProfiles DHW(
        redeclare BESMod.Systems.Demand.DHW.RecordsCollection.ProfileM DHWProfile,

        redeclare BESMod.Systems.RecordsCollection.Movers.DefaultMover parPum,
        redeclare BESMod.Systems.Demand.DHW.TappingProfiles.calcmFlowEquStatic
          calcmFlow),
      redeclare Systems.UserProfiles.TEASERProfiles userProfiles,
      redeclare UseCaseDesignOptimization.AachenSystem systemParameters(
          use_ventilation=true),
      redeclare UseCaseDesignOptimization.ParametersToChange parameterStudy,
      redeclare final package MediumDHW = AixLib.Media.Water,
      redeclare final package MediumZone = AixLib.Media.Air,
      redeclare final package MediumHyd = AixLib.Media.Water,
      redeclare BESMod.Systems.Ventilation.NoVentilation ventilation);

    annotation (experiment(
        StopTime=31536000,
        Interval=600,
        __Dymola_Algorithm="Dassl"));
  end PartialHybridSystem;
end BaseClasses;
