within BESMod.Systems.Hydraulical.Control;
model MonoenergeticHeatPumpSystem
  "Monoenergetic HPS with on/off heating rod"
  extends BaseClasses.PartialHeatPumpSystemController(final meaValSecGen=BESMod.Systems.Hydraulical.Control.Components.BaseClasses.MeasuredValue
        .GenerationSupplyTemperature);

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
equation
  connect(constZero.y,swiSecGen. u3)
    annotation (Line(points={{81,-10},{92,-10},{92,2},{98,2}}, color={0,0,127}));
  connect(swiSecGen.y, sigBusGen.uHeaRod) annotation (Line(points={{121,10},{126,
          10},{126,-60},{-152,-60},{-152,-99}},
                                       color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(buiAndDHWCtr.secGen,swiSecGen. u2) annotation (Line(points={{-118,37.5},
          {-118,36},{-110,36},{-110,10},{28,10},{28,26},{66,26},{66,10},{98,10}},
                                              color={255,0,255}));
  connect(swiSecGen.u1, buiAndDHWCtr.ySecGenSet) annotation (Line(points={{98,18},
          {90,18},{90,45},{-118,45}},     color={0,0,127}));
  connect(buiAndDHWCtr.priGren, priGenPIDCtrl.setOn) annotation (Line(points={{
          -118,27.5},{-100,27.5},{-100,30},{-10,30},{-10,78},{-8,78},{-8,90},{
          100.4,90}}, color={255,0,255}));
end MonoenergeticHeatPumpSystem;
