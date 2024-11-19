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
  annotation (Documentation(info="<html>
<h4>Information</h4>
<p>This package contains a partial example case for a hybrid building energy system. The main model <code>PartialHybridSystem</code> defines a bivalent heat pump system that combines a heat pump with a backup boiler. The model extends <a href=\"modelica://BESMod.Systems.BaseClasses.PartialBuildingEnergySystem\">BESMod.Systems.BaseClasses.PartialBuildingEnergySystem</a> and includes:</p>

<ul>
  <li>Direct grid connection for electrical system</li>
  <li>TEASER thermal zone building model with Aachen reference parameters</li>
  <li>Hybrid heat pump hydraulic system with PI-controlled thermostatic valves</li>
  <li>Standard DHW profile system</li>
  <li>TEASER user profiles</li>
  <li>No ventilation system</li>
</ul>

<h4>Important Parameters</h4>
<ul>
  <li><code>TBiv</code> - Bivalent temperature point for heat pump operation</li>
  <li><code>TCutOff</code> - Heat pump cut-off temperature</li>
  <li><code>dTHysBui</code> - Building temperature hysteresis (5K)</li>
  <li><code>dTHysDHW</code> - DHW temperature hysteresis (5K)</li>
</ul>

<h4>Related Models</h4>
<ul>
  <li><a href=\"modelica://BESMod.Systems.Hydraulical.HydraulicSystem\">BESMod.Systems.Hydraulical.HydraulicSystem</a></li>
  <li><a href=\"modelica://BESMod.Systems.Demand.Building.TEASERThermalZone\">BESMod.Systems.Demand.Building.TEASERThermalZone</a></li>
  <li><a href=\"modelica://BESMod.Systems.Hydraulical.Control.HybridHeatPumpSystem\">BESMod.Systems.Hydraulical.Control.HybridHeatPumpSystem</a></li>
</ul>
</html>"));
end BaseClasses;
