within BESMod.Systems.Demand.Building.HeatDemand;
partial model PartialCalcHeatingDemand
  "Model to calculate the heating demand for a given building record"
  extends Modelica.Icons.Example;
  parameter Real h_heater[building.nZones] "Upper limit controller output of the heater";
  parameter Real KR_heater=1000 "Gain of the heating controller";
  parameter Modelica.Units.SI.Time TN_heater=1
    "Time constant of the heating controller";
  replaceable parameter BESMod.Systems.RecordsCollection.SystemParametersBaseDataDefinition
    systemParameters constrainedby
    BESMod.Systems.RecordsCollection.SystemParametersBaseDataDefinition
    "Parameters relevant for the whole energy system" annotation (
      choicesAllMatching=true, Placement(transformation(extent={{76,-96},{96,-76}})));
  Systems.UserProfiles.NoUser heatDemandScenario(final systemParameters=
        systemParameters,                        final T_const=systemParameters.TOda_nominal)
    annotation (Placement(transformation(extent={{-100,18},{-50,80}})));
  replaceable BESMod.Systems.Demand.Building.BaseClasses.PartialDemand building
      constrainedby
    BESMod.Systems.Demand.Building.BaseClasses.PartialDemand(                final TSetZone_nominal=systemParameters.TSetZone_nominal,
    final use_hydraulic=true,
    final use_ventilation=false,
    redeclare package MediumZone = IBPSA.Media.Air)
    annotation (choicesAllMatching=true, Placement(transformation(extent={{24,-34},{72,24}})));
  Modelica.Blocks.Interfaces.RealOutput QDemBuiSum_flow(final unit="W")
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={110,0}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={110,-80})));
  Modelica.Blocks.Sources.RealExpression
                                   realExpression(y=sum(heaterCooler.heatingPower))
    annotation (Placement(transformation(extent={{10,52},{32,74}})));
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
    annotation (Placement(transformation(extent={{-38,0},{-4,38}})));
  Modelica.Blocks.Sources.Constant const[building.nZones](final k=
        systemParameters.TSetZone_nominal)
    annotation (Placement(transformation(extent={{-74,-28},{-52,-6}})));
  Modelica.Blocks.Sources.BooleanConstant
                                   booleanConstant
                                        [building.nZones](each final k=true)
    annotation (Placement(transformation(extent={{-112,-46},{-90,-24}})));
  Modelica.Blocks.Sources.BooleanConstant
                                   booleanConstant1
                                        [building.nZones](each final k=false)
    annotation (Placement(transformation(extent={{-112,-12},{-90,10}})));
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
    HInfHorSou=IBPSA.BoundaryConditions.Types.DataSource.Parameter,
    HInfHor=0,
    HSou=IBPSA.BoundaryConditions.Types.RadiationDataSource.Input_HGloHor_HDifHor)
    "Weather data reader"
    annotation (Placement(transformation(extent={{-100,86},{-42,152}})));
  Modelica.Blocks.Sources.Constant constIrr(each final k=0)
    annotation (Placement(transformation(extent={{-162,66},{-140,88}})));

  Interfaces.UseProBus                               useProBus annotation (
      Placement(transformation(extent={{16,72},{68,108}}),  iconTransformation(
          extent={{80,-34},{150,32}})));
equation

  connect(QDemBuiSum_flow, realExpression.y) annotation (Line(points={{110,0},
          {80,0},{80,63},{33.1,63}}, color={0,0,127}));
  connect(building.heatPortCon, heaterCooler.heatCoolRoom) annotation (Line(
        points={{24,12.4},{16,12.4},{16,12},{6,12},{6,11.4},{-5.7,11.4}}, color=
         {191,0,0}));
  connect(const.y, heaterCooler.setPointHeat) annotation (Line(points={{-50.9,
          -17},{-17.26,-17},{-17.26,5.32}},
                                       color={0,0,127}));
  connect(heaterCooler.heatingPower, QBui_flow_nominal) annotation (Line(points=
         {{-4,26.6},{14,26.6},{14,40},{110,40}}, color={0,0,127}));
  connect(heaterCooler.heaterActive, booleanConstant.y) annotation (Line(points={{-9.44,
          5.32},{-9.44,-35},{-88.9,-35}},        color={255,0,255}));
  connect(booleanConstant1.y, heaterCooler.coolerActive) annotation (Line(
        points={{-88.9,-1},{-59.45,-1},{-59.45,5.32},{-32.9,5.32}}, color={255,0,
          255}));
  connect(weaDat.weaBus, building.weaBus) annotation (Line(
      points={{-42,119},{-8,119},{-8,50},{34.08,50},{34.08,24.58}},
      color={255,204,51},
      thickness=0.5));
  connect(constIrr.y, weaDat.HDifHor_in) annotation (Line(points={{-138.9,77},{
          -122.45,77},{-122.45,87.65},{-102.9,87.65}}, color={0,0,127}));
  connect(constIrr.y, weaDat.HGloHor_in) annotation (Line(points={{-138.9,77},{
          -122.45,77},{-122.45,76.1},{-102.9,76.1}}, color={0,0,127}));
  connect(heatDemandScenario.useProBus, useProBus) annotation (Line(
      points={{-51.0417,48.7417},{42,48.7417},{42,90}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(useProBus, building.useProBus) annotation (Line(
      points={{42,90},{40,90},{40,24},{61.2,24}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false), graphics={Text(
          extent={{-130,-24},{56,-118}},
          lineColor={28,108,200},
          textString="Right click -> Parameters -> 
Select your system parameters -> 
Simulate and extract QDemand and 
array based demand for your systemParameters")}),      experiment(StopTime=31536000, Interval=3600),
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
