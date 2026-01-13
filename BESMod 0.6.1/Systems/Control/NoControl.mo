within BESMod.Systems.Control;
model NoControl "No HEMS control"
  extends BaseClasses.PartialControl;
  annotation (Documentation(info="<html>
<p>This is a system that does not control anything. It may be used to disable supervisory control.</p>
</html>"));
end NoControl;
