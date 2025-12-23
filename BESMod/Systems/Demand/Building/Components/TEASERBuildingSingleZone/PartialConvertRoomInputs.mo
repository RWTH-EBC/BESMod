within BESMod.Systems.Demand.Building.Components.TEASERBuildingSingleZone;
partial model PartialConvertRoomInputs
  "Reduce and delays the the solar and internal gians to the usable amount for heating"
  parameter Integer nOrientations = 1;
  parameter Integer nRooms = 1;
  parameter Integer nZones = 1;
  parameter Real FacATransparentPerRoom[nOrientations, nRooms] = fill({1}, nOrientations);
  parameter Real roomVolumes[nRooms] = fill(0, nRooms);
  parameter Real zoneVolume[nZones] = {sum(roomVolumes)};

  Modelica.Blocks.Interfaces.RealInput TDryBul
    annotation (Placement(transformation(extent={{-126,60},{-86,100}})));
  Modelica.Blocks.Interfaces.RealInput TRoomSet[nRooms]
    annotation (Placement(transformation(extent={{-126,20},{-86,60}})));
  Modelica.Blocks.Interfaces.RealInput solOrientationGain[nOrientations]
    annotation (Placement(transformation(extent={{-126,-60},{-86,-20}})));
  Modelica.Blocks.Interfaces.RealOutput solGain[nOrientations] annotation (
      Placement(transformation(extent={{96,-66},{134,-28}}),iconTransformation(
          extent={{96,-66},{134,-28}})));

  Modelica.Blocks.Interfaces.RealInput intGains[nRooms]
    annotation (Placement(transformation(extent={{-126,-100},{-86,-60}})));
  Modelica.Blocks.Interfaces.RealOutput intGain[nZones] annotation (Placement(
        transformation(extent={{94,-100},{132,-62}}), iconTransformation(extent=
           {{96,-20},{134,18}})));
  Modelica.Blocks.Interfaces.RealInput natVent[nRooms]
    annotation (Placement(transformation(extent={{-126,-20},{-86,20}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialConvertRoomInputs;
