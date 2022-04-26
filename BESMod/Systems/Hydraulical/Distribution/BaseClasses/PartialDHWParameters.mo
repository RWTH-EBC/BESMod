within BESMod.Systems.Hydraulical.Distribution.BaseClasses;
model PartialDHWParameters
  parameter Modelica.SIunits.MassFlowRate mDHW_flow_nominal
    "Nominal mass flow rate" annotation (Dialog(group="Design - Top Down: Parameters are given by the parent system"));
  parameter Modelica.SIunits.HeatFlowRate QDHW_flow_nominal
    "Nominal heat flow rate to DHW" annotation (Dialog(group="Design - Top Down: Parameters are given by the parent system"));
  parameter Modelica.SIunits.Temperature TDHW_nominal "Nominal DHW temperature"  annotation (Dialog(group="Design - Top Down: Parameters are given by the parent system"));
  parameter Modelica.SIunits.TemperatureDifference dTTraDHW_nominal "Nominal temperature difference to transfer heat to DHW"  annotation (Dialog(group="Design - Bottom Up: Parameters are defined by the subsystem"));
  parameter Modelica.SIunits.Volume VDHWDay "Daily volume of DHW tapping"  annotation (Dialog(group="Design - Top Down: Parameters are given by the parent system"));
   parameter Modelica.SIunits.Temperature TDHWCold_nominal "DHW cold city water"  annotation (Dialog(group="Design - Top Down: Parameters are given by the parent system"));

 annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialDHWParameters;
