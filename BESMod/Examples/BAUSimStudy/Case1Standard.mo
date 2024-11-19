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
  annotation (Documentation(info="<html>
<h4>Information</h4>
<p>
This model represents the standard case (Case 1) of a building energy simulation study. It extends from 
<a href=\"modelica://BESMod.Examples.BAUSimStudy.PartialCase\">BESMod.Examples.BAUSimStudy.PartialCase</a> 
and uses parameters for a non-retrofitted single dwelling house from 1918.
</p>
</html>"));
end Case1Standard;
