within BESMod.Systems.Demand.Building.HeatDemand;
partial model PartialCalcHeatingDemand
  "Model to calculate the heating demand for a given building record"
  parameter Real h_heater[building.nZones] "Upper limit controller output of the heater";
  parameter Real KR_heater=1000 "Gain of the heating controller";
  parameter Modelica.Units.SI.Time TN_heater=1
    "Time constant of the heating controller";
  replaceable parameter BESMod.Systems.RecordsCollection.SystemParametersBaseDataDefinition
    systemParameters constrainedby
    BESMod.Systems.RecordsCollection.SystemParametersBaseDataDefinition
    "Parameters relevant for the whole energy system" annotation (
      choicesAllMatching=true, Placement(transformation(extent={{76,-96},{96,-76}})));
  replaceable Systems.UserProfiles.BaseClasses.PartialUserProfiles heaDemSce constrainedby
    UserProfiles.BaseClasses.PartialUserProfiles(final nZones=systemParameters.nZones,
      final TSetZone_nominal=systemParameters.TSetZone_nominal)
    "Heat demand scenario"
    annotation (choicesAllMatching=true, Placement(transformation(extent={{-98,2},{-62,38}})));
  replaceable BESMod.Systems.Demand.Building.BaseClasses.PartialDemand building
      constrainedby BESMod.Systems.Demand.Building.BaseClasses.PartialDemand(final TSetZone_nominal=systemParameters.TSetZone_nominal,
    final use_hydraulic=true,
    final use_ventilation=false,
    redeclare package MediumZone = IBPSA.Media.Air)
    annotation (choicesAllMatching=true, Placement(transformation(extent={{2,-16},
            {58,38}})));
  Modelica.Blocks.Interfaces.RealOutput QDemBuiSum_flow(final unit="W")
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={110,0}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={110,-80})));
  Modelica.Blocks.Sources.RealExpression reaExpQSum_flow(y=sum(heaterCooler.heatingPower))
    annotation (Placement(transformation(extent={{58,-42},{80,-20}})));
  Modelica.Blocks.Interfaces.RealOutput QBui_flow_nominal[building.nZones](
     each final unit="W") "Indoor air temperature" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={110,40}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={110,-80})));
  AixLib.Utilities.Sources.HeaterCooler.HeaterCoolerPI heaterCooler[
    building.nZones](
    h_heater=h_heater,
    each final l_heater=0,
    each final KR_heater=KR_heater,
    each final TN_heater=TN_heater,
    each final zoneParam=AixLib.DataBase.ThermalZones.ZoneRecordDummy(),
    each recOrSep=false,
    each Heater_on=true,
    each Cooler_on=false,
    each final staOrDyn=false)                                        "Heater Cooler with PI control"
    annotation (Placement(transformation(extent={{-80,-40},{-40,0}})));
  Modelica.Blocks.Sources.Constant const[building.nZones](final k=
        systemParameters.TSetZone_nominal)
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
  Modelica.Blocks.Sources.BooleanConstant
                                   booleanConstant
                                        [building.nZones](each final k=true)
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
  Modelica.Blocks.Sources.BooleanConstant
                                   booleanConstant1
                                        [building.nZones](each final k=false)
    annotation (Placement(transformation(extent={{-100,-60},{-80,-40}})));
  IBPSA.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    final filNam=systemParameters.filNamWea,
    TDryBulSou=IBPSA.BoundaryConditions.Types.DataSource.Parameter,
    TDryBul=systemParameters.TOda_nominal,
    TDewPoiSou=IBPSA.BoundaryConditions.Types.DataSource.Parameter,
    TDewPoi=systemParameters.TOda_nominal,
    TBlaSkySou=IBPSA.BoundaryConditions.Types.DataSource.Parameter,
    TBlaSky=systemParameters.TOda_nominal,
    relHumSou=IBPSA.BoundaryConditions.Types.DataSource.Parameter,
    relHum=0,
    winSpeSou=IBPSA.BoundaryConditions.Types.DataSource.Parameter,
    winSpe=0,
    HInfHorSou=IBPSA.BoundaryConditions.Types.DataSource.Parameter,
    HInfHor=0,
    HSou=IBPSA.BoundaryConditions.Types.RadiationDataSource.Input_HGloHor_HDifHor)
    "Weather data reader"
    annotation (Placement(transformation(extent={{-60,60},{-20,100}})));
  Modelica.Blocks.Sources.Constant consNultIrr(each final k=0) "No irradiation"
    annotation (Placement(transformation(extent={{-100,58},{-78,80}})));

equation

  connect(QDemBuiSum_flow, reaExpQSum_flow.y) annotation (Line(points={{110,0},{
          86,0},{86,-31},{81.1,-31}}, color={0,0,127}));
  connect(building.heatPortCon, heaterCooler.heatCoolRoom) annotation (Line(
        points={{2,27.2},{2,26},{-8,26},{-8,-28},{-42,-28}},              color=
         {191,0,0}));
  connect(const.y, heaterCooler.setPointHeat) annotation (Line(points={{-59,-70},
          {-55.6,-70},{-55.6,-34.4}},  color={0,0,127}));
  connect(heaterCooler.heatingPower, QBui_flow_nominal) annotation (Line(points={{-40,-12},
          {-26,-12},{-26,-48},{84,-48},{84,40},{110,40}},
                                                 color={0,0,127}));
  connect(heaterCooler.heaterActive, booleanConstant.y) annotation (Line(points={{-46.4,
          -34.4},{-46,-34.4},{-46,-90},{-79,-90}},
                                                 color={255,0,255}));
  connect(booleanConstant1.y, heaterCooler.coolerActive) annotation (Line(
        points={{-79,-50},{-79,-44},{-74,-44},{-74,-34.4}},         color={255,0,
          255}));
  connect(weaDat.weaBus, building.weaBus) annotation (Line(
      points={{-20,80},{14,80},{14,38},{13.76,38},{13.76,38.54}},
      color={255,204,51},
      thickness=0.5));
  connect(consNultIrr.y, weaDat.HDifHor_in) annotation (Line(points={{-76.9,69},
          {-76.9,68},{-68,68},{-68,61},{-62,61}}, color={0,0,127}));
  connect(consNultIrr.y, weaDat.HGloHor_in) annotation (Line(points={{-76.9,69},
          {-76.9,68},{-68,68},{-68,48},{-62,48},{-62,54}}, color={0,0,127}));
  connect(weaDat.HDifHor_in, weaDat.HGloHor_in)
    annotation (Line(points={{-62,61},{-62,54}}, color={0,0,127}));
  connect(heaDemSce.useProBus, building.useProBus) annotation (Line(
      points={{-62.75,19.85},{-36,19.85},{-36,50},{45.4,50},{45.4,38}},
      color={255,204,51},
      thickness=0.5));
  connect(weaDat.weaBus, heaDemSce.weaBus) annotation (Line(
      points={{-20,80},{-18,80},{-18,78},{-16,78},{-16,2.45},{-80,2.45}},
      color={255,204,51},
      thickness=0.5));
  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false), graphics={Text(
          extent={{18,126},{204,32}},
          lineColor={28,108,200},
          textString="Right click -> Parameters -> 
Select your system parameters -> 
Simulate and extract QDemand and 
array based demand for your systemParameters")}),      experiment(StopTime=172800, Interval=3600),
    Documentation(info="<html>
<p>The heat demand is one of the most important paramters to quantify in order to correctly size the components in a BES. Hence, we add this partial heat demand calculator to enable a heat demand calculation according to EN 12831 for all possible Building-Subsystems.</p>
<h4>Note:</h4>
<ol>
<li>Depending on your subsystem, you have to ensure a nominal air exchange rate of 0.5 1/h is met. </li>
<li>You have to specify the maximal heat load to give the ideal heater (a PI Control) an upper limit. If your demand is equal to the upper limit, be sure to check if the required room temperature is supplied.</li>
<li>Choose some systemParameters. Most importantly, set your nominal outdoor air temperature TOda_nominal</li>
</ol>
</html>"));
end PartialCalcHeatingDemand;
