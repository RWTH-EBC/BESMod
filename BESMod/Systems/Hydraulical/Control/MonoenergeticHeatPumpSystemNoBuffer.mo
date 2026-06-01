within BESMod.Systems.Hydraulical.Control;
model MonoenergeticHeatPumpSystemNoBuffer
  extends BaseClasses.PartialHeatPumpSystemController(
    redeclare model BuildingHysteresis =
        BESMod.Systems.Hydraulical.Control.Components.BivalentOnOffControllers.DegreeMinuteController
        (
        priGenOn(fixed=true),
        secGenOn(start=false, fixed=true),
        DegreeMinute(start=-30, fixed=true)),
    final dTHysBui=0,
      final meaValSecGen=BESMod.Systems.Hydraulical.Control.Components.BaseClasses.MeasuredValue.GenerationSupplyTemperature);

  parameter BESMod.Utilities.SupervisoryControl.Types.SupervisoryControlType supCtrlYGenPumTyp=BESMod.Utilities.SupervisoryControl.Types.SupervisoryControlType.
       Local "Type of supervisory control for generation pump speed"
    annotation (Dialog(group="Heat Pump"));

  Modelica.Blocks.Sources.Constant constZero(final k=0) annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={70,-10})));
  Modelica.Blocks.Logical.Switch swiSecGen "Switch second generator on or off"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={110,10})));

  BESMod.Utilities.SupervisoryControl.SupervisoryControl supCrtGenPum(
    final ctrlType=supCtrlYGenPumTyp)
    annotation (Placement(transformation(extent={{-48,-48},{-28,-28}})));
  replaceable BESMod.Systems.Hydraulical.Control.Components.PumpController.BaseClasses.PartialPumpController pumGenCtrl
    constrainedby BESMod.Systems.Hydraulical.Control.Components.PumpController.BaseClasses.PartialPumpController(
      final dTSet=parGen.dTTra_nominal[1])
    annotation (Dialog(group="Building control"), choicesAllMatching=true,Placement(transformation(extent={{-84,-50},{-64,-30}})));
equation
  connect(constZero.y,swiSecGen. u3)
    annotation (Line(points={{81,-10},{92,-10},{92,2},{98,2}}, color={0,0,127}));
  connect(swiSecGen.y, sigBusGen.uEleHea) annotation (Line(points={{121,10},{126,
          10},{126,-60},{-152,-60},{-152,-99}},
                                       color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(swiSecGen.u1, buiAndDHWCtr.ySecGenSet) annotation (Line(points={{98,18},
          {90,18},{90,39},{-118,39}},     color={0,0,127}));
  connect(logicalDelayPreGen.y2, priGenPIDCtrl.setOn) annotation (Line(points={{
          -61,-10},{-16,-10},{-16,90},{80.4,90}}, color={255,0,255}));
  connect(logicalDelaySecGen.y2, swiSecGen.u2) annotation (Line(points={{-39,24},
          {86,24},{86,10},{98,10}}, color={255,0,255}));
  connect(sigBusGen.TGenOutMea,pumGenCtrl. TSup) annotation (Line(
      points={{-152,-99},{-152,-34},{-86,-34}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(sigBusGen.THeaPumIn,pumGenCtrl. TRet) annotation (Line(
      points={{-152,-99},{-152,-46},{-86,-46}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(anyGenDevIsOn.y,pumGenCtrl. GenOn) annotation (Line(points={{-150,-21.5},
          {-150,-40},{-86,-40}}, color={255,0,255}));
  connect(pumGenCtrl.yPum, supCrtGenPum.uLoc) annotation (Line(points={{-62,-40},
          {-58,-40},{-58,-46},{-50,-46}}, color={0,0,127}));
  connect(supCrtGenPum.y, sigBusDistr.uPumGen) annotation (Line(points={{-26,-38},
          {1,-38},{1,-100}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
end MonoenergeticHeatPumpSystemNoBuffer;
