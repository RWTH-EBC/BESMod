within BESMod.Systems.Hydraulical.Control.Components.BaseClasses;
model HeatPumpBusPassThrough
  Interfaces.GenerationControlBus sigBusGen
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  AixLib.Obsolete.Year2024.Controls.Interfaces.VapourCompressionMachineControlBus
    vapourCompressionMachineControlBus
    annotation (Placement(transformation(extent={{82,-22},{122,18}})));
  Modelica.Blocks.Routing.RealPassThrough realPassThrough[4]
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Routing.BooleanPassThrough booleanPassThrough
    annotation (Placement(transformation(extent={{-10,-40},{10,-20}})));
equation
  connect(booleanPassThrough.u, sigBusGen.heaPumIsOn) annotation (Line(points={{
          -12,-30},{-86,-30},{-86,0},{-100,0}}, color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(booleanPassThrough.y, vapourCompressionMachineControlBus.onOffMea)
    annotation (Line(points={{11,-30},{46,-30},{46,-26},{102.1,-26},{102.1,-1.9}},
        color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(realPassThrough[1].u, sigBusGen.THeaPumIn) annotation (Line(points={{-12,
          0},{-100,0}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(realPassThrough[1].y, vapourCompressionMachineControlBus.TConInMea)
    annotation (Line(points={{11,0},{78,0},{78,-1.9},{102.1,-1.9}},
                                                              color={0,0,127}),
      Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(realPassThrough[2].u, sigBusGen.THeaPumOut) annotation (Line(points={
          {-12,0},{-100,0}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(realPassThrough[2].y, vapourCompressionMachineControlBus.TConOutMea)
    annotation (Line(points={{11,0},{78,0},{78,-1.9},{102.1,-1.9}},
                                                              color={0,0,127}),
      Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(realPassThrough[3].y, vapourCompressionMachineControlBus.nSet)
    annotation (Line(points={{11,0},{78,0},{78,-1.9},{102.1,-1.9}},
                                                              color={0,0,127}),
      Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(realPassThrough[3].u, sigBusGen.yHeaPumSet) annotation (Line(points={{
          -12,0},{-100,0}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(realPassThrough[4].u, sigBusGen.THeaPumEvaIn) annotation (Line(
        points={{-12,0},{-100,0}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(realPassThrough[4].y, vapourCompressionMachineControlBus.TEvaInMea)
    annotation (Line(points={{11,0},{78,0},{78,-1.9},{102.1,-1.9}},
                                                              color={0,0,127}),
      Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end HeatPumpBusPassThrough;
