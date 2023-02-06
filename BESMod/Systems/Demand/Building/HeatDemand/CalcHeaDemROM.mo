within BESMod.Systems.Demand.Building.HeatDemand;
model CalcHeaDemROM
  "Calculate the heat demand for a given reduced order model from TEASER"
  extends PartialCalcHeatingDemand(
    redeclare BESMod.Systems.UserProfiles.TEASERProfiles heaDemSce(final gain={
          0,0,0}),
    TN_heater=building.zoneParam[1].TNHeat,
    KR_heater=building.zoneParam[1].KRHeat,
    h_heater=building.zoneParam.hHeat*10,
    redeclare BESMod.Examples.BAUSimStudy.BESParameters
      systemParameters(TOda_nominal=259.15, THydSup_nominal={328.15}),
    redeclare BESMod.Systems.Demand.Building.TEASERThermalZone
      building(
      nZones=1,
      redeclare BESMod.Examples.BAUSimStudy.Buildings.Case_1_retrofit
        oneZoneParam,
      final ventRate=0.5 .- building.zoneParam.baseACH,
      energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
      TOda_nominal=systemParameters.TOda_nominal));
  extends Modelica.Icons.Example;

  Modelica.Blocks.Interfaces.RealOutput QBuiFroRec_flow_nominal[building.nZones](
     each final unit="W") "Indoor air temperature" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={110,-60}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={110,-80})));

  Modelica.Blocks.Sources.RealExpression reaExpQFroRec_flow[building.nZones](y=
        building.QRec_flow_nominal)
    annotation (Placement(transformation(extent={{58,-70},{80,-48}})));
equation
  connect(QBuiFroRec_flow_nominal, reaExpQFroRec_flow.y) annotation (Line(
        points={{110,-60},{108,-60},{108,-59},{81.1,-59}},     color={0,0,127}));
    annotation (Placement(transformation(extent={{48,-72},{70,-50}})),
              Documentation(info="<html>
<p>In order to use this model, choose a number of zones and pass a zoneParam from TEASER for every zone. Further specify the nominal heat outdoor air temperature in the system parameters or pass your custom systemParameters record.</p>
</html>"));
end CalcHeaDemROM;
