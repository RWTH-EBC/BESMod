within BESMod.BESRules.DesignOptimization.ExamplesInModelica;
model OptiHorst4D
  extends MonoenergeticOptiHorstDefrost (redeclare
      BESMod.Examples.TEASERExport.ArchetypeExample.ResidentialBuilding.ResidentialBuilding
      building, hydraulic(redeclare
        BESMod.Systems.Hydraulical.Transfer.RadiatorPressureBased transfer(
          redeclare
          BESMod.Systems.Hydraulical.Transfer.RecordsCollection.RadiatorTransferData
          parRad)));
end OptiHorst4D;
