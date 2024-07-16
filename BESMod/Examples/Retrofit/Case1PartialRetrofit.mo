within BESMod.Examples.Retrofit;
model Case1PartialRetrofit
  extends PartialCase(
    NoRetrofitHydGen=true,
    NoRetrofitHydDis=false,
    NoRetrofitHydTra=false,
    building(redeclare
        BESMod.Systems.Demand.Building.RecordsCollection.ACoolHeadAndBEStPar.Retrofit1918_SingleDwelling
        oneZoneParam),
    systemParameters(
      QBui_flow_nominal={5267.49},
      TOda_nominal=263.15,
      THydSup_nominal={318.15},
      QBuiOld_flow_design={17442.7},
      THydSupOld_design={338.15}));
  extends Modelica.Icons.Example;

  annotation (experiment(
      StopTime=86400,
      Interval=600,
      __Dymola_Algorithm="Dassl"), Documentation(info="<html>
<p>
  This example demonstrates the usage of partial retrofit, 
  where <code>QOld_flow_design</code> and <code>Q_flow_nominal</code> differ. 
  The values used in the <code>systemParameters</code> records are extracted 
  from the other examples 
  <a href=\"BESMod.Examples.Retrofit.Case1TotalRetrofit\">BESMod.Examples.Retrofit.Case1TotalRetrofit</a> 
  and <a href=\"BESMod.Examples.Retrofit.Case1NoRetrofit\">BESMod.Examples.Retrofit.Case1NoRetrofit</a>. 
  Using TEASER and ebcpy, you can calculate these values in Python and 
  automate the setting if you do not have the old and new values at hand. 
  Alternativly, you can just simulate the other examples and extract the 
  values from the results.
</p>
</html>"));
end Case1PartialRetrofit;
