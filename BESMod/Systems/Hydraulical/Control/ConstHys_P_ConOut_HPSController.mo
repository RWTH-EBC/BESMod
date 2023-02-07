within BESMod.Systems.Hydraulical.Control;
model ConstHys_P_ConOut_HPSController
  "Hys + P with condenser outlet as control variable"
  extends BaseClasses.PartialTwoPoint_HPS_Controller(
    redeclare
      BESMod.Systems.Hydraulical.Control.Components.HeatPumpNSetController.P_InverterHeatPumpController
      HP_nSet_Controller(P=bivalentControlData.k, nMin=bivalentControlData.nMin),
    redeclare
      Components.OnOffController.ConstantHysteresisTimeBasedHR
      BufferOnOffController(Hysteresis=bivalentControlData.dTHysBui, dt_hr=
          bivalentControlData.dtHeaRodBui),
    redeclare
      Components.OnOffController.ConstantHysteresisTimeBasedHR
      DHWOnOffContoller(Hysteresis=bivalentControlData.dTHysDHW, dt_hr=
          bivalentControlData.dtHeaRodDHW));

equation
  connect(HP_nSet_Controller.T_Meas, sigBusGen.THeaPumOut)
    annotation (Line(points={{97,61.2},{97,-99},{-152,-99}},
        color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
end ConstHys_P_ConOut_HPSController;
