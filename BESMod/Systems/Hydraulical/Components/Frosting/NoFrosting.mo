within BESMod.Systems.Hydraulical.Components.Frosting;
model NoFrosting "Model for no frosting at all times"
  extends BaseClasses.partialIceFac(final use_reverse_cycle=true);
  Modelica.Blocks.Sources.Constant constZero(final k=0) "No energy  needed"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,-70})));
  Modelica.Blocks.Sources.BooleanConstant booCon(final k=true) "Always heating"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={-50,0})));
  Modelica.Blocks.Sources.Constant constOne(final k=1) "Always iceFac=1"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-50,50})));
equation
  connect(constZero.y, P_el_add)
    annotation (Line(points={{0,-81},{0,-110}}, color={0,0,127}));
  connect(booCon.y, genConBus.hp_mode) annotation (Line(points={{-61,8.88178e-16},
          {-88,8.88178e-16},{-88,0},{-108,0}}, color={255,0,255}));
  connect(constOne.y, genConBus.iceFac) annotation (Line(points={{-61,50},{-90,50},
          {-90,0},{-108,0}},           color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  annotation (Icon(graphics={Text(
          extent={{-68,-50},{80,48}},
          lineColor={0,0,0},
          textString="=1")}));
end NoFrosting;
