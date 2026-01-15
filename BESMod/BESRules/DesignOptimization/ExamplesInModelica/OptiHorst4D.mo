within BESMod.BESRules.DesignOptimization.ExamplesInModelica;
model OptiHorst4D
  extends MonoenergeticOptiHorstDefrost( redeclare
      BESMod.Examples.TEASERExport.ArchetypeExample.ResidentialBuilding.ResidentialBuilding
      building, hydraulic(generation(
      redeclare replaceable AixLib.Fluid.HeatPumps.ModularReversible.Controls.Defrost.OptimalDefrostTimeWangEtAl defCtrl),
        redeclare
        BESMod.Systems.Hydraulical.Transfer.RadiatorPressureBased transfer(
          redeclare
          BESMod.Systems.Hydraulical.Transfer.RecordsCollection.RadiatorTransferData
          parRad)));
end OptiHorst4D;
