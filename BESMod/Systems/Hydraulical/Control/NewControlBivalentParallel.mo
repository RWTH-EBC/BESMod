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
      BESMod.Systems.Hydraulical.Control.Components.OnOffController.PartParallelBivalent
      BufferOnOffController(
      Hysteresis=bivalentControlData.dTHysBui,
      TCutOff=TCutOff,
      TBiv=bivalentControlData.TBiv,
      TOda_nominal=bivalentControlData.TOda_nominal,
      TRoom=bivalentControlData.TSetRoomConst,
      QDem_flow_nominal=sum(parTra.Q_flow_nominal),
      QHP_flow_cutOff=QHP_flow_cutOff),
    redeclare
      BESMod.Systems.Hydraulical.Control.Components.OnOffController.PartParallelBivalent
      DHWOnOffContoller(
      Hysteresis=bivalentControlData.dTHysDHW,
      TCutOff=TCutOff,
      TBiv=bivalentControlData.TBiv,
      TOda_nominal=bivalentControlData.TOda_nominal,
      TRoom=bivalentControlData.TSetRoomConst,
      QDem_flow_nominal=sum(parTra.Q_flow_nominal),
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
equation
    connect(HP_nSet_Controller.T_Meas, sigBusGen.THeaPumOut) annotation (
       Line(points={{110,80.4},{110,56},{98,56},{98,50},{138,50},{138,-36},{-152,
          -36},{-152,-99}},                                     color={0,0,127}),
        Text(
        string="%second",
        index=1,
        extent={{-3,-6},{-3,-6}},
        horizontalAlignment=TextAlignment.Right));

  connect(switch1.y, Boiler_uRel_Controller.T_Set) annotation (Line(points={{68.5,73},
          {68.5,72},{72,72},{72,48},{58,48},{58,34.4},{71,34.4}},
                                                  color={0,0,127}));
  connect(Boiler_uRel_Controller.T_Meas, sigBusGen.TBoilerOut) annotation (Line(
        points={{89,9.2},{82,9.2},{82,-60},{-150,-60},{-150,-68},{-152,-68},{-152,
          -99}},                                            color={0,0,127}),
      Text(
      string="%second",
      index=1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end NewControlBivalentParallel;
