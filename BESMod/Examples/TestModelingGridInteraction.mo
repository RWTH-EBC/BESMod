within BESMod.Examples;
package TestModelingGridInteraction
  model BES_GridInteraction
    extends Systems.BaseClasses.PartialBuildingEnergySystem(
      redeclare BESMod.Systems.Electrical.DirectGridConnectionSystem electrical,
      redeclare Systems.Demand.Building.TEASERThermalZone building(redeclare
          BESMod.Systems.Demand.Building.RecordsCollection.RefAachen oneZoneParam(
            heaLoadFacGrd=0, heaLoadFacOut=0)),
      redeclare BESMod.Examples.TestModelingGridInteraction.GridInteractionControl control,
      redeclare BESMod.Systems.Hydraulical.HydraulicSystem hydraulic(
        redeclare Systems.Hydraulical.Generation.HeatPumpAndHeatingRod generation(
          redeclare BESMod.Systems.RecordsCollection.Movers.DefaultMover pumpData,
          redeclare package Medium_eva = AixLib.Media.Air,
          redeclare
            BESMod.Systems.Hydraulical.Generation.RecordsCollection.DefaultHP
            heatPumpParameters(
            genDesTyp=BESMod.Systems.Hydraulical.Generation.Types.GenerationDesign.BivalentPartParallel,
            TBiv=parameterStudy.TBiv,
            scalingFactor=hydraulic.generation.heatPumpParameters.QPri_flow_nominal
                /parameterStudy.QHP_flow_biv,
            useAirSource=true,
            dpCon_nominal=0,
            dpEva_nominal=0,
            use_refIne=false,
            refIneFre_constant=0),
          redeclare
            BESMod.Systems.Hydraulical.Generation.RecordsCollection.DefaultHR
            heatingRodParameters,
          redeclare model PerDataMainHP =
              AixLib.DataBase.HeatPump.PerformanceData.VCLibMap (
              QCon_flow_nominal=hydraulic.generation.heatPumpParameters.QPri_flow_nominal,
              refrigerant="Propane",
              flowsheet="VIPhaseSeparatorFlowsheet")),
        redeclare BESMod.Examples.TestModelingGridInteraction.PartBiv_PI_ConOut_HPS_Grid_Interaction control(
          redeclare
            BESMod.Systems.Hydraulical.Control.Components.ThermostaticValveController.ThermostaticValvePIControlled
            thermostaticValveController,
          redeclare
            BESMod.Systems.Hydraulical.Control.RecordsCollection.ThermostaticValveDataDefinition
            thermostaticValveParameters,
          redeclare
            BESMod.Systems.Hydraulical.Control.RecordsCollection.DefaultBivHPControl
            bivalentControlData(TBiv=parameterStudy.TBiv),
          redeclare
            Systems.Hydraulical.Control.Components.DHWSetControl.ConstTSet_DHW
            TSet_DHW,
          redeclare
            BESMod.Systems.Hydraulical.Control.RecordsCollection.DefaultSafetyControl
            safetyControl,
          TCutOff=parameterStudy.TCutOff,
          QHP_flow_cutOff=parameterStudy.QHP_flow_cutOff*hydraulic.generation.heatPumpParameters.scalingFactor),
        redeclare Systems.Hydraulical.Distribution.DistributionTwoStorageParallel
          distribution(
          redeclare
            BESMod.Systems.Hydraulical.Distribution.RecordsCollection.SimpleStorage.DefaultStorage
            bufParameters(VPerQ_flow=parameterStudy.VPerQFlow, dTLoadingHC1=0),
          redeclare
            BESMod.Systems.Hydraulical.Distribution.RecordsCollection.SimpleStorage.DefaultStorage
            dhwParameters(dTLoadingHC1=10),
          redeclare BESMod.Systems.RecordsCollection.Valves.DefaultThreeWayValve
            threeWayValveParameters),
        redeclare Systems.Hydraulical.Transfer.IdealValveRadiator transfer(
            redeclare
            BESMod.Systems.Hydraulical.Transfer.RecordsCollection.RadiatorTransferData
            radParameters, redeclare
            BESMod.Systems.RecordsCollection.Movers.DefaultMover pumpData)),
      redeclare Systems.Demand.DHW.DHW DHW(
        redeclare BESMod.Systems.Demand.DHW.RecordsCollection.ProfileM DHWProfile,
        redeclare BESMod.Systems.RecordsCollection.Movers.DefaultMover pumpData,
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

    extends Modelica.Icons.Example;

    annotation (experiment(
        StopTime=31536000,
        Interval=599.999616,
        __Dymola_Algorithm="Dassl"));
  end BES_GridInteraction;

  model GridInteractionControl
    "Basic gird interaction control (implementing of EVU-Sperre)"
    extends Systems.Control.BaseClasses.PartialControl;

   // parameter Real HP_EVU_blocking "Variable to store if the HP is allowed to operate or not (depending on the hour of the day, the EVU-Sperre intervents)";

  parameter String filNam="D:/fwu-nmu/BESMod/table_EVU_Sperre_1.txt" "Name of weather data file" annotation (
      Dialog(loadSelector(filter="Weather files (*.mos)",
                          caption="Select weather file")));
  protected
    final parameter Modelica.Units.SI.Time[2] timeSpan=
        IBPSA.BoundaryConditions.WeatherData.BaseClasses.getTimeSpanTMY3(filNam,
        "tab1") "Start time, end time of weather data";
    Modelica.Blocks.Tables.CombiTable1Ds datRea(
      final tableOnFile=true,
      table=[1,1; 1,2; 1,3; 1,4; 1,5; 1,6; 1,7; 1,8; 0,9; 0,10; 0,11; 1,12; 1,13;
          1,14; 1,15; 1,16; 0,17; 0,18; 0,19; 1,20; 1,21; 1,22; 1,23; 1,24],
      final tableName="tab1",
      final fileName="D:/fwu-nmu/BESMod/table_EVU_Sperre_test.txt",
      verboseRead=false,
      final smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments)
      "Data reader"
      annotation (Placement(transformation(extent={{16,22},{36,42}})));
    IBPSA.BoundaryConditions.WeatherData.BaseClasses.ConvertTime conTim(final
        weaDatStaTim=timeSpan[1], final weaDatEndTim=timeSpan[2])
      "Convert simulation time to calendar time"
      annotation (Placement(transformation(extent={{-30,22},{-10,42}})));
    IBPSA.Utilities.Time.ModelTime modTim "Model time"
      annotation (Placement(transformation(extent={{-80,22},{-60,42}})));
  equation
    connect(conTim.modTim, modTim.y)
      annotation (Line(points={{-32,32},{-59,32}}, color={0,0,127}));
    connect(conTim.calTim, datRea.u)
      annotation (Line(points={{-9,32},{14,32}},             color={0,0,127}));
    connect(datRea.y[1], sigBusHyd.Test) annotation (Line(points={{37,32},{42,
            32},{42,-82},{-79,-82},{-79,-101}},
                                        color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
  end GridInteractionControl;

  model Biv_PI_ConFlow_HPSController_Grid_Interaction
    "Using alt_bivalent + PI Inverter + Return Temperature as controller + Grid Interaction"
    extends
      BESMod.Examples.TestModelingGridInteraction.PartialTwoPoint_HPS_Controller_Grid_Interaction(
      redeclare
        BESMod.Systems.Hydraulical.Control.Components.DHWSetControl.ConstTSet_DHW
        TSet_DHW,
      redeclare
        BESMod.Systems.Hydraulical.Control.Components.HeatPumpNSetController.PI_InverterHeatPumpController
        HP_nSet_Controller(
        P=bivalentControlData.k,
        nMin=bivalentControlData.nMin,
        T_I=bivalentControlData.T_I),
      redeclare
        BESMod.Systems.Hydraulical.Control.Components.OnOffController.AlternativeBivalentOnOffController
        BufferOnOffController(final T_biv=bivalentControlData.TBiv, hysteresis=
            bivalentControlData.dTHysDHW),
      redeclare
        BESMod.Systems.Hydraulical.Control.Components.OnOffController.AlternativeBivalentOnOffController
        DHWOnOffContoller(final T_biv=bivalentControlData.TBiv, hysteresis=
            bivalentControlData.dTHysDHW));

  equation
    connect(HP_nSet_Controller.T_Meas, sigBusGen.THeaPumOut)
      annotation (Line(points={{97,61.2},{97,-66},{-118,-66},{-118,-99},{-152,-99}},
                                 color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{-3,-6},{-3,-6}},
        horizontalAlignment=TextAlignment.Right));
  end Biv_PI_ConFlow_HPSController_Grid_Interaction;

  partial model PartialTwoPoint_HPS_Controller_Grid_Interaction
    "Partial model with replaceable blocks for rule based control of HPS using on off heating rods"
    extends
      BESMod.Systems.Hydraulical.Control.BaseClasses.SystemWithThermostaticValveControl;
    replaceable
      BESMod.Systems.Hydraulical.Control.Components.OnOffController.BaseClasses.PartialOnOffController
      DHWOnOffContoller annotation (choicesAllMatching=true, Placement(
          transformation(extent={{-128,70},{-112,86}})));
    replaceable
      BESMod.Systems.Hydraulical.Control.Components.OnOffController.BaseClasses.PartialOnOffController
      BufferOnOffController annotation (choicesAllMatching=true, Placement(
          transformation(extent={{-126,36},{-110,50}})));
    replaceable BESMod.Systems.Hydraulical.Control.RecordsCollection.HeatPumpSafetyControl
      safetyControl
      annotation (choicesAllMatching=true,Placement(transformation(extent={{200,30},{220,50}})));
    replaceable parameter
      Systems.Hydraulical.Control.RecordsCollection.BivalentHeatPumpControlDataDefinition
      bivalentControlData constrainedby
      Systems.Hydraulical.Control.RecordsCollection.BivalentHeatPumpControlDataDefinition(
      final TOda_nominal=generationParameters.TOda_nominal,
      TSup_nominal=generationParameters.TSup_nominal[1],
      TSetRoomConst=sum(transferParameters.TDem_nominal)/transferParameters.nParallelDem)
      annotation (choicesAllMatching=true, Placement(transformation(extent={{-92,
              -32},{-70,-10}})));
    replaceable
      BESMod.Systems.Hydraulical.Control.Components.DHWSetControl.BaseClasses.PartialTSet_DHW_Control
      TSet_DHW constrainedby
      BESMod.Systems.Hydraulical.Control.Components.DHWSetControl.BaseClasses.PartialTSet_DHW_Control(
        final T_DHW=distributionParameters.TDHW_nominal) annotation (
        choicesAllMatching=true, Placement(transformation(extent={{-216,66},{-192,
              90}})));
    BESMod.Systems.Hydraulical.Control.Components.HeatingCurve
      heatingCurve(
      GraHeaCurve=bivalentControlData.gradientHeatCurve,
      THeaThres=bivalentControlData.TSetRoomConst,
      dTOffSet_HC=bivalentControlData.dTOffSetHeatCurve)
      annotation (Placement(transformation(extent={{-160,20},{-140,40}})));
    Modelica.Blocks.MathBoolean.Or
                               HRactive(nu=3)
                                        annotation (Placement(transformation(
          extent={{-5,-5},{5,5}},
          rotation=0,
          origin={15,25})));
    Modelica.Blocks.Logical.Or HP_active
                                        annotation (Placement(transformation(
          extent={{-5,-5},{5,5}},
          rotation=0,
          origin={27,91})));
    replaceable
      BESMod.Systems.Hydraulical.Control.Components.HeatPumpNSetController.BaseClasses.PartialHPNSetController
      HP_nSet_Controller annotation (choicesAllMatching=true, Placement(
          transformation(extent={{82,64},{112,92}})));
    Modelica.Blocks.Logical.Switch switch1
      annotation (Placement(transformation(extent={{-5,-5},{5,5}},
          rotation=0,
          origin={63,73})));
    Modelica.Blocks.Sources.Constant const_dT_loading1(k=distributionParameters.dTTra_nominal[1])
                                                            annotation (Placement(
          transformation(
          extent={{4,-4},{-4,4}},
          rotation=180,
          origin={14,58})));

    Modelica.Blocks.MathBoolean.Or
                               DHWHysOrLegionella(nu=4)
      "Use the HR if the HP reached its limit" annotation (Placement(
          transformation(
          extent={{-5,-5},{5,5}},
          rotation=0,
          origin={-77,69})));
    AixLib.Controls.HeatPump.SafetyControls.SafetyControl securityControl(
      final minRunTime=safetyControl.minRunTime,
      final minLocTime=safetyControl.minLocTime,
      final maxRunPerHou=safetyControl.maxRunPerHou,
      final use_opeEnv=safetyControl.use_opeEnv,
      final use_opeEnvFroRec=false,
      final dataTable=AixLib.DataBase.HeatPump.EN14511.Vitocal200AWO201(
          tableUppBou=[-20,50; -10,60; 30,60; 35,55]),
      final tableUpp=safetyControl.tableUpp,
      final use_minRunTime=safetyControl.use_minRunTime,
      final use_minLocTime=safetyControl.use_minLocTime,
      final use_runPerHou=safetyControl.use_runPerHou,
      final dTHystOperEnv=safetyControl.dT_opeEnv,
      final use_deFro=false,
      final minIceFac=0,
      final use_chiller=false,
      final calcPel_deFro=0,
      final pre_n_start=safetyControl.pre_n_start_hp,
      use_antFre=false) annotation (Placement(transformation(
          extent={{-16,-17},{16,17}},
          rotation=0,
          origin={210,81})));
    Modelica.Blocks.Sources.BooleanConstant hp_mode(final k=true) annotation (
        Placement(transformation(
          extent={{-7,-7},{7,7}},
          rotation=0,
          origin={155,69})));

    Modelica.Blocks.Logical.Switch switchHR annotation (Placement(transformation(
          extent={{-5,-5},{5,5}},
          rotation=0,
          origin={43,25})));
    Modelica.Blocks.Sources.Constant constZero(final k=0) annotation (Placement(
          transformation(
          extent={{2,-2},{-2,2}},
          rotation=180,
          origin={24,10})));
    Modelica.Blocks.Math.Max max annotation (Placement(transformation(
          extent={{4,-4},{-4,4}},
          rotation=180,
          origin={24,38})));

    Modelica.Blocks.Math.Add add_dT_LoadingBuf
      annotation (Placement(transformation(extent={{38,54},{48,64}})));
    Modelica.Blocks.Sources.Constant const_dT_loading2(k=distributionParameters.dTTraDHW_nominal
           + bivalentControlData.dTHysDHW/2) annotation (Placement(transformation(
          extent={{4,-4},{-4,4}},
          rotation=180,
          origin={14,74})));
    Modelica.Blocks.Math.Add add_dT_LoadingDHW
      annotation (Placement(transformation(extent={{36,78},{46,88}})));

    Modelica.Blocks.Math.BooleanToReal booleanToReal annotation (Placement(
          transformation(
          extent={{-6,-6},{6,6}},
          rotation=270,
          origin={-38,-36})));
    Modelica.Blocks.Logical.Not bufOn "buffer is charged" annotation (Placement(
          transformation(
          extent={{-5,-5},{5,5}},
          rotation=270,
          origin={-37,-17})));
    BESMod.Utilities.SupervisoryControl.SupervisoryControl supervisoryControlDHW(
        ctrlType=supCtrlTypeDHWSet)
      annotation (Placement(transformation(extent={{-182,72},{-170,84}})));
    parameter BESMod.Utilities.SupervisoryControl.Types.SupervisoryControlType
      supCtrlTypeDHWSet=BESMod.Utilities.SupervisoryControl.Types.SupervisoryControlType.Local
      "Type of supervisory control for DHW Setpoint";
    Modelica.Blocks.Math.MinMax minMax(nu=transferParameters.nParallelDem)
      annotation (Placement(transformation(extent={{-202,32},{-182,52}})));
    Modelica.Blocks.Math.BooleanToReal booleanToReal1 "Turn Pump in heat pump on"
                                                     annotation (Placement(
          transformation(
          extent={{-10,-10},{10,10}},
          rotation=270,
          origin={-170,-54})));
    Modelica.Blocks.Logical.Or HP_or_HR_active annotation (Placement(
          transformation(
          extent={{-10,-10},{10,10}},
          rotation=270,
          origin={-170,-24})));
    Systems.Hydraulical.Control.Components.HeatPumpBusPassThrough heatPumpBusPassThrough
      annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=180,
          origin={-230,-90})));
    Modelica.Blocks.Logical.LogicalSwitch logicalSwitch
      annotation (Placement(transformation(extent={{142,-16},{162,4}})));
    Modelica.Blocks.Math.RealToBoolean realToBoolean(threshold=1)
      annotation (Placement(transformation(extent={{102,-24},{110,-16}})));
    Modelica.Blocks.Sources.BooleanConstant hp_mode1(final k=false)
                                                                  annotation (
        Placement(transformation(
          extent={{-7,-7},{7,7}},
          rotation=0,
          origin={117,-31})));
  equation
    connect(BufferOnOffController.T_Top, sigBusDistr.TStoBufTopMea) annotation (
        Line(points={{-126.8,47.9},{-128,47.9},{-128,48},{-130,48},{-130,-86},{4,-86},
            {4,-100},{1,-100}},
          color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(DHWOnOffContoller.T_Top, sigBusDistr.TStoDHWTopMea) annotation (Line(
          points={{-128.8,83.6},{-316,83.6},{-316,-166},{1,-166},{1,-100}},
          color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(heatingCurve.TSet, BufferOnOffController.T_Set) annotation (Line(
          points={{-139,30},{-139,28},{-118,28},{-118,35.3}},
                                                      color={0,0,127}));

    connect(DHWOnOffContoller.T_bot, sigBusDistr.TStoDHWTopMea) annotation (Line(
          points={{-128.8,74},{-318,74},{-318,-166},{1,-166},{1,-100}},
          color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(sigBusDistr, TSet_DHW.sigBusDistr) annotation (Line(
        points={{1,-100},{-2,-100},{-2,-152},{-292,-152},{-292,77.88},{-216,77.88}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));

    connect(DHWOnOffContoller.Auxilliar_Heater_On, HRactive.u[1]) annotation (
        Line(points={{-110.88,74},{-22,74},{-22,23.8333},{10,23.8333}}, color={
            255,0,255}));
    connect(BufferOnOffController.Auxilliar_Heater_On, HRactive.u[2]) annotation (
       Line(points={{-108.88,39.5},{-94,39.5},{-94,25},{10,25}},           color=
            {255,0,255}));
    connect(TSet_DHW.y, HRactive.u[3]) annotation (Line(points={{-190.8,71.04},
            {-96,71.04},{-96,26.1667},{10,26.1667}},                        color=
           {255,0,255}));

    connect(securityControl.modeSet, hp_mode.y) annotation (Line(points={{191.867,
            77.6},{168,77.6},{168,69},{162.7,69}}, color={255,0,255}));
    connect(securityControl.nOut, sigBusGen.yHeaPumSet) annotation (Line(
          points={{227.333,84.4},{264,84.4},{264,-132},{-42,-132},{-42,-99},{
            -152,-99}},                    color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{6,3},{6,3}},
        horizontalAlignment=TextAlignment.Left));
    connect(HP_nSet_Controller.n_Set, securityControl.nSet) annotation (Line(
          points={{113.5,78},{144,78},{144,84.4},{191.867,84.4}}, color={0,0,127}));
    connect(BufferOnOffController.HP_On, HP_active.u2) annotation (Line(points={{-108.88,
            47.9},{-78,47.9},{-78,54},{-38,54},{-38,87},{21,87}},
                                                   color={255,0,255}));
    connect(DHWOnOffContoller.HP_On, HP_active.u1) annotation (Line(points={{-110.88,
            83.6},{-32,83.6},{-32,91},{21,91}},    color={255,0,255}));
    connect(DHWHysOrLegionella.y, switch1.u2) annotation (Line(points={{-71.25,69},
            {-20,69},{-20,73},{57,73}},             color={255,0,255}));

    connect(TSet_DHW.y, DHWHysOrLegionella.u[1]) annotation (Line(points={{-190.8,
            71.04},{-96,71.04},{-96,67.6875},{-82,67.6875}},    color={255,0,255}));
    connect(DHWOnOffContoller.Auxilliar_Heater_On, DHWHysOrLegionella.u[2])
      annotation (Line(points={{-110.88,74},{-92,74},{-92,68.5625},{-82,68.5625}},
                                                                          color={
            255,0,255}));
    connect(DHWOnOffContoller.HP_On, DHWHysOrLegionella.u[3]) annotation (Line(
          points={{-110.88,83.6},{-90,83.6},{-90,69.4375},{-82,69.4375}},
          color={255,0,255}));
    connect(TSet_DHW.y, DHWHysOrLegionella.u[4]) annotation (Line(points={{-190.8,
            71.04},{-136.4,71.04},{-136.4,70.3125},{-82,70.3125}},
                                                                 color={255,0,255}));
    connect(BufferOnOffController.T_bot, sigBusDistr.TStoBufTopMea) annotation (
        Line(points={{-126.8,39.5},{-130,39.5},{-130,-86},{134,-86},{134,-100},{1,
            -100}},              color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(HRactive.y, switchHR.u2)
      annotation (Line(points={{20.75,25},{37,25}}, color={255,0,255}));
    connect(constZero.y, switchHR.u3) annotation (Line(points={{26.2,10},{28,10},{
            28,21},{37,21}}, color={0,0,127}));
    connect(max.y, switchHR.u1)
      annotation (Line(points={{28.4,38},{37,38},{37,29}}, color={0,0,127}));
    connect(BufferOnOffController.Auxilliar_Heater_set, max.u1) annotation (Line(
          points={{-108.88,36.98},{-84,36.98},{-84,35.6},{19.2,35.6}}, color={0,0,
            127}));
    connect(DHWOnOffContoller.Auxilliar_Heater_set, max.u2) annotation (Line(
          points={{-110.88,71.12},{-104,71.12},{-104,64},{-10,64},{-10,40.4},{19.2,
            40.4}}, color={0,0,127}));
    connect(switchHR.y, sigBusGen.uHeaRod) annotation (Line(points={{48.5,25},{62,25},
            {62,-48},{-152,-48},{-152,-99}},  color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{6,3},{6,3}},
        horizontalAlignment=TextAlignment.Left));
    connect(HP_nSet_Controller.IsOn, sigBusGen.heaPumIsOn) annotation (Line(
          points={{88,61.2},{88,-58},{-152,-58},{-152,-99}}, color={255,0,255}),
        Text(
        string="%second",
        index=1,
        extent={{-3,-6},{-3,-6}},
        horizontalAlignment=TextAlignment.Right));
    connect(const_dT_loading2.y,add_dT_LoadingDHW. u2) annotation (Line(points={{18.4,74},
            {24,74},{24,80},{35,80}},                  color={0,0,127}));
    connect(switch1.y, HP_nSet_Controller.T_Set) annotation (Line(points={{68.5,
            73},{70,73},{70,86.4},{79,86.4}}, color={0,0,127}));
    connect(heatingCurve.TSet, add_dT_LoadingBuf.u1) annotation (Line(points={{-139,30},
            {-139,28},{4,28},{4,66},{32,66},{32,62},{37,62}},
                                               color={0,0,127}));
    connect(add_dT_LoadingBuf.y, switch1.u3) annotation (Line(points={{48.5,59},{
            54,59},{54,69},{57,69}}, color={0,0,127}));
    connect(add_dT_LoadingDHW.y, switch1.u1) annotation (Line(points={{46.5,83},{
            51.25,83},{51.25,77},{57,77}}, color={0,0,127}));
    connect(const_dT_loading1.y, add_dT_LoadingBuf.u2) annotation (Line(points={{
            18.4,58},{26,58},{26,56},{37,56}}, color={0,0,127}));
    connect(booleanToReal.y, sigBusDistr.uThrWayVal) annotation (Line(points={{
            -38,-42.6},{-38,-62},{1,-62},{1,-100}}, color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{-3,-6},{-3,-6}},
        horizontalAlignment=TextAlignment.Right));
    connect(booleanToReal.u, bufOn.y) annotation (Line(points={{-38,-28.8},{-38,
            -26},{-37,-26},{-37,-22.5}}, color={255,0,255}));
    connect(bufOn.u, DHWHysOrLegionella.y) annotation (Line(points={{-37,-11},{
            -37,70},{-71.25,70},{-71.25,69}}, color={255,0,255}));
    connect(TSet_DHW.TSet_DHW, supervisoryControlDHW.uLoc) annotation (Line(
          points={{-190.8,78},{-188,78},{-188,73.2},{-183.2,73.2}}, color={0,0,
            127}));
    connect(supervisoryControlDHW.y, DHWOnOffContoller.T_Set) annotation (Line(
          points={{-168.8,78},{-150,78},{-150,74},{-122,74},{-122,69.2},{-120,69.2}},
                    color={0,0,127}));
    connect(supervisoryControlDHW.y, add_dT_LoadingDHW.u1) annotation (Line(
          points={{-168.8,78},{-150,78},{-150,76},{-10,76},{-10,86},{35,86}},
          color={0,0,127}));
    connect(supervisoryControlDHW.actInt, sigBusHyd.overwriteTSetDHW) annotation (
       Line(points={{-183.2,78},{-186,78},{-186,94},{-28,94},{-28,101}}, color={
            255,0,255}), Text(
        string="%second",
        index=1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(supervisoryControlDHW.uSup, sigBusHyd.TSetDHW) annotation (Line(
          points={{-183.2,82.8},{-183.2,92},{-28,92},{-28,101}}, color={0,0,127}),
        Text(
        string="%second",
        index=1,
        extent={{-3,6},{-3,6}},
        horizontalAlignment=TextAlignment.Right));
    connect(heatingCurve.TOda, weaBus.TDryBul) annotation (Line(points={{-162,30},
            {-236,30},{-236,2},{-237,2}}, color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(BufferOnOffController.T_oda, weaBus.TDryBul) annotation (Line(points={
            {-118,50.84},{-118,58},{-236,58},{-236,30},{-237,30},{-237,2}}, color=
           {0,0,127}), Text(
        string="%second",
        index=1,
        extent={{-3,-6},{-3,-6}},
        horizontalAlignment=TextAlignment.Right));
    connect(DHWOnOffContoller.T_oda, weaBus.TDryBul) annotation (Line(points={{-120,
            86.96},{-192,86.96},{-192,94},{-248,94},{-248,2},{-237,2}}, color={0,0,
            127}), Text(
        string="%second",
        index=1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(minMax.u, useProBus.TZoneSet) annotation (Line(points={{-202,42},{-206,
            42},{-206,52},{-208,52},{-208,60},{-119,60},{-119,103}}, color={0,0,127}),
        Text(
        string="%second",
        index=1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(minMax.yMax, heatingCurve.TSetRoom)
      annotation (Line(points={{-181,48},{-150,48},{-150,42}}, color={0,0,127}));
    connect(booleanToReal1.u, HP_or_HR_active.y)
      annotation (Line(points={{-170,-42},{-170,-35}}, color={255,0,255}));
    connect(booleanToReal1.y, sigBusGen.uPump) annotation (Line(points={{-170,-65},
            {-172,-65},{-172,-72},{-152,-72},{-152,-99}}, color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{6,3},{6,3}},
        horizontalAlignment=TextAlignment.Left));
    connect(HP_or_HR_active.u1, HRactive.y) annotation (Line(points={{-170,-12},{
            -134,-12},{-134,-6},{-6,-6},{-6,18},{20.75,18},{20.75,25}}, color={
            255,0,255}));
    connect(HP_or_HR_active.u2, sigBusGen.heaPumIsOn) annotation (Line(
          points={{-178,-12},{-194,-12},{-194,-99},{-152,-99}}, color={255,0,255}),
        Text(
        string="%second",
        index=1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(heatPumpBusPassThrough.sigBusGen, sigBusGen) annotation (Line(
        points={{-220,-90},{-200,-90},{-200,-80},{-180,-80},{-180,-72},{-152,-72},
            {-152,-99}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%second",
        index=1,
        extent={{6,3},{6,3}},
        horizontalAlignment=TextAlignment.Left));
    connect(heatPumpBusPassThrough.vapourCompressionMachineControlBus,
      securityControl.sigBusHP) annotation (Line(
        points={{-240.2,-89.8},{-252,-89.8},{-252,-80},{72,-80},{72,-38},{192,-38},
            {192,69.27},{192,69.27}},
        color={255,204,51},
        thickness=0.5));
    connect(realToBoolean.u, sigBusHyd.Test) annotation (Line(points={{101.2,
            -20},{64,-20},{64,48},{-24,48},{-24,78},{-28,78},{-28,101}}, color=
            {0,0,127}), Text(
        string="%second",
        index=1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(realToBoolean.y, logicalSwitch.u2) annotation (Line(points={{110.4,
            -20},{132,-20},{132,-6},{140,-6}}, color={255,0,255}));
    connect(HP_active.y, logicalSwitch.u1) annotation (Line(points={{32.5,91},{
            32.5,100},{14,100},{14,82},{26,82},{26,50},{134,50},{134,2},{140,2}},
          color={255,0,255}));
    connect(hp_mode1.y, logicalSwitch.u3) annotation (Line(points={{124.7,-31},
            {134,-31},{134,-14},{140,-14}}, color={255,0,255}));
    connect(logicalSwitch.y, HP_nSet_Controller.HP_On) annotation (Line(points=
            {{163,-6},{168,-6},{168,52},{74,52},{74,70},{72,70},{72,78},{79,78}},
          color={255,0,255}));
    annotation (Diagram(graphics={
          Rectangle(
            extent={{-240,100},{-50,60}},
            lineColor={238,46,47},
            lineThickness=1),
          Text(
            extent={{-234,94},{-140,128}},
            lineColor={238,46,47},
            lineThickness=1,
            textString="DHW Control"),
          Rectangle(
            extent={{-240,58},{-50,14}},
            lineColor={0,140,72},
            lineThickness=1),
          Text(
            extent={{-216,-14},{-122,20}},
            lineColor={0,140,72},
            lineThickness=1,
            textString="Buffer Control"),
          Rectangle(
            extent={{0,100},{132,52}},
            lineColor={28,108,200},
            lineThickness=1),
          Text(
            extent={{4,122},{108,102}},
            lineColor={28,108,200},
            lineThickness=1,
            textString="Heat Pump Control"),
          Rectangle(
            extent={{0,46},{132,4}},
            lineColor={162,29,33},
            lineThickness=1),
          Rectangle(
            extent={{138,100},{240,52}},
            lineColor={28,108,200},
            lineThickness=1),
          Text(
            extent={{138,122},{242,102}},
            lineColor={28,108,200},
            lineThickness=1,
            textString="Heat Pump Safety")}));
  end PartialTwoPoint_HPS_Controller_Grid_Interaction;

  model PartBiv_PI_ConOut_HPS_Grid_Interaction
    "Part-parallel PI controlled HPS according to condenser outflow"
    extends
      BESMod.Examples.TestModelingGridInteraction.PartialTwoPoint_HPS_Controller_Grid_Interaction(
      redeclare
        BESMod.Systems.Hydraulical.Control.Components.HeatPumpNSetController.PI_InverterHeatPumpController
        HP_nSet_Controller(
        P=bivalentControlData.k,
        nMin=bivalentControlData.nMin,
        T_I=bivalentControlData.T_I),
      redeclare
        BESMod.Systems.Hydraulical.Control.Components.OnOffController.ParallelBivalentControl
        BufferOnOffController(
        Hysteresis=bivalentControlData.dTHysBui,
        TCutOff=TCutOff,
        TBiv=bivalentControlData.TBiv,
        TOda_nominal=bivalentControlData.TOda_nominal,
        TRoom=bivalentControlData.TSetRoomConst,
        QDem_flow_nominal=sum(transferParameters.Q_flow_nominal),
        QHP_flow_cutOff=QHP_flow_cutOff),
      redeclare
        BESMod.Systems.Hydraulical.Control.Components.OnOffController.ParallelBivalentControl
        DHWOnOffContoller(
        Hysteresis=bivalentControlData.dTHysDHW,
        TCutOff=TCutOff,
        TBiv=bivalentControlData.TBiv,
        TOda_nominal=bivalentControlData.TOda_nominal,
        TRoom=bivalentControlData.TSetRoomConst,
        QDem_flow_nominal=sum(transferParameters.Q_flow_nominal),
        QHP_flow_cutOff=QHP_flow_cutOff));

    parameter Modelica.Units.SI.Temperature TCutOff "Cut-off temperature";
    parameter Modelica.Units.SI.HeatFlowRate QHP_flow_cutOff;

  equation
      connect(HP_nSet_Controller.T_Meas, sigBusGen.THeaPumOut) annotation (
         Line(points={{97,61.2},{97,-56},{-152,-56},{-152,-99}},  color={0,0,127}),
          Text(
          string="%second",
          index=1,
          extent={{-3,-6},{-3,-6}},
          horizontalAlignment=TextAlignment.Right));

    annotation (Icon(graphics,
                     coordinateSystem(preserveAspectRatio=false)), Diagram(graphics={
          Text(
            extent={{14,8},{118,-12}},
            lineColor={162,29,33},
            lineThickness=1,
            textString="Heating Rod Control")},
          coordinateSystem(preserveAspectRatio=false)));
  end PartBiv_PI_ConOut_HPS_Grid_Interaction;
end TestModelingGridInteraction;
