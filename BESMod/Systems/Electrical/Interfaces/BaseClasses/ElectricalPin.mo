within BESMod.Systems.Electrical.Interfaces.BaseClasses;
partial connector ElectricalPin
  Modelica.SIunits.Power PElecLoa "Electrical power flow; positive = power consumption; negative = power generation";
  Modelica.SIunits.Power PElecGen "Electrical power flow; positive = power generation; negative = power consumption";

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end ElectricalPin;
