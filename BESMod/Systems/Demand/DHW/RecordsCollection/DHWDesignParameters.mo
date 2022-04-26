within BESMod.Systems.Demand.DHW.RecordsCollection;
record DHWDesignParameters
  parameter Modelica.SIunits.MassFlowRate mDHW_flow_nominal
    "Nominal mass flow rate" annotation (Dialog(group="DHW Demand"));
  parameter Modelica.SIunits.HeatFlowRate QDHW_flow_nominal
    "Nominal heat flow rate to DHW" annotation (Dialog(group="DHW Demand"));
  parameter Modelica.SIunits.Temperature TDHW_nominal "Nominal DHW temperature"  annotation (Dialog(group="DHW Demand"));
  parameter Modelica.SIunits.Temperature TDHWCold_nominal "Nominal DHW temperature of cold city water"  annotation (Dialog(group="DHW Demand"));
  parameter Modelica.SIunits.Volume VDHWDay "Daily volume of DHW tapping"  annotation (Dialog(group="DHW Demand"));

end DHWDesignParameters;
