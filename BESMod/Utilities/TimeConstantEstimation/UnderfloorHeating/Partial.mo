within BESMod.Utilities.TimeConstantEstimation.UnderfloorHeating;
partial model Partial "Estimate UFH time constants"
  extends BaseClasses.PartialEstimation(
    startTimeTSet=86400*3 + 3600*5,
    use_solGai=false,
    TOda_start=268.15,
    hydraulic(
      T_start=308.15,
      redeclare BESMod.Systems.Hydraulical.Distribution.BuildingOnly distribution(
          nParallelDem=1),
      redeclare BESMod.Systems.Hydraulical.Transfer.UFHTransferSystem transfer(
        redeclare
          BESMod.Systems.Hydraulical.Transfer.RecordsCollection.DefaultUFHData
          UFHParameters,
        redeclare BESMod.Systems.RecordsCollection.Movers.DefaultMover parPum,
        redeclare
          BESMod.Systems.Hydraulical.Transfer.RecordsCollection.SteelRadiatorStandardPressureLossData
          parTra),
      control(
        valCtrl(k={0.5}),
        redeclare
          BESMod.Systems.Hydraulical.Control.RecordsCollection.BasicBoilerPI
          parPID(
          yMin=0,
          P=0.05,
          timeInt=100))),
    systemParameters(THydSup_nominal={308.15},
                     use_dhw=false),
    building(energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial));
  annotation (experiment(
      StopTime=864000,
      Interval=600,
      __Dymola_Algorithm="Dassl"));
end Partial;
