within BESMod.Systems.Electrical.Interfaces.BaseClasses;
partial connector ElectricalPin
  Modelica.Units.SI.Power PElecLoa
    "Electrical power flow; positive = power consumption; negative = power generation";
  Modelica.Units.SI.Power PElecGen
    "Electrical power flow; positive = power generation; negative = power consumption";

  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(graphics,
        coordinateSystem(preserveAspectRatio=false)));
end ElectricalPin;
