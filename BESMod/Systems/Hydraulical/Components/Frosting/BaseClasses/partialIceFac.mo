within BESMod.Systems.Hydraulical.Components.Frosting.BaseClasses;
partial model partialIceFac "PartialIceFacCalculator"
  parameter Boolean use_reverse_cycle=true "If false, an eletrical heater will be used instead of reverse cycle method";
  parameter Modelica.Units.SI.SpecificEnthalpy h_water_fusion=333.5e3 "Fusion enthalpy of water (Schmelzenthalpie)";
  parameter Real eta_hr=1 "Efficiency of used heating rod"
    annotation (Dialog(enable=not use_reverse_cycle));
  parameter Modelica.Units.SI.Power P_el_hr=0 "Heating power of heating rod" annotation (Dialog(enable=not use_reverse_cycle));

  Modelica.Blocks.Interfaces.RealOutput P_el_add
    "Additional power required to defrost"       annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,-110}), iconTransformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={2,-110})));
  Modelica.Blocks.Interfaces.RealInput relHum
    "Input relative humidity of outdoor air" annotation (Placement(
        transformation(extent={{-140,60},{-100,100}}), iconTransformation(
          extent={{-140,56},{-100,96}})));
  AixLib.Controls.Interfaces.VapourCompressionMachineControlBus
                                  genConBus
    "Bus with the most relevant information for hp frosting calculation"
    annotation (Placement(transformation(extent={{-128,-20},{-88,20}}),
        iconTransformation(extent={{-130,-20},{-90,20}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5), Text(
          extent={{-76,102},{66,66}},
          lineColor={28,108,200},
          textString="%name%")}),                                Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end partialIceFac;
