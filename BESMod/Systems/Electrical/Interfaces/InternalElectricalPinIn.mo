within BESMod.Systems.Electrical.Interfaces;
connector InternalElectricalPinIn
  "Simplified electrical pin for power flow inputs only within the building energy system"
  extends BESMod.Systems.Electrical.Interfaces.BaseClasses.ElectricalPinIn;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          lineThickness=1,
          fillColor={0,140,72},
          fillPattern=FillPattern.Solid), Line(
          points={{52,90},{-60,-10},{48,12},{-20,-86}},
          color={0,0,0},
          thickness=1,
          arrow={Arrow.None,Arrow.Filled})}),
                                            Diagram(graphics,
                                                    coordinateSystem(
          preserveAspectRatio=false)));
  annotation (Documentation(info="<html>
<p>A simplified electrical pin connector for power flow inputs within building energy systems. 
This connector extends from <a href=\"modelica://BESMod.Systems.Electrical.Interfaces.BaseClasses.ElectricalPinIn\">
BESMod.Systems.Electrical.Interfaces.BaseClasses.ElectricalPinIn</a>.</p>
<h4>Usage</h4>
<p>This connector is intended for internal connections between electrical components 
of building energy systems, where only power flow inputs need to be considered.</p></html>"));
end InternalElectricalPinIn;
