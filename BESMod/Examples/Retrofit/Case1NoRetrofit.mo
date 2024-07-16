within BESMod.Examples.Retrofit;
model Case1NoRetrofit
  extends PartialCase(building(redeclare
        BESMod.Examples.Retrofit.Buildings.Case_1_standard
        oneZoneParam), systemParameters(
      QBui_flow_nominal={15300},
      TOda_nominal=263.15,
      THydSup_nominal={338.15}));
  extends Modelica.Icons.Example;

  annotation (experiment(
      StopTime=86400,
      Interval=600,
      __Dymola_Algorithm="Dassl"));
end Case1NoRetrofit;
