within BESMod.Examples.Retrofit;
model Case1NoRetrofit "Example with no retrofit at all"
  extends PartialCase(building(redeclare
        BESMod.Systems.Demand.Building.RecordsCollection.ACoolHeadAndBEStPar.NoRetrofit1918_SingleDwelling
        oneZoneParam), systemParameters(TOda_nominal=263.15, THydSup_nominal={338.15}));
  extends Modelica.Icons.Example;

  annotation (experiment(
      StopTime=86400,
      Interval=600,
      Tolerance=1e-06),
       __Dymola_Commands(file="modelica://BESMod/Resources/Scripts/Dymola/Examples/Retrofit/Case1NoRetrofit.mos"
        "Simulate and plot"), Documentation(info="<html>
<p>
  This example demonstrates the usage of no retrofit, 
  where <code>QOld_flow_design</code> equals <code>Q_flow_nominal</code>. 
</p>
</html>"));
end Case1NoRetrofit;
