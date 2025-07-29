within BESMod.Systems.Demand.Building.Components.TEASERBuildingSingleZone;
model ConvertRoomsInputsSimple
  extends PartialConvertRoomInputs;
  Modelica.Blocks.Math.Sum sum3[nZones](each nin=nRooms)
    annotation (Placement(transformation(extent={{-8,-90},{12,-70}})));
equation
  connect(solOrientationGain, solGain) annotation (Line(points={{-106,-40},{88,
          -40},{88,-47},{115,-47}},
                               color={0,0,127}));
  connect(intGains, sum3[1].u)
    annotation (Line(points={{-106,-80},{-10,-80}}, color={0,0,127}));
  connect(sum3[1].y, intGain[1]) annotation (Line(points={{13,-80},{63,-80},{63,
          -81},{113,-81}}, color={0,0,127}));
end ConvertRoomsInputsSimple;
