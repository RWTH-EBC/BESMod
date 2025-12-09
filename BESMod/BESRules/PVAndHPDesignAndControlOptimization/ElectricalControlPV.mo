within BESMod.BESRules.PVAndHPDesignAndControlOptimization;
model ElectricalControlPV "Electrical Control with PV surplus"
  extends BESMod.Systems.Electrical.Control.BaseClasses.PartialControl;
  Modelica.Blocks.Routing.RealPassThrough realPassThrough annotation (Placement(
        transformation(extent={{-10,-10},{10,10}}, rotation=90,
        origin={0,2})));
equation
  connect(realPassThrough.u, distributionControlBus.PEleGen) annotation (Line(
        points={{0,-10},{0,-32},{11,-32},{11,-99}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  connect(realPassThrough.y, systemControlBus.PEleGenGrid) annotation (Line(
        points={{7.21645e-16,13},{7.21645e-16,56.5},{0,56.5},{0,100}}, color={0,
          0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end ElectricalControlPV;
