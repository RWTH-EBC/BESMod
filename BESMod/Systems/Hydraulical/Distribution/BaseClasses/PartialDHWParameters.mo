within BESMod.Systems.Hydraulical.Distribution.BaseClasses;
model PartialDHWParameters
  parameter Modelica.Units.SI.MassFlowRate mDHW_flow_nominal(min=Modelica.Constants.eps)
    "Nominal mass flow rate" annotation (Dialog(group=
          "Design - Top Down: Parameters are given by the parent system"));
  parameter Modelica.Units.SI.HeatFlowRate QDHW_flow_nominal(min=Modelica.Constants.eps)
    "Nominal heat flow rate to DHW" annotation (Dialog(group="Design - Top Down: Parameters are given by the parent system"));
  parameter Modelica.Units.SI.HeatFlowRate QDHWBefSto_flow_nominal(min=Modelica.Constants.eps) = if designType==BESMod.Systems.Hydraulical.Distribution.Types.DHWDesignType.NoStorage then QDHW_flow_nominal elseif designType==BESMod.Systems.Hydraulical.Distribution.Types.DHWDesignType.PartStorage then (((QCrit - (VStoDHW * 4184 * 1000 / 3600000) * (TDHW_nominal - 313.15)) / (tCrit/3600)) * 1000 + QDHWStoLoss_flow) elseif designType == BESMod.Systems.Hydraulical.Distribution.Types.DHWDesignType.FullStorage then (VStoDHW * 4184 * 1000 / 3600000 / tCrit) * (TDHW_nominal - TDHWCold_nominal) else Modelica.Constants.eps
    "Nominal heat flow rate to DHW before the storage. Used to design the size of heat generation devices if a storage is used." annotation (Dialog(group="Design - Bottom Up: Parameters are defined by the subsystem"));
  parameter Modelica.Units.SI.Temperature TDHW_nominal
    "Nominal DHW temperature" annotation (Dialog(group=
          "Design - Top Down: Parameters are given by the parent system"));
  parameter Modelica.Units.SI.TemperatureDifference dTTraDHW_nominal
    "Nominal temperature difference to transfer heat to DHW" annotation (Dialog(
        group="Design - Bottom Up: Parameters are defined by the subsystem"));
  parameter Modelica.Units.SI.Volume VDHWDay(min=Modelica.Constants.eps) "Daily volume of DHW tapping"
    annotation (Dialog(group=
          "Design - Top Down: Parameters are given by the parent system"));
  parameter Modelica.Units.SI.Temperature TDHWCold_nominal
    "DHW cold city water" annotation (Dialog(group=
          "Design - Top Down: Parameters are given by the parent system"));
  parameter Types.DHWDesignType designType "Design according to EN 15450" annotation (Dialog(group="Design - Bottom Up: Parameters are defined by the subsystem"));
  parameter Modelica.Units.SI.HeatFlowRate QDHWStoLoss_flow "Losses of DHW storage" annotation (Dialog(group="Design - Bottom Up: Parameters are defined by the subsystem", enable=designType <> BESMod.Systems.Hydraulical.Distribution.Types.DHWDesignType.NoStorage));
  parameter Modelica.Units.SI.Time tCrit(displayUnit="h") "Time for critical period. Based on EN 15450" annotation (Dialog(group="Design - Top Down: Parameters are given by the parent system", enable=designType <> BESMod.Systems.Hydraulical.Distribution.Types.DHWDesignType.NoStorage));
  parameter Real QCrit "Energy demand in kWh during critical period. Based on EN 15450" annotation (Dialog(group="Design - Top Down: Parameters are given by the parent system", enable=designType == BESMod.Systems.Hydraulical.Distribution.Types.DHWDesignType.PartStorage));
  parameter Real fFullSto=2 "Oversize the DHW storage by this factor if full storage is used according to EN 15450" annotation (Dialog(group="Design - Bottom Up: Parameters are defined by the subsystem", enable=designType == BESMod.Systems.Hydraulical.Distribution.Types.DHWDesignType.FullStorage));
  parameter Modelica.Units.SI.Volume VStoDHW "Volume of DHW storage" annotation (Dialog(group=
          "Design - Bottom Up: Parameters are defined by the subsystem", enable=designType <> BESMod.Systems.Hydraulical.Distribution.Types.DHWDesignType.NoStorage));

 annotation (Icon(graphics,
                  coordinateSystem(preserveAspectRatio=false)), Diagram(graphics,
        coordinateSystem(preserveAspectRatio=false)));
end PartialDHWParameters;
