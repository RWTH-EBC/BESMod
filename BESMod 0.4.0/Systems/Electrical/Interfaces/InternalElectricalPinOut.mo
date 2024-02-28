within BESMod.Systems.Electrical.Interfaces;
connector InternalElectricalPinOut
  "Simplified electrical pin for power flow only within the building energy system"
  extends BESMod.Systems.Electrical.Interfaces.BaseClasses.ElectricalPinOut;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          lineThickness=1,
          fillColor={0,247,123},
          fillPattern=FillPattern.Solid), Line(
          points={{52,90},{-60,-10},{48,12},{-20,-86}},
          color={0,0,0},
          thickness=1,
          arrow={Arrow.None,Arrow.Filled})}),
                                            Diagram(graphics,
                                                    coordinateSystem(
          preserveAspectRatio=false)));
end InternalElectricalPinOut;
