within BESMod.Systems.Demand.DHW;
model StandardProfiles "DHW profiles based on EU 812/2013"
  extends BaseClasses.PartialDHWWithBasics(
    QCrit=DHWProfile.QCrit,
    tCrit=DHWProfile.tCrit,
    TDHWCold_nominal=283.15,
    TDHW_nominal=323.15,
    VDHWDay=DHWProfile.VDHWDay,
    mDHW_flow_nominal=DHWProfile.m_flow_nominal,
    combiTimeTableDHWInput(tableOnFile=false, table=DHWProfile.table));
  replaceable parameter Systems.Demand.DHW.RecordsCollection.ProfileM
    DHWProfile constrainedby Systems.Demand.DHW.RecordsCollection.PartialDHWTap annotation (choicesAllMatching=true, Dialog(
      enable=not use_dhwCalc and use_dhw));


  annotation (Documentation(info="<html><p>
  <span style=\"font-size: 8.25pt;\">Source for EU Regulation
  812/2013:</span>
</p>
<p>
  <span style=
  \"font-size: 8.25pt;\">https://eur-lex.europa.eu/LexUriServ/LexUriServ.do?uri=OJ:L:2013:239:0083:0135:en:PDF</span>
</p>
</html>"));
end StandardProfiles;
