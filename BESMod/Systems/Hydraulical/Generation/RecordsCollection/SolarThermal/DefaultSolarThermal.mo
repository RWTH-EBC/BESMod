within BESMod.Systems.Hydraulical.Generation.RecordsCollection.SolarThermal;
record DefaultSolarThermal "DummyParameters"
  extends
    BESMod.Systems.Hydraulical.Generation.RecordsCollection.SolarThermal.Generic(
    GMax=1000,
    dTMax=35,
    spacing=0.1,
    dPipe=0.001,
    volPip=5e-3,
    m_flow_nominal=0.1);

  annotation (Documentation(info="<html>
<p>Record containing default parameters for a basic solar thermal system model.</p>
</html>"));
end DefaultSolarThermal;
