within BESMod.Systems.Hydraulical.Control;
model Biv_PI_ConFlow_HPSController
  "Using alt_bivalent + PI Inverter + Return Temperature as controller"
  extends BaseClasses.PartialTwoPoint_HPS_Controller(
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
end Biv_PI_ConFlow_HPSController;
