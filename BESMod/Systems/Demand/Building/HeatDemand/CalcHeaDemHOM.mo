within BESMod.Systems.Demand.Building.HeatDemand;
model CalcHeaDemHOM
  "Calculate the heat demand for a high order model from AixLib library"
  extends Modelica.Icons.Example;
  parameter Integer TIR=1 "Thermal Insulation Regulation" annotation (Dialog(
      group="Construction parameters",
      compact=true,
      descriptionLabel=true), choices(
      choice=1 "EnEV_2009",
      choice=2 "EnEV_2002",
      choice=3 "WSchV_1995",
      choice=4 "WSchV_1984",
      radioButtons=true));

  extends PartialCalcHeatingDemand(
    redeclare BESMod.Systems.UserProfiles.AixLibHighOrderProfiles heaDemSce(
        redeclare AixLib.DataBase.Profiles.Ventilation2perDayMean05perH venPro,
        redeclare AixLib.DataBase.Profiles.SetTemperaturesVentilation2perDay
        TSetProfile),
    TN_heater=1,
    KR_heater=10000,
    h_heater=fill(100000, building.nZones),
    redeclare Examples.UseCaseHOM.HOMSystem systemParameters(
      TOda_nominal=261.15,
      TSetZone_nominal(each displayUnit="K") = {293.15,293.15,288.15,293.15,
        293.15,293.15,293.15,288.15,297.15,293.15},
      THydSup_nominal=fill(273.15 + 55, building.nZones)),
    redeclare AixLibHighOrder building(
      useConstVentRate=true,
      ventRate={0.5,0.5,0,0.5,0.5,0.5,0.5,0,0.5,0.5},
      Latitude=Modelica.Units.Conversions.to_deg(weaDat.lat),
      Longitude=Modelica.Units.Conversions.to_deg(weaDat.lon),
      DiffWeatherDataTime=Modelica.Units.Conversions.to_hour(weaDat.timZon),
      GroundReflection=0.2,
      T0_air=293.15,
      TWalls_start=292.15,
      redeclare AixLib.DataBase.Walls.Collections.OFD.EnEV2009Heavy wallTypes,
      redeclare model WindowModel =
          AixLib.ThermalZones.HighOrder.Components.WindowsDoors.WindowSimple,
      redeclare AixLib.DataBase.WindowsDoors.Simple.WindowSimple_EnEV2009
        Type_Win,
      redeclare model CorrSolarGainWin =
          AixLib.ThermalZones.HighOrder.Components.WindowsDoors.BaseClasses.CorrectionSolarGain.CorGSimple,

      use_sunblind=false,
      UValOutDoors=if TIR == 1 then 1.8 else 2.9,
      use_infiltEN12831=true,
      n50=if TIR == 1 or TIR == 2 then 3 else if TIR == 3 then 4 else 6),
    heaterCooler(each Heater_on=true));

  annotation (Documentation(info="<html>
<p>In order to use this model, choose a number of zones and pass a zoneParam from TEASER for every zone. Further specify the nominal heat outdoor air temperature in the system parameters or pass your custom systemParameters record.</p>
</html>"), experiment(
      StopTime=25920000,
      Interval=3600,
      __Dymola_Algorithm="Dassl"));
end CalcHeaDemHOM;
