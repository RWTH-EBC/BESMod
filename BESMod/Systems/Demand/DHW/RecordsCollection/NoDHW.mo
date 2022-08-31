within BESMod.Systems.Demand.DHW.RecordsCollection;
record NoDHW
  extends BESMod.Systems.Demand.DHW.RecordsCollection.PartialDHWTap(
    QCrit=0,
    tCrit=0,
    final m_flow_nominal=0,
    final table=[0,0,0,10,10; 86400,0,0,10,10],
    final VDHWDay=0);
end NoDHW;
