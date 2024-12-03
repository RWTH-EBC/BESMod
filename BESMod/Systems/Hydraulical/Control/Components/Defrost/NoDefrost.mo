within BESMod.Systems.Hydraulical.Control.Components.Defrost;
model NoDefrost "No defrost, always heating"
  extends BaseClasses.PartialDefrost;
  Modelica.Blocks.Sources.BooleanConstant booCon(final k=true) "Always heating"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0)));
equation
  connect(booCon.y, hea)
    annotation (Line(points={{11,0},{110,0}}, color={255,0,255}));
  annotation (Icon(graphics={Text(
          extent={{-68,-50},{80,48}},
          lineColor={0,0,0},
          textString="=1")}));
  annotation (Documentation(info="<html>
<p>Simple defrost model which disables defrost by always enabling heating mode.</p>
</html>"));
end NoDefrost;
