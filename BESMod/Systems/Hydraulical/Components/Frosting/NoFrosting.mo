within BESMod.Systems.Hydraulical.Components.Frosting;
model NoFrosting "Model for no frosting at all times"
  extends BaseClasses.PartialFrosting;
  Modelica.Blocks.Sources.BooleanConstant booCon(final k=true) "Always heating"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={10,-60})));
  Modelica.Blocks.Sources.Constant constOne(final k=1) "Always iceFac=1"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={10,60})));
equation
  connect(constOne.y, iceFacMea)
    annotation (Line(points={{21,60},{110,60}}, color={0,0,127}));
  connect(booCon.y, modeHeaPum)
    annotation (Line(points={{21,-60},{110,-60}}, color={255,0,255}));
  annotation (Icon(graphics={Text(
          extent={{-68,-50},{80,48}},
          lineColor={0,0,0},
          textString="=1")}));
end NoFrosting;
