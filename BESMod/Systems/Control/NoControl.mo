within BESMod.Systems.Control;
model NoControl "No HEMS control"
  extends BaseClasses.PartialControl;
  annotation (Documentation(info="<html>
<p>This class is meant to be selected, when no supervisory control is needed. </p>
</html>"));
end NoControl;
