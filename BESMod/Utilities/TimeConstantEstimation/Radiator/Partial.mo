within BESMod.Utilities.TimeConstantEstimation.Radiator;
partial model Partial "Estimate UFH time constants"
  extends BaseClasses.PartialEstimation(
    startTimeTSet=86400*3 + 3600*5,
    use_solGai=false,
    TOda_start=268.15,
    hydraulic(
      T_start=273.15 + 55,
      redeclare BESMod.Systems.Hydraulical.Distribution.BuildingOnly distribution(
          nParallelDem=1),
      redeclare BESMod.Systems.Hydraulical.Transfer.RadiatorPressureBased
        transfer(
        redeclare
          BESMod.Systems.Hydraulical.Transfer.RecordsCollection.SteelRadiatorStandardPressureLossData
          parTra,
        redeclare BESMod.Systems.RecordsCollection.Movers.DefaultMover parPum,
        redeclare
          BESMod.Systems.Hydraulical.Transfer.RecordsCollection.RadiatorTransferData
          parRad),
      control(
        valCtrl(k={0.5}),
        redeclare
          BESMod.Systems.Hydraulical.Control.RecordsCollection.BasicBoilerPI
          parPID(
          yMin=0,
          P=0.05,
          timeInt=100))),
    systemParameters(THydSup_nominal={328.15},
                     use_dhw=false));
  annotation (experiment(
      StopTime=864000,
      Interval=600,
      __Dymola_Algorithm="Dassl"));
end Partial;
