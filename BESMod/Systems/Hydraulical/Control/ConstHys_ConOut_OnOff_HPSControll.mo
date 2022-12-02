within BESMod.Systems.Hydraulical.Control;
model ConstHys_ConOut_OnOff_HPSControll
  "Constant Hysteresis for an on/off HP with condenser outlet as control variable"
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

  connect(HP_nSet_Controller.T_Meas, sigBusGen.THeaPumOut) annotation (Line(
        points={{97,61.2},{96,61.2},{96,-60},{-150,-60},{-150,-68},{-152,-68},{
          -152,-99}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
end ConstHys_ConOut_OnOff_HPSControll;
