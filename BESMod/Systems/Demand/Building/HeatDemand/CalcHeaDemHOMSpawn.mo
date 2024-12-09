within BESMod.Systems.Demand.Building.HeatDemand;
model CalcHeaDemHOMSpawn
  "Calculate the heat demand for a Spawn model of the high order model from AixLib library"
  extends Modelica.Icons.Example;
  extends PartialCalcHeatingDemand(
    redeclare BESMod.Systems.UserProfiles.AixLibHighOrderProfiles heaDemSce(
      redeclare AixLib.DataBase.Profiles.Ventilation2perDayMean05perH venPro,
      redeclare AixLib.DataBase.Profiles.SetTemperaturesVentilation2perDay
        TSetProfile,
      gain=0),
    TN_heater=1,
    KR_heater=10000,
    h_heater=fill(100000, building.nZones),
    redeclare BESMod.Examples.HighOrderModel.HOMSystem systemParameters(
      QBui_flow_nominal={832.063,514.782,366.72,721.233,688.894,864.215,580.23,
          233.253,765.68,700.719},
      TOda_nominal=261.15,
      TSetZone_nominal(each displayUnit="K") = {293.15,293.15,288.15,293.15,
        293.15,293.15,293.15,288.15,297.15,293.15},
      THydSup_nominal=fill(273.15 + 55, building.nZones),
      filNamWea=Modelica.Utilities.Files.loadResource(
          "modelica://BESMod/Resources/Spawn/Potsdam_HeatLoad.mos")),
    redeclare BESMod.Systems.Demand.Building.SpawnHighOrder  building(
      nZones=systemParameters.nZones,
      TOda_nominal=systemParameters.TOda_nominal,
      useConstVentRate=true,
      ventRate=fill(0.5, systemParameters.nZones),
      epw_name=Modelica.Utilities.Files.loadResource(
          "modelica://BESMod/Resources/Spawn/Potsdam_HeatLoad.epw"),
      wea_name=systemParameters.filNamWea),
    heaterCooler(each Heater_on=true));

  annotation (Documentation(info="<html>
<p>This model calculates the heat demand for the Spawn model of the AixLib High Order model according to EN 12831.</p>
<p>If you want to change the nominal outdoor air temperature, you have to adjust the outdoor air temperature in the epw file as well (see documentation of BESMod.Systems.Demand.Building.SpawnHighOrder). You can do this easily by using the search and replace function in Notepad.</p>
<p>Further information and possible solutions for error messages can be found in the SpawnHighOrder model documentation
(<a href=\"modelica://BESMod.Systems.Demand.Building.SpawnHighOrder\">BESMod.Systems.Demand.Building.SpawnHighOrder</a>).
</p>
</html>"), experiment(
      StopTime=25920000,
      Interval=600,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"));
end CalcHeaDemHOMSpawn;
