within BESMod.Systems.Electrical.Control;
model NoControl
  extends BESMod.Systems.Electrical.Control.BaseClasses.PartialControl;
  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>This class is meant to be selected, when no supervisory control is needed. </p>
</html>"));
end NoControl;
