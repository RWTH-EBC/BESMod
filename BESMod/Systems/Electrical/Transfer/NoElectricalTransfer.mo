within BESMod.Systems.Electrical.Transfer;
model NoElectricalTransfer "No transfer system"
  extends
    BESMod.Systems.Electrical.Transfer.BaseClasses.PartialTransfer;
  Modelica.Blocks.Sources.RealExpression NoLoad
    annotation (Placement(transformation(extent={{4,6},{24,26}})));
  Utilities.Electrical.RealToElecCon realToElecCon annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={46,40})));
equation
  connect(heatPortRad, heatPortCon) annotation (Line(points={{100,-38},{100,1},
          {100,1},{100,38}}, color={191,0,0}));
  connect(NoLoad.y, realToElecCon.PElec)
    annotation (Line(points={{25,16},{46,16},{46,29.4}}, color={0,0,127}));
  connect(realToElecCon.internalElectricalPin, internalElectricalPin)
    annotation (Line(
      points={{45.8,50.2},{45.8,72.1},{48,72.1},{48,100}},
      color={0,0,0},
      thickness=1));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end NoElectricalTransfer;
