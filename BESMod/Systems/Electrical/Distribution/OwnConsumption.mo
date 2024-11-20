within BESMod.Systems.Electrical.Distribution;
model OwnConsumption
  "Direct grid connection, own consumption"
  extends
    BESMod.Systems.Electrical.Distribution.BaseClasses.PartialDistribution(
      nSubSys=6);

  BESMod.Utilities.Electrical.MultiSumElec multiSumElec(nPorts=nSubSys)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={50,76})));
  BESMod.Utilities.Electrical.ElecConToReal elecConToRealSpl annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={50,52})));
  BESMod.Utilities.Electrical.RealToElecCon realToElecConJoi
   annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={70,-72})));
  Modelica.Blocks.Math.Add add(k2=-1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={50,22})));
  Modelica.Blocks.Nonlinear.Limiter limiter(uMax=Modelica.Constants.inf, uMin=0)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={78,-2})));
  Modelica.Blocks.Math.Add add1(k2=-1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={50,-40})));
equation
  connect(internalElectricalPin, multiSumElec.internalElectricalPinIn)
    annotation (Line(
      points={{50,100},{50,89.9},{50.2,89.9},{50.2,85.8}},
      color={0,0,0},
      thickness=1));
  connect(add.y, limiter.u) annotation (Line(points={{50,11},{50,10},{78,10}},
                  color={0,0,127}));
  connect(limiter.y, add1.u1) annotation (Line(points={{78,-13},{78,-28},{56,-28}},
                          color={0,0,127}));
  connect(add.y, add1.u2) annotation (Line(points={{50,11},{50,-28},{44,-28}},
                    color={0,0,127}));
  connect(elecConToRealSpl.PElecLoa, add.u1)
    annotation (Line(points={{54,40},{54,34},{56,34}}, color={0,0,127}));
  connect(elecConToRealSpl.PElecGen, add.u2)
    annotation (Line(points={{46,40},{46,34},{44,34}}, color={0,0,127}));
  connect(multiSumElec.internalElectricalPinOut, elecConToRealSpl.internalElectricalPin)
    annotation (Line(
      points={{50,66},{50,63.9},{50.2,63.9},{50.2,61.8}},
      color={0,0,0},
      thickness=1));
  connect(limiter.y, realToElecConJoi.PEleLoa) annotation (Line(points={{78,-13},
          {78,-54},{74,-54},{74,-60}}, color={0,0,127}));
  connect(add1.y, realToElecConJoi.PEleGen) annotation (Line(points={{50,-51},{50,
          -54},{52,-54},{52,-60},{66,-60}}, color={0,0,127}));
  connect(realToElecConJoi.internalElectricalPin, externalElectricalPin)
    annotation (Line(
      points={{70.2,-82.2},{70.2,-98},{50,-98}},
      color={0,0,0},
      thickness=1));
  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)), Documentation(info="<html>
<p>Electric distribution system model for direct grid 
connection with own consumption. 
</p>
<p>
The model calculates the energy balance between generation and load. 
Generated electricity can be consumed directly (own consumption) and 
excess generation is fed into the grid. 
If generation is insufficient, additional electricity is drawn 
from the grid.</p>
</html>"));
end OwnConsumption;
