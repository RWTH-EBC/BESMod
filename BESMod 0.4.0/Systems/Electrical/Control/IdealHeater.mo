within BESMod.Systems.Electrical.Control;
model IdealHeater "Ideal heater control"
  extends BESMod.Systems.Electrical.Control.BaseClasses.PartialControl;
  Modelica.Blocks.Routing.RealPassThrough reaPasThr[nParallelDem]
    "Pass through expandable signal"
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
equation
  connect(reaPasThr.u, useProBus.TZoneSet) annotation (Line(points={{-2,10},{-91,10},
          {-91,103}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(reaPasThr.y, transferControlBus.TZoneSet) annotation (Line(points={{21,10},
          {177,10},{177,-99}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end IdealHeater;
