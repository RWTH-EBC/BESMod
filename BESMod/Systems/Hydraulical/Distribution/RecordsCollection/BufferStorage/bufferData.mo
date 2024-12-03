within BESMod.Systems.Hydraulical.Distribution.RecordsCollection.BufferStorage;
record bufferData "Simpler design for this repo"
  extends AixLib.DataBase.Storage.StorageDetailedBaseDataDefinition(
    roughness=2.5e-5,
    lengthHC1=floor((hHC1Up - hHC1Low)/(dTank*0.8*tan(0.17453292519943)))*cos(0.17453292519943)*dTank*0.8,
    cWall=cIns,
    rhoWall=rhoIns,
    lengthHC2=floor((hHC1Up - hHC1Low)/(dTank*0.8*tan(0.17453292519943)))*cos(
        0.17453292519943)*dTank*0.8,
    pipeHC2=pipeHC1,
    hTS2=hTank,
    hTS1=0,
    hHR=hTank/2,
    hHC2Low=0,
    hHC2Up=hTank/2,
    hHC1Low=hTank/2,
    hHC1Up=hTank,
    hUpperPortSupply=hTank,
    hLowerPortSupply=0,
    hUpperPortDemand=hTank,
    hLowerPortDemand=0);

  annotation (Documentation(info="<html>
<p>Record for simplified buffer storage data extending from 
The model implements a standard buffer storage tank with fixed geometric parameters.</p>
</html>"));
end bufferData;
