within BESMod.Systems.Hydraulical.Control;
model NewControlBivalentParallel
  "Bivalent Parallel Generation Control Class (Part-parallel PI controlled HPS according to condenser outflow)"
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
    annotation (choicesAllMatching=true, Placement(transformation(extent={{68,14},
            {98,42}})));
  Modelica.Blocks.Sources.BooleanConstant BooleanConstant(final k=true)
    annotation (Placement(transformation(
        extent={{-7,-7},{7,7}},
        rotation=0,
        origin={43,17})));
 Modelica.Blocks.Sources.RealExpression T_Oda(final y(
      unit="K",
      displayUnit="degC") = heatingCurve.TOda)
                                              annotation (Placement(
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
  Modelica.Blocks.Logical.And OperationalBoundryCheck
    "checks, if hp is allowed to operate regarding operational boundry. If HP_ON = true and IsON=False, then hp is deactivated on purpose. In this case, this signal will be true."
    annotation (Placement(transformation(extent={{-158,-464},{-138,-444}})));
  Modelica.Blocks.Logical.Not not1
    annotation (Placement(transformation(extent={{-224,-450},{-204,-430}})));
  Modelica.Blocks.Sources.BooleanExpression HP_IsON1(y=HP_nSet_Controller.IsOn)
    annotation (Placement(transformation(extent={{-282,-448},{-262,-428}})));
  Modelica.Blocks.Sources.BooleanExpression HP_HP_ON(y=HP_nSet_Controller.HP_On)
    annotation (Placement(transformation(extent={{-284,-480},{-264,-460}})));
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
  Modelica.Blocks.Sources.Constant const3(k=0.5) "WP und Boiler"
    annotation (Placement(transformation(extent={{-800,-38},{-780,-18}})));
  Modelica.Blocks.Logical.Switch ThrWayVal1
    "to decide position of three way vlave in generation class" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-708,-70})));
  Modelica.Blocks.Sources.Constant const2(k=1) "nur WP"
    annotation (Placement(transformation(extent={{-800,-100},{-780,-80}})));
  Modelica.Blocks.Logical.Switch ThrWayVal2
    "to decide position of three way vlave in generation class" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-634,-104})));
  Modelica.Blocks.Sources.Constant const1(k=0) "nur Boiler falls TCutOff"
    annotation (Placement(transformation(extent={{-682,-32},{-662,-12}})));
  Modelica.Blocks.Logical.Switch ThrWayVal3
    "to decide position of three way vlave in generation class" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-520,-104})));
  Modelica.Blocks.Sources.Constant const4(k=0.5) "WP und Boiler"
    annotation (Placement(transformation(extent={{-596,-76},{-576,-56}})));
  Modelica.Blocks.Logical.Hysteresis HysteresisBoilerControl(uLow=0.85, uHigh=
        0.9)
    "Hysteresis in boiler Control to check for HP Compressor utilization"
    annotation (Placement(transformation(extent={{-192,-408},{-172,-388}})));
equation
    connect(HP_nSet_Controller.T_Meas, sigBusGen.THeaPumOut) annotation (
       Line(points={{97,61.2},{97,56},{98,56},{98,50},{138,50},{138,-36},{-152,
          -36},{-152,-99}},                                     color={0,0,127}),
        Text(
        string="%second",
        index=1,
        extent={{-3,-6},{-3,-6}},
        horizontalAlignment=TextAlignment.Right));

  connect(switch1.y, Boiler_uRel_Controller.T_Set) annotation (Line(points={{68.5,73},
          {68.5,72},{72,72},{72,48},{58,48},{58,36.4},{65,36.4}},
                                                  color={0,0,127}));
  connect(BooleanConstant.y, Boiler_uRel_Controller.HP_On) annotation (Line(
        points={{50.7,17},{50.7,4},{56,4},{56,28},{65,28}},
                                                     color={255,0,255}));
  connect(BooleanConstant.y, Boiler_uRel_Controller.IsOn) annotation (Line(
        points={{50.7,17},{50.7,4},{74,4},{74,11.2}},          color={255,0,255}));
  connect(Boiler_uRel_Controller.T_Meas, sigBusGen.TBoilerOut) annotation (Line(
        points={{83,11.2},{82,11.2},{82,-60},{-150,-60},{-150,-68},{-152,-68},{
          -152,-99}},                                       color={0,0,127}),
      Text(
      string="%second",
      index=1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  connect(T_Oda.y,lessThreshold. u) annotation (Line(points={{-196.4,-323},{
          -196.4,-320},{-167.2,-320}},
                              color={0,0,127}));
  connect(not1.y, OperationalBoundryCheck.u1) annotation (Line(points={{-203,
          -440},{-160,-440},{-160,-454}}, color={255,0,255}));
  connect(HP_IsON1.y,not1. u) annotation (Line(points={{-261,-438},{-244,-438},
          {-244,-440},{-226,-440}},
                           color={255,0,255}));
  connect(HP_HP_ON.y, OperationalBoundryCheck.u2) annotation (Line(points={{-263,
          -470},{-220,-470},{-220,-462},{-160,-462}}, color={255,0,255}));
  connect(OperationalBoundryCheck.y, or1.u2) annotation (Line(points={{-137,-454},
          {-137,-422},{-92,-422}}, color={255,0,255}));
  connect(lessThreshold.y, CheckBoilerConditions.u[1]) annotation (Line(points={{-130.4,
          -320},{-20,-320},{-20,-476.033},{-4,-476.033}},         color={255,0,255}));
  connect(or1.y, CheckBoilerConditions.u[2]) annotation (Line(points={{-69,-414},
          {-52,-414},{-52,-416},{-32,-416},{-32,-473},{-4,-473}}, color={255,0,255}));
  connect(CheckBoilerConditions.y, or2.u2) annotation (Line(points={{23.95,-473},
          {23.95,-472},{178,-472},{178,-458}}, color={255,0,255}));
  connect(T_Oda1.y,CheckTCut_Off. u) annotation (Line(points={{17.6,-373},{37,
          -373},{37,-372},{58.8,-372}},   color={0,0,127}));
  connect(CheckTCut_Off.y, or2.u1) annotation (Line(points={{95.6,-372},{136,-372},
          {136,-450},{178,-450}}, color={255,0,255}));
  connect(heatDemand_AuxiliarHeater.y, CheckBoilerConditions.u[3]) annotation (
      Line(points={{26.75,23},{26.75,-196},{26,-196},{26,-469.967},{-4,-469.967}},
        color={255,0,255}));
  connect(constZero2.y, BoilerSwitch.u3) annotation (Line(points={{-29,-238},{-58,
          -238},{-58,-220}}, color={0,0,127}));
  connect(or2.y, BoilerSwitch.u2) annotation (Line(points={{201,-450},{201,-280},
          {-66,-280},{-66,-220}}, color={255,0,255}));
  connect(Boiler_uRel_Controller.n_Set, BoilerSwitch.u1) annotation (Line(
        points={{99.5,28},{104,28},{104,-46},{-42,-46},{-42,-100},{-74,-100},{
          -74,-220}},                                       color={0,0,127}));
  connect(BoilerSwitch.y, thermalDesinfection.u3) annotation (Line(points={{-66,
          -197},{-66,-183},{-117,-183}}, color={0,0,127}));
  connect(TSet_DHW.y, thermalDesinfection.u2) annotation (Line(points={{-190.8,71.04},
          {-190.8,-150},{-108,-150},{-108,-179},{-117,-179}}, color={255,0,255}));
  connect(constOne.y, thermalDesinfection.u1)
    annotation (Line(points={{-92.5,-175},{-117,-175}}, color={0,0,127}));
  connect(const3.y, ThrWayVal1.u1) annotation (Line(points={{-779,-28},{-750,-28},
          {-750,-62},{-720,-62}}, color={0,0,127}));
  connect(const2.y, ThrWayVal1.u3) annotation (Line(points={{-779,-90},{-750,-90},
          {-750,-78},{-720,-78}}, color={0,0,127}));
  connect(ThrWayVal1.y, ThrWayVal2.u3) annotation (Line(points={{-697,-70},{-672,
          -70},{-672,-112},{-646,-112}}, color={0,0,127}));
  connect(const1.y, ThrWayVal2.u1) annotation (Line(points={{-661,-22},{-661,-59},
          {-646,-59},{-646,-96}}, color={0,0,127}));
  connect(CheckBoilerConditions.y, ThrWayVal1.u2) annotation (Line(points={{23.95,
          -473},{23.95,-352},{-922,-352},{-922,-70},{-720,-70}}, color={255,0,255}));
  connect(CheckTCut_Off.y, ThrWayVal2.u2) annotation (Line(points={{95.6,-372},
          {116,-372},{116,-290},{-686,-290},{-686,-104},{-646,-104}}, color={
          255,0,255}));
  connect(ThrWayVal2.y, ThrWayVal3.u3) annotation (Line(points={{-623,-104},{-578,
          -104},{-578,-112},{-532,-112}}, color={0,0,127}));
  connect(const4.y, ThrWayVal3.u1) annotation (Line(points={{-575,-66},{-560,-66},
          {-560,-96},{-532,-96}}, color={0,0,127}));
  connect(TSet_DHW.y, ThrWayVal3.u2) annotation (Line(points={{-190.8,71.04},{-190.8,
          188},{-550,188},{-550,-104},{-532,-104}}, color={255,0,255}));
  connect(HP_NSet.y, HysteresisBoilerControl.u) annotation (Line(points={{
          -216.4,-379},{-204,-379},{-204,-398},{-194,-398}}, color={0,0,127}));
  connect(HysteresisBoilerControl.y, or1.u1) annotation (Line(points={{-171,
          -398},{-132,-398},{-132,-414},{-92,-414}}, color={255,0,255}));
  connect(ThrWayVal3.y, sigBusGen.uThrWayValGen) annotation (Line(points={{-509,
          -104},{-370,-104},{-370,-128},{-142,-128},{-142,-99},{-152,-99}},
        color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(thermalDesinfection.y, sigBusGen.yBoiler) annotation (Line(points={{-128.5,
          -179},{-152,-179},{-152,-99}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end NewControlBivalentParallel;
