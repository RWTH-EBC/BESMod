within BESMod.Systems.Hydraulical.Distribution.BaseClasses;
model PartialDHWParameters
  parameter Modelica.Units.SI.MassFlowRate mDHW_flow_nominal(min=Modelica.Constants.eps)
    "Nominal mass flow rate" annotation (Dialog(group=
          "Design - Top Down: Parameters are given by the parent system"));
  parameter Modelica.Units.SI.PressureDifference dpDHW_nominal=0
    "Nominal pressure drop of DHW"
    annotation (Dialog(tab="Pressure losses",
      group="Design - Bottom Up: Parameters are defined by the subsystem"));
  parameter Modelica.Units.SI.HeatFlowRate QDHW_flow_nominal(min=Modelica.Constants.eps)
    "Nominal heat flow rate to DHW" annotation (Dialog(group="Design - Top Down: Parameters are given by the parent system"));
  parameter Modelica.Units.SI.HeatFlowRate QDHWBefSto_flow_nominal(min=Modelica.Constants.eps) = max(
    Modelica.Constants.eps,
      if designType==BESMod.Systems.Hydraulical.Distribution.Types.DHWDesignType.NoStorage
         then QDHW_flow_nominal
      elseif designType==BESMod.Systems.Hydraulical.Distribution.Types.DHWDesignType.PartStorage
         then max((QCrit - QDHWStoUse) / tCrit, 0) + QDHWStoLoss_flow
      elseif designType == BESMod.Systems.Hydraulical.Distribution.Types.DHWDesignType.FullStorage
         then VStoDHW * rho_cp * (TDHW_nominal - TDHWCold_nominal) / secondsInDay
      else Modelica.Constants.eps)
    "Nominal heat flow rate to DHW before the storage. Used to design the size of heat generation devices if a storage is used." annotation (Dialog(group="Design - Bottom Up: Parameters are defined by the subsystem"));

  parameter Modelica.Units.SI.Temperature TDHW_nominal
    "Nominal DHW temperature" annotation (Dialog(group=
          "Design - Top Down: Parameters are given by the parent system"));
  parameter Modelica.Units.SI.TemperatureDifference dTTraDHW_nominal
    "Nominal temperature difference to transfer heat to DHW" annotation (Dialog(
        group="Design - Bottom Up: Parameters are defined by the subsystem"));
  parameter Modelica.Units.SI.Volume VDHWDayAt60(min=Modelica.Constants.eps) "Daily volume of DHW tapping at 60 °C"
    annotation (Dialog(group=
          "Design - Top Down: Parameters are given by the parent system"));
  parameter Modelica.Units.SI.Volume VDHWDay_nominal(min=Modelica.Constants.eps)=
    VDHWDayAt60 * (TDHW_nominal_EN15450 - TDHWCold_nominal) / (TDHW_nominal - TDHWCold_nominal)
    "Daily volume of DHW tapping at nominal DHW temperature"
    annotation (Dialog(group=
          "Design - Bottom Up: Parameters are defined by the subsystem"));
  parameter Modelica.Units.SI.Temperature TDHWCold_nominal
    "DHW cold city water" annotation (Dialog(group=
          "Design - Top Down: Parameters are given by the parent system"));
  parameter BESMod.Systems.Hydraulical.Distribution.Types.DHWDesignType
    designType "Design according to EN 15450" annotation (Dialog(group=
          "Design - Bottom Up: Parameters are defined by the subsystem"));
  parameter Modelica.Units.SI.HeatFlowRate QDHWStoLoss_flow "Losses of DHW storage"
    annotation (Dialog(group="Design - Bottom Up: Parameters are defined by the subsystem",
      enable=designType <> BESMod.Systems.Hydraulical.Distribution.Types.DHWDesignType.NoStorage));
  parameter Modelica.Units.SI.HeatFlowRate QDHWStoLoss_flow_estimate
    "Estimate of DHW storage losses based on daily dhw volume only to avoid implicit functions"
    annotation (Dialog(group="Design - Bottom Up: Parameters are defined by the subsystem",
      enable=designType <> BESMod.Systems.Hydraulical.Distribution.Types.DHWDesignType.NoStorage));
  parameter Modelica.Units.SI.Time tCrit(displayUnit="h") "Time for critical period. Based on EN 15450"
    annotation (Dialog(group="Design - Top Down: Parameters are given by the parent system",
      enable=designType <> BESMod.Systems.Hydraulical.Distribution.Types.DHWDesignType.NoStorage));
  parameter Modelica.Units.SI.Energy QCrit(displayUnit="kWh")
    "Energy demand in kWh during critical period. Based on EN 15450 at 60 °C"
    annotation (Dialog(group="Design - Top Down: Parameters are given by the parent system",
      enable=designType == BESMod.Systems.Hydraulical.Distribution.Types.DHWDesignType.PartStorage));
  parameter Real fFullSto=2 "Oversize the DHW storage by this factor if full storage is used according to EN 15450"
    annotation (Dialog(group="Design - Bottom Up: Parameters are defined by the subsystem",
      enable=designType == BESMod.Systems.Hydraulical.Distribution.Types.DHWDesignType.FullStorage));
  parameter Modelica.Units.SI.Volume VStoDHWLos =
    (QDHWStoLoss_flow_estimate * secondsInDay) / (rho_cp * (TDHW_nominal - TDHWCold_nominal))
    "Extra volume to account for storage loss according to EN 15450, in l/d"
    annotation (Dialog(group="Design - Bottom Up: Parameters are defined by the subsystem"));
  parameter Modelica.Units.SI.Volume VStoDHW =
    if designType ==BESMod.Systems.Hydraulical.Distribution.Types.DHWDesignType.FullStorage
      then VDHWDay_nominal * fFullSto + VStoDHWLos
    else VDHWDay_nominal + VStoDHWLos
    "Volume of DHW storage" annotation (Dialog(group=
          "Design - Bottom Up: Parameters are defined by the subsystem", enable=designType
           <> BESMod.Systems.Hydraulical.Distribution.Types.DHWDesignType.NoStorage));
protected
  parameter Modelica.Units.SI.Time secondsInDay = 24 * 3600 "Seconds in day";
  parameter Modelica.Units.SI.Temperature TDHW_nominal_EN15450=333.15
    "Storage temperature according to EN 15450 is 60 °C";
  parameter Modelica.Units.SI.Temperature TDHW_min_EN15450=313.15
    "Minimum tapping temperature according to EN 15450 is 40 °C";
  parameter Real rho_cp_kWh_in_m3 = rho_cp / 3600000
    "Helper variable as the 0,0016 in EN 15450, just in m3";
  parameter Real rho_cp = 4184 * 1000
    "Helper variable, J/m3/K";
  parameter Modelica.Units.SI.Energy QDHWStoUse = VStoDHW * rho_cp * (TDHW_nominal - TDHW_min_EN15450)
  "Useful energy stored above minimal tapping temperature TDHW_min_EN15450";

 annotation (Icon(graphics,
                  coordinateSystem(preserveAspectRatio=false)), Diagram(graphics,
        coordinateSystem(preserveAspectRatio=false)));
end PartialDHWParameters;
