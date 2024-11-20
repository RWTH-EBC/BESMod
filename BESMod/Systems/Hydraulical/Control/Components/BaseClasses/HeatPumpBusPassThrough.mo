within BESMod.Systems.Hydraulical.Control.Components.BaseClasses;
model HeatPumpBusPassThrough
  Interfaces.GenerationControlBus sigBusGen
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  AixLib.Fluid.HeatPumps.ModularReversible.BaseClasses.RefrigerantMachineControlBus
    vapComBus
    annotation (Placement(transformation(extent={{-120,-20},{-80,20}})));
  Modelica.Blocks.Routing.RealPassThrough realPassThrough[3]
    annotation (Placement(transformation(extent={{-10,0},{10,20}})));
  Modelica.Blocks.Routing.BooleanPassThrough booleanPassThrough
    annotation (Placement(transformation(extent={{-10,-40},{10,-20}})));
equation
  connect(booleanPassThrough.y, sigBusGen.heaPumIsOn) annotation (Line(points={{11,-30},
          {100,-30},{100,0}},                   color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(booleanPassThrough.u, vapComBus.onOffMea)
    annotation (Line(points={{-12,-30},{-84,-30},{-84,0},{-100,0}},
        color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(realPassThrough[1].y, sigBusGen.THeaPumIn) annotation (Line(points={{11,10},
          {56,10},{56,0},{100,0}},
                           color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(realPassThrough[1].u, vapComBus.TConInMea)
    annotation (Line(points={{-12,10},{-56,10},{-56,0},{-100,0}},
                                                              color={0,0,127}),
      Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(realPassThrough[2].y, sigBusGen.THeaPumOut) annotation (Line(points={{11,10},
          {56,10},{56,0},{100,0}},
                            color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(realPassThrough[2].u, vapComBus.TConOutMea)
    annotation (Line(points={{-12,10},{-56,10},{-56,0},{-100,0}},
                                                              color={0,0,127}),
      Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(realPassThrough[3].y, sigBusGen.THeaPumEvaIn) annotation (Line(points={{11,10},
          {56,10},{56,0},{100,0}},
                            color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(realPassThrough[3].u, vapComBus.TEvaInMea)
    annotation (Line(points={{-12,10},{-56,10},{-56,0},{-100,0}},
                                                              color={0,0,127}),
      Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                                        Text(
        extent={{-150,138},{150,98}},
        textString="%name",
        textColor={0,0,255}),   Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid)}),                        Diagram(
        coordinateSystem(preserveAspectRatio=false)), Documentation(info="<html>
<p>
Model to connect the generation bus interface to the refrigerant machine bus. 
It transfers all data between 
<a href=\"modelica://BESMod.Systems.Hydraulical.Control.Components.BaseClasses.Interfaces.GenerationControlBus\">BESMod.Systems.Hydraulical.Control.Components.BaseClasses.Interfaces.GenerationControlBus</a> and 
<a href=\"modelica://AixLib.Fluid.HeatPumps.ModularReversible.BaseClasses.RefrigerantMachineControlBus\">AixLib.Fluid.HeatPumps.ModularReversible.BaseClasses.RefrigerantMachineControlBus</a>.
</p>
<p>
The model passes through the following signals:
<ul>
  <li>Heat pump on/off status</li>
  <li>Condenser inlet temperature</li>
  <li>Condenser outlet temperature</li> 
  <li>Evaporator inlet temperature</li>
</ul>
</p>
</html>"));
end HeatPumpBusPassThrough;
