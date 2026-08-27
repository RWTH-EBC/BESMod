within BESMod.BESRules.BaseClasses;
model MPC_API "Partial model with components for MPC API in bes-rules"
  Modelica.Blocks.Interfaces.RealInput yEleHeaSet
    "Electric heater set point, not used, just to store";

  Modelica.Blocks.Interfaces.RealInput TDHWSet(unit="K", displayUnit="degC")
    "DHW set temperature"
    annotation (Placement(transformation(extent={{-356,62},{-316,102}})));
  Modelica.Blocks.Interfaces.BooleanInput actExtDHWCtrl(start=false)
    "Activate external DHW control"
    annotation (Placement(transformation(extent={{-356,12},{-316,52}})));
  Modelica.Blocks.Interfaces.BooleanInput actExtBufCtrl(start=false)
    "Activate external buffer control"
    annotation (Placement(transformation(extent={{-356,-28},{-316,12}})));
  Modelica.Blocks.Interfaces.RealInput TBufSet(unit="K", displayUnit="degC")
    "Buffer set temperature"
    annotation (Placement(transformation(extent={{-356,-66},{-316,-26}})));
  Modelica.Blocks.Interfaces.RealInput yValSet "Valve set point"
    annotation (Placement(transformation(extent={{-356,-134},{-316,-94}})));
  Modelica.Blocks.Interfaces.BooleanInput actExtVal(start=false)
    "Activate external buffer control"
    annotation (Placement(transformation(extent={{-356,-96},{-316,-56}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end MPC_API;
