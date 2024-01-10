within BESMod.Utilities.TimeConstantEstimation.BaseClasses;
model ProfilesWithStep "User profile with a step and no internal gains"
  extends Systems.UserProfiles.BaseClasses.PartialUserProfiles;
  parameter Modelica.Units.SI.TemperatureDifference dTStep "Temperature difference of step";
  parameter Modelica.Units.SI.Time startTime=0 "Start time of step";
  Modelica.Blocks.Sources.Step     conTSetZone[nZones](
    each height=dTStep,
    offset=TSetZone_nominal .- dTStep,
    y(each unit="K", each displayUnit="K"),
    each startTime=startTime) "Constant room set temperature"
                                    annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-10,-50})));

  Modelica.Blocks.Sources.Constant conIntGai[3](each final k=0)
    "Constant no internal gains" annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-10,-10})));
equation
  connect(conTSetZone.y, useProBus.TZoneSet) annotation (Line(points={{1,-50},{
          115,-50},{115,-1}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(conIntGai.y, useProBus.intGains) annotation (Line(points={{1,-10},{62,-10},
          {62,-1},{115,-1}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
end ProfilesWithStep;
