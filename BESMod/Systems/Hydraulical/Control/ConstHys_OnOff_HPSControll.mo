within BESMod.Systems.Hydraulical.Control;
model ConstHys_OnOff_HPSControll
  "Constant Hysteresis for an on/off HP"
  extends BaseClasses.PartialTwoPoint_HPS_Controller(
    redeclare
      BESMod.Systems.Hydraulical.Control.Components.HeatPumpNSetController.OnOffHeatPumpController
      HP_nSet_Controller(final n_opt=nOptHP),
    redeclare
      BESMod.Systems.Hydraulical.Control.Components.OnOffController.ConstantHysteresis
      BufferOnOffController(Hysteresis=bivalentControlData.dTHysBui, dt_hr=
          bivalentControlData.dtHeaRodBui),
    redeclare
      BESMod.Systems.Hydraulical.Control.Components.OnOffController.ConstantHysteresis
      DHWOnOffContoller(Hysteresis=bivalentControlData.dTHysDHW, dt_hr=
          bivalentControlData.dtHeaRodDHW));
  parameter Real nOptHP=0.7
    "Frequency of the heat pump map with an optimal isentropic efficiency. Necessary, as on-off HP will be optimized for this frequency and only used there."
    annotation (Dialog(group="Heat Pumps"));
equation

  connect(sigBusGen.THeaPumpIn, HP_nSet_Controller.T_Meas) annotation (
      Line(
      points={{-152,-99},{-114,-99},{-114,0},{97,0},{97,61.2}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
end ConstHys_OnOff_HPSControll;
