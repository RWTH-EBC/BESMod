within BESMod.Systems.Hydraulical.Control;
model ConstHys_PI_ConOut_HPSController
  "Hys + PI with condenser outlet as control variable"
  extends BaseClasses.PartialTwoPoint_HPS_Controller(
    redeclare
      BESMod.Systems.Hydraulical.Control.Components.HeatPumpNSetController.PI_InverterHeatPumpController
      HP_nSet_Controller(
      P=bivalentControlData.k,
      nMin=bivalentControlData.nMin,
      T_I=bivalentControlData.T_I),
    redeclare
      BESMod.Systems.Hydraulical.Control.Components.OnOffController.ConstantHysteresisTimeBasedHR
      BufferOnOffController(
      Hysteresis=bivalentControlData.dTHysBui,
      dt_hr=bivalentControlData.dtHeaRodBui,
      addSet_dt_hr=bivalentControlData.addSet_dtHeaRodBui),
    redeclare
      BESMod.Systems.Hydraulical.Control.Components.OnOffController.ConstantHysteresisTimeBasedHR
      DHWOnOffContoller(
      Hysteresis=bivalentControlData.dTHysDHW,
      dt_hr=bivalentControlData.dtHeaRodDHW,
      addSet_dt_hr=bivalentControlData.addSet_dtHeaRodDHW));

equation
  connect(HP_nSet_Controller.T_Meas, sigBusGen.THeaPumOut) annotation (
      Line(points={{97,61.2},{97,-64},{-152,-64},{-152,-99}},  color={0,0,127}),
      Text(
      string="%second",
      index=1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
end ConstHys_PI_ConOut_HPSController;
