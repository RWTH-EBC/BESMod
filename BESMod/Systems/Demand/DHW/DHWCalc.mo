within BESMod.Systems.Demand.DHW;
model DHWCalc "Use DHWCalc tables"
  extends BaseClasses.PartialDHWWithBasics(
    QCrit=0.0172*VDHWDayAt60/1000 + 0.1582,
    tCrit=3600,
    TDHWCold_nominal=283.15,
    TDHW_nominal=323.15,
    combiTimeTableDHWInput(
      final tableOnFile=true,
      final tableName=tableName,
      final fileName=fileName));
  parameter String tableName="DHWCalc" "Table name on file for DHWCalc";
  parameter String fileName=Modelica.Utilities.Files.loadResource(
      "modelica://BESMod/Resources/DHWCalc.txt")
    "File where matrix is stored for DHWCalc";

  annotation (Documentation(info="<html><p>
  <span style=\"font-size: 8.25pt;\">The tool DHWCalc enables stochastic
  DHW profile models. It can be downloaded and used from here:
  https://www.uni-kassel.de/maschinenbau/institute/thermische-energietechnik/fachgebiete/solar-und-anlagentechnik/downloads</span>
</p>
<p>
  The columns of the file-name need to
  be the same as in the StandardProfiles module based on EU Regulation
  812/2013.
</p>
<p>
  The default values for tCrit are
  based on the EU profiles. As the three profiles S, M, and L have a
  near ideal linear fit (R2 = 0.999) for QCrit depending on the daily
  volume, the default regression for QCrit was added.
</p>
<p>
  <span style=\"font-size: 8.25pt;\">This should be re-considered for
  larger daily volumes.</span>
</p>
</html>"));
end DHWCalc;
