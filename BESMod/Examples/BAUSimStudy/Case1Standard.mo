within BESMod.Examples.BAUSimStudy;
model Case1Standard
  extends PartialCase(building(redeclare Buildings.Case_1_standard oneZoneParam),
  systemParameters(QBui_flow_nominal={16308.1}, TOda_nominal=263.15, THydSup_nominal={328.15}));
  annotation (experiment(
      StopTime=86400,
      Interval=600,
      __Dymola_Algorithm="Dassl"));
end Case1Standard;
