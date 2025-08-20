within BESMod.Systems.Hydraulical.Control.Components.BuildingSupplyTemperatureSetpoints;
model IdealHeatingCurveHOMtoROM "Ideal linear heating curve based on Room set points"
  extends BaseClasses.PartialSetpoint;

  parameter Boolean useRoomSetT=false;
  parameter Integer nRooms=nZones "Number of Room set points";

  Modelica.Blocks.Interfaces.RealInput TRoomSet[nRooms](each final unit="K",
      each final displayUnit="degC") "Room set temperatures"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));

  Modelica.Blocks.Math.MinMax maxTRoomSet(nu=nRooms)
    annotation (Placement(transformation(extent={{-66,-50},{-46,-30}})));
  parameter Modelica.Units.SI.TemperatureDifference dTAddCon=0
    "Constant offset of ideal heating curve";
  parameter Modelica.Units.SI.Temperature THeaThr=293.15 "Heating threshold temeperature";

  replaceable function heaCur =
    BESMod.Systems.Hydraulical.Control.Components.BuildingSupplyTemperatureSetpoints.BaseClasses.Functions.ConstantGradientHeatCurve
    constrainedby
    BESMod.Systems.Hydraulical.Control.Components.BuildingSupplyTemperatureSetpoints.BaseClasses.Functions.PartialHeatingCurve
    "Linearization approach"
    annotation(choicesAllMatching=true);
  Modelica.Blocks.Math.MinMax maxTZoneSet(nu=nZones)
    annotation (Placement(transformation(extent={{-64,-88},{-44,-68}})));
  Modelica.Blocks.Sources.RealExpression TSetMax(y=if useRoomSetT then
        maxTRoomSet.yMax else maxTZoneSet.yMax)
    annotation (Placement(transformation(extent={{16,-60},{36,-40}})));
equation
  if TOda <maxTRoomSet.yMax then
    TSet = heaCur(TOda, THeaThr, TSetMax.y, TSup_nominal, TRet_nominal, TOda_nominal, nHeaTra) + dTAddCon;
  else
    // No heating required.
    TSet =maxTRoomSet.yMax  + dTAddCon;
  end if;
  connect(TRoomSet, maxTRoomSet.u)
    annotation (Line(points={{-120,-40},{-66,-40}}, color={0,0,127}));
  connect(TZoneSet, maxTZoneSet.u) annotation (Line(points={{-120,-80},{-118,-80},
          {-118,-78},{-64,-78}}, color={0,0,127}));
end IdealHeatingCurveHOMtoROM;
