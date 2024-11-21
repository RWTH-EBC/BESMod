within BESMod.Examples.Retrofit;
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
        use_old_design={NoRetrofitHydGen},
        redeclare BESMod.Systems.RecordsCollection.Movers.DefaultMover parPum,
        TBiv=271.15,
        redeclare
          BESMod.Systems.Hydraulical.Generation.RecordsCollection.HeatPumps.DefaultHP
          parHeaPum,
        redeclare model RefrigerantCycleHeatPumpHeating =
            AixLib.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.TableData3D
            (y_nominal=0.8, redeclare
              AixLib.Fluid.HeatPumps.ModularReversible.Data.TableDataSDF.TableData3D.VCLibPy.VCLibVaporInjectionPhaseSeparatorPropane
              datTab),
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
        use_old_design={NoRetrofitHydDis},
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
        use_oldRad_design={NoRetrofitHydTra},
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

  parameter Boolean NoRetrofitHydTra = false
    "If true, hydraulic transfersystem uses QBuiNoRetrofit.";
  parameter Boolean NoRetrofitHydDis = false
    "If true, hydraulic distribution system uses QBuiNoRetrofit.";
  parameter Boolean NoRetrofitHydGen = false
    "If true, hydraulic generation system uses QBuiNoRetrofit.";
  annotation (Documentation(info="<html>
<h4>Information</h4>
This partial model serves as a base class for retrofit case studies in building energy systems. It configures:

<ul>
<li>A direct grid electrical system (<a href=\"modelica://BESMod.Systems.Electrical.DirectGridConnectionSystem\">BESMod.Systems.Electrical.DirectGridConnectionSystem</a>)</li>
<li>A TEASER thermal zone building model (<a href=\"modelica://BESMod.Systems.Demand.Building.TEASERThermalZone\">BESMod.Systems.Demand.Building.TEASERThermalZone</a>)</li>
<li>A hydraulic system with heat pump and electric heater (<a href=\"modelica://BESMod.Systems.Hydraulical.HydraulicSystem\">BESMod.Systems.Hydraulical.HydraulicSystem</a>)</li>
<li>Standard DHW profiles (<a href=\"modelica://BESMod.Systems.Demand.DHW.StandardProfiles\">BESMod.Systems.Demand.DHW.StandardProfiles</a>)</li>
</ul>

<h4>Important Parameters</h4>
<ul>
<li>NoRetrofitHydTra: Boolean flag to use non-retrofitted heating load for transfer system sizing</li>
<li>NoRetrofitHydDis: Boolean flag to use non-retrofitted heating load for distribution system sizing</li>
<li>NoRetrofitHydGen: Boolean flag to use non-retrofitted heating load for generation system sizing</li>
<li>Heat pump bivalence temperature: 271.15 K (-2 degC)</li>
</ul>
</html>"));
end PartialCase;
