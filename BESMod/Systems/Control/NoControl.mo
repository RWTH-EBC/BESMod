within BESMod.Systems.Control;
model NoControl "No HEMS control"
  extends BaseClasses.PartialControl;
  annotation (Documentation(info="<html>
<p>When no supervisory controll is needed, this class is meant to be selected. </p>
</html>"));
end NoControl;
