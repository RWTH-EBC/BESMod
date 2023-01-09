within BESMod.Examples;
package TestControlStrategiesGridConnection
  model BES_Test
    extends Systems.BaseClasses.PartialBuildingEnergySystem(
      redeclare BESMod.Systems.Electrical.DirectGridConnectionSystem electrical,
      redeclare Systems.Demand.Building.TEASERThermalZone building(redeclare
          BESMod.Systems.Demand.Building.RecordsCollection.RefAachen oneZoneParam(
            heaLoadFacGrd=0, heaLoadFacOut=0)),
      redeclare BESMod.Systems.Control.NoControl control,
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
        redeclare BESMod.Examples.TestControlStrategiesGridConnection.PartBiv_PI_ConOut_HPS_summer_winter_mode control(
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
        StartTime=4320000,
        StopTime=6048000,
        Interval=599.999616,
        __Dymola_Algorithm="Dassl"));
  end BES_Test;

  partial record SummerHeatPumpControl
    extends Modelica.Icons.Record;

    parameter Modelica.Units.SI.TemperatureDifference dTHysBui
      "Hysteresis for building demand control"
      annotation (Dialog(group="General"));
    parameter Modelica.Units.SI.TemperatureDifference dTHysDHW
      "Hysteresis for DHW demand control" annotation (Dialog(group="General"));
        parameter Real k     "Proportional gain of Primary PID Controller"
                                                                    annotation(Dialog(group="Primary PID Control",
        enable=use_hydraulic or use_ventilation));
    parameter Modelica.Units.SI.Time T_I
      "Time constant of Integrator block of PI control" annotation (Dialog(group=
            "Primary PID Control", enable=use_hydraulic or use_ventilation));

    parameter Modelica.Units.SI.Time Ni "Anti wind up constant of PID control"
      annotation (Dialog(group="Primary PID Control", enable=use_hydraulic or
            use_ventilation));

    parameter Modelica.Units.SI.TemperatureDifference dTOffSetHeatCurve
      "Additional Offset of heating curve"
      annotation (Evaluate=true, Dialog(group="Heating Curve"));
    parameter Modelica.Units.SI.Temperature TOda_nominal
      "Nominal outdoor air temperature";
    parameter Modelica.Units.SI.Temperature TSup_nominal
      "Nominal supply temperature of primary energy system";
    parameter Modelica.Units.SI.Temperature TSetRoomConst=293.15
      "Room set temerature";
    parameter Modelica.Units.SI.Temperature TBiv=TOda_nominal
      "Nominal bivalence temperature. = TOda_nominal for monovalent systems.";

    parameter Real gradientHeatCurve=((TSup_nominal) - (TSetRoomConst + dTOffSetHeatCurve))/(TSetRoomConst-TOda_nominal)  "Heat curve gradient"    annotation(Evaluate=true, Dialog(group=
            "Heating Curve"));
    parameter Modelica.Units.SI.Time dtHeaRodBui
      "Seconds for regulation when hr should be activated: If lower set temperature is hurt for more than this time period"
      annotation (group="Heat Pumps", Dialog(group="Secondary RBC"));

    parameter Real addSet_dtHeaRodBui
      "Each time dt_hr passes, the output of the heating rod is increased by this amount in percentage. Maximum and default is 100 (on-off hr)%" annotation(Dialog(group=
            "Secondary RBC"));
    parameter Modelica.Units.SI.Time dtHeaRodDHW
      "Seconds for regulation when hr should be activated: If lower set temperature is hurt for more than this time period"
      annotation (group="Heat Pumps", Dialog(group="Secondary RBC"));

    parameter Real addSet_dtHeaRodDHW
      "Each time dt_hr passes, the output of the heating rod is increased by this amount in percentage. Maximum and default is 100 (on-off hr)%" annotation(Dialog(group=
            "Secondary RBC"));
    parameter Real nMin
      "Minimum relative input signal of primary device PID control"
      annotation (Dialog(group="Primary PID Control"));

  end SummerHeatPumpControl;

  partial model PartialTwoPoint_HPS_Controller_summer_mode
    "Partial model with replaceable blocks for rule based control of HPS using on off heating rods with additional summer mode"
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
      bivalentControlData(nMin=0)
                          constrainedby
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
      HP_nSet_Controller_winter_mode annotation (choicesAllMatching=true,
        Placement(transformation(extent={{82,64},{112,92}})));
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
          extent={{-7,-7},{7,7}},
          rotation=270,
          origin={-37,-35})));
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
    replaceable
      Systems.Hydraulical.Control.Components.HeatPumpNSetController.BaseClasses.PartialHPNSetController
      HP_nSet_Controller_summer_mode annotation (choicesAllMatching=true,
        Placement(transformation(extent={{142,14},{172,42}})));
    Modelica.Blocks.Logical.Switch WinterSummerSwitch
      annotation (Placement(transformation(extent={{150,76},{170,96}})));
    Modelica.Blocks.Logical.LessThreshold lessThreshold(threshold=283.15)
      annotation (Placement(transformation(extent={{22,-36},{32,-26}})));
    Modelica.Blocks.Logical.LogicalSwitch WinterSummerSwitch_Valve
      annotation (Placement(transformation(extent={{-78,-6},{-58,14}})));
    Modelica.Blocks.Logical.Timer timer
      annotation (Placement(transformation(extent={{140,-22},{160,-2}})));
    Modelica.Blocks.Logical.GreaterThreshold greaterThreshold(threshold=259200)
      annotation (Placement(transformation(extent={{170,-22},{190,-2}})));
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
    connect(HP_active.y, HP_nSet_Controller_winter_mode.HP_On) annotation (Line(
          points={{32.5,91},{68,91},{68,78},{79,78}}, color={255,0,255}));
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
    connect(HP_nSet_Controller_winter_mode.IsOn, sigBusGen.heaPumIsOn)
      annotation (Line(points={{88,61.2},{88,-58},{-152,-58},{-152,-99}}, color=
           {255,0,255}), Text(
        string="%second",
        index=1,
        extent={{-3,-6},{-3,-6}},
        horizontalAlignment=TextAlignment.Right));
    connect(const_dT_loading2.y,add_dT_LoadingDHW. u2) annotation (Line(points={{18.4,74},
            {24,74},{24,80},{35,80}},                  color={0,0,127}));
    connect(switch1.y, HP_nSet_Controller_winter_mode.T_Set) annotation (Line(
          points={{68.5,73},{70,73},{70,86.4},{79,86.4}}, color={0,0,127}));
    connect(heatingCurve.TSet, add_dT_LoadingBuf.u1) annotation (Line(points={{-139,30},
            {-139,28},{4,28},{4,66},{32,66},{32,62},{37,62}},
                                               color={0,0,127}));
    connect(add_dT_LoadingBuf.y, switch1.u3) annotation (Line(points={{48.5,59},{
            54,59},{54,69},{57,69}}, color={0,0,127}));
    connect(add_dT_LoadingDHW.y, switch1.u1) annotation (Line(points={{46.5,83},{
            51.25,83},{51.25,77},{57,77}}, color={0,0,127}));
    connect(const_dT_loading1.y, add_dT_LoadingBuf.u2) annotation (Line(points={{
            18.4,58},{26,58},{26,56},{37,56}}, color={0,0,127}));
    connect(booleanToReal.y, sigBusDistr.uThrWayVal) annotation (Line(points={{-37,
            -42.7},{-37,-62},{1,-62},{1,-100}},     color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{-3,-6},{-3,-6}},
        horizontalAlignment=TextAlignment.Right));
    connect(booleanToReal.u, bufOn.y) annotation (Line(points={{-37,-26.6},{-37,
            -22.5}},                     color={255,0,255}));
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
    connect(HP_nSet_Controller_winter_mode.IsOn, HP_nSet_Controller_summer_mode.IsOn)
      annotation (Line(points={{88,61.2},{88,-10},{118,-10},{118,11.2},{148,
            11.2}}, color={255,0,255}));
    connect(add_dT_LoadingDHW.y, HP_nSet_Controller_summer_mode.T_Set)
      annotation (Line(points={{46.5,83},{46.5,82},{50,82},{50,68},{52,68},{52,
            52},{130,52},{130,36.4},{139,36.4}}, color={0,0,127}));
    connect(HP_nSet_Controller_summer_mode.HP_On, DHWHysOrLegionella.y)
      annotation (Line(points={{139,28},{54,28},{54,46},{-36,46},{-36,69},{
            -71.25,69}}, color={255,0,255}));
    connect(HP_nSet_Controller_winter_mode.n_Set, WinterSummerSwitch.u1)
      annotation (Line(points={{113.5,78},{140,78},{140,94},{148,94}}, color={0,
            0,127}));
    connect(HP_nSet_Controller_summer_mode.n_Set, WinterSummerSwitch.u3)
      annotation (Line(points={{173.5,28},{178,28},{178,54},{142,54},{142,78},{
            148,78}}, color={0,0,127}));
    connect(WinterSummerSwitch.y, securityControl.nSet) annotation (Line(points={{171,86},
            {184,86},{184,84.4},{191.867,84.4}},          color={0,0,127}));
    connect(weaBus.TDryBul, lessThreshold.u) annotation (Line(
        points={{-237,2},{-237,58},{-8,58},{-8,-31},{21,-31}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(WinterSummerSwitch_Valve.y, bufOn.u)
      annotation (Line(points={{-57,4},{-37,4},{-37,-11}}, color={255,0,255}));
    connect(WinterSummerSwitch_Valve.u1, DHWHysOrLegionella.y) annotation (Line(
          points={{-80,12},{-86,12},{-86,44},{-36,44},{-36,69},{-71.25,69}},
          color={255,0,255}));
    connect(WinterSummerSwitch_Valve.u3, DHWOnOffContoller.HP_On) annotation (
        Line(points={{-80,-4},{-90,-4},{-90,83.6},{-110.88,83.6}}, color={255,0,
            255}));
    connect(timer.y, greaterThreshold.u)
      annotation (Line(points={{161,-12},{168,-12}}, color={0,0,127}));
    connect(lessThreshold.y, timer.u) annotation (Line(points={{32.5,-31},{126,
            -31},{126,-12},{138,-12}}, color={255,0,255}));
    connect(greaterThreshold.y, WinterSummerSwitch.u2) annotation (Line(points=
            {{191,-12},{194,-12},{194,62},{164,62},{164,60},{146,60},{146,74},{
            144,74},{144,80},{142,80},{142,86},{148,86}}, color={255,0,255}));
    connect(greaterThreshold.y, WinterSummerSwitch_Valve.u2) annotation (Line(
          points={{191,-12},{194,-12},{194,62},{164,62},{164,60},{126,60},{126,
            50},{-80,50},{-80,20},{-88,20},{-88,4},{-80,4}}, color={255,0,255}));
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
          Text(
            extent={{2,4},{106,-16}},
            lineColor={162,29,33},
            lineThickness=1,
            textString="Heating Rod Control"),
          Rectangle(
            extent={{138,100},{240,52}},
            lineColor={28,108,200},
            lineThickness=1),
          Text(
            extent={{138,122},{242,102}},
            lineColor={28,108,200},
            lineThickness=1,
            textString="Heat Pump Safety")}));
  end PartialTwoPoint_HPS_Controller_summer_mode;

  model PartBiv_PI_ConOut_HPS_summer_winter_mode
    extends PartialTwoPoint_HPS_Controller_summer_mode(
      redeclare
        BESMod.Systems.Hydraulical.Control.Components.HeatPumpNSetController.PI_InverterHeatPumpController
        HP_nSet_Controller_winter_mode(
        P=bivalentControlData.k,
        nMin=bivalentControlData.nMin,
        T_I=bivalentControlData.T_I),
      redeclare
        BESMod.Systems.Hydraulical.Control.Components.HeatPumpNSetController.PI_InverterHeatPumpController
        HP_nSet_Controller_summer_mode(
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
        QHP_flow_cutOff=QHP_flow_cutOff),
      lessThreshold(threshold=285.15));

    parameter Modelica.Units.SI.Temperature TCutOff "Cut-off temperature";
    parameter Modelica.Units.SI.HeatFlowRate QHP_flow_cutOff;

  equation

    connect(HP_nSet_Controller_summer_mode.T_Meas, sigBusGen.THeaPumOut)
      annotation (Line(points={{157,11.2},{156,11.2},{156,-46},{-152,-46},{-152,
            -99}}, color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(HP_nSet_Controller_winter_mode.T_Meas, sigBusGen.THeaPumOut)
      annotation (Line(points={{97,61.2},{96,61.2},{96,-46},{-152,-46},{-152,
            -99}}, color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    annotation (Icon(graphics,
                     coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)),
      experiment(
        StopTime=864000,
        Interval=599.999616,
        __Dymola_Algorithm="Dassl"));
  end PartBiv_PI_ConOut_HPS_summer_winter_mode;

  model Parameter_fit_control
    extends Systems.Hydraulical.Control.BaseClasses.PartialControl;

    replaceable
      Systems.Hydraulical.Control.Components.DHWSetControl.BaseClasses.PartialTSet_DHW_Control
      TSet_DHW constrainedby
      Systems.Hydraulical.Control.Components.DHWSetControl.BaseClasses.PartialTSet_DHW_Control(
        final T_DHW=distributionParameters.TDHW_nominal) annotation (
        choicesAllMatching=true, Placement(transformation(extent={{-154,24},{-130,
              48}})));
    Utilities.SupervisoryControl.SupervisoryControl        supervisoryControlDHW(ctrlType=
          supCtrlTypeDHWSet)
      annotation (Placement(transformation(extent={{-20,34},{4,56}})));
      parameter BESMod.Utilities.SupervisoryControl.Types.SupervisoryControlType
      supCtrlTypeDHWSet=BESMod.Utilities.SupervisoryControl.Types.SupervisoryControlType.Local
      "Type of supervisory control for DHW Setpoint";

     replaceable parameter
      Systems.Hydraulical.Control.RecordsCollection.BivalentHeatPumpControlDataDefinition
      bivalentControlData constrainedby
      Systems.Hydraulical.Control.RecordsCollection.BivalentHeatPumpControlDataDefinition(
      final TOda_nominal=generationParameters.TOda_nominal,
      TSup_nominal=generationParameters.TSup_nominal[1],
      TSetRoomConst=sum(transferParameters.TDem_nominal)/transferParameters.nParallelDem);

    Modelica.Blocks.Math.Add add_dT_LoadingDHW
      annotation (Placement(transformation(extent={{46,30},{64,48}})));
    Modelica.Blocks.Sources.Constant const_dT_loading2(k=distributionParameters.dTTraDHW_nominal
           + bivalentControlData.dTHysDHW/2) annotation (Placement(transformation(
          extent={{6,-6},{-6,6}},
          rotation=180,
          origin={26,34})));
      Systems.Hydraulical.Control.Components.HeatPumpNSetController.PI_InverterHeatPumpController
      HP_nSet_Controller_winter_mode(
      P=bivalentControlData.k,
      nMin=bivalentControlData.nMin,
      T_I=bivalentControlData.T_I)   annotation (choicesAllMatching=true,
        Placement(transformation(extent={{92,10},{130,46}})));
  equation
    connect(const_dT_loading2.y, add_dT_LoadingDHW.u2) annotation (Line(points={{32.6,
            34},{40,34},{40,33.6},{44.2,33.6}}, color={0,0,127}));
    connect(supervisoryControlDHW.y, add_dT_LoadingDHW.u1) annotation (Line(
          points={{6.4,45},{25.5,45},{25.5,44.4},{44.2,44.4}}, color={0,0,127}));
    connect(add_dT_LoadingDHW.y, HP_nSet_Controller_winter_mode.T_Set)
      annotation (Line(points={{64.9,39},{64.9,38.8},{88.2,38.8}}, color={0,0,127}));
    connect(HP_nSet_Controller_winter_mode.T_Meas, sigBusGen.THeaPumOut)
      annotation (Line(points={{111,6.4},{110,6.4},{110,-66},{-152,-66},{-152,-99}},
          color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(TSet_DHW.TSet_DHW, supervisoryControlDHW.uLoc) annotation (Line(
          points={{-128.8,36},{-32,36},{-32,36.2},{-22.4,36.2}}, color={0,0,127}));
    connect(sigBusHyd.TSetDHW, supervisoryControlDHW.uSup) annotation (Line(
        points={{-28,101},{-22.4,101},{-22.4,53.8}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{6,3},{6,3}},
        horizontalAlignment=TextAlignment.Left));
    connect(supervisoryControlDHW.actInt, sigBusHyd.overwriteTSetDHW) annotation (
       Line(points={{-22.4,45},{-28,45},{-28,101}}, color={255,0,255}), Text(
        string="%second",
        index=1,
        extent={{6,3},{6,3}},
        horizontalAlignment=TextAlignment.Left));
    connect(HP_nSet_Controller_winter_mode.n_Set, sigBusGen.yHeaPumSet)
      annotation (Line(points={{131.9,28},{148,28},{148,-66},{-152,-66},{-152,-99}},
          color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(sigBusDistr, TSet_DHW.sigBusDistr) annotation (Line(
        points={{1,-100},{0,-100},{0,-118},{-254,-118},{-254,35.88},{-154,35.88}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{6,3},{6,3}},
        horizontalAlignment=TextAlignment.Left));

  end Parameter_fit_control;

  model BES_Test_1
    extends Systems.BaseClasses.PartialBuildingEnergySystem(
      redeclare BESMod.Systems.Electrical.DirectGridConnectionSystem electrical,
      redeclare Systems.Demand.Building.TEASERThermalZone building(redeclare
          BESMod.Systems.Demand.Building.RecordsCollection.RefAachen oneZoneParam(
            heaLoadFacGrd=0, heaLoadFacOut=0)),
      redeclare BESMod.Systems.Control.NoControl control,
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
        redeclare BESMod.Examples.TestControlStrategiesGridConnection.Parameter_fit_control_Thermostatic_9 control(
        redeclare
            BESMod.Systems.Hydraulical.Control.Components.ThermostaticValveController.ThermostaticValvePIControlled
            thermostaticValveController,
          redeclare
            BESMod.Systems.Hydraulical.Control.RecordsCollection.ThermostaticValveDataDefinition
            thermostaticValveParameters,
        redeclare
            Systems.Hydraulical.Control.Components.DHWSetControl.ConstTSet_DHW
            TSet_DHW,
         redeclare
            BESMod.Systems.Hydraulical.Control.RecordsCollection.DefaultBivHPControl
            bivalentControlData(TBiv=parameterStudy.TBiv),
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
        StartTime=15552000,
        StopTime=16416000,
        Interval=599.999616,
        __Dymola_Algorithm="Dassl"));
  end BES_Test_1;

  model Parameter_fit_control_Thermostatic
    extends
      BESMod.Systems.Hydraulical.Control.BaseClasses.SystemWithThermostaticValveControl;

    replaceable
      Systems.Hydraulical.Control.Components.DHWSetControl.BaseClasses.PartialTSet_DHW_Control
      TSet_DHW constrainedby
      Systems.Hydraulical.Control.Components.DHWSetControl.BaseClasses.PartialTSet_DHW_Control(
        final T_DHW=distributionParameters.TDHW_nominal) annotation (
        choicesAllMatching=true, Placement(transformation(extent={{-154,24},{-130,
              48}})));
    Utilities.SupervisoryControl.SupervisoryControl        supervisoryControlDHW(ctrlType=
          supCtrlTypeDHWSet)
      annotation (Placement(transformation(extent={{-20,34},{4,56}})));
      parameter BESMod.Utilities.SupervisoryControl.Types.SupervisoryControlType
      supCtrlTypeDHWSet=BESMod.Utilities.SupervisoryControl.Types.SupervisoryControlType.Local
      "Type of supervisory control for DHW Setpoint";

     replaceable parameter
      Systems.Hydraulical.Control.RecordsCollection.BivalentHeatPumpControlDataDefinition
      bivalentControlData constrainedby
      Systems.Hydraulical.Control.RecordsCollection.BivalentHeatPumpControlDataDefinition(
      final TOda_nominal=generationParameters.TOda_nominal,
      TSup_nominal=generationParameters.TSup_nominal[1],
      TSetRoomConst=sum(transferParameters.TDem_nominal)/transferParameters.nParallelDem);

    Modelica.Blocks.Math.Add add_dT_LoadingDHW
      annotation (Placement(transformation(extent={{46,30},{64,48}})));
    Modelica.Blocks.Sources.Constant const_dT_loading2(k=distributionParameters.dTTraDHW_nominal
           + bivalentControlData.dTHysDHW/2) annotation (Placement(transformation(
          extent={{6,-6},{-6,6}},
          rotation=180,
          origin={26,34})));
      Systems.Hydraulical.Control.Components.HeatPumpNSetController.PI_InverterHeatPumpController
      HP_nSet_Controller_winter_mode(
      P=bivalentControlData.k,
      nMin=bivalentControlData.nMin,
      T_I=bivalentControlData.T_I)   annotation (choicesAllMatching=true,
        Placement(transformation(extent={{92,10},{130,46}})));
    Modelica.Blocks.Sources.BooleanStep                   booleanStep(startTime=
         86400, startValue=false)
      annotation (Placement(transformation(extent={{-18,-10},{2,10}})));
    Modelica.Blocks.Sources.Constant constZero(final k=0) annotation (Placement(
          transformation(
          extent={{10,-10},{-10,10}},
          rotation=180,
          origin={-186,-66})));
    Modelica.Blocks.Logical.Not bufOn "buffer is charged" annotation (Placement(
          transformation(
          extent={{-5,-5},{5,5}},
          rotation=270,
          origin={-67,-1})));
    Modelica.Blocks.Math.BooleanToReal booleanToReal annotation (Placement(
          transformation(
          extent={{-7,-7},{7,7}},
          rotation=270,
          origin={-67,-31})));
    Modelica.Blocks.Sources.Constant constZero1(final k=1)
                                                          annotation (Placement(
          transformation(
          extent={{10,-10},{-10,10}},
          rotation=180,
          origin={-192,-36})));
  equation
    connect(const_dT_loading2.y, add_dT_LoadingDHW.u2) annotation (Line(points={{32.6,
            34},{40,34},{40,33.6},{44.2,33.6}}, color={0,0,127}));
    connect(supervisoryControlDHW.y, add_dT_LoadingDHW.u1) annotation (Line(
          points={{6.4,45},{25.5,45},{25.5,44.4},{44.2,44.4}}, color={0,0,127}));
    connect(add_dT_LoadingDHW.y, HP_nSet_Controller_winter_mode.T_Set)
      annotation (Line(points={{64.9,39},{64.9,38.8},{88.2,38.8}}, color={0,0,127}));
    connect(HP_nSet_Controller_winter_mode.T_Meas, sigBusGen.THeaPumOut)
      annotation (Line(points={{111,6.4},{110,6.4},{110,-66},{-152,-66},{-152,-99}},
          color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(TSet_DHW.TSet_DHW, supervisoryControlDHW.uLoc) annotation (Line(
          points={{-128.8,36},{-32,36},{-32,36.2},{-22.4,36.2}}, color={0,0,127}));
    connect(sigBusHyd.TSetDHW, supervisoryControlDHW.uSup) annotation (Line(
        points={{-28,101},{-22.4,101},{-22.4,53.8}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{6,3},{6,3}},
        horizontalAlignment=TextAlignment.Left));
    connect(supervisoryControlDHW.actInt, sigBusHyd.overwriteTSetDHW) annotation (
       Line(points={{-22.4,45},{-28,45},{-28,101}}, color={255,0,255}), Text(
        string="%second",
        index=1,
        extent={{6,3},{6,3}},
        horizontalAlignment=TextAlignment.Left));
    connect(HP_nSet_Controller_winter_mode.n_Set, sigBusGen.yHeaPumSet)
      annotation (Line(points={{131.9,28},{148,28},{148,-66},{-152,-66},{-152,-99}},
          color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(sigBusDistr, TSet_DHW.sigBusDistr) annotation (Line(
        points={{1,-100},{0,-100},{0,-118},{-254,-118},{-254,35.88},{-154,35.88}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{6,3},{6,3}},
        horizontalAlignment=TextAlignment.Left));

    connect(booleanStep.y, HP_nSet_Controller_winter_mode.HP_On) annotation (
        Line(points={{3,0},{78,0},{78,28},{88.2,28}}, color={255,0,255}));
    connect(booleanStep.y, HP_nSet_Controller_winter_mode.IsOn)
      annotation (Line(points={{3,0},{99.6,0},{99.6,6.4}}, color={255,0,255}));
    connect(constZero.y, sigBusGen.uHeaRod) annotation (Line(points={{-175,-66},
            {-152,-66},{-152,-99}}, color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{-3,-6},{-3,-6}},
        horizontalAlignment=TextAlignment.Right));
    connect(TSet_DHW.y, bufOn.u) annotation (Line(points={{-128.8,29.04},{
            -128.8,28},{-67,28},{-67,5}}, color={255,0,255}));
    connect(bufOn.y, booleanToReal.u)
      annotation (Line(points={{-67,-6.5},{-67,-22.6}}, color={255,0,255}));
    connect(booleanToReal.y, sigBusDistr.uThrWayVal) annotation (Line(points={{
            -67,-38.7},{-67,-58},{1,-58},{1,-100}}, color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{6,3},{6,3}},
        horizontalAlignment=TextAlignment.Left));
    connect(constZero1.y, sigBusGen.uPump) annotation (Line(points={{-181,-36},
            {-166,-36},{-166,-32},{-152,-32},{-152,-99}}, color={0,0,127}),
        Text(
        string="%second",
        index=1,
        extent={{6,3},{6,3}},
        horizontalAlignment=TextAlignment.Left));
  end Parameter_fit_control_Thermostatic;

  model SupervisoryControl_1
    extends Systems.Control.BaseClasses.PartialControl;

   parameter Real B_cons = 3500 "threshold for switching off HP";
    parameter Real B_inj = -3500 "threshold for switching on HP";
    parameter Real SOC_start = 0.5 "boundary condition for SOC";
      parameter Real SOC_stop = 0.7 "boundary condition for SOC";
  end SupervisoryControl_1;

  model Parameter_fit_control_Thermostatic_1
    extends
      BESMod.Systems.Hydraulical.Control.BaseClasses.SystemWithThermostaticValveControl;

    replaceable
      Systems.Hydraulical.Control.Components.DHWSetControl.BaseClasses.PartialTSet_DHW_Control
      TSet_DHW constrainedby
      Systems.Hydraulical.Control.Components.DHWSetControl.BaseClasses.PartialTSet_DHW_Control(
        final T_DHW=distributionParameters.TDHW_nominal) annotation (
        choicesAllMatching=true, Placement(transformation(extent={{-154,72},{
              -130,96}})));
      parameter BESMod.Utilities.SupervisoryControl.Types.SupervisoryControlType
      supCtrlTypeDHWSet=BESMod.Utilities.SupervisoryControl.Types.SupervisoryControlType.Local
      "Type of supervisory control for DHW Setpoint";

     replaceable parameter
      Systems.Hydraulical.Control.RecordsCollection.BivalentHeatPumpControlDataDefinition
      bivalentControlData constrainedby
      Systems.Hydraulical.Control.RecordsCollection.BivalentHeatPumpControlDataDefinition(
      final TOda_nominal=generationParameters.TOda_nominal,
      TSup_nominal=generationParameters.TSup_nominal[1],
      TSetRoomConst=sum(transferParameters.TDem_nominal)/transferParameters.nParallelDem);

    Modelica.Blocks.Math.Add add_dT_LoadingDHW
      annotation (Placement(transformation(extent={{36,44},{54,62}})));
    Modelica.Blocks.Sources.Constant const_dT_loading2(k=distributionParameters.dTTraDHW_nominal
           + bivalentControlData.dTHysDHW/2) annotation (Placement(transformation(
          extent={{6,-6},{-6,6}},
          rotation=180,
          origin={26,34})));
      Systems.Hydraulical.Control.Components.HeatPumpNSetController.PI_InverterHeatPumpController
      HP_nSet_Controller_winter_mode(
      P=bivalentControlData.k,
      nMin=bivalentControlData.nMin,
      T_I=bivalentControlData.T_I)   annotation (choicesAllMatching=true,
        Placement(transformation(extent={{92,10},{130,46}})));
    Modelica.Blocks.Sources.Constant constZero(final k=0) annotation (Placement(
          transformation(
          extent={{10,-10},{-10,10}},
          rotation=180,
          origin={-186,-66})));
    Modelica.Blocks.Logical.Not bufOn "buffer is charged" annotation (Placement(
          transformation(
          extent={{-5,-5},{5,5}},
          rotation=270,
          origin={-67,-1})));
    Modelica.Blocks.Math.BooleanToReal booleanToReal annotation (Placement(
          transformation(
          extent={{-7,-7},{7,7}},
          rotation=270,
          origin={-67,-31})));
      Systems.Hydraulical.Control.Components.OnOffController.ParallelBivalentControl
      DHWOnOffContoller(
      Hysteresis=bivalentControlData.dTHysDHW,
      TCutOff=TCutOff,
      TBiv=bivalentControlData.TBiv,
      TOda_nominal=bivalentControlData.TOda_nominal,
      TRoom=bivalentControlData.TSetRoomConst,
      QDem_flow_nominal=sum(transferParameters.Q_flow_nominal),
      QHP_flow_cutOff=QHP_flow_cutOff)
                        annotation (choicesAllMatching=true, Placement(
          transformation(extent={{-22,68},{-6,84}})));
    parameter Modelica.Units.SI.Temperature TCutOff "Cut-off temperature";
    parameter Modelica.Units.SI.HeatFlowRate QHP_flow_cutOff;

    Modelica.Blocks.Math.BooleanToReal booleanToReal1 "Turn Pump in heat pump on"
                                                     annotation (Placement(
          transformation(
          extent={{-10,-10},{10,10}},
          rotation=270,
          origin={-158,-46})));
    Modelica.Blocks.Logical.Switch switch1
      annotation (Placement(transformation(extent={{-7,-7},{7,7}},
          rotation=0,
          origin={71,39})));
      Systems.Hydraulical.Control.Components.OnOffController.ParallelBivalentControl
      BufferOnOffController(
      Hysteresis=bivalentControlData.dTHysBui,
      TCutOff=TCutOff,
      TBiv=bivalentControlData.TBiv,
      TOda_nominal=bivalentControlData.TOda_nominal,
      TRoom=bivalentControlData.TSetRoomConst,
      QDem_flow_nominal=sum(transferParameters.Q_flow_nominal),
      QHP_flow_cutOff=QHP_flow_cutOff)
                            annotation (choicesAllMatching=true, Placement(
          transformation(extent={{-108,8},{-92,22}})));
    Systems.Hydraulical.Control.Components.HeatingCurve
      heatingCurve(
      GraHeaCurve=bivalentControlData.gradientHeatCurve,
      THeaThres=bivalentControlData.TSetRoomConst,
      dTOffSet_HC=bivalentControlData.dTOffSetHeatCurve)
      annotation (Placement(transformation(extent={{-142,-8},{-122,12}})));
    Modelica.Blocks.Math.MinMax minMax(nu=transferParameters.nParallelDem)
      annotation (Placement(transformation(extent={{-184,4},{-164,24}})));
    Modelica.Blocks.Logical.Or HP_active
                                        annotation (Placement(transformation(
          extent={{-5,-5},{5,5}},
          rotation=0,
          origin={75,63})));
    Modelica.Blocks.Math.Add add_dT_LoadingBuf
      annotation (Placement(transformation(extent={{36,2},{54,20}})));
    Modelica.Blocks.Sources.Constant const_dT_loading1(k=distributionParameters.dTTra_nominal[
          1])                                               annotation (Placement(
          transformation(
          extent={{4,-4},{-4,4}},
          rotation=180,
          origin={24,2})));
    Modelica.Blocks.MathBoolean.Or
                               DHWHysOrLegionella(nu=3)
      "Use the HR if the HP reached its limit" annotation (Placement(
          transformation(
          extent={{-5,-5},{5,5}},
          rotation=0,
          origin={-11,39})));
  equation
    connect(const_dT_loading2.y, add_dT_LoadingDHW.u2) annotation (Line(points={{32.6,34},
            {40,34},{40,47.6},{34.2,47.6}},     color={0,0,127}));
    connect(HP_nSet_Controller_winter_mode.T_Meas, sigBusGen.THeaPumOut)
      annotation (Line(points={{111,6.4},{110,6.4},{110,-66},{-152,-66},{-152,-99}},
          color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(HP_nSet_Controller_winter_mode.n_Set, sigBusGen.yHeaPumSet)
      annotation (Line(points={{131.9,28},{148,28},{148,-66},{-152,-66},{-152,-99}},
          color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(sigBusDistr, TSet_DHW.sigBusDistr) annotation (Line(
        points={{1,-100},{0,-100},{0,-118},{-254,-118},{-254,83.88},{-154,83.88}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{6,3},{6,3}},
        horizontalAlignment=TextAlignment.Left));

    connect(constZero.y, sigBusGen.uHeaRod) annotation (Line(points={{-175,-66},
            {-152,-66},{-152,-99}}, color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{-3,-6},{-3,-6}},
        horizontalAlignment=TextAlignment.Right));
    connect(TSet_DHW.y, bufOn.u) annotation (Line(points={{-128.8,77.04},{
            -128.8,76},{-67,76},{-67,5}}, color={255,0,255}));
    connect(bufOn.y, booleanToReal.u)
      annotation (Line(points={{-67,-6.5},{-67,-22.6}}, color={255,0,255}));
    connect(booleanToReal.y, sigBusDistr.uThrWayVal) annotation (Line(points={{
            -67,-38.7},{-67,-58},{1,-58},{1,-100}}, color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{6,3},{6,3}},
        horizontalAlignment=TextAlignment.Left));
    connect(HP_nSet_Controller_winter_mode.IsOn, sigBusGen.heaPumIsOn)
      annotation (Line(points={{99.6,6.4},{98,6.4},{98,-68},{-152,-68},{-152,-99}},
          color={255,0,255}), Text(
        string="%second",
        index=1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(DHWOnOffContoller.T_Top, sigBusDistr.TStoDHWTopMea) annotation (Line(
          points={{-22.8,81.6},{-22.8,44},{-38,44},{-38,-56},{1,-56},{1,-100}},
          color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{-3,-6},{-3,-6}},
        horizontalAlignment=TextAlignment.Right));
    connect(DHWOnOffContoller.T_bot, sigBusDistr.TStoDHWBotMea) annotation (Line(
          points={{-22.8,72},{-34,72},{-34,-54},{1,-54},{1,-100}}, color={0,0,127}),
        Text(
        string="%second",
        index=1,
        extent={{6,3},{6,3}},
        horizontalAlignment=TextAlignment.Left));
    connect(TSet_DHW.TSet_DHW, DHWOnOffContoller.T_Set) annotation (Line(points={{-128.8,
            84},{-14,84},{-14,67.2}},                   color={0,0,127}));
    connect(DHWOnOffContoller.T_oda, weaBus.TDryBul) annotation (Line(points={{-14,
            84.96},{-14,94},{-248,94},{-248,2},{-237,2}}, color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(add_dT_LoadingDHW.u1, TSet_DHW.TSet_DHW) annotation (Line(points={{
            34.2,58.4},{16,58.4},{16,84},{-128.8,84}}, color={0,0,127}));
    connect(sigBusGen.heaPumIsOn, booleanToReal1.u) annotation (Line(
        points={{-152,-99},{-152,-100},{-142,-100},{-142,-34},{-158,-34}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{-3,-6},{-3,-6}},
        horizontalAlignment=TextAlignment.Right));
    connect(booleanToReal1.y, sigBusGen.uPump) annotation (Line(points={{-158,
            -57},{-158,-64},{-152,-64},{-152,-99}}, color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{6,3},{6,3}},
        horizontalAlignment=TextAlignment.Left));
    connect(switch1.y, HP_nSet_Controller_winter_mode.T_Set) annotation (Line(
          points={{78.7,39},{78.7,38},{80,38},{80,38.8},{88.2,38.8}}, color={0,
            0,127}));
    connect(BufferOnOffController.T_Top, sigBusDistr.TStoBufTopMea) annotation (
        Line(points={{-108.8,19.9},{-110,19.9},{-110,20},{-112,20},{-112,-114},
            {22,-114},{22,-100},{1,-100}},
          color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(heatingCurve.TSet,BufferOnOffController. T_Set) annotation (Line(
          points={{-121,2},{-121,0},{-100,0},{-100,7.3}},
                                                      color={0,0,127}));
    connect(BufferOnOffController.T_bot, sigBusDistr.TStoBufTopMea) annotation (
        Line(points={{-108.8,11.5},{-112,11.5},{-112,-114},{152,-114},{152,-100},
            {1,-100}},           color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(minMax.u, useProBus.TZoneSet) annotation (Line(points={{-184,14},{
            -188,14},{-188,24},{-190,24},{-190,32},{-119,32},{-119,103}},
                                                                     color={0,0,127}),
        Text(
        string="%second",
        index=1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(minMax.yMax,heatingCurve. TSetRoom)
      annotation (Line(points={{-163,20},{-132,20},{-132,14}}, color={0,0,127}));
    connect(heatingCurve.TOda, weaBus.TDryBul) annotation (Line(points={{-144,2},
            {-158,2},{-158,-2},{-210,-2},{-210,2},{-237,2}}, color={0,0,127}),
        Text(
        string="%second",
        index=1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(BufferOnOffController.T_oda, weaBus.TDryBul) annotation (Line(
          points={{-100,22.84},{-100,60},{-237,60},{-237,2}}, color={0,0,127}),
        Text(
        string="%second",
        index=1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(BufferOnOffController.HP_On, HP_active.u2) annotation (Line(points=
            {{-90.88,19.9},{-90.88,18},{12,18},{12,60},{28,60},{28,68},{64,68},
            {64,59},{69,59}}, color={255,0,255}));
    connect(DHWOnOffContoller.HP_On, HP_active.u1) annotation (Line(points={{
            -4.88,81.6},{-4.88,44},{30,44},{30,42},{58,42},{58,56},{60,56},{60,
            63},{69,63}}, color={255,0,255}));
    connect(HP_active.y, HP_nSet_Controller_winter_mode.HP_On) annotation (Line(
          points={{80.5,63},{80.5,28},{88.2,28}}, color={255,0,255}));
    connect(add_dT_LoadingDHW.y, switch1.u1) annotation (Line(points={{54.9,53},
            {54.9,50},{62.6,50},{62.6,44.6}}, color={0,0,127}));
    connect(add_dT_LoadingBuf.u2, const_dT_loading1.y) annotation (Line(points=
            {{34.2,5.6},{30,5.6},{30,2},{28.4,2}}, color={0,0,127}));
    connect(heatingCurve.TSet, add_dT_LoadingBuf.u1) annotation (Line(points={{
            -121,2},{-78,2},{-78,12},{26,12},{26,16.4},{34.2,16.4}}, color={0,0,
            127}));
    connect(add_dT_LoadingBuf.y, switch1.u3) annotation (Line(points={{54.9,11},
            {54.9,10},{62.6,10},{62.6,33.4}}, color={0,0,127}));
    connect(DHWHysOrLegionella.y, switch1.u2) annotation (Line(points={{-5.25,
            39},{14,39},{14,24},{36,24},{36,32},{54,32},{54,39},{62.6,39}},
          color={255,0,255}));
    connect(DHWOnOffContoller.Auxilliar_Heater_On, DHWHysOrLegionella.u[1])
      annotation (Line(points={{-4.88,72},{2,72},{2,30},{-20,30},{-20,37.8333},
            {-16,37.8333}}, color={255,0,255}));
    connect(DHWOnOffContoller.HP_On, DHWHysOrLegionella.u[2]) annotation (Line(
          points={{-4.88,81.6},{-4.88,80},{2,80},{2,30},{-20,30},{-20,39},{-16,
            39}}, color={255,0,255}));
    connect(TSet_DHW.y, DHWHysOrLegionella.u[3]) annotation (Line(points={{-128.8,
            77.04},{-128.8,76},{-66,76},{-66,40.1667},{-16,40.1667}},
          color={255,0,255}));
    annotation (Diagram(graphics={
          Rectangle(
            extent={{-222,30},{-32,-14}},
            lineColor={0,140,72},
            lineThickness=1),
          Text(
            extent={{-198,-42},{-104,-8}},
            lineColor={0,140,72},
            lineThickness=1,
            textString="Buffer Control")}));
  end Parameter_fit_control_Thermostatic_1;

  model Parameter_fit_control_Thermostatic_2
    extends
      BESMod.Systems.Hydraulical.Control.BaseClasses.SystemWithThermostaticValveControl;

    replaceable
      Systems.Hydraulical.Control.Components.DHWSetControl.BaseClasses.PartialTSet_DHW_Control
      TSet_DHW constrainedby
      Systems.Hydraulical.Control.Components.DHWSetControl.BaseClasses.PartialTSet_DHW_Control(
        final T_DHW=distributionParameters.TDHW_nominal) annotation (
        choicesAllMatching=true, Placement(transformation(extent={{-154,72},{
              -130,96}})));
      parameter BESMod.Utilities.SupervisoryControl.Types.SupervisoryControlType
      supCtrlTypeDHWSet=BESMod.Utilities.SupervisoryControl.Types.SupervisoryControlType.Local
      "Type of supervisory control for DHW Setpoint";

     replaceable parameter
      Systems.Hydraulical.Control.RecordsCollection.BivalentHeatPumpControlDataDefinition
      bivalentControlData constrainedby
      Systems.Hydraulical.Control.RecordsCollection.BivalentHeatPumpControlDataDefinition(
      final TOda_nominal=generationParameters.TOda_nominal,
      TSup_nominal=generationParameters.TSup_nominal[1],
      TSetRoomConst=sum(transferParameters.TDem_nominal)/transferParameters.nParallelDem);

    Modelica.Blocks.Math.Add add_dT_LoadingDHW
      annotation (Placement(transformation(extent={{36,44},{54,62}})));
    Modelica.Blocks.Sources.Constant const_dT_loading2(k=distributionParameters.dTTraDHW_nominal
           + bivalentControlData.dTHysDHW/2) annotation (Placement(transformation(
          extent={{6,-6},{-6,6}},
          rotation=180,
          origin={26,34})));
      Systems.Hydraulical.Control.Components.HeatPumpNSetController.PI_InverterHeatPumpController
      HP_nSet_Controller_winter_mode(
      P=bivalentControlData.k,
      nMin=bivalentControlData.nMin,
      T_I=bivalentControlData.T_I)   annotation (choicesAllMatching=true,
        Placement(transformation(extent={{92,10},{130,46}})));
    Modelica.Blocks.Sources.Constant constZero(final k=0) annotation (Placement(
          transformation(
          extent={{10,-10},{-10,10}},
          rotation=180,
          origin={-186,-66})));
    Modelica.Blocks.Logical.Not bufOn "buffer is charged" annotation (Placement(
          transformation(
          extent={{-5,-5},{5,5}},
          rotation=270,
          origin={-67,-1})));
    Modelica.Blocks.Math.BooleanToReal booleanToReal annotation (Placement(
          transformation(
          extent={{-7,-7},{7,7}},
          rotation=270,
          origin={-67,-31})));
      Systems.Hydraulical.Control.Components.OnOffController.ParallelBivalentControl
      DHWOnOffContoller(
      Hysteresis=bivalentControlData.dTHysDHW,
      TCutOff=TCutOff,
      TBiv=bivalentControlData.TBiv,
      TOda_nominal=bivalentControlData.TOda_nominal,
      TRoom=bivalentControlData.TSetRoomConst,
      QDem_flow_nominal=sum(transferParameters.Q_flow_nominal),
      QHP_flow_cutOff=QHP_flow_cutOff)
                        annotation (choicesAllMatching=true, Placement(
          transformation(extent={{-32,32},{-16,48}})));
    parameter Modelica.Units.SI.Temperature TCutOff "Cut-off temperature";
    parameter Modelica.Units.SI.HeatFlowRate QHP_flow_cutOff;

    Modelica.Blocks.Math.BooleanToReal booleanToReal1 "Turn Pump in heat pump on"
                                                     annotation (Placement(
          transformation(
          extent={{-10,-10},{10,10}},
          rotation=270,
          origin={-158,-46})));
    Modelica.Blocks.Logical.Switch switch1
      annotation (Placement(transformation(extent={{-7,-7},{7,7}},
          rotation=0,
          origin={71,39})));
      Systems.Hydraulical.Control.Components.OnOffController.ParallelBivalentControl
      BufferOnOffController(
      Hysteresis=bivalentControlData.dTHysBui,
      TCutOff=TCutOff,
      TBiv=bivalentControlData.TBiv,
      TOda_nominal=bivalentControlData.TOda_nominal,
      TRoom=bivalentControlData.TSetRoomConst,
      QDem_flow_nominal=sum(transferParameters.Q_flow_nominal),
      QHP_flow_cutOff=QHP_flow_cutOff)
                            annotation (choicesAllMatching=true, Placement(
          transformation(extent={{-108,8},{-92,22}})));
    Systems.Hydraulical.Control.Components.HeatingCurve
      heatingCurve(
      GraHeaCurve=bivalentControlData.gradientHeatCurve,
      THeaThres=bivalentControlData.TSetRoomConst,
      dTOffSet_HC=bivalentControlData.dTOffSetHeatCurve)
      annotation (Placement(transformation(extent={{-142,-8},{-122,12}})));
    Modelica.Blocks.Math.MinMax minMax(nu=transferParameters.nParallelDem)
      annotation (Placement(transformation(extent={{-184,4},{-164,24}})));
    Modelica.Blocks.Logical.Or HP_active
                                        annotation (Placement(transformation(
          extent={{-5,-5},{5,5}},
          rotation=0,
          origin={75,63})));
    Modelica.Blocks.Math.Add add_dT_LoadingBuf
      annotation (Placement(transformation(extent={{36,2},{54,20}})));
    Modelica.Blocks.Sources.Constant const_dT_loading1(k=distributionParameters.dTTra_nominal[
          1])                                               annotation (Placement(
          transformation(
          extent={{4,-4},{-4,4}},
          rotation=180,
          origin={24,2})));
  equation
    connect(const_dT_loading2.y, add_dT_LoadingDHW.u2) annotation (Line(points={{32.6,34},
            {40,34},{40,47.6},{34.2,47.6}},     color={0,0,127}));
    connect(HP_nSet_Controller_winter_mode.T_Meas, sigBusGen.THeaPumOut)
      annotation (Line(points={{111,6.4},{110,6.4},{110,-66},{-152,-66},{-152,-99}},
          color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(HP_nSet_Controller_winter_mode.n_Set, sigBusGen.yHeaPumSet)
      annotation (Line(points={{131.9,28},{148,28},{148,-66},{-152,-66},{-152,-99}},
          color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(sigBusDistr, TSet_DHW.sigBusDistr) annotation (Line(
        points={{1,-100},{0,-100},{0,-118},{-254,-118},{-254,83.88},{-154,83.88}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{6,3},{6,3}},
        horizontalAlignment=TextAlignment.Left));

    connect(constZero.y, sigBusGen.uHeaRod) annotation (Line(points={{-175,-66},
            {-152,-66},{-152,-99}}, color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{-3,-6},{-3,-6}},
        horizontalAlignment=TextAlignment.Right));
    connect(TSet_DHW.y, bufOn.u) annotation (Line(points={{-128.8,77.04},{
            -128.8,76},{-67,76},{-67,5}}, color={255,0,255}));
    connect(bufOn.y, booleanToReal.u)
      annotation (Line(points={{-67,-6.5},{-67,-22.6}}, color={255,0,255}));
    connect(booleanToReal.y, sigBusDistr.uThrWayVal) annotation (Line(points={{
            -67,-38.7},{-67,-58},{1,-58},{1,-100}}, color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{6,3},{6,3}},
        horizontalAlignment=TextAlignment.Left));
    connect(HP_nSet_Controller_winter_mode.IsOn, sigBusGen.heaPumIsOn)
      annotation (Line(points={{99.6,6.4},{98,6.4},{98,-68},{-152,-68},{-152,-99}},
          color={255,0,255}), Text(
        string="%second",
        index=1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(DHWOnOffContoller.T_Top, sigBusDistr.TStoDHWTopMea) annotation (Line(
          points={{-32.8,45.6},{-32.8,44},{-38,44},{-38,-56},{1,-56},{1,-100}},
          color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{-3,-6},{-3,-6}},
        horizontalAlignment=TextAlignment.Right));
    connect(DHWOnOffContoller.T_bot, sigBusDistr.TStoDHWBotMea) annotation (Line(
          points={{-32.8,36},{-34,36},{-34,-54},{1,-54},{1,-100}}, color={0,0,127}),
        Text(
        string="%second",
        index=1,
        extent={{6,3},{6,3}},
        horizontalAlignment=TextAlignment.Left));
    connect(TSet_DHW.TSet_DHW, DHWOnOffContoller.T_Set) annotation (Line(points={{-128.8,
            84},{-36,84},{-36,31.2},{-24,31.2}},        color={0,0,127}));
    connect(DHWOnOffContoller.T_oda, weaBus.TDryBul) annotation (Line(points={{-24,
            48.96},{-24,60},{-236,60},{-236,2},{-237,2}}, color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(add_dT_LoadingDHW.u1, TSet_DHW.TSet_DHW) annotation (Line(points={{
            34.2,58.4},{16,58.4},{16,84},{-128.8,84}}, color={0,0,127}));
    connect(sigBusGen.heaPumIsOn, booleanToReal1.u) annotation (Line(
        points={{-152,-99},{-152,-100},{-142,-100},{-142,-34},{-158,-34}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{-3,-6},{-3,-6}},
        horizontalAlignment=TextAlignment.Right));
    connect(booleanToReal1.y, sigBusGen.uPump) annotation (Line(points={{-158,
            -57},{-158,-64},{-152,-64},{-152,-99}}, color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{6,3},{6,3}},
        horizontalAlignment=TextAlignment.Left));
    connect(switch1.y, HP_nSet_Controller_winter_mode.T_Set) annotation (Line(
          points={{78.7,39},{78.7,38},{80,38},{80,38.8},{88.2,38.8}}, color={0,
            0,127}));
    connect(BufferOnOffController.T_Top, sigBusDistr.TStoBufTopMea) annotation (
        Line(points={{-108.8,19.9},{-110,19.9},{-110,20},{-112,20},{-112,-114},
            {22,-114},{22,-100},{1,-100}},
          color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(heatingCurve.TSet,BufferOnOffController. T_Set) annotation (Line(
          points={{-121,2},{-121,0},{-100,0},{-100,7.3}},
                                                      color={0,0,127}));
    connect(BufferOnOffController.T_bot, sigBusDistr.TStoBufTopMea) annotation (
        Line(points={{-108.8,11.5},{-112,11.5},{-112,-114},{152,-114},{152,-100},
            {1,-100}},           color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(minMax.u, useProBus.TZoneSet) annotation (Line(points={{-184,14},{
            -188,14},{-188,24},{-190,24},{-190,32},{-119,32},{-119,103}},
                                                                     color={0,0,127}),
        Text(
        string="%second",
        index=1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(minMax.yMax,heatingCurve. TSetRoom)
      annotation (Line(points={{-163,20},{-132,20},{-132,14}}, color={0,0,127}));
    connect(heatingCurve.TOda, weaBus.TDryBul) annotation (Line(points={{-144,2},
            {-158,2},{-158,-2},{-210,-2},{-210,2},{-237,2}}, color={0,0,127}),
        Text(
        string="%second",
        index=1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(BufferOnOffController.T_oda, weaBus.TDryBul) annotation (Line(
          points={{-100,22.84},{-100,60},{-237,60},{-237,2}}, color={0,0,127}),
        Text(
        string="%second",
        index=1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(BufferOnOffController.HP_On, HP_active.u2) annotation (Line(points=
            {{-90.88,19.9},{-90.88,18},{12,18},{12,60},{28,60},{28,68},{64,68},
            {64,59},{69,59}}, color={255,0,255}));
    connect(DHWOnOffContoller.HP_On, HP_active.u1) annotation (Line(points={{
            -14.88,45.6},{-14.88,44},{30,44},{30,42},{58,42},{58,56},{60,56},{
            60,63},{69,63}}, color={255,0,255}));
    connect(HP_active.y, HP_nSet_Controller_winter_mode.HP_On) annotation (Line(
          points={{80.5,63},{80.5,28},{88.2,28}}, color={255,0,255}));
    connect(add_dT_LoadingDHW.y, switch1.u1) annotation (Line(points={{54.9,53},
            {54.9,50},{62.6,50},{62.6,44.6}}, color={0,0,127}));
    connect(add_dT_LoadingBuf.u2, const_dT_loading1.y) annotation (Line(points=
            {{34.2,5.6},{30,5.6},{30,2},{28.4,2}}, color={0,0,127}));
    connect(heatingCurve.TSet, add_dT_LoadingBuf.u1) annotation (Line(points={{
            -121,2},{-78,2},{-78,12},{26,12},{26,16.4},{34.2,16.4}}, color={0,0,
            127}));
    annotation (Diagram(graphics={
          Rectangle(
            extent={{-222,30},{-32,-14}},
            lineColor={0,140,72},
            lineThickness=1),
          Text(
            extent={{-198,-42},{-104,-8}},
            lineColor={0,140,72},
            lineThickness=1,
            textString="Buffer Control")}));
  end Parameter_fit_control_Thermostatic_2;

  model Parameter_fit_control_Thermostatic_3
    extends
      BESMod.Systems.Hydraulical.Control.BaseClasses.SystemWithThermostaticValveControl;

    replaceable
      Systems.Hydraulical.Control.Components.DHWSetControl.BaseClasses.PartialTSet_DHW_Control
      TSet_DHW constrainedby
      Systems.Hydraulical.Control.Components.DHWSetControl.BaseClasses.PartialTSet_DHW_Control(
        final T_DHW=distributionParameters.TDHW_nominal) annotation (
        choicesAllMatching=true, Placement(transformation(extent={{-154,24},{-130,
              48}})));
      parameter BESMod.Utilities.SupervisoryControl.Types.SupervisoryControlType
      supCtrlTypeDHWSet=BESMod.Utilities.SupervisoryControl.Types.SupervisoryControlType.Local
      "Type of supervisory control for DHW Setpoint";

     replaceable parameter
      Systems.Hydraulical.Control.RecordsCollection.BivalentHeatPumpControlDataDefinition
      bivalentControlData constrainedby
      Systems.Hydraulical.Control.RecordsCollection.BivalentHeatPumpControlDataDefinition(
      final TOda_nominal=generationParameters.TOda_nominal,
      TSup_nominal=generationParameters.TSup_nominal[1],
      TSetRoomConst=sum(transferParameters.TDem_nominal)/transferParameters.nParallelDem);

    Modelica.Blocks.Math.Add add_dT_LoadingDHW
      annotation (Placement(transformation(extent={{46,30},{64,48}})));
    Modelica.Blocks.Sources.Constant const_dT_loading2(k=distributionParameters.dTTraDHW_nominal
           + bivalentControlData.dTHysDHW/2) annotation (Placement(transformation(
          extent={{6,-6},{-6,6}},
          rotation=180,
          origin={26,34})));
      Systems.Hydraulical.Control.Components.HeatPumpNSetController.PI_InverterHeatPumpController
      HP_nSet_Controller_winter_mode(
      P=bivalentControlData.k,
      nMin=bivalentControlData.nMin,
      T_I=bivalentControlData.T_I)   annotation (choicesAllMatching=true,
        Placement(transformation(extent={{92,10},{130,46}})));
    Modelica.Blocks.Sources.Constant constZero(final k=0) annotation (Placement(
          transformation(
          extent={{10,-10},{-10,10}},
          rotation=180,
          origin={-186,-66})));
    Modelica.Blocks.Logical.Not bufOn "buffer is charged" annotation (Placement(
          transformation(
          extent={{-5,-5},{5,5}},
          rotation=270,
          origin={-67,-1})));
    Modelica.Blocks.Math.BooleanToReal booleanToReal annotation (Placement(
          transformation(
          extent={{-7,-7},{7,7}},
          rotation=270,
          origin={-67,-31})));
      Systems.Hydraulical.Control.Components.OnOffController.ParallelBivalentControl
      DHWOnOffContoller(
      Hysteresis=bivalentControlData.dTHysDHW,
      TCutOff=TCutOff,
      TBiv=bivalentControlData.TBiv,
      TOda_nominal=bivalentControlData.TOda_nominal,
      TRoom=bivalentControlData.TSetRoomConst,
      QDem_flow_nominal=sum(transferParameters.Q_flow_nominal),
      QHP_flow_cutOff=QHP_flow_cutOff)
                        annotation (choicesAllMatching=true, Placement(
          transformation(extent={{-82,40},{-66,56}})));

      parameter Modelica.Units.SI.Temperature TCutOff "Cut-off temperature";
      parameter Modelica.Units.SI.HeatFlowRate QHP_flow_cutOff;

    Modelica.Blocks.Math.BooleanToReal booleanToReal1 "Turn Pump in heat pump on"
                                                     annotation (Placement(
          transformation(
          extent={{-10,-10},{10,10}},
          rotation=270,
          origin={-126,-42})));
    Modelica.Blocks.Logical.Switch safety_switch
      annotation (Placement(transformation(extent={{168,18},{188,38}})));
    Modelica.Blocks.Sources.Constant heatPump_off(k=0) annotation (Placement(
          transformation(
          extent={{6,-6},{-6,6}},
          rotation=180,
          origin={144,18})));
    Modelica.Blocks.Logical.LessThreshold lessThreshold(threshold=333.15)
      annotation (Placement(transformation(extent={{152,-20},{172,0}})));
  equation
    connect(const_dT_loading2.y, add_dT_LoadingDHW.u2) annotation (Line(points={{32.6,
            34},{40,34},{40,33.6},{44.2,33.6}}, color={0,0,127}));
    connect(add_dT_LoadingDHW.y, HP_nSet_Controller_winter_mode.T_Set)
      annotation (Line(points={{64.9,39},{64.9,38.8},{88.2,38.8}}, color={0,0,127}));
    connect(HP_nSet_Controller_winter_mode.T_Meas, sigBusGen.THeaPumOut)
      annotation (Line(points={{111,6.4},{110,6.4},{110,-66},{-152,-66},{-152,-99}},
          color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(sigBusDistr, TSet_DHW.sigBusDistr) annotation (Line(
        points={{1,-100},{0,-100},{0,-118},{-254,-118},{-254,35.88},{-154,35.88}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{6,3},{6,3}},
        horizontalAlignment=TextAlignment.Left));

    connect(constZero.y, sigBusGen.uHeaRod) annotation (Line(points={{-175,-66},
            {-152,-66},{-152,-99}}, color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{-3,-6},{-3,-6}},
        horizontalAlignment=TextAlignment.Right));
    connect(TSet_DHW.y, bufOn.u) annotation (Line(points={{-128.8,29.04},{
            -128.8,28},{-67,28},{-67,5}}, color={255,0,255}));
    connect(bufOn.y, booleanToReal.u)
      annotation (Line(points={{-67,-6.5},{-67,-22.6}}, color={255,0,255}));
    connect(booleanToReal.y, sigBusDistr.uThrWayVal) annotation (Line(points={{
            -67,-38.7},{-67,-58},{1,-58},{1,-100}}, color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{6,3},{6,3}},
        horizontalAlignment=TextAlignment.Left));
    connect(DHWOnOffContoller.Auxilliar_Heater_set, add_dT_LoadingDHW.u1)
      annotation (Line(points={{-64.88,41.12},{-64.88,56},{36,56},{36,44.4},{44.2,
            44.4}}, color={0,0,127}));
    connect(DHWOnOffContoller.T_bot, sigBusDistr.TStoDHWTopMea) annotation (Line(
          points={{-82.8,44},{-88,44},{-88,30},{-24,30},{-24,-56},{1,-56},{1,-100}},
          color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{6,3},{6,3}},
        horizontalAlignment=TextAlignment.Left));
    connect(DHWOnOffContoller.T_Top, sigBusDistr.TStoDHWTopMea) annotation (Line(
          points={{-82.8,53.6},{-82.8,52},{-88,52},{-88,30},{-24,30},{-24,-56},{1,
            -56},{1,-100}}, color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{-3,-6},{-3,-6}},
        horizontalAlignment=TextAlignment.Right));
    connect(DHWOnOffContoller.T_oda, weaBus.TDryBul) annotation (Line(points={{-74,
            56.96},{-74,72},{-238,72},{-238,2},{-237,2}}, color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(TSet_DHW.TSet_DHW, DHWOnOffContoller.T_Set) annotation (Line(points={{
            -128.8,36},{-86,36},{-86,34},{-74,34},{-74,39.2}}, color={0,0,127}));
    connect(HP_nSet_Controller_winter_mode.IsOn, sigBusGen.heaPumIsOn)
      annotation (Line(points={{99.6,6.4},{98,6.4},{98,-64},{78,-64},{78,-68},{
            -152,-68},{-152,-99}}, color={255,0,255}), Text(
        string="%second",
        index=1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(DHWOnOffContoller.HP_On, HP_nSet_Controller_winter_mode.HP_On)
      annotation (Line(points={{-64.88,53.6},{-64.88,46},{8,46},{8,18},{72,18},
            {72,28},{88.2,28}}, color={255,0,255}));
    connect(booleanToReal1.u, sigBusGen.heaPumIsOn) annotation (Line(points={{
            -126,-30},{-126,-24},{-152,-24},{-152,-99}}, color={255,0,255}),
        Text(
        string="%second",
        index=1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(booleanToReal1.y, sigBusGen.uPump) annotation (Line(points={{-126,
            -53},{-126,-72},{-152,-72},{-152,-99}}, color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(HP_nSet_Controller_winter_mode.n_Set, safety_switch.u1) annotation (
       Line(points={{131.9,28},{158,28},{158,36},{166,36}}, color={0,0,127}));
    connect(safety_switch.y, sigBusGen.yHeaPumSet) annotation (Line(points={{
            189,28},{194,28},{194,-46},{-110,-46},{-110,-22},{-152,-22},{-152,
            -99}}, color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(heatPump_off.y, safety_switch.u3) annotation (Line(points={{150.6,
            18},{150.6,20},{166,20}}, color={0,0,127}));
    connect(lessThreshold.y, safety_switch.u2) annotation (Line(points={{173,
            -10},{178,-10},{178,12},{160,12},{160,28},{166,28}}, color={255,0,
            255}));
    connect(lessThreshold.u, sigBusGen.THeaPumIn) annotation (Line(points={{150,
            -10},{-152,-10},{-152,-99}}, color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
  end Parameter_fit_control_Thermostatic_3;

  model Parameter_fit_control_Thermostatic_4
    extends
      BESMod.Systems.Hydraulical.Control.BaseClasses.SystemWithThermostaticValveControl;

    replaceable
      Systems.Hydraulical.Control.Components.DHWSetControl.BaseClasses.PartialTSet_DHW_Control
      TSet_DHW constrainedby
      Systems.Hydraulical.Control.Components.DHWSetControl.BaseClasses.PartialTSet_DHW_Control(
        final T_DHW=distributionParameters.TDHW_nominal) annotation (
        choicesAllMatching=true, Placement(transformation(extent={{-154,24},{-130,
              48}})));
      parameter BESMod.Utilities.SupervisoryControl.Types.SupervisoryControlType
      supCtrlTypeDHWSet=BESMod.Utilities.SupervisoryControl.Types.SupervisoryControlType.Local
      "Type of supervisory control for DHW Setpoint";

     replaceable parameter
      Systems.Hydraulical.Control.RecordsCollection.BivalentHeatPumpControlDataDefinition
      bivalentControlData constrainedby
      Systems.Hydraulical.Control.RecordsCollection.BivalentHeatPumpControlDataDefinition(
      final TOda_nominal=generationParameters.TOda_nominal,
      TSup_nominal=generationParameters.TSup_nominal[1],
      TSetRoomConst=sum(transferParameters.TDem_nominal)/transferParameters.nParallelDem);

    Modelica.Blocks.Math.Add add_dT_LoadingDHW
      annotation (Placement(transformation(extent={{46,30},{64,48}})));
    Modelica.Blocks.Sources.Constant const_dT_loading2(k=distributionParameters.dTTraDHW_nominal
           + bivalentControlData.dTHysDHW/2) annotation (Placement(transformation(
          extent={{6,-6},{-6,6}},
          rotation=180,
          origin={26,34})));
      Systems.Hydraulical.Control.Components.HeatPumpNSetController.PI_InverterHeatPumpController
      HP_nSet_Controller_winter_mode(
      P=bivalentControlData.k,
      nMin=bivalentControlData.nMin,
      T_I=bivalentControlData.T_I)   annotation (choicesAllMatching=true,
        Placement(transformation(extent={{92,10},{130,46}})));
    Modelica.Blocks.Sources.Constant constZero(final k=0) annotation (Placement(
          transformation(
          extent={{10,-10},{-10,10}},
          rotation=180,
          origin={-186,-66})));
    Modelica.Blocks.Logical.Not bufOn "buffer is charged" annotation (Placement(
          transformation(
          extent={{-5,-5},{5,5}},
          rotation=270,
          origin={-67,-1})));
    Modelica.Blocks.Math.BooleanToReal booleanToReal annotation (Placement(
          transformation(
          extent={{-7,-7},{7,7}},
          rotation=270,
          origin={-67,-31})));
      Systems.Hydraulical.Control.Components.OnOffController.ParallelBivalentControl
      DHWOnOffContoller(
      Hysteresis=bivalentControlData.dTHysDHW,
      TCutOff=TCutOff,
      TBiv=bivalentControlData.TBiv,
      TOda_nominal=bivalentControlData.TOda_nominal,
      TRoom=bivalentControlData.TSetRoomConst,
      QDem_flow_nominal=sum(transferParameters.Q_flow_nominal),
      QHP_flow_cutOff=QHP_flow_cutOff)
                        annotation (choicesAllMatching=true, Placement(
          transformation(extent={{-82,40},{-66,56}})));

      parameter Modelica.Units.SI.Temperature TCutOff "Cut-off temperature";
      parameter Modelica.Units.SI.HeatFlowRate QHP_flow_cutOff;

      parameter Boolean use_opeEnv=true
      "False to allow HP to run out of operational envelope"
      annotation (Dialog(group="Operational Envelope"), choices(checkBox=true));
      parameter DataBase.HeatPump.HeatPumpBaseDataDefinition
      dataTable "Data Table of HP" annotation (Dialog(group=
            "Operational Envelope", enable=use_opeEnv and use_opeEnvFroRec),
        choicesAllMatching=true);
      parameter Real tableUpp[:,2] "Upper boundary of envelope"
      annotation (Dialog(group="Operational Envelope", enable=use_opeEnv and not use_opeEnvFroRec));
      parameter Modelica.Units.SI.TemperatureDifference dTHystOperEnv=5
      "Temperature difference used for both upper and lower hysteresis in the operational envelope."
      annotation (Dialog(group="Operational Envelope", enable=use_opeEnv));

    Modelica.Blocks.Math.BooleanToReal booleanToReal1 "Turn Pump in heat pump on"
                                                     annotation (Placement(
          transformation(
          extent={{-10,-10},{10,10}},
          rotation=270,
          origin={-126,-42})));
    Modelica.Blocks.Logical.Switch safety_switch
      annotation (Placement(transformation(extent={{168,18},{188,38}})));
    Modelica.Blocks.Sources.Constant heatPump_off(k=0) annotation (Placement(
          transformation(
          extent={{6,-6},{-6,6}},
          rotation=180,
          origin={144,18})));
    AixLib.Controls.HeatPump.SafetyControls.BaseClasses.BoundaryMap
                            boundaryMap(
      final tableUpp=tableUpp,
      final use_opeEnvFroRec=use_opeEnvFroRec,
      final dataTable=dataTable,
      final dx=dTHyst)
                    if use_opeEnv
      annotation (Placement(transformation(extent={{168,56},{182,70}})));
    Modelica.Blocks.Math.UnitConversions.To_degC toDegCT_flow_ev annotation (
        extent=[-88,38; -76,50], Placement(transformation(extent={{144,60},{156,72}})));
      Modelica.Blocks.Math.UnitConversions.To_degC toDegCT_ret_co annotation (
        extent=[-88,38; -76,50], Placement(transformation(extent={{144,44},{156,56}})));
    Systems.Hydraulical.Control.Components.HeatPumpBusPassThrough heatPumpBusPassThrough
      annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=180,
          origin={-184,-34})));
    AixLib.Controls.Interfaces.VapourCompressionMachineControlBus
                                                  sigBusHP
      "Bus-connector for the heat pump"
      annotation (Placement(transformation(extent={{-238,-48},{-204,-18}})));
    replaceable Systems.Hydraulical.Control.RecordsCollection.HeatPumpSafetyControl
      safetyControl
      annotation (choicesAllMatching=true,Placement(transformation(extent={{196,72},
              {216,92}})));
  equation
    connect(const_dT_loading2.y, add_dT_LoadingDHW.u2) annotation (Line(points={{32.6,
            34},{40,34},{40,33.6},{44.2,33.6}}, color={0,0,127}));
    connect(add_dT_LoadingDHW.y, HP_nSet_Controller_winter_mode.T_Set)
      annotation (Line(points={{64.9,39},{64.9,38.8},{88.2,38.8}}, color={0,0,127}));
    connect(HP_nSet_Controller_winter_mode.T_Meas, sigBusGen.THeaPumOut)
      annotation (Line(points={{111,6.4},{110,6.4},{110,-66},{-152,-66},{-152,-99}},
          color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(sigBusDistr, TSet_DHW.sigBusDistr) annotation (Line(
        points={{1,-100},{0,-100},{0,-118},{-254,-118},{-254,35.88},{-154,35.88}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{6,3},{6,3}},
        horizontalAlignment=TextAlignment.Left));

    connect(constZero.y, sigBusGen.uHeaRod) annotation (Line(points={{-175,-66},
            {-152,-66},{-152,-99}}, color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{-3,-6},{-3,-6}},
        horizontalAlignment=TextAlignment.Right));
    connect(TSet_DHW.y, bufOn.u) annotation (Line(points={{-128.8,29.04},{
            -128.8,28},{-67,28},{-67,5}}, color={255,0,255}));
    connect(bufOn.y, booleanToReal.u)
      annotation (Line(points={{-67,-6.5},{-67,-22.6}}, color={255,0,255}));
    connect(booleanToReal.y, sigBusDistr.uThrWayVal) annotation (Line(points={{
            -67,-38.7},{-67,-58},{1,-58},{1,-100}}, color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{6,3},{6,3}},
        horizontalAlignment=TextAlignment.Left));
    connect(DHWOnOffContoller.Auxilliar_Heater_set, add_dT_LoadingDHW.u1)
      annotation (Line(points={{-64.88,41.12},{-64.88,56},{36,56},{36,44.4},{44.2,
            44.4}}, color={0,0,127}));
    connect(DHWOnOffContoller.T_bot, sigBusDistr.TStoDHWTopMea) annotation (Line(
          points={{-82.8,44},{-88,44},{-88,30},{-24,30},{-24,-56},{1,-56},{1,-100}},
          color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{6,3},{6,3}},
        horizontalAlignment=TextAlignment.Left));
    connect(DHWOnOffContoller.T_Top, sigBusDistr.TStoDHWTopMea) annotation (Line(
          points={{-82.8,53.6},{-82.8,52},{-88,52},{-88,30},{-24,30},{-24,-56},{1,
            -56},{1,-100}}, color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{-3,-6},{-3,-6}},
        horizontalAlignment=TextAlignment.Right));
    connect(DHWOnOffContoller.T_oda, weaBus.TDryBul) annotation (Line(points={{-74,
            56.96},{-74,72},{-238,72},{-238,2},{-237,2}}, color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(TSet_DHW.TSet_DHW, DHWOnOffContoller.T_Set) annotation (Line(points={{
            -128.8,36},{-86,36},{-86,34},{-74,34},{-74,39.2}}, color={0,0,127}));
    connect(HP_nSet_Controller_winter_mode.IsOn, sigBusGen.heaPumIsOn)
      annotation (Line(points={{99.6,6.4},{98,6.4},{98,-64},{78,-64},{78,-68},{
            -152,-68},{-152,-99}}, color={255,0,255}), Text(
        string="%second",
        index=1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(DHWOnOffContoller.HP_On, HP_nSet_Controller_winter_mode.HP_On)
      annotation (Line(points={{-64.88,53.6},{-64.88,46},{8,46},{8,18},{72,18},{72,
            28},{88.2,28}},     color={255,0,255}));
    connect(booleanToReal1.u, sigBusGen.heaPumIsOn) annotation (Line(points={{-126,
            -30},{-126,-24},{-152,-24},{-152,-99}}, color={255,0,255}), Text(
        string="%second",
        index=1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(booleanToReal1.y, sigBusGen.uPump) annotation (Line(points={{-126,-53},
            {-126,-72},{-152,-72},{-152,-99}}, color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(HP_nSet_Controller_winter_mode.n_Set, safety_switch.u1) annotation (
        Line(points={{131.9,28},{158,28},{158,36},{166,36}}, color={0,0,127}));
    connect(safety_switch.y, sigBusGen.yHeaPumSet) annotation (Line(points={{189,28},
            {194,28},{194,-46},{-110,-46},{-110,-22},{-152,-22},{-152,-99}},
          color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(heatPump_off.y, safety_switch.u3) annotation (Line(points={{150.6,18},
            {150.6,20},{166,20}}, color={0,0,127}));
    connect(boundaryMap.noErr, safety_switch.u2) annotation (Line(points={{182.7,63},
            {182.7,62},{188,62},{188,44},{160,44},{160,28},{166,28}}, color={255,0,
            255}));
    connect(toDegCT_flow_ev.y, boundaryMap.x_in) annotation (Line(points={{156.6,66},
            {156.6,67.2},{167.02,67.2}}, color={0,0,127}));
    connect(toDegCT_ret_co.y, boundaryMap.y_in) annotation (Line(points={{156.6,50},
            {160,50},{160,58.8},{167.02,58.8}}, color={0,0,127}));
    connect(heatPumpBusPassThrough.sigBusGen, sigBusGen) annotation (Line(
        points={{-174,-34},{-152,-34},{-152,-99}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%second",
        index=1,
        extent={{6,3},{6,3}},
        horizontalAlignment=TextAlignment.Left));
    connect(heatPumpBusPassThrough.vapourCompressionMachineControlBus, sigBusHP)
      annotation (Line(
        points={{-194.2,-33.8},{-194.2,-33},{-221,-33}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%second",
        index=1,
        extent={{-3,6},{-3,6}},
        horizontalAlignment=TextAlignment.Right));
    connect(toDegCT_flow_ev.u, sigBusHP.TEvaInMea) annotation (Line(points={{142.8,
            66},{-220.915,66},{-220.915,-32.925}}, color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(toDegCT_ret_co.u, sigBusHP.TConOutMea) annotation (Line(points={{142.8,
            50},{76,50},{76,62},{-192,62},{-192,-10},{-206,-10},{-206,-32.925},{-220.915,
            -32.925}}, color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
  end Parameter_fit_control_Thermostatic_4;

  model Parameter_fit_control_Thermostatic_5
    extends
      BESMod.Systems.Hydraulical.Control.BaseClasses.SystemWithThermostaticValveControl;

    replaceable
      Systems.Hydraulical.Control.Components.DHWSetControl.BaseClasses.PartialTSet_DHW_Control
      TSet_DHW constrainedby
      Systems.Hydraulical.Control.Components.DHWSetControl.BaseClasses.PartialTSet_DHW_Control(
        final T_DHW=distributionParameters.TDHW_nominal) annotation (
        choicesAllMatching=true, Placement(transformation(extent={{-154,24},{-130,
              48}})));
      parameter BESMod.Utilities.SupervisoryControl.Types.SupervisoryControlType
      supCtrlTypeDHWSet=BESMod.Utilities.SupervisoryControl.Types.SupervisoryControlType.Local
      "Type of supervisory control for DHW Setpoint";

     replaceable parameter
      Systems.Hydraulical.Control.RecordsCollection.BivalentHeatPumpControlDataDefinition
      bivalentControlData constrainedby
      Systems.Hydraulical.Control.RecordsCollection.BivalentHeatPumpControlDataDefinition(
      final TOda_nominal=generationParameters.TOda_nominal,
      TSup_nominal=generationParameters.TSup_nominal[1],
      TSetRoomConst=sum(transferParameters.TDem_nominal)/transferParameters.nParallelDem);

    Modelica.Blocks.Math.Add add_dT_LoadingDHW
      annotation (Placement(transformation(extent={{46,30},{64,48}})));
    Modelica.Blocks.Sources.Constant const_dT_loading2(k=distributionParameters.dTTraDHW_nominal
           + bivalentControlData.dTHysDHW/2) annotation (Placement(transformation(
          extent={{6,-6},{-6,6}},
          rotation=180,
          origin={26,34})));
      Systems.Hydraulical.Control.Components.HeatPumpNSetController.PI_InverterHeatPumpController
      HP_nSet_Controller_winter_mode(
      P=bivalentControlData.k,
      nMin=bivalentControlData.nMin,
      T_I=bivalentControlData.T_I)   annotation (choicesAllMatching=true,
        Placement(transformation(extent={{92,10},{130,46}})));
    Modelica.Blocks.Sources.Constant constZero(final k=0) annotation (Placement(
          transformation(
          extent={{10,-10},{-10,10}},
          rotation=180,
          origin={-186,-66})));
    Modelica.Blocks.Logical.Not bufOn "buffer is charged" annotation (Placement(
          transformation(
          extent={{-5,-5},{5,5}},
          rotation=270,
          origin={-67,-1})));
    Modelica.Blocks.Math.BooleanToReal booleanToReal annotation (Placement(
          transformation(
          extent={{-7,-7},{7,7}},
          rotation=270,
          origin={-67,-31})));
      Systems.Hydraulical.Control.Components.OnOffController.ParallelBivalentControl
      DHWOnOffContoller(
      Hysteresis=bivalentControlData.dTHysDHW,
      TCutOff=TCutOff,
      TBiv=bivalentControlData.TBiv,
      TOda_nominal=bivalentControlData.TOda_nominal,
      TRoom=bivalentControlData.TSetRoomConst,
      QDem_flow_nominal=sum(transferParameters.Q_flow_nominal),
      QHP_flow_cutOff=QHP_flow_cutOff)
                        annotation (choicesAllMatching=true, Placement(
          transformation(extent={{-82,40},{-66,56}})));

      parameter Modelica.Units.SI.Temperature TCutOff "Cut-off temperature";
      parameter Modelica.Units.SI.HeatFlowRate QHP_flow_cutOff;

    Modelica.Blocks.Math.BooleanToReal booleanToReal1 "Turn Pump in heat pump on"
                                                     annotation (Placement(
          transformation(
          extent={{-10,-10},{10,10}},
          rotation=270,
          origin={-126,-42})));
    Modelica.Blocks.Logical.Switch safety_switch
      annotation (Placement(transformation(extent={{168,18},{188,38}})));
    Modelica.Blocks.Sources.Constant heatPump_off(k=0) annotation (Placement(
          transformation(
          extent={{6,-6},{-6,6}},
          rotation=180,
          origin={144,18})));
    Modelica.Blocks.Logical.Hysteresis hysteresis(
      uLow=333.15,
      uHigh=343.15,
      pre_y_start=false)
      annotation (Placement(transformation(extent={{30,-40},{50,-20}})));
    Modelica.Blocks.Logical.LessThreshold lessThreshold(threshold=333.15)
      annotation (Placement(transformation(extent={{4,-10},{16,2}})));
    Modelica.Blocks.Logical.And and1
      annotation (Placement(transformation(extent={{70,-44},{80,-34}})));
  equation
    connect(const_dT_loading2.y, add_dT_LoadingDHW.u2) annotation (Line(points={{32.6,
            34},{40,34},{40,33.6},{44.2,33.6}}, color={0,0,127}));
    connect(add_dT_LoadingDHW.y, HP_nSet_Controller_winter_mode.T_Set)
      annotation (Line(points={{64.9,39},{64.9,38.8},{88.2,38.8}}, color={0,0,127}));
    connect(HP_nSet_Controller_winter_mode.T_Meas, sigBusGen.THeaPumOut)
      annotation (Line(points={{111,6.4},{110,6.4},{110,-66},{-152,-66},{-152,-99}},
          color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(sigBusDistr, TSet_DHW.sigBusDistr) annotation (Line(
        points={{1,-100},{0,-100},{0,-118},{-254,-118},{-254,35.88},{-154,35.88}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{6,3},{6,3}},
        horizontalAlignment=TextAlignment.Left));

    connect(constZero.y, sigBusGen.uHeaRod) annotation (Line(points={{-175,-66},
            {-152,-66},{-152,-99}}, color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{-3,-6},{-3,-6}},
        horizontalAlignment=TextAlignment.Right));
    connect(TSet_DHW.y, bufOn.u) annotation (Line(points={{-128.8,29.04},{
            -128.8,28},{-67,28},{-67,5}}, color={255,0,255}));
    connect(bufOn.y, booleanToReal.u)
      annotation (Line(points={{-67,-6.5},{-67,-22.6}}, color={255,0,255}));
    connect(booleanToReal.y, sigBusDistr.uThrWayVal) annotation (Line(points={{
            -67,-38.7},{-67,-58},{1,-58},{1,-100}}, color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{6,3},{6,3}},
        horizontalAlignment=TextAlignment.Left));
    connect(DHWOnOffContoller.Auxilliar_Heater_set, add_dT_LoadingDHW.u1)
      annotation (Line(points={{-64.88,41.12},{-64.88,56},{36,56},{36,44.4},{44.2,
            44.4}}, color={0,0,127}));
    connect(DHWOnOffContoller.T_bot, sigBusDistr.TStoDHWTopMea) annotation (Line(
          points={{-82.8,44},{-88,44},{-88,30},{-24,30},{-24,-56},{1,-56},{1,-100}},
          color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{6,3},{6,3}},
        horizontalAlignment=TextAlignment.Left));
    connect(DHWOnOffContoller.T_Top, sigBusDistr.TStoDHWTopMea) annotation (Line(
          points={{-82.8,53.6},{-82.8,52},{-88,52},{-88,30},{-24,30},{-24,-56},{1,
            -56},{1,-100}}, color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{-3,-6},{-3,-6}},
        horizontalAlignment=TextAlignment.Right));
    connect(DHWOnOffContoller.T_oda, weaBus.TDryBul) annotation (Line(points={{-74,
            56.96},{-74,72},{-238,72},{-238,2},{-237,2}}, color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(TSet_DHW.TSet_DHW, DHWOnOffContoller.T_Set) annotation (Line(points={{
            -128.8,36},{-86,36},{-86,34},{-74,34},{-74,39.2}}, color={0,0,127}));
    connect(HP_nSet_Controller_winter_mode.IsOn, sigBusGen.heaPumIsOn)
      annotation (Line(points={{99.6,6.4},{98,6.4},{98,-64},{78,-64},{78,-68},{
            -152,-68},{-152,-99}}, color={255,0,255}), Text(
        string="%second",
        index=1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(DHWOnOffContoller.HP_On, HP_nSet_Controller_winter_mode.HP_On)
      annotation (Line(points={{-64.88,53.6},{-64.88,46},{8,46},{8,18},{72,18},
            {72,28},{88.2,28}}, color={255,0,255}));
    connect(booleanToReal1.u, sigBusGen.heaPumIsOn) annotation (Line(points={{
            -126,-30},{-126,-24},{-152,-24},{-152,-99}}, color={255,0,255}),
        Text(
        string="%second",
        index=1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(booleanToReal1.y, sigBusGen.uPump) annotation (Line(points={{-126,
            -53},{-126,-72},{-152,-72},{-152,-99}}, color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(HP_nSet_Controller_winter_mode.n_Set, safety_switch.u1) annotation (
       Line(points={{131.9,28},{158,28},{158,36},{166,36}}, color={0,0,127}));
    connect(safety_switch.y, sigBusGen.yHeaPumSet) annotation (Line(points={{
            189,28},{194,28},{194,-46},{-110,-46},{-110,-22},{-152,-22},{-152,
            -99}}, color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(heatPump_off.y, safety_switch.u3) annotation (Line(points={{150.6,
            18},{150.6,20},{166,20}}, color={0,0,127}));
    connect(hysteresis.u, sigBusGen.THeaPumOut) annotation (Line(points={{28,
            -30},{-58,-30},{-58,-40},{-108,-40},{-108,-20},{-152,-20},{-152,-99}},
          color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(lessThreshold.u, sigBusGen.THeaPumOut) annotation (Line(points={{
            2.8,-4},{-22,-4},{-22,-30},{-58,-30},{-58,-40},{-108,-40},{-108,-20},
            {-152,-20},{-152,-99}}, color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(and1.u1, lessThreshold.y) annotation (Line(points={{69,-39},{69,-4},
            {16.6,-4}}, color={255,0,255}));
    connect(hysteresis.y, and1.u2) annotation (Line(points={{51,-30},{64,-30},{
            64,-43},{69,-43}}, color={255,0,255}));
    connect(and1.y, safety_switch.u2) annotation (Line(points={{80.5,-39},{156,
            -39},{156,24},{160,24},{160,28},{166,28}}, color={255,0,255}));
  end Parameter_fit_control_Thermostatic_5;

  model Parameter_fit_control_Thermostatic_6
    extends
      BESMod.Systems.Hydraulical.Control.BaseClasses.SystemWithThermostaticValveControl;

    replaceable
      Systems.Hydraulical.Control.Components.DHWSetControl.BaseClasses.PartialTSet_DHW_Control
      TSet_DHW constrainedby
      Systems.Hydraulical.Control.Components.DHWSetControl.BaseClasses.PartialTSet_DHW_Control(
        final T_DHW=distributionParameters.TDHW_nominal) annotation (
        choicesAllMatching=true, Placement(transformation(extent={{-154,24},{-130,
              48}})));
      parameter BESMod.Utilities.SupervisoryControl.Types.SupervisoryControlType
      supCtrlTypeDHWSet=BESMod.Utilities.SupervisoryControl.Types.SupervisoryControlType.Local
      "Type of supervisory control for DHW Setpoint";

     replaceable parameter
      Systems.Hydraulical.Control.RecordsCollection.BivalentHeatPumpControlDataDefinition
      bivalentControlData constrainedby
      Systems.Hydraulical.Control.RecordsCollection.BivalentHeatPumpControlDataDefinition(
      final TOda_nominal=generationParameters.TOda_nominal,
      TSup_nominal=generationParameters.TSup_nominal[1],
      TSetRoomConst=sum(transferParameters.TDem_nominal)/transferParameters.nParallelDem);

    Modelica.Blocks.Math.Add add_dT_LoadingDHW
      annotation (Placement(transformation(extent={{46,30},{64,48}})));
    Modelica.Blocks.Sources.Constant const_dT_loading2(k=distributionParameters.dTTraDHW_nominal
           + bivalentControlData.dTHysDHW/2) annotation (Placement(transformation(
          extent={{6,-6},{-6,6}},
          rotation=180,
          origin={26,34})));
      Systems.Hydraulical.Control.Components.HeatPumpNSetController.PI_InverterHeatPumpController
      HP_nSet_Controller_winter_mode(
      P=bivalentControlData.k,
      nMin=bivalentControlData.nMin,
      T_I=bivalentControlData.T_I)   annotation (choicesAllMatching=true,
        Placement(transformation(extent={{92,10},{130,46}})));
    Modelica.Blocks.Sources.Constant constZero(final k=0) annotation (Placement(
          transformation(
          extent={{10,-10},{-10,10}},
          rotation=180,
          origin={-186,-66})));
    Modelica.Blocks.Logical.Not bufOn "buffer is charged" annotation (Placement(
          transformation(
          extent={{-5,-5},{5,5}},
          rotation=270,
          origin={-67,-1})));
    Modelica.Blocks.Math.BooleanToReal booleanToReal annotation (Placement(
          transformation(
          extent={{-7,-7},{7,7}},
          rotation=270,
          origin={-67,-31})));
      Systems.Hydraulical.Control.Components.OnOffController.ParallelBivalentControl
      DHWOnOffContoller(
      Hysteresis=bivalentControlData.dTHysDHW,
      TCutOff=TCutOff,
      TBiv=bivalentControlData.TBiv,
      TOda_nominal=bivalentControlData.TOda_nominal,
      TRoom=bivalentControlData.TSetRoomConst,
      QDem_flow_nominal=sum(transferParameters.Q_flow_nominal),
      QHP_flow_cutOff=QHP_flow_cutOff)
                        annotation (choicesAllMatching=true, Placement(
          transformation(extent={{-82,40},{-66,56}})));

      parameter Modelica.Units.SI.Temperature TCutOff "Cut-off temperature";
      parameter Modelica.Units.SI.HeatFlowRate QHP_flow_cutOff;

     /* parameter Boolean use_minRunTime=true
    "False if minimal runtime of HP is not considered"
    annotation (Dialog(group="OnOffControl"), choices(checkBox=true));
    parameter Modelica.Units.SI.Time minRunTime "Mimimum runtime of heat pump"
    annotation (Dialog(group="OnOffControl", enable=use_minRunTime));
    parameter Boolean use_minLocTime=true
    "False if minimal locktime of HP is not considered"
    annotation (Dialog(group="OnOffControl"), choices(checkBox=true));
    parameter Modelica.Units.SI.Time minLocTime "Minimum lock time of heat pump"
    annotation (Dialog(group="OnOffControl", enable=use_minLocTime));
    parameter Boolean use_runPerHou=true
    "False if maximal runs per hour HP are not considered"
    annotation (Dialog(group="OnOffControl"), choices(checkBox=true));
    parameter Integer maxRunPerHou "Maximal number of on/off cycles in one hour"
    annotation (Dialog(group="OnOffControl",enable=use_runPerHou));
    parameter Boolean pre_n_start=true "Start value of pre(n) at initial time"
    annotation (Dialog(group="OnOffControl", descriptionLabel=true),choices(checkBox=true));*/

    Modelica.Blocks.Math.BooleanToReal booleanToReal1 "Turn Pump in heat pump on"
                                                     annotation (Placement(
          transformation(
          extent={{-10,-10},{10,10}},
          rotation=270,
          origin={-126,-42})));
      replaceable Systems.Hydraulical.Control.RecordsCollection.HeatPumpSafetyControl
      safetyControl  annotation (choicesAllMatching=true,Placement(transformation(extent={{142,62},
              {162,82}})));


    /* AixLib.Controls.HeatPump.SafetyControls.SafetyControl securityControl(
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
        origin={210,81}))); // only for later/orientation */


    Systems.Hydraulical.Control.Components.HeatPumpBusPassThrough heatPumpBusPassThrough
      annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=180,
          origin={-222,-64})));

    AixLib.Controls.HeatPump.SafetyControls.OnOffControl
                 onOffController(
      final minRunTime=safetyControl.minRunTime,
      final minLocTime=safetyControl.minLocTime,
      final use_minRunTime=safetyControl.use_minRunTime,
      final use_minLocTime=safetyControl.use_minLocTime,
      final use_runPerHou=safetyControl.use_runPerHou,
      final maxRunPerHou=safetyControl.maxRunPerHou,
      final pre_n_start=safetyControl.pre_n_start_hp)
      annotation (Placement(transformation(extent={{190,12},{226,48}})));
    Modelica.Blocks.Logical.Switch safety_switch
      annotation (Placement(transformation(extent={{150,22},{170,42}})));
    Modelica.Blocks.Sources.Constant heatPump_off(k=0) annotation (Placement(
          transformation(
          extent={{6,-6},{-6,6}},
          rotation=180,
          origin={122,0})));
    Modelica.Blocks.Logical.LessThreshold lessThreshold(threshold=333.15)
      annotation (Placement(transformation(extent={{130,-36},{150,-16}})));
  equation
    connect(const_dT_loading2.y, add_dT_LoadingDHW.u2) annotation (Line(points={{32.6,
            34},{40,34},{40,33.6},{44.2,33.6}}, color={0,0,127}));
    connect(add_dT_LoadingDHW.y, HP_nSet_Controller_winter_mode.T_Set)
      annotation (Line(points={{64.9,39},{64.9,38.8},{88.2,38.8}}, color={0,0,127}));
    connect(HP_nSet_Controller_winter_mode.T_Meas, sigBusGen.THeaPumOut)
      annotation (Line(points={{111,6.4},{110,6.4},{110,-66},{-152,-66},{-152,-99}},
          color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(sigBusDistr, TSet_DHW.sigBusDistr) annotation (Line(
        points={{1,-100},{0,-100},{0,-118},{-254,-118},{-254,35.88},{-154,35.88}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{6,3},{6,3}},
        horizontalAlignment=TextAlignment.Left));

    connect(constZero.y, sigBusGen.uHeaRod) annotation (Line(points={{-175,-66},
            {-152,-66},{-152,-99}}, color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{-3,-6},{-3,-6}},
        horizontalAlignment=TextAlignment.Right));
    connect(bufOn.y, booleanToReal.u)
      annotation (Line(points={{-67,-6.5},{-67,-22.6}}, color={255,0,255}));
    connect(booleanToReal.y, sigBusDistr.uThrWayVal) annotation (Line(points={{
            -67,-38.7},{-67,-58},{1,-58},{1,-100}}, color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{6,3},{6,3}},
        horizontalAlignment=TextAlignment.Left));
    connect(DHWOnOffContoller.Auxilliar_Heater_set, add_dT_LoadingDHW.u1)
      annotation (Line(points={{-64.88,41.12},{-64.88,56},{36,56},{36,44.4},{44.2,
            44.4}}, color={0,0,127}));
    connect(DHWOnOffContoller.T_bot, sigBusDistr.TStoDHWTopMea) annotation (Line(
          points={{-82.8,44},{-88,44},{-88,30},{-24,30},{-24,-56},{1,-56},{1,-100}},
          color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{6,3},{6,3}},
        horizontalAlignment=TextAlignment.Left));
    connect(DHWOnOffContoller.T_Top, sigBusDistr.TStoDHWTopMea) annotation (Line(
          points={{-82.8,53.6},{-82.8,52},{-88,52},{-88,30},{-24,30},{-24,-56},{1,
            -56},{1,-100}}, color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{-3,-6},{-3,-6}},
        horizontalAlignment=TextAlignment.Right));
    connect(DHWOnOffContoller.T_oda, weaBus.TDryBul) annotation (Line(points={{-74,
            56.96},{-74,72},{-238,72},{-238,2},{-237,2}}, color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(TSet_DHW.TSet_DHW, DHWOnOffContoller.T_Set) annotation (Line(points={{
            -128.8,36},{-86,36},{-86,34},{-74,34},{-74,39.2}}, color={0,0,127}));
    connect(HP_nSet_Controller_winter_mode.IsOn, sigBusGen.heaPumIsOn)
      annotation (Line(points={{99.6,6.4},{98,6.4},{98,-64},{78,-64},{78,-68},{
            -152,-68},{-152,-99}}, color={255,0,255}), Text(
        string="%second",
        index=1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(DHWOnOffContoller.HP_On, HP_nSet_Controller_winter_mode.HP_On)
      annotation (Line(points={{-64.88,53.6},{-64.88,46},{8,46},{8,18},{72,18},{72,
            28},{88.2,28}},     color={255,0,255}));
    connect(booleanToReal1.u, sigBusGen.heaPumIsOn) annotation (Line(points={{-126,
            -30},{-126,-24},{-152,-24},{-152,-99}}, color={255,0,255}), Text(
        string="%second",
        index=1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(booleanToReal1.y, sigBusGen.uPump) annotation (Line(points={{-126,-53},
            {-126,-72},{-152,-72},{-152,-99}}, color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(sigBusGen, heatPumpBusPassThrough.sigBusGen) annotation (Line(
        points={{-152,-99},{-152,-48},{-206,-48},{-206,-64},{-212,-64}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{6,3},{6,3}},
        horizontalAlignment=TextAlignment.Left));
    connect(onOffController.sigBusHP, heatPumpBusPassThrough.vapourCompressionMachineControlBus)
      annotation (Line(
        points={{187.75,20.3455},{140,20.3455},{140,-14},{-210,-14},{-210,-48},
            {-238,-48},{-238,-63.8},{-232.2,-63.8}},
        color={255,204,51},
        thickness=0.5));
    connect(onOffController.nOut, sigBusGen.yHeaPumSet) annotation (Line(points={{227.5,
            31.6364},{227.5,32},{230,32},{230,-44},{-72,-44},{-72,-20},{-152,
            -20},{-152,-99}},      color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(HP_nSet_Controller_winter_mode.n_Set, safety_switch.u1) annotation (
       Line(points={{131.9,28},{131.9,40},{148,40}}, color={0,0,127}));
    connect(heatPump_off.y, safety_switch.u3) annotation (Line(points={{128.6,
            -4.44089e-16},{130,-4.44089e-16},{130,0},{132,0},{132,24},{148,24}},
          color={0,0,127}));
    connect(lessThreshold.y, safety_switch.u2) annotation (Line(points={{151,
            -26},{156,-26},{156,-10},{148,-10},{148,32}}, color={255,0,255}));
    connect(safety_switch.y, onOffController.nSet) annotation (Line(points={{171,32},
            {174.3,32},{174.3,31.6364},{187.6,31.6364}},         color={0,0,127}));
    connect(lessThreshold.u, sigBusGen.THeaPumOut) annotation (Line(points={{
            128,-26},{-54,-26},{-54,-72},{-152,-72},{-152,-99}}, color={0,0,127}),
        Text(
        string="%second",
        index=1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(TSet_DHW.y, bufOn.u) annotation (Line(points={{-128.8,29.04},{
            -128.8,28},{-67,28},{-67,5}}, color={255,0,255}));
  end Parameter_fit_control_Thermostatic_6;

  model Parameter_fit_control_Thermostatic_7
    extends
      BESMod.Systems.Hydraulical.Control.BaseClasses.SystemWithThermostaticValveControl;

    replaceable
      Systems.Hydraulical.Control.Components.DHWSetControl.BaseClasses.PartialTSet_DHW_Control
      TSet_DHW constrainedby
      Systems.Hydraulical.Control.Components.DHWSetControl.BaseClasses.PartialTSet_DHW_Control(
        final T_DHW=distributionParameters.TDHW_nominal) annotation (
        choicesAllMatching=true, Placement(transformation(extent={{-154,24},{-130,
              48}})));
      parameter BESMod.Utilities.SupervisoryControl.Types.SupervisoryControlType
      supCtrlTypeDHWSet=BESMod.Utilities.SupervisoryControl.Types.SupervisoryControlType.Local
      "Type of supervisory control for DHW Setpoint";

     replaceable parameter
      Systems.Hydraulical.Control.RecordsCollection.BivalentHeatPumpControlDataDefinition
      bivalentControlData constrainedby
      Systems.Hydraulical.Control.RecordsCollection.BivalentHeatPumpControlDataDefinition(
      final TOda_nominal=generationParameters.TOda_nominal,
      TSup_nominal=generationParameters.TSup_nominal[1],
      TSetRoomConst=sum(transferParameters.TDem_nominal)/transferParameters.nParallelDem);

    Modelica.Blocks.Math.Add add_dT_LoadingDHW
      annotation (Placement(transformation(extent={{46,30},{64,48}})));
    Modelica.Blocks.Sources.Constant const_dT_loading2(k=distributionParameters.dTTraDHW_nominal
           + bivalentControlData.dTHysDHW/2) annotation (Placement(transformation(
          extent={{6,-6},{-6,6}},
          rotation=180,
          origin={26,34})));
      Systems.Hydraulical.Control.Components.HeatPumpNSetController.PI_InverterHeatPumpController
      HP_nSet_Controller_winter_mode(
      P=bivalentControlData.k,
      nMin=bivalentControlData.nMin,
      T_I=bivalentControlData.T_I)   annotation (choicesAllMatching=true,
        Placement(transformation(extent={{92,10},{130,46}})));
    Modelica.Blocks.Sources.Constant constZero(final k=0) annotation (Placement(
          transformation(
          extent={{10,-10},{-10,10}},
          rotation=180,
          origin={-186,-66})));
    Modelica.Blocks.Logical.Not bufOn "buffer is charged" annotation (Placement(
          transformation(
          extent={{-5,-5},{5,5}},
          rotation=270,
          origin={-67,-1})));
    Modelica.Blocks.Math.BooleanToReal booleanToReal annotation (Placement(
          transformation(
          extent={{-7,-7},{7,7}},
          rotation=270,
          origin={-67,-31})));
      Systems.Hydraulical.Control.Components.OnOffController.ParallelBivalentControl
      DHWOnOffContoller(
      Hysteresis=bivalentControlData.dTHysDHW,
      TCutOff=TCutOff,
      TBiv=bivalentControlData.TBiv,
      TOda_nominal=bivalentControlData.TOda_nominal,
      TRoom=bivalentControlData.TSetRoomConst,
      QDem_flow_nominal=sum(transferParameters.Q_flow_nominal),
      QHP_flow_cutOff=QHP_flow_cutOff)
                        annotation (choicesAllMatching=true, Placement(
          transformation(extent={{-82,40},{-66,56}})));

      parameter Modelica.Units.SI.Temperature TCutOff "Cut-off temperature";
      parameter Modelica.Units.SI.HeatFlowRate QHP_flow_cutOff;

     /* parameter Boolean use_minRunTime=true
    "False if minimal runtime of HP is not considered"
    annotation (Dialog(group="OnOffControl"), choices(checkBox=true));
    parameter Modelica.Units.SI.Time minRunTime "Mimimum runtime of heat pump"
    annotation (Dialog(group="OnOffControl", enable=use_minRunTime));
    parameter Boolean use_minLocTime=true
    "False if minimal locktime of HP is not considered"
    annotation (Dialog(group="OnOffControl"), choices(checkBox=true));
    parameter Modelica.Units.SI.Time minLocTime "Minimum lock time of heat pump"
    annotation (Dialog(group="OnOffControl", enable=use_minLocTime));
    parameter Boolean use_runPerHou=true
    "False if maximal runs per hour HP are not considered"
    annotation (Dialog(group="OnOffControl"), choices(checkBox=true));
    parameter Integer maxRunPerHou "Maximal number of on/off cycles in one hour"
    annotation (Dialog(group="OnOffControl",enable=use_runPerHou));
    parameter Boolean pre_n_start=true "Start value of pre(n) at initial time"
    annotation (Dialog(group="OnOffControl", descriptionLabel=true),choices(checkBox=true));*/

    Modelica.Blocks.Math.BooleanToReal booleanToReal1 "Turn Pump in heat pump on"
                                                     annotation (Placement(
          transformation(
          extent={{-10,-10},{10,10}},
          rotation=270,
          origin={-126,-42})));
      replaceable Systems.Hydraulical.Control.RecordsCollection.HeatPumpSafetyControl
      safetyControl  annotation (choicesAllMatching=true,Placement(transformation(extent={{142,62},
              {162,82}})));

    /* AixLib.Controls.HeatPump.SafetyControls.SafetyControl securityControl(
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
        origin={210,81}))); // only for later/orientation */

    Systems.Hydraulical.Control.Components.HeatPumpBusPassThrough heatPumpBusPassThrough
      annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=180,
          origin={-222,-64})));

    AixLib.Controls.HeatPump.SafetyControls.OnOffControl
                 onOffController(
      final minRunTime=safetyControl.minRunTime,
      final minLocTime=safetyControl.minLocTime,
      final use_minRunTime=safetyControl.use_minRunTime,
      final use_minLocTime=safetyControl.use_minLocTime,
      final use_runPerHou=safetyControl.use_runPerHou,
      final maxRunPerHou=safetyControl.maxRunPerHou,
      final pre_n_start=safetyControl.pre_n_start_hp)
      annotation (Placement(transformation(extent={{190,12},{226,48}})));
    Modelica.Blocks.Logical.Switch safety_switch
      annotation (Placement(transformation(extent={{150,22},{170,42}})));
    Modelica.Blocks.Sources.Constant heatPump_off(k=0) annotation (Placement(
          transformation(
          extent={{6,-6},{-6,6}},
          rotation=180,
          origin={122,0})));
    Modelica.Blocks.Logical.LessThreshold lessThreshold(threshold=333.15)
      annotation (Placement(transformation(extent={{130,-36},{150,-16}})));
  equation
    connect(const_dT_loading2.y, add_dT_LoadingDHW.u2) annotation (Line(points={{32.6,
            34},{40,34},{40,33.6},{44.2,33.6}}, color={0,0,127}));
    connect(add_dT_LoadingDHW.y, HP_nSet_Controller_winter_mode.T_Set)
      annotation (Line(points={{64.9,39},{64.9,38.8},{88.2,38.8}}, color={0,0,127}));
    connect(HP_nSet_Controller_winter_mode.T_Meas, sigBusGen.THeaPumOut)
      annotation (Line(points={{111,6.4},{110,6.4},{110,-66},{-152,-66},{-152,-99}},
          color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(sigBusDistr, TSet_DHW.sigBusDistr) annotation (Line(
        points={{1,-100},{0,-100},{0,-118},{-254,-118},{-254,35.88},{-154,35.88}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{6,3},{6,3}},
        horizontalAlignment=TextAlignment.Left));

    connect(constZero.y, sigBusGen.uHeaRod) annotation (Line(points={{-175,-66},
            {-152,-66},{-152,-99}}, color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{-3,-6},{-3,-6}},
        horizontalAlignment=TextAlignment.Right));
    connect(TSet_DHW.y, bufOn.u) annotation (Line(points={{-128.8,29.04},{
            -128.8,28},{-67,28},{-67,5}}, color={255,0,255}));
    connect(bufOn.y, booleanToReal.u)
      annotation (Line(points={{-67,-6.5},{-67,-22.6}}, color={255,0,255}));
    connect(booleanToReal.y, sigBusDistr.uThrWayVal) annotation (Line(points={{
            -67,-38.7},{-67,-58},{1,-58},{1,-100}}, color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{6,3},{6,3}},
        horizontalAlignment=TextAlignment.Left));
    connect(DHWOnOffContoller.Auxilliar_Heater_set, add_dT_LoadingDHW.u1)
      annotation (Line(points={{-64.88,41.12},{-64.88,56},{36,56},{36,44.4},{44.2,
            44.4}}, color={0,0,127}));
    connect(DHWOnOffContoller.T_bot, sigBusDistr.TStoDHWTopMea) annotation (Line(
          points={{-82.8,44},{-88,44},{-88,30},{-24,30},{-24,-56},{1,-56},{1,-100}},
          color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{6,3},{6,3}},
        horizontalAlignment=TextAlignment.Left));
    connect(DHWOnOffContoller.T_Top, sigBusDistr.TStoDHWTopMea) annotation (Line(
          points={{-82.8,53.6},{-82.8,52},{-88,52},{-88,30},{-24,30},{-24,-56},{1,
            -56},{1,-100}}, color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{-3,-6},{-3,-6}},
        horizontalAlignment=TextAlignment.Right));
    connect(DHWOnOffContoller.T_oda, weaBus.TDryBul) annotation (Line(points={{-74,
            56.96},{-74,72},{-238,72},{-238,2},{-237,2}}, color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(TSet_DHW.TSet_DHW, DHWOnOffContoller.T_Set) annotation (Line(points={{
            -128.8,36},{-86,36},{-86,34},{-74,34},{-74,39.2}}, color={0,0,127}));
    connect(HP_nSet_Controller_winter_mode.IsOn, sigBusGen.heaPumIsOn)
      annotation (Line(points={{99.6,6.4},{98,6.4},{98,-64},{78,-64},{78,-68},{
            -152,-68},{-152,-99}}, color={255,0,255}), Text(
        string="%second",
        index=1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(DHWOnOffContoller.HP_On, HP_nSet_Controller_winter_mode.HP_On)
      annotation (Line(points={{-64.88,53.6},{-64.88,46},{8,46},{8,18},{72,18},{72,
            28},{88.2,28}},     color={255,0,255}));
    connect(booleanToReal1.u, sigBusGen.heaPumIsOn) annotation (Line(points={{-126,
            -30},{-126,-24},{-152,-24},{-152,-99}}, color={255,0,255}), Text(
        string="%second",
        index=1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(booleanToReal1.y, sigBusGen.uPump) annotation (Line(points={{-126,-53},
            {-126,-72},{-152,-72},{-152,-99}}, color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(sigBusGen, heatPumpBusPassThrough.sigBusGen) annotation (Line(
        points={{-152,-99},{-152,-48},{-206,-48},{-206,-64},{-212,-64}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{6,3},{6,3}},
        horizontalAlignment=TextAlignment.Left));
    connect(onOffController.sigBusHP, heatPumpBusPassThrough.vapourCompressionMachineControlBus)
      annotation (Line(
        points={{187.75,20.3455},{140,20.3455},{140,-14},{-210,-14},{-210,-48},
            {-238,-48},{-238,-63.8},{-232.2,-63.8}},
        color={255,204,51},
        thickness=0.5));
    connect(onOffController.nOut, sigBusGen.yHeaPumSet) annotation (Line(points={{227.5,
            31.6364},{227.5,32},{230,32},{230,-44},{-72,-44},{-72,-20},{-152,
            -20},{-152,-99}},      color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(HP_nSet_Controller_winter_mode.n_Set, safety_switch.u1) annotation (
       Line(points={{131.9,28},{131.9,40},{148,40}}, color={0,0,127}));
    connect(heatPump_off.y, safety_switch.u3) annotation (Line(points={{128.6,
            -4.44089e-16},{130,-4.44089e-16},{130,0},{132,0},{132,24},{148,24}},
          color={0,0,127}));
    connect(lessThreshold.y, safety_switch.u2) annotation (Line(points={{151,
            -26},{156,-26},{156,-10},{148,-10},{148,32}}, color={255,0,255}));
    connect(safety_switch.y, onOffController.nSet) annotation (Line(points={{171,32},
            {174.3,32},{174.3,31.6364},{187.6,31.6364}},         color={0,0,127}));
    connect(lessThreshold.u, sigBusGen.TBoiIn) annotation (Line(points={{128,
            -26},{-54,-26},{-54,-72},{-152,-72},{-152,-99}}, color={0,0,127}),
        Text(
        string="%second",
        index=1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
  end Parameter_fit_control_Thermostatic_7;

  model Parameter_fit_control_Thermostatic_8
    extends
      BESMod.Systems.Hydraulical.Control.BaseClasses.SystemWithThermostaticValveControl;

    replaceable
      Systems.Hydraulical.Control.Components.DHWSetControl.BaseClasses.PartialTSet_DHW_Control
      TSet_DHW constrainedby
      Systems.Hydraulical.Control.Components.DHWSetControl.BaseClasses.PartialTSet_DHW_Control(
        final T_DHW=distributionParameters.TDHW_nominal) annotation (
        choicesAllMatching=true, Placement(transformation(extent={{-154,24},{-130,
              48}})));
      parameter BESMod.Utilities.SupervisoryControl.Types.SupervisoryControlType
      supCtrlTypeDHWSet=BESMod.Utilities.SupervisoryControl.Types.SupervisoryControlType.Local
      "Type of supervisory control for DHW Setpoint";

     replaceable parameter
      Systems.Hydraulical.Control.RecordsCollection.BivalentHeatPumpControlDataDefinition
      bivalentControlData constrainedby
      Systems.Hydraulical.Control.RecordsCollection.BivalentHeatPumpControlDataDefinition(
      final TOda_nominal=generationParameters.TOda_nominal,
      TSup_nominal=generationParameters.TSup_nominal[1],
      TSetRoomConst=sum(transferParameters.TDem_nominal)/transferParameters.nParallelDem);

    Modelica.Blocks.Math.Add add_dT_LoadingDHW
      annotation (Placement(transformation(extent={{46,30},{64,48}})));
    Modelica.Blocks.Sources.Constant const_dT_loading2(k=distributionParameters.dTTraDHW_nominal
           + bivalentControlData.dTHysDHW/2) annotation (Placement(transformation(
          extent={{6,-6},{-6,6}},
          rotation=180,
          origin={26,34})));
      Systems.Hydraulical.Control.Components.HeatPumpNSetController.PI_InverterHeatPumpController
      HP_nSet_Controller_winter_mode(
      P=bivalentControlData.k,
      nMin=bivalentControlData.nMin,
      T_I=bivalentControlData.T_I)   annotation (choicesAllMatching=true,
        Placement(transformation(extent={{92,10},{130,46}})));
    Modelica.Blocks.Sources.Constant constZero(final k=0) annotation (Placement(
          transformation(
          extent={{10,-10},{-10,10}},
          rotation=180,
          origin={-186,-66})));
    Modelica.Blocks.Logical.Not bufOn "buffer is charged" annotation (Placement(
          transformation(
          extent={{-5,-5},{5,5}},
          rotation=270,
          origin={-67,-1})));
    Modelica.Blocks.Math.BooleanToReal booleanToReal annotation (Placement(
          transformation(
          extent={{-7,-7},{7,7}},
          rotation=270,
          origin={-67,-31})));
      Systems.Hydraulical.Control.Components.OnOffController.ParallelBivalentControl
      DHWOnOffContoller(
      Hysteresis=bivalentControlData.dTHysDHW,
      TCutOff=TCutOff,
      TBiv=bivalentControlData.TBiv,
      TOda_nominal=bivalentControlData.TOda_nominal,
      TRoom=bivalentControlData.TSetRoomConst,
      QDem_flow_nominal=sum(transferParameters.Q_flow_nominal),
      QHP_flow_cutOff=QHP_flow_cutOff)
                        annotation (choicesAllMatching=true, Placement(
          transformation(extent={{-82,40},{-66,56}})));

      parameter Modelica.Units.SI.Temperature TCutOff "Cut-off temperature";
      parameter Modelica.Units.SI.HeatFlowRate QHP_flow_cutOff;

     /* parameter Boolean use_minRunTime=true
    "False if minimal runtime of HP is not considered"
    annotation (Dialog(group="OnOffControl"), choices(checkBox=true));
    parameter Modelica.Units.SI.Time minRunTime "Mimimum runtime of heat pump"
    annotation (Dialog(group="OnOffControl", enable=use_minRunTime));
    parameter Boolean use_minLocTime=true
    "False if minimal locktime of HP is not considered"
    annotation (Dialog(group="OnOffControl"), choices(checkBox=true));
    parameter Modelica.Units.SI.Time minLocTime "Minimum lock time of heat pump"
    annotation (Dialog(group="OnOffControl", enable=use_minLocTime));
    parameter Boolean use_runPerHou=true
    "False if maximal runs per hour HP are not considered"
    annotation (Dialog(group="OnOffControl"), choices(checkBox=true));
    parameter Integer maxRunPerHou "Maximal number of on/off cycles in one hour"
    annotation (Dialog(group="OnOffControl",enable=use_runPerHou));
    parameter Boolean pre_n_start=true "Start value of pre(n) at initial time"
    annotation (Dialog(group="OnOffControl", descriptionLabel=true),choices(checkBox=true));*/

    Modelica.Blocks.Math.BooleanToReal booleanToReal1 "Turn Pump in heat pump on"
                                                     annotation (Placement(
          transformation(
          extent={{-10,-10},{10,10}},
          rotation=270,
          origin={-126,-42})));
      replaceable Systems.Hydraulical.Control.RecordsCollection.HeatPumpSafetyControl
      safetyControl  annotation (choicesAllMatching=true,Placement(transformation(extent={{142,62},
              {162,82}})));

    /* AixLib.Controls.HeatPump.SafetyControls.SafetyControl securityControl(
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
        origin={210,81}))); // only for later/orientation */

    Systems.Hydraulical.Control.Components.HeatPumpBusPassThrough heatPumpBusPassThrough
      annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=180,
          origin={-222,-64})));

    /*AixLib.Controls.HeatPump.SafetyControls.OnOffControl
               onOffController(
    final minRunTime=safetyControl.minRunTime,
    final minLocTime=safetyControl.minLocTime,
    final use_minRunTime=safetyControl.use_minRunTime,
    final use_minLocTime=safetyControl.use_minLocTime,
    final use_runPerHou=safetyControl.use_runPerHou,
    final maxRunPerHou=safetyControl.maxRunPerHou,
    final pre_n_start=safetyControl.pre_n_start_hp)
    annotation (Placement(transformation(extent={{190,12},{226,48}})));*/
    Modelica.Blocks.Logical.Switch safety_switch
      annotation (Placement(transformation(extent={{150,22},{170,42}})));
    Modelica.Blocks.Sources.Constant heatPump_off(k=0) annotation (Placement(
          transformation(
          extent={{6,-6},{-6,6}},
          rotation=180,
          origin={122,0})));
    Modelica.Blocks.Logical.LessThreshold lessThreshold(threshold=343.15)
      annotation (Placement(transformation(extent={{130,-36},{150,-16}})));
  equation
    connect(const_dT_loading2.y, add_dT_LoadingDHW.u2) annotation (Line(points={{32.6,
            34},{40,34},{40,33.6},{44.2,33.6}}, color={0,0,127}));
    connect(add_dT_LoadingDHW.y, HP_nSet_Controller_winter_mode.T_Set)
      annotation (Line(points={{64.9,39},{64.9,38.8},{88.2,38.8}}, color={0,0,127}));
    connect(HP_nSet_Controller_winter_mode.T_Meas, sigBusGen.THeaPumOut)
      annotation (Line(points={{111,6.4},{110,6.4},{110,-66},{-152,-66},{-152,-99}},
          color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(sigBusDistr, TSet_DHW.sigBusDistr) annotation (Line(
        points={{1,-100},{0,-100},{0,-118},{-254,-118},{-254,35.88},{-154,35.88}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{6,3},{6,3}},
        horizontalAlignment=TextAlignment.Left));

    connect(constZero.y, sigBusGen.uHeaRod) annotation (Line(points={{-175,-66},
            {-152,-66},{-152,-99}}, color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{-3,-6},{-3,-6}},
        horizontalAlignment=TextAlignment.Right));
    connect(bufOn.y, booleanToReal.u)
      annotation (Line(points={{-67,-6.5},{-67,-22.6}}, color={255,0,255}));
    connect(booleanToReal.y, sigBusDistr.uThrWayVal) annotation (Line(points={{
            -67,-38.7},{-67,-58},{1,-58},{1,-100}}, color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{6,3},{6,3}},
        horizontalAlignment=TextAlignment.Left));
    connect(DHWOnOffContoller.Auxilliar_Heater_set, add_dT_LoadingDHW.u1)
      annotation (Line(points={{-64.88,41.12},{-64.88,56},{36,56},{36,44.4},{44.2,
            44.4}}, color={0,0,127}));
    connect(DHWOnOffContoller.T_bot, sigBusDistr.TStoDHWTopMea) annotation (Line(
          points={{-82.8,44},{-88,44},{-88,30},{-24,30},{-24,-56},{1,-56},{1,-100}},
          color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{6,3},{6,3}},
        horizontalAlignment=TextAlignment.Left));
    connect(DHWOnOffContoller.T_Top, sigBusDistr.TStoDHWTopMea) annotation (Line(
          points={{-82.8,53.6},{-82.8,52},{-88,52},{-88,30},{-24,30},{-24,-56},{1,
            -56},{1,-100}}, color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{-3,-6},{-3,-6}},
        horizontalAlignment=TextAlignment.Right));
    connect(DHWOnOffContoller.T_oda, weaBus.TDryBul) annotation (Line(points={{-74,
            56.96},{-74,72},{-238,72},{-238,2},{-237,2}}, color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(TSet_DHW.TSet_DHW, DHWOnOffContoller.T_Set) annotation (Line(points={{
            -128.8,36},{-86,36},{-86,34},{-74,34},{-74,39.2}}, color={0,0,127}));
    connect(HP_nSet_Controller_winter_mode.IsOn, sigBusGen.heaPumIsOn)
      annotation (Line(points={{99.6,6.4},{98,6.4},{98,-64},{78,-64},{78,-68},{
            -152,-68},{-152,-99}}, color={255,0,255}), Text(
        string="%second",
        index=1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(DHWOnOffContoller.HP_On, HP_nSet_Controller_winter_mode.HP_On)
      annotation (Line(points={{-64.88,53.6},{-64.88,46},{8,46},{8,18},{72,18},{72,
            28},{88.2,28}},     color={255,0,255}));
    connect(booleanToReal1.u, sigBusGen.heaPumIsOn) annotation (Line(points={{-126,
            -30},{-126,-24},{-152,-24},{-152,-99}}, color={255,0,255}), Text(
        string="%second",
        index=1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(booleanToReal1.y, sigBusGen.uPump) annotation (Line(points={{-126,-53},
            {-126,-72},{-152,-72},{-152,-99}}, color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(sigBusGen, heatPumpBusPassThrough.sigBusGen) annotation (Line(
        points={{-152,-99},{-152,-48},{-206,-48},{-206,-64},{-212,-64}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{6,3},{6,3}},
        horizontalAlignment=TextAlignment.Left));
    connect(bufOn.u, DHWOnOffContoller.HP_On) annotation (Line(points={{-67,5},{-67,
            34},{-58,34},{-58,46},{-64.88,46},{-64.88,53.6}}, color={255,0,255}));
    connect(heatPump_off.y, safety_switch.u3) annotation (Line(points={{128.6,
            -7.21645e-16},{142,-7.21645e-16},{142,24},{148,24}}, color={0,0,127}));
    connect(lessThreshold.y, safety_switch.u2) annotation (Line(points={{151,
            -26},{148,-26},{148,32},{148,32}}, color={255,0,255}));
    connect(safety_switch.y, sigBusGen.yHeaPumSet) annotation (Line(points={{
            171,32},{176,32},{176,-46},{-110,-46},{-110,-22},{-152,-22},{-152,
            -99}}, color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(lessThreshold.u, sigBusGen.THeaPumOut) annotation (Line(points={{
            128,-26},{-58,-26},{-58,-40},{-108,-40},{-108,-20},{-152,-20},{-152,
            -99}}, color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(HP_nSet_Controller_winter_mode.n_Set, safety_switch.u1) annotation (
       Line(points={{131.9,28},{142,28},{142,40},{148,40}}, color={0,0,127}));
  end Parameter_fit_control_Thermostatic_8;

  model Parameter_fit_control_Thermostatic_9
    extends
      BESMod.Systems.Hydraulical.Control.BaseClasses.SystemWithThermostaticValveControl;

    replaceable
      Systems.Hydraulical.Control.Components.DHWSetControl.BaseClasses.PartialTSet_DHW_Control
      TSet_DHW constrainedby
      Systems.Hydraulical.Control.Components.DHWSetControl.BaseClasses.PartialTSet_DHW_Control(
        final T_DHW=distributionParameters.TDHW_nominal) annotation (
        choicesAllMatching=true, Placement(transformation(extent={{-154,24},{-130,
              48}})));
      parameter BESMod.Utilities.SupervisoryControl.Types.SupervisoryControlType
      supCtrlTypeDHWSet=BESMod.Utilities.SupervisoryControl.Types.SupervisoryControlType.Local
      "Type of supervisory control for DHW Setpoint";

     replaceable parameter
      Systems.Hydraulical.Control.RecordsCollection.BivalentHeatPumpControlDataDefinition
      bivalentControlData constrainedby
      Systems.Hydraulical.Control.RecordsCollection.BivalentHeatPumpControlDataDefinition(
      final TOda_nominal=generationParameters.TOda_nominal,
      TSup_nominal=generationParameters.TSup_nominal[1],
      TSetRoomConst=sum(transferParameters.TDem_nominal)/transferParameters.nParallelDem);

    Modelica.Blocks.Math.Add add_dT_LoadingDHW
      annotation (Placement(transformation(extent={{46,30},{64,48}})));
    Modelica.Blocks.Sources.Constant const_dT_loading2(k=distributionParameters.dTTraDHW_nominal
           + bivalentControlData.dTHysDHW/2) annotation (Placement(transformation(
          extent={{6,-6},{-6,6}},
          rotation=180,
          origin={26,34})));
      Systems.Hydraulical.Control.Components.HeatPumpNSetController.PI_InverterHeatPumpController
      HP_nSet_Controller_winter_mode(
      P=bivalentControlData.k,
      nMin=bivalentControlData.nMin,
      T_I=bivalentControlData.T_I)   annotation (choicesAllMatching=true,
        Placement(transformation(extent={{92,10},{130,46}})));
    Modelica.Blocks.Sources.Constant constZero(final k=0) annotation (Placement(
          transformation(
          extent={{10,-10},{-10,10}},
          rotation=180,
          origin={-186,-66})));
    Modelica.Blocks.Logical.Not bufOn "buffer is charged" annotation (Placement(
          transformation(
          extent={{-5,-5},{5,5}},
          rotation=270,
          origin={-67,-1})));
    Modelica.Blocks.Math.BooleanToReal booleanToReal annotation (Placement(
          transformation(
          extent={{-7,-7},{7,7}},
          rotation=270,
          origin={-67,-31})));
      Systems.Hydraulical.Control.Components.OnOffController.ParallelBivalentControl
      DHWOnOffContoller(
      Hysteresis=bivalentControlData.dTHysDHW,
      TCutOff=TCutOff,
      TBiv=bivalentControlData.TBiv,
      TOda_nominal=bivalentControlData.TOda_nominal,
      TRoom=bivalentControlData.TSetRoomConst,
      QDem_flow_nominal=sum(transferParameters.Q_flow_nominal),
      QHP_flow_cutOff=QHP_flow_cutOff)
                        annotation (choicesAllMatching=true, Placement(
          transformation(extent={{-82,40},{-66,56}})));

      parameter Modelica.Units.SI.Temperature TCutOff "Cut-off temperature";
      parameter Modelica.Units.SI.HeatFlowRate QHP_flow_cutOff;

     /* parameter Boolean use_minRunTime=true
    "False if minimal runtime of HP is not considered"
    annotation (Dialog(group="OnOffControl"), choices(checkBox=true));
    parameter Modelica.Units.SI.Time minRunTime "Mimimum runtime of heat pump"
    annotation (Dialog(group="OnOffControl", enable=use_minRunTime));
    parameter Boolean use_minLocTime=true
    "False if minimal locktime of HP is not considered"
    annotation (Dialog(group="OnOffControl"), choices(checkBox=true));
    parameter Modelica.Units.SI.Time minLocTime "Minimum lock time of heat pump"
    annotation (Dialog(group="OnOffControl", enable=use_minLocTime));
    parameter Boolean use_runPerHou=true
    "False if maximal runs per hour HP are not considered"
    annotation (Dialog(group="OnOffControl"), choices(checkBox=true));
    parameter Integer maxRunPerHou "Maximal number of on/off cycles in one hour"
    annotation (Dialog(group="OnOffControl",enable=use_runPerHou));
    parameter Boolean pre_n_start=true "Start value of pre(n) at initial time"
    annotation (Dialog(group="OnOffControl", descriptionLabel=true),choices(checkBox=true));*/

    Modelica.Blocks.Math.BooleanToReal booleanToReal1 "Turn Pump in heat pump on"
                                                     annotation (Placement(
          transformation(
          extent={{-10,-10},{10,10}},
          rotation=270,
          origin={-126,-42})));
      replaceable Systems.Hydraulical.Control.RecordsCollection.HeatPumpSafetyControl
      safetyControl  annotation (choicesAllMatching=true,Placement(transformation(extent={{142,62},
              {162,82}})));

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
          origin={210,81}))); // only for later/orientation

    Systems.Hydraulical.Control.Components.HeatPumpBusPassThrough heatPumpBusPassThrough
      annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=180,
          origin={-222,-64})));

    /*AixLib.Controls.HeatPump.SafetyControls.OnOffControl
               onOffController(
    final minRunTime=safetyControl.minRunTime,
    final minLocTime=safetyControl.minLocTime,
    final use_minRunTime=safetyControl.use_minRunTime,
    final use_minLocTime=safetyControl.use_minLocTime,
    final use_runPerHou=safetyControl.use_runPerHou,
    final maxRunPerHou=safetyControl.maxRunPerHou,
    final pre_n_start=safetyControl.pre_n_start_hp)
    annotation (Placement(transformation(extent={{190,12},{226,48}})));*/
    /*Modelica.Blocks.Logical.Switch safety_switch
    annotation (Placement(transformation(extent={{150,22},{170,42}})));
  Modelica.Blocks.Sources.Constant heatPump_off(k=0) annotation (Placement(
        transformation(
        extent={{6,-6},{-6,6}},
        rotation=180,
        origin={122,0})));
  Modelica.Blocks.Logical.LessThreshold lessThreshold(threshold=343.15)
    annotation (Placement(transformation(extent={{130,-36},{150,-16}})));*/
    Modelica.Blocks.Sources.BooleanConstant hp_mode(final k=true) annotation (
        Placement(transformation(
          extent={{-7,-7},{7,7}},
          rotation=0,
          origin={175,43})));
  equation
    connect(const_dT_loading2.y, add_dT_LoadingDHW.u2) annotation (Line(points={{32.6,
            34},{40,34},{40,33.6},{44.2,33.6}}, color={0,0,127}));
    connect(add_dT_LoadingDHW.y, HP_nSet_Controller_winter_mode.T_Set)
      annotation (Line(points={{64.9,39},{64.9,38.8},{88.2,38.8}}, color={0,0,127}));
    connect(HP_nSet_Controller_winter_mode.T_Meas, sigBusGen.THeaPumOut)
      annotation (Line(points={{111,6.4},{110,6.4},{110,-66},{-152,-66},{-152,-99}},
          color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(sigBusDistr, TSet_DHW.sigBusDistr) annotation (Line(
        points={{1,-100},{0,-100},{0,-118},{-254,-118},{-254,35.88},{-154,35.88}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{6,3},{6,3}},
        horizontalAlignment=TextAlignment.Left));

    connect(constZero.y, sigBusGen.uHeaRod) annotation (Line(points={{-175,-66},
            {-152,-66},{-152,-99}}, color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{-3,-6},{-3,-6}},
        horizontalAlignment=TextAlignment.Right));
    connect(bufOn.y, booleanToReal.u)
      annotation (Line(points={{-67,-6.5},{-67,-22.6}}, color={255,0,255}));
    connect(booleanToReal.y, sigBusDistr.uThrWayVal) annotation (Line(points={{
            -67,-38.7},{-67,-58},{1,-58},{1,-100}}, color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{6,3},{6,3}},
        horizontalAlignment=TextAlignment.Left));
    connect(DHWOnOffContoller.Auxilliar_Heater_set, add_dT_LoadingDHW.u1)
      annotation (Line(points={{-64.88,41.12},{-64.88,56},{36,56},{36,44.4},{44.2,
            44.4}}, color={0,0,127}));
    connect(DHWOnOffContoller.T_bot, sigBusDistr.TStoDHWTopMea) annotation (Line(
          points={{-82.8,44},{-88,44},{-88,30},{-24,30},{-24,-56},{1,-56},{1,-100}},
          color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{6,3},{6,3}},
        horizontalAlignment=TextAlignment.Left));
    connect(DHWOnOffContoller.T_Top, sigBusDistr.TStoDHWTopMea) annotation (Line(
          points={{-82.8,53.6},{-82.8,52},{-88,52},{-88,30},{-24,30},{-24,-56},{1,
            -56},{1,-100}}, color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{-3,-6},{-3,-6}},
        horizontalAlignment=TextAlignment.Right));
    connect(DHWOnOffContoller.T_oda, weaBus.TDryBul) annotation (Line(points={{-74,
            56.96},{-74,72},{-238,72},{-238,2},{-237,2}}, color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(TSet_DHW.TSet_DHW, DHWOnOffContoller.T_Set) annotation (Line(points={{
            -128.8,36},{-86,36},{-86,34},{-74,34},{-74,39.2}}, color={0,0,127}));
    connect(HP_nSet_Controller_winter_mode.IsOn, sigBusGen.heaPumIsOn)
      annotation (Line(points={{99.6,6.4},{98,6.4},{98,-64},{78,-64},{78,-68},{
            -152,-68},{-152,-99}}, color={255,0,255}), Text(
        string="%second",
        index=1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(DHWOnOffContoller.HP_On, HP_nSet_Controller_winter_mode.HP_On)
      annotation (Line(points={{-64.88,53.6},{-64.88,46},{8,46},{8,18},{72,18},{72,
            28},{88.2,28}},     color={255,0,255}));
    connect(booleanToReal1.u, sigBusGen.heaPumIsOn) annotation (Line(points={{-126,
            -30},{-126,-24},{-152,-24},{-152,-99}}, color={255,0,255}), Text(
        string="%second",
        index=1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(booleanToReal1.y, sigBusGen.uPump) annotation (Line(points={{-126,-53},
            {-126,-72},{-152,-72},{-152,-99}}, color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(sigBusGen, heatPumpBusPassThrough.sigBusGen) annotation (Line(
        points={{-152,-99},{-152,-48},{-206,-48},{-206,-64},{-212,-64}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{6,3},{6,3}},
        horizontalAlignment=TextAlignment.Left));
    connect(bufOn.u, DHWOnOffContoller.HP_On) annotation (Line(points={{-67,5},{-67,
            34},{-58,34},{-58,46},{-64.88,46},{-64.88,53.6}}, color={255,0,255}));
    connect(HP_nSet_Controller_winter_mode.n_Set, securityControl.nSet)
      annotation (Line(points={{131.9,28},{146,28},{146,56},{184,56},{184,84.4},
            {191.867,84.4}}, color={0,0,127}));
    connect(securityControl.nOut, sigBusGen.yHeaPumSet) annotation (Line(points={{227.333,
            84.4},{234,84.4},{234,4},{144,4},{144,-58},{-152,-58},{-152,-99}},
                        color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(hp_mode.y, securityControl.modeSet) annotation (Line(points={{182.7,
            43},{182.7,42},{190,42},{190,58},{182,58},{182,77.6},{191.867,77.6}},
          color={255,0,255}));
    connect(securityControl.sigBusHP, heatPumpBusPassThrough.vapourCompressionMachineControlBus)
      annotation (Line(
        points={{192,69.27},{192,-46},{-106,-46},{-106,-18},{-210,-18},{-210,
            -48},{-238,-48},{-238,-63.8},{-232.2,-63.8}},
        color={255,204,51},
        thickness=0.5));
  end Parameter_fit_control_Thermostatic_9;
end TestControlStrategiesGridConnection;
