within BESMod.Systems.Hydraulical.Control;
model ConstHys_PI_StoTop_HPSController
  "Using const. hys + PI Inverter + top level storage as controller"
  extends BaseClasses.PartialTwoPoint_HPS_Controller(
    redeclare
      BESMod.Systems.Hydraulical.Control.Components.HeatPumpNSetController.PI_InverterHeatPumpController
      HP_nSet_Controller(
      P=bivalentControlData.k,
      nMin=bivalentControlData.nMin,
      T_I=bivalentControlData.T_I),
    redeclare
      Components.OnOffController.ConstantHysteresisTimeBasedHR
      BufferOnOffController(Hysteresis=bivalentControlData.dTHysBui, dt_hr=
          bivalentControlData.dtHeaRodBui),
    redeclare
      Components.OnOffController.ConstantHysteresisTimeBasedHR
      DHWOnOffContoller(Hysteresis=bivalentControlData.dTHysDHW, dt_hr=
          bivalentControlData.dtHeaRodDHW));

  Modelica.Blocks.Logical.Switch switch2 "on: DHW, off: Buffer"
    annotation (Placement(transformation(extent={{-5,-5},{5,5}},
        rotation=90,
        origin={83,-27})));
equation
  connect(DHWHysOrLegionella.y, switch2.u2) annotation (Line(points={{-71.25,
          69},{-20,69},{-20,-30},{6,-30},{6,-33},{83,-33}}, color={255,0,255}));
  connect(switch2.u1, sigBusDistr.T_StoDHW_top) annotation (Line(points={{79,-33},
          {79,-62},{108,-62},{108,-100},{1,-100}},                    color={
          0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  connect(switch2.u3, sigBusDistr.T_StoBuf_top) annotation (Line(points={{87,-33},
          {87,-46},{1,-46},{1,-100}},                      color={0,0,127}),
      Text(
      string="%second",
      index=1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
end ConstHys_PI_StoTop_HPSController;
