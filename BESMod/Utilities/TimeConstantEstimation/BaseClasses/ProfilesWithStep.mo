within BESMod.Utilities.TimeConstantEstimation.BaseClasses;
model ProfilesWithStep "User profile with a step and no internal gains"
  extends Systems.UserProfiles.BaseClasses.PartialUserProfiles;
  parameter Modelica.Units.SI.TemperatureDifference dTStep "Temperature difference of step";
  parameter Modelica.Units.SI.Time startTime=0 "Start time of step";
  parameter Real hoursStep "Number of hours the step lasts, maximum 24";

  Modelica.Blocks.Sources.Constant conIntGai[3](each final k=0)
    "Constant no internal gains" annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-10,-10})));
  Modelica.Blocks.Sources.Pulse nigSetBakTSetZone[nZones](
    each amplitude=-dTStep,
    each width=100*hoursStep /24,
    each period=86400,
    offset=TSetZone_nominal,
    each startTime=startTime)                  "Constant room set temperature"
    annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-10,-50})));
equation
  connect(conIntGai.y, useProBus.intGains) annotation (Line(points={{1,-10},{62,-10},
          {62,-1},{115,-1}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(nigSetBakTSetZone.y, useProBus.TZoneSet) annotation (Line(points={{1,
          -50},{116,-50},{116,-54},{115,-54},{115,-1}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
end ProfilesWithStep;
