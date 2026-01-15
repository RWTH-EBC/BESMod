within BESMod.BESRules.DesignOptimization.ExamplesInModelica;
model VitoCal250
  extends MonoenergeticVitoCal(
    hydraulic(control(
        useSGReady=true,
        useExtSGSig=false,
        filNamSGReady=ModelicaServices.ExternalReferences.loadResource(
            "modelica://BESMod/Resources/SGReady/EVU_Sperre_Westnetz.txt"),
        buiAndDHWCtr(TSetBuiSup(dTAddCon=10)))),
    redeclare
      BESMod.Examples.TEASERExport.ArchetypeExample.ResidentialBuilding.ResidentialBuilding
      building,
    hydraulic(redeclare
        BESMod.Systems.Hydraulical.Transfer.RadiatorPressureBased transfer(
          redeclare
          BESMod.Systems.Hydraulical.Transfer.RecordsCollection.RadiatorTransferData
          parRad)),
    systemParameters(use_dhw=false),
    hydraulic(distribution(stoBuf(redeclare model HeatTransfer =
              AixLib.Fluid.Storage.BaseClasses.HeatTransferOnlyConduction),
          stoDHW(redeclare model HeatTransfer =
              AixLib.Fluid.Storage.BaseClasses.HeatTransferOnlyConduction))),
    DHW(redeclare BESMod.Systems.Demand.DHW.TappingProfiles.PassThrough
        calcmFlow, redeclare BESMod.Systems.Demand.DHW.RecordsCollection.NoDHW
        DHWProfile));
end VitoCal250;
