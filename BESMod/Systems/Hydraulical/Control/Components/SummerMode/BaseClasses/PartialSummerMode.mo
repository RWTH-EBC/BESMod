within BESMod.Systems.Hydraulical.Control.Components.SummerMode.BaseClasses;
partial model PartialSummerMode "Partial summer mode model"
  Modelica.Blocks.Interfaces.RealInput TOda(unit="K", displayUnit="degC")
    "Outdoor air temperature"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.BooleanOutput sumMod "=true for summer mode"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
  annotation (Documentation(info="<html>
<p>Partial model defining a basic interface for summer mode determination. 
The model takes outdoor air temperature as input and provides a 
boolean output signal indicating if summer mode is active.</p>
</html>"));
end PartialSummerMode;
