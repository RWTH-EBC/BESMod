within BESMod.Systems.Hydraulical.Control.Components.BuildingSupplyTemperatureSetpoints;
model IdealHeatingCurveHOMtoROM "Ideal linear heating curve based on Room set points"
  extends BaseClasses.PartialSetpoint(useRoomSetT=true);

  Modelica.Blocks.Math.MinMax maxTZoneSet(nu=nRooms)
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));
  parameter Modelica.Units.SI.TemperatureDifference dTAddCon=0
    "Constant offset of ideal heating curve";
  parameter Modelica.Units.SI.Temperature THeaThr=293.15 "Heating threshold temeperature";

  replaceable function heaCur =
    BESMod.Systems.Hydraulical.Control.Components.BuildingSupplyTemperatureSetpoints.BaseClasses.Functions.ConstantGradientHeatCurve
    constrainedby
    BESMod.Systems.Hydraulical.Control.Components.BuildingSupplyTemperatureSetpoints.BaseClasses.Functions.PartialHeatingCurve
    "Linearization approach"
    annotation(choicesAllMatching=true);
equation
  if TOda < maxTZoneSet.yMax then
    TSet = heaCur(TOda, THeaThr, maxTZoneSet.yMax, TSup_nominal, TRet_nominal, TOda_nominal, nHeaTra) + dTAddCon;
  else
    // No heating required.
    TSet = maxTZoneSet.yMax + dTAddCon;
  end if;
  connect(TRoomSet, maxTZoneSet.u) annotation (Line(points={{-120,-40},{-66,-40},
          {-66,-70},{-60,-70}}, color={0,0,127}));
end IdealHeatingCurveHOMtoROM;
