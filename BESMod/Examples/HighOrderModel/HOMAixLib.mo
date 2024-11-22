within BESMod.Examples.HighOrderModel;
model HOMAixLib
  extends BESMod.Examples.HighOrderModel.PartialHOM(
    redeclare BESMod.Systems.Demand.Building.AixLibHighOrder building(
      energyDynamicsWalls=Modelica.Fluid.Types.Dynamics.FixedInitial,
      energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
      useConstVentRate=false,
      TimeCorrection=0,
      DiffWeatherDataTime=Modelica.Units.Conversions.to_hour(weaDat.timZon),
      redeclare AixLib.DataBase.Walls.Collections.OFD.EnEV2009Heavy wallTypes,
      redeclare model WindowModel =
          AixLib.ThermalZones.HighOrder.Components.WindowsDoors.WindowSimple,
      redeclare AixLib.DataBase.WindowsDoors.Simple.WindowSimple_EnEV2009
        Type_Win,
      redeclare model CorrSolarGainWin =
          AixLib.ThermalZones.HighOrder.Components.WindowsDoors.BaseClasses.CorrectionSolarGain.CorGSimple,
      redeclare BESMod.Systems.Demand.Building.Components.AixLibHighOrderOFD
        HOMBuiEnv));

  extends Modelica.Icons.Example;
  annotation (experiment(StopTime=172800,
     Interval=600,
     Tolerance=1e-06),
   __Dymola_Commands(file="modelica://BESMod/Resources/Scripts/Dymola/Examples/HighOrderModel/HOMAixLib.mos"
        "Simulate and plot"));
end HOMAixLib;
