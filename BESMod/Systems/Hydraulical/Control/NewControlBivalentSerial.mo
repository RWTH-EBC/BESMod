within BESMod.Systems.Hydraulical.Control;
model NewControlBivalentSerial
  "Bivalent Serial Control Class (Part-parallel PI controlled HPS according to condenser outflow)"
  extends BaseClasses.PartialTwoPoint_HPS_Controller_BivalentBoiler(
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

  replaceable
    Components.HeatPumpNSetController.PI_InverterHeatPumpController
    Boiler_uRel_Controller(
    P=2,
    nMin=0,
    T_I=1200,
    Ni=0.9)  constrainedby
    Components.HeatPumpNSetController.PI_InverterHeatPumpController
    annotation (choicesAllMatching=true, Placement(transformation(extent={{80,10},
            {110,38}})));
  Modelica.Blocks.Sources.BooleanConstant TestBoilerZustand1(final k=true)
    annotation (Placement(transformation(
        extent={{-7,-7},{7,7}},
        rotation=0,
        origin={43,5})));
 Modelica.Blocks.Sources.RealExpression T_Oda(final y(
      unit="K",
      displayUnit="degC") = heatingCurve.TOda)
    "Außtentemperatur für Boiler Steuerung" annotation (Placement(
        transformation(
        extent={{-16,-5},{16,5}},
        rotation=0,
        origin={-214,-323})));
 Modelica.Blocks.Sources.RealExpression HP_NSet(final y(
      unit="K",
      displayUnit="degC") = HP_nSet_Controller.n_Set)
    "Compressor Drehzahl für Boiler Steuerung" annotation (Placement(
        transformation(
        extent={{-16,-5},{16,5}},
        rotation=0,
        origin={-234,-379})));
  Modelica.Blocks.Logical.LessThreshold lessThreshold(threshold=
        bivalentControlData.TBiv) "checks if Toda is smaller than TBiv"
    annotation (Placement(transformation(extent={{-164,-336},{-132,-304}})));
  Modelica.Blocks.Logical.Or or1
    "hp outside operational boundary or high utilization (high compressor rotational speed)"
    annotation (Placement(transformation(extent={{-90,-424},{-70,-404}})));
  Modelica.Blocks.MathBoolean.And CheckBoilerConditions(nu=3)
    "if all 3 conditions are met, turn on boiler"
    annotation (Placement(transformation(extent={{-4,-486},{22,-460}})));
  Modelica.Blocks.Logical.Or or2
    "if Toda is smaller than TCutOff, activate Boiler"
    annotation (Placement(transformation(extent={{180,-460},{200,-440}})));
  Modelica.Blocks.Logical.LessThreshold CheckTCut_Off(threshold=
        bivalentControlData.TCutOff) "checks if Toda is below TCutOff"
    annotation (Placement(transformation(extent={{62,-388},{94,-356}})));
 Modelica.Blocks.Sources.RealExpression T_Oda1(final y(
      unit="K",
      displayUnit="degC") = heatingCurve.TOda)
    "Außtentemperatur für Boiler Steuerung" annotation (Placement(
        transformation(
        extent={{-16,-5},{16,5}},
        rotation=0,
        origin={0,-373})));
  Modelica.Blocks.Logical.Switch BoilerSwitch
    "checks if Boiler is allowed to turn on, if not set Gas to 0" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-66,-208})));
  Modelica.Blocks.Sources.Constant ConstZero2(k=0)
    annotation (Placement(transformation(extent={{-8,-248},{-28,-228}})));
  Modelica.Blocks.Logical.Switch thermalDesinfection
    "use Boiler to desinfect DHW tank" annotation (Placement(transformation(
        extent={{5,-5},{-5,5}},
        rotation=0,
        origin={-123,-179})));
  Modelica.Blocks.Sources.Constant constOne(final k=1)
    "maximum Boiler usage for thermal desinfection" annotation (Placement(
        transformation(
        extent={{-5,-5},{5,5}},
        rotation=180,
        origin={-87,-175})));
  Modelica.Blocks.Logical.And OperationalBoundryCheck
    "checks, if hp is allowed to operate regarding operational boundry. If HP_ON = true and IsON=False, then hp is deactivated on purpose. In this case, this signal will be true."
    annotation (Placement(transformation(extent={{-216,-476},{-196,-456}})));
  Modelica.Blocks.Logical.Not not2
    annotation (Placement(transformation(extent={{-282,-462},{-262,-442}})));
  Modelica.Blocks.Sources.BooleanExpression HP_IsON2(y=HP_nSet_Controller.IsOn)
    annotation (Placement(transformation(extent={{-340,-460},{-320,-440}})));
  Modelica.Blocks.Sources.BooleanExpression HP_HP_ON1(y=HP_nSet_Controller.HP_On)
    annotation (Placement(transformation(extent={{-342,-492},{-322,-472}})));
  Modelica.Blocks.Logical.Hysteresis HysteresisBoilerControl(uLow=0.85, uHigh=
        0.9)
    "Hysteresis in boiler Control to check for HP Compressor utilization"
    annotation (Placement(transformation(extent={{-166,-386},{-146,-366}})));
equation
    connect(HP_nSet_Controller.T_Meas, sigBusGen.THeaPumOut) annotation (
       Line(points={{97,61.2},{97,20},{98,20},{98,-22},{-152,-22},{-152,-99}},
                                                                color={0,0,127}),
        Text(
        string="%second",
        index=1,
        extent={{-3,-6},{-3,-6}},
        horizontalAlignment=TextAlignment.Right));

  connect(switch1.y, Boiler_uRel_Controller.T_Set) annotation (Line(points={{68.5,73},
          {68.5,72},{72,72},{72,38},{70,38},{70,32.4},{77,32.4}},
                                                  color={0,0,127}));
  connect(TestBoilerZustand1.y, Boiler_uRel_Controller.HP_On) annotation (Line(
        points={{50.7,5},{50.7,4},{54,4},{54,6},{70,6},{70,24},{77,24}},
                                                     color={255,0,255}));
  connect(TestBoilerZustand1.y, Boiler_uRel_Controller.IsOn) annotation (Line(
        points={{50.7,5},{50.7,4},{54,4},{54,6},{74,6},{74,0},{86,0},{86,7.2}},
                                                               color={255,0,255}));
  connect(Boiler_uRel_Controller.T_Meas, sigBusGen.TBoilerOut) annotation (Line(
        points={{95,7.2},{96,7.2},{96,-74},{-148,-74},{-148,-82},{-152,-82},{
          -152,-99}},                                       color={0,0,127}),
      Text(
      string="%second",
      index=1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  connect(T_Oda.y,lessThreshold. u) annotation (Line(points={{-196.4,-323},{
          -196.4,-320},{-167.2,-320}},
                              color={0,0,127}));
  connect(lessThreshold.y, CheckBoilerConditions.u[1]) annotation (Line(points={{-130.4,
          -320},{-20,-320},{-20,-476.033},{-4,-476.033}},          color={255,0,
          255}));
  connect(or1.y, CheckBoilerConditions.u[2]) annotation (Line(points={{-69,-414},
          {-52,-414},{-52,-416},{-32,-416},{-32,-473},{-4,-473}}, color={255,0,
          255}));
  connect(CheckBoilerConditions.y, or2.u2) annotation (Line(points={{23.95,-473},
          {23.95,-472},{178,-472},{178,-458}}, color={255,0,255}));
  connect(T_Oda1.y,CheckTCut_Off. u) annotation (Line(points={{17.6,-373},{37,
          -373},{37,-372},{58.8,-372}},   color={0,0,127}));
  connect(CheckTCut_Off.y, or2.u1) annotation (Line(points={{95.6,-372},{136,-372},
          {136,-450},{178,-450}}, color={255,0,255}));
  connect(ConstZero2.y, BoilerSwitch.u3) annotation (Line(points={{-29,-238},{-58,
          -238},{-58,-220}}, color={0,0,127}));
  connect(or2.y, BoilerSwitch.u2) annotation (Line(points={{201,-450},{201,-280},
          {-66,-280},{-66,-220}}, color={255,0,255}));
  connect(Boiler_uRel_Controller.n_Set, BoilerSwitch.u1) annotation (Line(
        points={{111.5,24},{116,24},{116,-58},{-74,-58},{-74,-220}}, color={0,0,
          127}));
  connect(BoilerSwitch.y, thermalDesinfection.u3) annotation (Line(points={{-66,
          -197},{-66,-183},{-117,-183}}, color={0,0,127}));
  connect(TSet_DHW.y, thermalDesinfection.u2) annotation (Line(points={{-190.8,
          71.04},{-190.8,-150},{-108,-150},{-108,-179},{-117,-179}}, color={255,
          0,255}));
  connect(constOne.y, thermalDesinfection.u1)
    annotation (Line(points={{-92.5,-175},{-117,-175}}, color={0,0,127}));
  connect(CheckBoilerConditions.u[3], heatDemand_AuxiliarHeater.y) annotation (
      Line(points={{-4,-469.967},{-32,-469.967},{-32,-172},{26.75,-172},{26.75,
          23}}, color={255,0,255}));
  connect(not2.y,OperationalBoundryCheck. u1) annotation (Line(points={{-261,
          -452},{-218,-452},{-218,-466}}, color={255,0,255}));
  connect(HP_IsON2.y,not2. u) annotation (Line(points={{-319,-450},{-302,-450},
          {-302,-452},{-284,-452}},
                           color={255,0,255}));
  connect(HP_HP_ON1.y, OperationalBoundryCheck.u2) annotation (Line(points={{
          -321,-482},{-278,-482},{-278,-474},{-218,-474}}, color={255,0,255}));
  connect(OperationalBoundryCheck.y, or1.u2) annotation (Line(points={{-195,
          -466},{-195,-422},{-92,-422}},
                                   color={255,0,255}));
  connect(thermalDesinfection.y, sigBusGen.yBoiler) annotation (Line(points={{
          -128.5,-179},{-152,-179},{-152,-99}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(HP_NSet.y, HysteresisBoilerControl.u) annotation (Line(points={{
          -216.4,-379},{-192.2,-379},{-192.2,-376},{-168,-376}}, color={0,0,127}));
  connect(HysteresisBoilerControl.y, or1.u1) annotation (Line(points={{-145,
          -376},{-130,-376},{-130,-406},{-92,-406},{-92,-414}}, color={255,0,
          255}));
  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end NewControlBivalentSerial;
