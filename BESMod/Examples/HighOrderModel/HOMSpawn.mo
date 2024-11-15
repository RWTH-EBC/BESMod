within BESMod.Examples.HighOrderModel;
model HOMSpawn
  extends BESMod.Examples.HighOrderModel.BaseClasses.PartialBES_HOM(
    redeclare Systems.Demand.Building.SpawnHighOrder         building(
      useConstVentRate=false, wea_name=systemParameters.filNamWea),
      systemParameters(
      QBui_flow_nominal={832.063,514.782,366.72,721.233,688.894,864.215,580.23,
          233.253,765.68,700.719},
      TOda_nominal=261.15,
      filNamWea=Modelica.Utilities.Files.loadResource(
          "modelica://BESMod/Resources/Spawn/Potsdam_TRY2015_normal.mos")));

  extends Modelica.Icons.Example;
  annotation (experiment(
      StopTime=172800,
      Interval=600,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
   __Dymola_Commands(file="modelica://BESMod/Resources/Scripts/Dymola/Examples/HighOrderModel/BES_HOM_Spawn.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>This is the Example model with the Spawn model corresponding to the High Order Model (HOM) contained in the AixLib library.</p>
<p>Further information and possible solutions for error messages can be found in the SpawnHighOrder model documentation.</p>
</html>"));
end HOMSpawn;
