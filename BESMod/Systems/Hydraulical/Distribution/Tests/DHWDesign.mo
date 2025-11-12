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
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end DHWDesign;
