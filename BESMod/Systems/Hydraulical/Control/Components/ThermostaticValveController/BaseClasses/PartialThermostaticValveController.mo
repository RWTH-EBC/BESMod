within BESMod.Systems.Hydraulical.Control.Components.ThermostaticValveController.BaseClasses;
partial model PartialThermostaticValveController
  parameter Integer nZones(min=1) "Number of zones";
  parameter Real leakageOpening = 0.0001
    "may be useful for simulation stability. Always check the influence it has on your results";
  parameter Utilities.SupervisoryControl.Types.SupervisoryControlType
    supCtrlTyp=BESMod.Utilities.SupervisoryControl.Types.SupervisoryControlType.Local
    "Type of supervisory control";
  Modelica.Blocks.Interfaces.RealInput TZoneMea[nZones]
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  Modelica.Blocks.Interfaces.RealOutput opening[nZones]
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));
  Modelica.Blocks.Interfaces.RealInput TZoneSet[nZones]
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));
  BESMod.Utilities.SupervisoryControl.SupervisoryControl supCtrl[nZones](each final
      ctrlType=supCtrlTyp)
    "Supervisory control to possibly override local control"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));

equation
  connect(supCtrl.y, opening)
    annotation (Line(points={{82,0},{120,0}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5)}),                                  Diagram(coordinateSystem(preserveAspectRatio=false)));
end PartialThermostaticValveController;
