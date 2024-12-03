within BESMod.Systems.Electrical.Interfaces;
connector ExternalElectricalPin
  "Simplified electrical pin for power flow outputs to the electricity grid"
  extends BESMod.Systems.Electrical.Interfaces.BaseClasses.ElectricalPinOut;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          lineThickness=1,
          fillColor={0,255,128},
          fillPattern=FillPattern.Solid), Line(
          points={{52,90},{-60,-10},{48,12},{-20,-86}},
          color={0,0,0},
          thickness=1,
          arrow={Arrow.None,Arrow.Filled})}),
                                            Diagram(graphics,
                                                    coordinateSystem(
          preserveAspectRatio=false)));
  annotation (Documentation(info="<html>
<p>
Simplified electrical pin connector for power flow outputs to the electricity grid. 
This connector extends from <a href=\"modelica://BESMod.Systems.Electrical.Interfaces.BaseClasses.ElectricalPinOut\">
BESMod.Systems.Electrical.Interfaces.BaseClasses.ElectricalPinOut</a>.
</p>
</html>"));
end ExternalElectricalPin;
