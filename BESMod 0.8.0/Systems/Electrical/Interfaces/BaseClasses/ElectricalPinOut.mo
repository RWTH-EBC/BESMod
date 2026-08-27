within BESMod.Systems.Electrical.Interfaces.BaseClasses;
partial connector ElectricalPinOut
  output Modelica.Units.SI.Power PElecLoa
    "Electrical power flow; positive = power consumption; negative = power generation";
  output Modelica.Units.SI.Power PElecGen
    "Electrical power flow; positive = power generation; negative = power consumption";

  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(graphics,
        coordinateSystem(preserveAspectRatio=false)));
end ElectricalPinOut;
