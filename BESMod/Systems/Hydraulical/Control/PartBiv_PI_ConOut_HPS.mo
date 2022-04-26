within BESMod.Systems.Hydraulical.Control;
model PartBiv_PI_ConOut_HPS
  "Part-parallel PI controlled HPS according to condenser outflow"
  extends BaseClasses.PartialTwoPoint_HPS_Controller(
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

    parameter Modelica.SIunits.Temperature TCutOff "Cut-off temperature";
    parameter Modelica.SIunits.HeatFlowRate QHP_flow_cutOff;

equation
    connect(HP_nSet_Controller.T_Meas, sigBusGen.hp_bus.TConOutMea) annotation (
       Line(points={{97,61.2},{97,-56},{-152,-56},{-152,-99}},  color={0,0,127}),
        Text(
        string="%second",
        index=1,
        extent={{-3,-6},{-3,-6}},
        horizontalAlignment=TextAlignment.Right));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartBiv_PI_ConOut_HPS;
