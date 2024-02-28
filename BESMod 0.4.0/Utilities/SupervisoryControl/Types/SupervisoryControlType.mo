within BESMod.Utilities.SupervisoryControl.Types;
type SupervisoryControlType = enumeration(
    Local "Local control only",
    Internal "Modelica internal supervisory control",
    External "External supervisory control (e.g. FMU, python)")
      "Enum for supervisory control type";
