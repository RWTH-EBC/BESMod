within BESMod.Examples.BAUSimStudy;
model Case1Standard
  extends PartialCase(building(redeclare Buildings.Case_1_standard oneZoneParam(
          heaLoadFacGrd=0, heaLoadFacOut=0)),
  systemParameters(QBui_flow_nominal={16308.1}, TOda_nominal=263.15, THydSup_nominal={328.15}));
  extends Modelica.Icons.Example;

  annotation (experiment(
      StopTime=86400,
      Interval=600,
      __Dymola_Algorithm="Dassl"),
   __Dymola_Commands(file="modelica://BESMod/Resources/Scripts/Dymola/Examples/BAUSimStudy/Case1Standard.mos"
        "Simulate and plot"));
end Case1Standard;
