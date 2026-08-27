within BESMod.Systems.Hydraulical.Control.Components.SummerMode;
model No "No summer mode approach"
  extends BaseClasses.PartialSummerMode;
  Modelica.Blocks.Sources.BooleanConstant noSumMod(final k=false)
    "No summer mode"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
equation
  connect(noSumMod.y, sumMod)
    annotation (Line(points={{11,0},{110,0}}, color={255,0,255}));
end No;
