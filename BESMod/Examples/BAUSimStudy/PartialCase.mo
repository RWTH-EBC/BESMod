within BESMod.Examples.BAUSimStudy;
partial model PartialCase
  extends Systems.BaseClasses.PartialBuildingEnergySystem(
    redeclare BESMod.Systems.Electrical.DirectGridConnectionSystem electrical,
    redeclare Systems.Demand.Building.TEASERThermalZone building(
      hBui=sum(building.zoneParam.VAir)^(1/3),
      ABui=sum(building.zoneParam.VAir)^(2/3),
      ARoo=sum(building.zoneParam.ARoof),
      energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial),
    redeclare BESMod.Systems.Control.NoControl control,
    redeclare BESMod.Systems.Hydraulical.HydraulicSystem hydraulic(
      energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
      redeclare Systems.Hydraulical.Generation.HeatPumpAndElectricHeater
        generation(
        redeclare model RefrigerantCycleHeatPumpHeating =
            AixLib.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.TableData3D
            (y_nominal=0.8, redeclare
              AixLib.Fluid.HeatPumps.ModularReversible.Data.TableDataSDF.TableData3D.VCLibPy.VCLibVaporInjectionPhaseSeparatorPropane
              datTab),
        redeclare BESMod.Systems.RecordsCollection.Movers.DefaultMover parPum,
        genDesTyp=BESMod.Systems.Hydraulical.Generation.Types.GenerationDesign.BivalentPartParallel,

        TBiv=TBiv,
        redeclare
          BESMod.Systems.Hydraulical.Generation.RecordsCollection.HeatPumps.DefaultHP
          parHeaPum,
        redeclare
          BESMod.Systems.Hydraulical.Generation.RecordsCollection.ElectricHeater.DefaultElectricHeater
          parEleHea,
        redeclare
          BESMod.Systems.RecordsCollection.TemperatureSensors.DefaultSensor
          parTemSen),
      redeclare Systems.Hydraulical.Control.MonoenergeticHeatPumpSystem control(
        redeclare
          BESMod.Systems.Hydraulical.Control.Components.ThermostaticValveController.ThermostaticValvePIControlled
          valCtrl,
        dTHysBui=10,
        dTHysDHW=10,
        redeclare model DHWHysteresis =
            BESMod.Systems.Hydraulical.Control.Components.BivalentOnOffControllers.TimeBasedElectricHeater,

        redeclare model BuildingHysteresis =
            BESMod.Systems.Hydraulical.Control.Components.BivalentOnOffControllers.TimeBasedElectricHeater,

        redeclare
          BESMod.Systems.Hydraulical.Control.RecordsCollection.BasicHeatPumpPI
          parPIDHeaPum),
      redeclare
        BESMod.Systems.Hydraulical.Distribution.TwoStoDetailedDirectLoading
        distribution(
        QHeaAftBuf_flow_nominal=0,
        redeclare
          BESMod.Systems.RecordsCollection.TemperatureSensors.DefaultSensor
          parTemSen,
        redeclare BESMod.Systems.RecordsCollection.Valves.DefaultThreeWayValve
          parThrWayVal,
        redeclare
          BESMod.Systems.Hydraulical.Distribution.RecordsCollection.BufferStorage.DefaultDetailedStorage
          parStoBuf(use_QLos=true, T_m=338.15),
        redeclare
          BESMod.Systems.Hydraulical.Distribution.RecordsCollection.BufferStorage.DefaultDetailedStorage
          parStoDHW(
          dTLoadingHC1=10,
          use_QLos=true,
          T_m=65 + 273.15),
        redeclare
          BESMod.Systems.Hydraulical.Generation.RecordsCollection.ElectricHeater.DefaultElectricHeater
          parEleHeaAftBuf),
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
      redeclare BESMod.Systems.Demand.DHW.TappingProfiles.calcmFlowEquStatic
        calcmFlow),
    redeclare Systems.UserProfiles.TEASERProfiles userProfiles,
    redeclare BESParameters systemParameters(QBui_flow_nominal=building.QRec_flow_nominal),
    redeclare BESMod.Systems.RecordsCollection.ParameterStudy.NoStudy
      parameterStudy,
    redeclare final package MediumDHW = AixLib.Media.Water,
    redeclare final package MediumZone = AixLib.Media.Air,
    redeclare final package MediumHyd = AixLib.Media.Water,
    redeclare BESMod.Systems.Ventilation.NoVentilation ventilation);

  parameter Modelica.Units.SI.Temperature TBiv=271.15
    "Nominal bivalence temperature. = TOda_nominal for monovalent systems.";

  annotation (experiment(
      StopTime=172800,
      Interval=600,
      __Dymola_Algorithm="Dassl"), Documentation(info="<html>
<h4>Information</h4>
<p>This is a partial case model for building energy system simulations. It extends a partial building energy system with specific subsystems for electrical, thermal, hydraulic and control components. The model includes:</p>
<ul>
  <li>Direct grid connection for electrical system</li>
  <li>TEASER thermal zone building model</li>
  <li>No control system</li>
  <li>Hydraulic system with:
    <ul>
      <li>Bivalent parallel heat pump and electric heater</li>
      <li>Two storage system with detailed loading</li>
      <li>Radiator-based heat transfer</li>
    </ul>
  </li>
  <li>DHW system with standard profiles</li>
  <li>TEASER user profiles</li>
  <li>No ventilation system</li>
</ul>

<h4>Related Models</h4>
<ul>
  <li><a href=\"modelica://BESMod.Systems.BaseClasses.PartialBuildingEnergySystem\">BESMod.Systems.BaseClasses.PartialBuildingEnergySystem</a></li>
  <li><a href=\"modelica://BESMod.Systems.Electrical.DirectGridConnectionSystem\">BESMod.Systems.Electrical.DirectGridConnectionSystem</a></li>
  <li><a href=\"modelica://BESMod.Systems.Demand.Building.TEASERThermalZone\">BESMod.Systems.Demand.Building.TEASERThermalZone</a></li>
  <li><a href=\"modelica://BESMod.Systems.Hydraulical.HydraulicSystem\">BESMod.Systems.Hydraulical.HydraulicSystem</a></li>
  <li><a href=\"modelica://BESMod.Systems.Demand.DHW.StandardProfiles\">BESMod.Systems.Demand.DHW.StandardProfiles</a></li>
</ul>
</html>"));
end PartialCase;
