within BESMod.Systems.Hydraulical.Control;
model MonoenergeticHeatPumpSystem
  "Monoenergetic HPS with on/off electric heater"
  extends BaseClasses.PartialHeatPumpSystemController(
    final meaValSecGen=BESMod.Systems.Hydraulical.Control.Components.BaseClasses.MeasuredValue.GenerationSupplyTemperature);

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
  Modelica.Blocks.Sources.Constant constTraPumOn(final k=1)
   annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-50,-30})));

  parameter BESMod.Utilities.SupervisoryControl.Types.SupervisoryControlType
  supCtrluHRSetTyp=BESMod.Utilities.SupervisoryControl.Types.SupervisoryControlType.
       Local "Type of supervisory control for heating rod"
    annotation (Dialog(group="Heat Pump"));
  BESMod.Utilities.SupervisoryControl.SupervisoryControl supCtruHRset(final
      ctrlType=supCtrluHRSetTyp) "Supervisory control of heating rod"
    annotation (Placement(transformation(extent={{134,0},{154,20}})));

equation
  connect(constZero.y,swiSecGen. u3)
    annotation (Line(points={{81,-10},{92,-10},{92,2},{98,2}}, color={0,0,127}));
  connect(swiSecGen.u1, buiAndDHWCtr.ySecGenSet) annotation (Line(points={{98,18},
          {90,18},{90,39},{-118,39}},     color={0,0,127}));
  connect(buiAndDHWCtr.priGren, priGenPIDCtrl.setOn) annotation (Line(points={{-118,
          27.3333},{-104,27.3333},{-104,90},{80.4,90}},
                      color={255,0,255}));
  connect(secGenOn.y, swiSecGen.u2) annotation (Line(points={{-69,30},{88,30},{
          88,10},{98,10}}, color={255,0,255}));
  connect(constTraPumOn.y, sigBusDistr.uPumTra) annotation (Line(points={{-39,-30},
          {-34,-30},{-34,-82},{-42,-82},{-42,-100},{1,-100}}, color={0,0,127}),
      Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(supCtruHRset.y, sigBusGen.uEleHea) annotation (Line(points={{156,10},{
          178,10},{178,-48},{-152,-48},{-152,-99}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(swiSecGen.y, supCtruHRset.uLoc) annotation (Line(points={{121,10},{126,
          10},{126,2},{132,2}}, color={0,0,127}));
end MonoenergeticHeatPumpSystem;
