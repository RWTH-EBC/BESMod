within BESMod.Systems.Ventilation.Control;
model NoControl "Dont control anything"
  extends BaseClasses.PartialControl;
  annotation (Documentation(info="<html>
<p>This class is meant to be selected, when no supervisory control is needed. </p>
</html>"));
end NoControl;
