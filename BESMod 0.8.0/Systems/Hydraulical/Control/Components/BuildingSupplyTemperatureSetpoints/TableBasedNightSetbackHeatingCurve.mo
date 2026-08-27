within BESMod.Systems.Hydraulical.Control.Components.BuildingSupplyTemperatureSetpoints;
model TableBasedNightSetbackHeatingCurve
  "Heating curve with table based night setback and re-heating temperatures"
  extends BESMod.Systems.Hydraulical.Control.Components.BuildingSupplyTemperatureSetpoints.BaseClasses.PartialSetpoint;
  parameter Boolean withSetback=true;
  parameter Boolean useOffsetAllDayLong=false "=true to use the offset all day long, not only during pre-heating";
  parameter Modelica.Units.SI.TemperatureDifference dTAddCon=0
    "Constant offset of ideal heating curve";
  parameter Modelica.Units.SI.TemperatureDifference dTSetBack=0
    "Temperature difference of set-back";
  parameter Modelica.Units.SI.Time startTimeSetBack(displayUnit="h")=79200
                                                      "Start time of set back";
  parameter Real hoursRealSetBack(max=24, min=0)=8
                                             "Number of hours the set-back lasts, maximum 24";
  parameter Modelica.Units.SI.Temperature TOdaMin=253.15
    "Minimal outdoor air temperature below which no setback is performed";
  parameter Modelica.Units.SI.Temperature THeaThr=293.15 "Heating threshold temeperature";
  parameter Modelica.Units.SI.Time T=600 "Time Constant";
  parameter Modelica.Units.SI.Temperature TZone_nominal=293.15 "Nominal zone temperature";
  parameter Real table[:,2]=fill(0.0, 0, 2)
    "Table matrix (grid = first column; e.g., table=[0, 0; 1, 1; 2, 4])";
  replaceable function heaCur =
    BESMod.Systems.Hydraulical.Control.Components.BuildingSupplyTemperatureSetpoints.BaseClasses.Functions.ConstantGradientHeatCurve
    constrainedby BESMod.Systems.Hydraulical.Control.Components.BuildingSupplyTemperatureSetpoints.BaseClasses.Functions.PartialHeatingCurve
    "Linearization approach"
    annotation(choicesAllMatching=true);
  Modelica.Blocks.Math.MinMax maxTZoneSet(final nu=nZones)
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));

  Modelica.Blocks.Math.Add preHeat(each k1=-1/dTSetBack, each k2=1/dTSetBack)
    if withSetback and not useOffsetAllDayLong
    "Difference is one if in pre-heat mode"
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
  Modelica.Blocks.Tables.CombiTable1Ds preHeatOffset(
    tableOnFile=false,
    table=table,
    columns={2},
    extrapolation=Modelica.Blocks.Types.Extrapolation.HoldLastPoint)
    if withSetback
    "Lookup table for pre-heat offset, depending on the outdoor air temperature"
    annotation (Placement(transformation(extent={{-78,-10},{-58,10}})));
  Modelica.Blocks.Math.Product addPreHea if withSetback
                                         "Amount of pre-heat"
    annotation (Placement(transformation(extent={{0,20},{20,40}})));

  Modelica.Blocks.Continuous.FirstOrder dTOffsetDel(final k=1, T=T)
    if withSetback
    "Delayed offset to smooth transitions"
    annotation (Placement(transformation(extent={{30,20},{50,40}})));
  Modelica.Blocks.Sources.RealExpression reaExpTSet_internal(y(
      unit="K",
      displayUnit="K") = TSet_internal)
    "Room set temperature with set-back option" annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={30,-20})));
  Modelica.Blocks.Math.Add preHeat1
    "Difference is one if in pre-heat mode"
    annotation (Placement(transformation(extent={{68,-10},{88,10}})));
  Modelica.Blocks.Sources.Constant conNoOffSet(k=0, y(unit="K", displayUnit="K"))
    if not withSetback "No offset" annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={40,70})));
  BESMod.Systems.UserProfiles.BaseClasses.NightSetback nightSetback(
    dTSetBack=dTSetBack,
    startTimeSetBack=startTimeSetBack,
    timeSetBack=hoursRealSetBack*3600,
    TZone_nominal=TZone_nominal,
    useTOda=true,
    TOdaMin=TOdaMin) if withSetback and not useOffsetAllDayLong
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));

  Modelica.Blocks.Sources.Constant conAlwOffSet(final k=1)
    if useOffsetAllDayLong
                       "Constant one to always trigger offset"
                                   annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-30,30})));
protected
     Modelica.Units.SI.Temperature TSet_internal;
equation
  if TOda < maxTZoneSet.yMax then
    TSet_internal = heaCur(TOda, THeaThr, maxTZoneSet.yMax, TSup_nominal, TRet_nominal, TOda_nominal, nHeaTra) + dTAddCon;
  else
      // No heating required.
    TSet_internal = maxTZoneSet.yMax;
  end if;

  connect(maxTZoneSet.u, TZoneSet) annotation (Line(points={{-80,-70},{-96,-70},
          {-96,-80},{-120,-80}},
                            color={0,0,127}));
  connect(maxTZoneSet.yMax, preHeat.u2) annotation (Line(points={{-59,-64},{-50,
          -64},{-50,64},{-42,64}},            color={0,0,127}));
  connect(TOda, preHeatOffset.u) annotation (Line(points={{-120,0},{-80,0}},
                         color={0,0,127}));
  connect(addPreHea.u1, preHeat.y) annotation (Line(points={{-2,36},{-14,36},{
          -14,70},{-19,70}},
                         color={0,0,127}));
  connect(preHeatOffset.y[1], addPreHea.u2) annotation (Line(points={{-57,0},{
          -8,0},{-8,24},{-2,24}},color={0,0,127}));
  connect(addPreHea.y, dTOffsetDel.u)
    annotation (Line(points={{21,30},{28,30}}, color={0,0,127}));
  connect(dTOffsetDel.y, preHeat1.u1)
    annotation (Line(points={{51,30},{66,30},{66,6}}, color={0,0,127}));
  connect(preHeat1.u2, reaExpTSet_internal.y) annotation (Line(points={{66,-6},
          {46,-6},{46,-20},{41,-20}}, color={0,0,127}));
  connect(conNoOffSet.y, preHeat1.u1)
    annotation (Line(points={{51,70},{62,70},{62,30},{66,30},{66,6}},
                                                      color={0,0,127}));
  connect(preHeat1.y, TSet)
    annotation (Line(points={{89,0},{110,0}}, color={0,0,127}));
  connect(nightSetback.y, preHeat.u1) annotation (Line(points={{-59,80},{-52,80},
          {-52,76},{-42,76}}, color={0,0,127}));
  connect(nightSetback.TOda, TOda) annotation (Line(points={{-82,80},{-94,80},{
          -94,0},{-120,0}}, color={0,0,127}));
  connect(conAlwOffSet.y, addPreHea.u1) annotation (Line(points={{-19,30},{-12,
          30},{-12,36},{-2,36}}, color={0,0,127}));
end TableBasedNightSetbackHeatingCurve;
