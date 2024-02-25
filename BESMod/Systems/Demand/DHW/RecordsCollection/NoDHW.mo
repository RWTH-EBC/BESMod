within BESMod.Systems.Demand.DHW.RecordsCollection;
record NoDHW
  extends BESMod.Systems.Demand.DHW.RecordsCollection.PartialDHWTap(
    QCrit=0,
    tCrit=1,
    final m_flow_nominal=0.1,
    final table=[0,0,0,10,10; 86400,0,0,10,10],
    final VDHWDay=100e-3);
  annotation (Documentation(info="<html>
<p>Do not tap any DHW water. The defalt values for other parameters prevent division by zero errors in the automatic parameterization on system level. As no DHW will be used, it should not affect the system in any way.</p>
</html>"));
end NoDHW;
