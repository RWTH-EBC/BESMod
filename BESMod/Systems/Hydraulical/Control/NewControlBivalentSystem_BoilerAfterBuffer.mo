within BESMod.Systems.Hydraulical.Control;
model NewControlBivalentSystem_BoilerAfterBuffer
  "intended use for bivalent systems with boiler after buffer (Part-parallel PI controlled HPS according to condenser outflow)"
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
    annotation (choicesAllMatching=true, Placement(transformation(extent={{74,12},
            {104,40}})));
  Modelica.Blocks.Sources.BooleanConstant TestBoilerZustand1(final k=true)
    annotation (Placement(transformation(
        extent={{-7,-7},{7,7}},
        rotation=0,
        origin={51,7})));
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
        bivalentControlData.TBiv) "checks, if Toda is below Tbiv"
    annotation (Placement(transformation(extent={{-164,-336},{-132,-304}})));
  Modelica.Blocks.Logical.Or or1
    "entweder WP im Sperrmodus oder voll ausgelastet"
    annotation (Placement(transformation(extent={{-90,-424},{-70,-404}})));
  Modelica.Blocks.MathBoolean.And CheckBoilerConditions(nu=3)
    "if all 3 conditions are met, turn on boiler"
    annotation (Placement(transformation(extent={{-4,-486},{22,-460}})));
  Modelica.Blocks.Logical.Or or2
    "if Toda is smaller than TCutOff, activate Boiler"
    annotation (Placement(transformation(extent={{180,-460},{200,-440}})));
  Modelica.Blocks.Logical.LessThreshold CheckTCut_Off(threshold=
        bivalentControlData.TCutOff) "checks if Toda  is below TCutOff"
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
  Modelica.Blocks.Sources.Constant constZero2(k=0)
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
    annotation (Placement(transformation(extent={{-146,-480},{-126,-460}})));
  Modelica.Blocks.Logical.Not not2
    annotation (Placement(transformation(extent={{-212,-466},{-192,-446}})));
  Modelica.Blocks.Sources.BooleanExpression HP_IsON2(y=HP_nSet_Controller.IsOn)
    annotation (Placement(transformation(extent={{-270,-464},{-250,-444}})));
  Modelica.Blocks.Sources.BooleanExpression HP_HP_ON1(y=HP_nSet_Controller.HP_On)
    annotation (Placement(transformation(extent={{-272,-496},{-252,-476}})));
  Modelica.Blocks.Logical.Hysteresis HysteresisBoilerControl(uLow=0.85, uHigh=
        0.9)
    "Hysteresis in boiler Control to check for HP Compressor utilization"
    annotation (Placement(transformation(extent={{-152,-394},{-132,-374}})));
equation
    connect(HP_nSet_Controller.T_Meas, sigBusGen.THeaPumOut) annotation (
       Line(points={{97,61.2},{97,50},{146,50},{146,-36},{-152,-36},{-152,-99}},
                                                                color={0,0,127}),
        Text(
        string="%second",
        index=1,
        extent={{-3,-6},{-3,-6}},
        horizontalAlignment=TextAlignment.Right));

  connect(switch1.y, Boiler_uRel_Controller.T_Set) annotation (Line(points={{68.5,73},
          {68.5,72},{72,72},{72,46},{64,46},{64,34.4},{71,34.4}},
                                                  color={0,0,127}));
  connect(TestBoilerZustand1.y, Boiler_uRel_Controller.HP_On) annotation (Line(
        points={{58.7,7},{58.7,6},{64,6},{64,26},{71,26}},
                                                     color={255,0,255}));
  connect(TestBoilerZustand1.y, Boiler_uRel_Controller.IsOn) annotation (Line(
        points={{58.7,7},{58.7,6},{72,6},{72,2},{80,2},{80,9.2}},
                                                               color={255,0,255}));
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
  connect(constZero2.y, BoilerSwitch.u3) annotation (Line(points={{-29,-238},{-58,
          -238},{-58,-220}}, color={0,0,127}));
  connect(or2.y, BoilerSwitch.u2) annotation (Line(points={{201,-450},{201,-280},
          {-66,-280},{-66,-220}}, color={255,0,255}));
  connect(Boiler_uRel_Controller.n_Set, BoilerSwitch.u1) annotation (Line(
        points={{105.5,26},{110,26},{110,-58},{-42,-58},{-42,-100},{-74,-100},{
          -74,-220}}, color={0,0,127}));
  connect(BoilerSwitch.y, thermalDesinfection.u3) annotation (Line(points={{-66,
          -197},{-66,-183},{-117,-183}}, color={0,0,127}));
  connect(TSet_DHW.y, thermalDesinfection.u2) annotation (Line(points={{-190.8,
          71.04},{-190.8,-150},{-108,-150},{-108,-179},{-117,-179}}, color={255,
          0,255}));
  connect(constOne.y, thermalDesinfection.u1)
    annotation (Line(points={{-92.5,-175},{-117,-175}}, color={0,0,127}));
  connect(Boiler_uRel_Controller.T_Meas, sigBusDistr.TBoilerOutDistribution)
    annotation (Line(points={{89,9.2},{88,9.2},{88,-60},{1,-60},{1,-100}},
                                                                    color={0,0,
          127}), Text(
      string="%second",
      index=1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  connect(CheckBoilerConditions.u[3], heatDemand_AuxiliarHeater.y) annotation (
      Line(points={{-4,-469.967},{-28,-469.967},{-28,6},{40,6},{40,20},{26.75,20},
          {26.75,23}},     color={255,0,255}));
  connect(not2.y,OperationalBoundryCheck. u1) annotation (Line(points={{-191,
          -456},{-148,-456},{-148,-470}}, color={255,0,255}));
  connect(HP_IsON2.y,not2. u) annotation (Line(points={{-249,-454},{-232,-454},
          {-232,-456},{-214,-456}},
                           color={255,0,255}));
  connect(HP_HP_ON1.y, OperationalBoundryCheck.u2) annotation (Line(points={{
          -251,-486},{-208,-486},{-208,-478},{-148,-478}}, color={255,0,255}));
  connect(OperationalBoundryCheck.y, or1.u2) annotation (Line(points={{-125,
          -470},{-125,-422},{-92,-422}},
                                   color={255,0,255}));
  connect(thermalDesinfection.y, sigBusDistr.yBoilerDistribution) annotation (
      Line(points={{-128.5,-179},{-154,-179},{-154,-150},{1,-150},{1,-100}},
        color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(HP_NSet.y, HysteresisBoilerControl.u) annotation (Line(points={{
          -216.4,-379},{-185.2,-379},{-185.2,-384},{-154,-384}}, color={0,0,127}));
  connect(HysteresisBoilerControl.y, or1.u1) annotation (Line(points={{-131,
          -384},{-116,-384},{-116,-414},{-92,-414},{-92,-414}}, color={255,0,
          255}));
  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end NewControlBivalentSystem_BoilerAfterBuffer;
