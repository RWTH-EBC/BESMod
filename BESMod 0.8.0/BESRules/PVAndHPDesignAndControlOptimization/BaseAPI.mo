within BESMod.BESRules.PVAndHPDesignAndControlOptimization;
partial model BaseAPI
  "Model for the python API for Optimization of SupControl"
  extends BESMod.BESRules.BaseClasses.PartialBESRulesSystem
                                                    (
    redeclare BESMod.Systems.Electrical.ElectricalSystem electrical(
      redeclare BESMod.Systems.Electrical.Generation.PVSystemMultiSub
        generation(
        final f_design=fill(parameterStudy.f_design, electrical.generation.numGenUnits),
        useTwoRoo=useTwoRoo,
        tilAllMod=0.5235987755983,
        aziMaiRoo=aziMaiRoo,
        redeclare model CellTemperature =
            AixLib.Electrical.PVSystem.BaseClasses.CellTemperatureMountingContactToGround,
        redeclare AixLib.DataBase.SolarElectric.QPlusBFRG41285 pVParameters,
        lat=weaDat.lat,
        lon=weaDat.lon,
        alt=weaDat.alt,
        timZon=weaDat.timZon,
        ARoo=building.ARoo),
      redeclare BESMod.Systems.Electrical.Distribution.OwnConsumption
        distribution,
      redeclare BESMod.Systems.Electrical.Transfer.NoElectricalTransfer
        transfer,
      redeclare ElectricalControlPV control),
    redeclare BESMod.Systems.Hydraulical.HydraulicSystem hydraulic(
      redeclare BESMod.Systems.Hydraulical.Generation.HeatPumpAndElectricHeater
        generation(
        redeclare model RefrigerantCycleHeatPumpHeating =
            AixLib.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.TableData2D
            (redeclare
               AixLib.Fluid.HeatPumps.ModularReversible.Data.TableData2D.EN14511.Vitocal251A08
              datTab),
        TBiv=parameterStudy.TBiv,
        THeaTresh=parameterStudy.THeaThr,
        TSupAtBiv=THydAtBiv_nominal,
        genDesTyp=BESMod.Systems.Hydraulical.Generation.Types.GenerationDesign.BivalentParallel,
        QPriAtTOdaNom_flow_nominal=QPriAtTOdaNom_flow_nominal,
        redeclare
          BESMod.Systems.Hydraulical.Generation.RecordsCollection.HeatPumps.DefaultHP
          parHeaPum,
        redeclare
          BESMod.Systems.Hydraulical.Generation.RecordsCollection.ElectricHeater.DefaultElectricHeater
          parEleHea,
        redeclare
          BESMod.Systems.RecordsCollection.TemperatureSensors.DefaultSensor
          parTemSen),
      redeclare
        BESMod.Systems.Hydraulical.Distribution.SimpleTwoStorageParallel
        distribution(
        designType=BESMod.Systems.Hydraulical.Distribution.Types.DHWDesignType.PartStorage,
        redeclare
          BESMod.Systems.Hydraulical.Distribution.RecordsCollection.SimpleStorage.DefaultStorage
          parStoBuf(
          VPerQ_flow=parameterStudy.VPerQFlow,
          dTLoadingHC1=0,
          energyLabel=BESMod.Systems.Hydraulical.Distribution.Types.EnergyLabel.APlus),
        redeclare
          BESMod.Systems.Hydraulical.Distribution.RecordsCollection.SimpleStorage.DefaultStorage
          parStoDHW(dTLoadingHC1=10, energyLabel=BESMod.Systems.Hydraulical.Distribution.Types.EnergyLabel.APlus),
        redeclare BESMod.Systems.RecordsCollection.Valves.DefaultThreeWayValve
          parThrWayVal),
      redeclare BESMod.Systems.Hydraulical.Transfer.IdealValveRadiator transfer(
          redeclare BESMod.Systems.RecordsCollection.Movers.DefaultMover parPum,
          redeclare
          BESMod.Systems.Hydraulical.Transfer.RecordsCollection.RadiatorTransferData
          parRad(n=1.001))),
    redeclare BESMod.Systems.Demand.DHW.StandardProfiles DHW(redeclare
        BESMod.Systems.Demand.DHW.RecordsCollection.ProfileM DHWProfile,
        redeclare final
        BESMod.Systems.Demand.DHW.TappingProfiles.calcmFlowEquDynamic calcmFlow),
    redeclare OptimizationVariables parameterStudy,
    building(incElePro=incElePro));
  extends BESMod.BESRules.BaseClasses.PartialHeatPumpDesign2D
                                                      (
    tabIdePEle=hydraulic.generation.heatPump.refCyc.refCycHeaPumHea.tabIdePEle,
    tabIdeQUse_flow=hydraulic.generation.heatPump.refCyc.refCycHeaPumHea.tabIdeQUse_flow,
    scalingFactor=hydraulic.generation.heatPump.refCyc.refCycHeaPumHea.scaFac,
    TOda_nominal=systemParameters.TOda_nominal,
    TSupAtOda_nominal=THyd_nominal);
  extends Modelica.Icons.Example;

  Modelica.Blocks.Sources.RealExpression realExpression(y=PEle_A2W35)
    annotation (Placement(transformation(
        extent={{-27,-11},{27,11}},
        rotation=180,
        origin={341,-45})));
  final parameter Modelica.Units.SI.Power PElePVMPP=sum(electrical.generation.PEleMaxPowPoi);
  parameter Boolean useTwoRoo=false
    "=true to use both roof-sides, e.g. north and south or east and west"
    annotation (Dialog(tab="Advanced"));
  parameter Modelica.Units.SI.Angle aziMaiRoo=0
    "Main roof areas surface's azimut angle (0:South)"
    annotation (Dialog(tab="Advanced"));
  parameter Boolean incElePro=true
    "=false to not include electrical energy consumption in the electrical connectors";
equation
  connect(realExpression.y, outputs.control.PEle_nominal) annotation (Line(
        points={{311.3,-45},{298,-45},{298,0},{285,0}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
    annotation (Dialog(tab="Advanced"),
              experiment(
      StartTime=7776000,
      StopTime=8640000,
      Interval=600.001344,
      __Dymola_Algorithm="Dassl"));
end BaseAPI;
