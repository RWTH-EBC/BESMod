within BESMod.Examples.HeatPumpAndBoiler;
package BaseClasses "Contains partial example case"
  extends Modelica.Icons.BasesPackage;
  partial model PartialHybridSystem "Partial bivalent heat pump system"
    extends Systems.BaseClasses.PartialBuildingEnergySystem(
      redeclare BESMod.Systems.Electrical.DirectGridConnectionSystem electrical,
      redeclare Systems.Demand.Building.TEASERThermalZone building(
        ABui=sum(building.zoneParam.VAir)^(2/3),
        hBui=sum(building.zoneParam.VAir)^(1/3),
        ARoo=sum(building.zoneParam.ARoof),
        redeclare BESMod.Systems.Demand.Building.RecordsCollection.RefAachen
          oneZoneParam,
        energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial),
      redeclare BESMod.Systems.Control.NoControl control,
      redeclare BESMod.Systems.Hydraulical.HydraulicSystem hydraulic(
        energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,   redeclare
          Systems.Hydraulical.Control.HybridHeatPumpSystem control(
          redeclare
            BESMod.Systems.Hydraulical.Control.Components.ThermostaticValveController.ThermostaticValvePIControlled
            valCtrl,
          dTHysBui=5,
          dTHysDHW=5,
          meaValPriGen=BESMod.Systems.Hydraulical.Control.Components.BaseClasses.MeasuredValue.GenerationSupplyTemperature,
          redeclare model DHWHysteresis =
              BESMod.Systems.Hydraulical.Control.Components.BivalentOnOffControllers.TimeBasedElectricHeater,
          redeclare model BuildingHysteresis =
              BESMod.Systems.Hydraulical.Control.Components.BivalentOnOffControllers.TimeBasedElectricHeater,
          redeclare model DHWSetTemperature =
              BESMod.Systems.Hydraulical.Control.Components.DHWSetControl.ConstTSet_DHW,
          redeclare
            BESMod.Systems.Hydraulical.Control.RecordsCollection.BasicHeatPumpPI
            parPIDHeaPum,
          TBiv=parameterStudy.TBiv,
          boiInGeneration=true,
          TCutOff=parameterStudy.TCutOff,
          redeclare
            BESMod.Systems.Hydraulical.Control.RecordsCollection.BasicBoilerPI
            parPIDBoi), redeclare final
          Systems.Hydraulical.Transfer.IdealValveRadiator transfer(
          redeclare
            BESMod.Systems.Hydraulical.Transfer.RecordsCollection.RadiatorTransferData
            parRad,
          redeclare BESMod.Systems.RecordsCollection.Movers.DefaultMover parPum,
          redeclare
            BESMod.Systems.Hydraulical.Transfer.RecordsCollection.SteelRadiatorStandardPressureLossData
            parTra)),
      redeclare Systems.Demand.DHW.StandardProfiles DHW(
        energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
        redeclare BESMod.Systems.Demand.DHW.RecordsCollection.ProfileM DHWProfile,
        redeclare BESMod.Systems.RecordsCollection.Movers.DefaultMover parPum,
        redeclare BESMod.Systems.Demand.DHW.TappingProfiles.calcmFlowEquStatic
          calcmFlow),
      redeclare Systems.UserProfiles.TEASERProfiles userProfiles,
      redeclare DesignOptimization.AachenSystem systemParameters(use_ventilation=
            true),
      redeclare DesignOptimization.ParametersToChange parameterStudy,
      redeclare final package MediumDHW = AixLib.Media.Water,
      redeclare final package MediumZone = AixLib.Media.Air,
      redeclare final package MediumHyd = AixLib.Media.Water,
      redeclare BESMod.Systems.Ventilation.NoVentilation ventilation);

  end PartialHybridSystem;
end BaseClasses;
