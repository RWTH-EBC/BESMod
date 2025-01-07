within BESMod.Systems.Hydraulical.RecordsCollection;
record DHWDesignParameters
  parameter Modelica.Units.SI.MassFlowRate mDHW_flow_nominal
    "Nominal mass flow rate" annotation (Dialog(group="DHW"));
  parameter Modelica.Units.SI.Temperature TDHW_nominal
    "Nominal DHW temperature" annotation (Dialog(group="DHW"));
  parameter Modelica.Units.SI.Temperature TDHWCold_nominal
    "Nominal DHW temperature of cold city water"
    annotation (Dialog(group="DHW"));
  parameter Modelica.Units.SI.Volume VDHWDayAt60 "Daily volume of DHW tapping" annotation (Dialog(group="DHW"));
  parameter Modelica.Units.SI.HeatFlowRate QDHW_flow_nominal "Nominal heat flow rate of DHW system" annotation (Dialog(group=
          "DHW"));
  parameter Modelica.Units.SI.Time tCrit(displayUnit="h") "Time for critical period. Based on EN 15450" annotation (Dialog(group="Design - Top Down: Parameters are given by the parent system", enable=designType <> BESMod.Systems.Hydraulical.Distribution.Types.DHWDesignType.NoStorage));
  parameter Real QCrit "Energy demand in kWh during critical period. Based on EN 15450" annotation (Dialog(group="Design - Bottom Up: Parameters are defined by the subsystem", enable=designType == BESMod.Systems.Hydraulical.Distribution.Types.DHWDesignType.PartStorage));


end DHWDesignParameters;
