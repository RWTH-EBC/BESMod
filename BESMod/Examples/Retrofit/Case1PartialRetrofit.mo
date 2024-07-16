within BESMod.Examples.Retrofit;
model Case1PartialRetrofit
  extends PartialCase(
    NoRetrofitHydGen=true,
    NoRetrofitHydDis=false,
    NoRetrofitHydTra=false,
    building(redeclare
        BESMod.Examples.Retrofit.Buildings.Case_1_retrofit
        oneZoneParam),
    systemParameters(
      QBui_flow_nominal={5300},
      TOda_nominal=263.15,
      THydSup_nominal={318.15},
      QBuiOld_flow_design={15300},
      THydSupOld_design={338.15}));
  extends Modelica.Icons.Example;

  annotation (experiment(
      StopTime=86400,
      Interval=600,
      __Dymola_Algorithm="Dassl"));
end Case1PartialRetrofit;
