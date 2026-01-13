within BESMod.Examples.BAUSimStudy;
model Case1Standard
  extends PartialCase(building(redeclare
        BESMod.Systems.Demand.Building.RecordsCollection.ACoolHeadAndBEStPar.NoRetrofit1918_SingleDwelling
        oneZoneParam),
  systemParameters(TOda_nominal=263.15, THydSup_nominal={328.15}));
  extends Modelica.Icons.Example;

  annotation (experiment(
      StopTime=31536000,
      Interval=599.999616,
      Tolerance=1e-06,
      __Dymola_Algorithm="Dassl"),
   __Dymola_Commands(file="modelica://BESMod/Resources/Scripts/Dymola/Examples/BAUSimStudy/Case1Standard.mos"
        "Simulate and plot"));
end Case1Standard;
