within BESMod.Systems.Demand.Building.HeatDemand;
model CalcHeaDemHOM
  "Calculate the heat demand for a high order model from AixLib library"

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
    TN_heater=building.zoneParam[1].TNHeat,
    KR_heater=building.zoneParam[1].KRHeat,
    h_heater=building.zoneParam.hHeat*10,
    redeclare Examples.UseCaseHOM.HOMSystem systemParameters(TOda_nominal=259.75,
        THydSup_nominal={328.15}),
    redeclare AixLibHighOrder building(
      nZones=1,
      useConstNatVentRate=true,
      ventRate=fill(0.5, nZones),
      TSoil=281.65,
      Latitude=weaDat.lon,
      Longitude=weaDat.lon,
      DiffWeatherDataTime=weaDat.timZon,
      GroundReflection=0.2,
      redeclare AixLib.DataBase.Walls.Collections.OFD.EnEV2009Light wallTypes,
      redeclare model WindowModel =
          AixLib.ThermalZones.HighOrder.Components.WindowsDoors.WindowSimple,
      redeclare AixLib.DataBase.WindowsDoors.Simple.WindowSimple_EnEV2009
        Type_Win,
      redeclare model CorrSolarGainWin =
          AixLib.ThermalZones.HighOrder.Components.WindowsDoors.BaseClasses.CorrectionSolarGain.CorGSimple,
      use_sunblind=false,
      UValOutDoors=if TIR == 1 then 1.8 else 2.9,
      use_infiltEN12831=true,
      n50=if TIR == 1 or TIR == 2 then 3 else if TIR == 3 then 4 else 6));

  annotation (Documentation(info="<html>
<p>In order to use this model, choose a number of zones and pass a zoneParam from TEASER for every zone. Further specify the nominal heat outdoor air temperature in the system parameters or pass your custom systemParameters record.</p>
</html>"));
end CalcHeaDemHOM;
