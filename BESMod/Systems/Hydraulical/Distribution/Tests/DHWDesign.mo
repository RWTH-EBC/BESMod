within BESMod.Systems.Hydraulical.Distribution.Tests;
model DHWDesign
  extends Modelica.Icons.Example;

  BESMod.Systems.Hydraulical.Distribution.BaseClasses.PartialDHWParameters partStorage(
    mDHW_flow_nominal=1,
    dpDHW_nominal=0,
    QDHW_flow_nominal=1,
    TDHW_nominal=323.15,
    dTTraDHW_nominal=0,
    VDHWDayAt60(displayUnit="l") = 0.075,
    TDHWCold_nominal=283.15,
    designType=BESMod.Systems.Hydraulical.Distribution.Types.DHWDesignType.PartStorage,
    QDHWStoLoss_flow=300/24,
    QDHWStoLoss_flow_estimate=300/24,
    tCrit=3600,
    QCrit=16002000) "Example E.2 part storage"
    annotation (Placement(transformation(extent={{-18,4},{16,36}})));
  BESMod.Systems.Hydraulical.Distribution.BaseClasses.PartialDHWParameters fullStorage(
    mDHW_flow_nominal=1,
    dpDHW_nominal=0,
    QDHW_flow_nominal=1,
    TDHW_nominal=323.15,
    dTTraDHW_nominal=0,
    VDHWDayAt60(displayUnit="l") = 0.075,
    TDHWCold_nominal=283.15,
    designType=BESMod.Systems.Hydraulical.Distribution.Types.DHWDesignType.FullStorage,
    QDHWStoLoss_flow=2200/24,
    QDHWStoLoss_flow_estimate=2200/24,
    tCrit=3600,
    QCrit=0) "Example E.2 full storage"
    annotation (Placement(transformation(extent={{-18,-46},{16,-14}})));
  annotation (experiment(StopTime=1, Tolerance=1e-06, Interval=1),
     __Dymola_Commands(file="modelica://BESMod/Resources/Scripts/Dymola/Systems/Hydraulical/Distribution/Tests/DHWDesign.mos"
          "Simulate and plot"),
    Documentation(info="<html>
<p>This test checks whether the model <a href=\"modelica://BESMod.Systems.Hydraulical.Distribution.BaseClasses.PartialDHWParameters\">BESMod.Systems.Hydraulical.Distribution.BaseClasses.PartialDHWParameters</a> calculates the DHW design power as specified in the Examples in EN 15450.</p>
<p>Note that in the example for part-storage, EN 15450 has a bad unit. It should be 0.3 kWh/d and not kWh/h. Else, the daily loss volume does not match and, more importantly, the storage would have a really bad insulation value, much worse than enegy label G.</p>
<p>The results do not exactly match the values of the example, as the example rounds values and chooses discrete component sizes, e.g. 250 l instead of the required 235 l in the full-storage example.</p>
</html>"));
end DHWDesign;
