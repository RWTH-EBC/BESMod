within BESMod.Examples.TestControlStrategiesGridConnection;
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
