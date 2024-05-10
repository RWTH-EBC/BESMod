within BESMod.Systems.Hydraulical.Transfer.BaseClasses;
partial model PartialTransfer "Partial transfer model for BES"
  extends BESMod.Utilities.Icons.TransferIcon;
  extends BESMod.Systems.BaseClasses.PartialFluidSubsystemWithParameters(
    TSup_nominal=fill(max(TTra_nominal),nParallelSup),
    TSup_nominal_old_design=fill(max(TTra_nominal_old_design),nParallelSup),
      dTTra_nominal={if TTra_nominal[i] > 64.9 + 273.15 then 15 elseif
        TTra_nominal[i] > 44.9 + 273.15 then 10 else 7 for i in 1:nParallelDem},
      m_flow_nominal=Q_flow_nominal ./ (dTTra_nominal .* 4184),
      dTTra_nominal_design={if TTra_nominal_design[i] > 64.9 + 273.15 then 15 elseif
        TTra_nominal_design[i] > 44.9 + 273.15 then 10 else 7 for i in 1:nParallelDem},
      m_flow_nominal_design=Q_flow_nominal_design ./ (dTTra_nominal .* 4184));

  parameter Modelica.Units.SI.HeatFlowRate QSup_flow_nominal[nParallelSup]=fill(sum(
      Q_flow_nominal .* f_design), nParallelSup)
    "Nominal heat flow rate at supply ports to transfer system" annotation (Dialog(group=
          "Design - Bottom Up: Parameters are defined by the subsystem"));
  parameter Modelica.Units.SI.HeatFlowRate QSup_flow_nominal_old_design[nParallelSup]=fill(sum(
      Q_flow_nominal_old_design .* f_design), nParallelSup)
    "Nominal heat flow rate at supply ports to transfer system" annotation (Dialog(group=
          "Design - Bottom Up: Parameters are defined by the subsystem"));

  parameter Modelica.Units.SI.Temperature TTra_nominal[nParallelDem] "Nominal supply temperature to transfer systems"
   annotation(Dialog(group="Design - Top Down: Parameters are given by the parent system"));
  parameter Modelica.Units.SI.Temperature TTra_nominal_old_design[nParallelDem] "Nominal supply temperature to transfer systems at old design"
   annotation(Dialog(group="Design - Top Down: Parameters are given by the parent system"));
  parameter Modelica.Units.SI.Temperature TTra_nominal_design[nParallelDem]=
      {if NoRetrofit[i] then TTra_nominal_old_design[i] else TTra_nominal[i] for i in 1:nParallelDem}
      "Nominal supply temperature to transfer systems at first design"
   annotation(Dialog(group="Design - Internal: Parameters are defined by the subsystem at first design"));
  parameter Modelica.Units.SI.MassFlowRate mSup_flow_nominal[nParallelSup]=fill(sum(
      m_flow_nominal), nParallelSup)
   "Nominal mass flow rate of the supply ports to the transfer system" annotation (Dialog(
        group="Design - Bottom Up: Parameters are defined by the subsystem"));
  parameter Modelica.Units.SI.MassFlowRate mSup_flow_nominal_old_design[nParallelSup]=fill(sum(
      m_flow_nominal), nParallelSup)
   "Nominal mass flow rate of the supply ports to the transfer system" annotation (Dialog(
        group="Design - Bottom Up: Parameters are defined by the subsystem"));

  parameter Modelica.Units.SI.PressureDifference dpSup_nominal[nParallelSup]
    "Nominal pressure loss of resistances in the supply system of the distribution"
    annotation (Dialog(group=
          "Design - Top Down: Parameters are given by the parent system"));

  parameter Modelica.Units.SI.Area AZone[nParallelDem](each min=0.1)
     "Area of zones/rooms"
    annotation (Dialog(group=
          "Design - Top Down: Parameters are given by the parent system"));
  parameter Modelica.Units.SI.Height hZone[nParallelDem](each min=0.1)
     "Height of zones"
    annotation (Dialog(group=
          "Design - Top Down: Parameters are given by the parent system"));
  parameter Modelica.Units.SI.Area ABui(min=0.1)
     "Ground area of building" annotation (
      Dialog(group=
          "Design - Top Down: Parameters are given by the parent system"));
  parameter Modelica.Units.SI.Height hBui(min=0.1)
     "Height of building" annotation (
      Dialog(group=
          "Design - Top Down: Parameters are given by the parent system"));
  parameter Real nHeaTra "Exponent of heat transfer system"
    annotation (Dialog(
        group="Design - Bottom Up: Parameters are defined by the subsystem"));
  Modelica.Fluid.Interfaces.FluidPort_b portTra_out[nParallelSup](redeclare
      final package Medium = Medium) "Outlet of the transfer system"
    annotation (Placement(transformation(extent={{-110,-52},{-90,-32}}),
        iconTransformation(extent={{-110,-52},{-90,-32}})));
  Modelica.Fluid.Interfaces.FluidPort_a portTra_in[nParallelSup](redeclare
      final package Medium = Medium) "Inlet to the transfer system" annotation (
     Placement(transformation(extent={{-110,28},{-90,48}}), iconTransformation(
          extent={{-110,30},{-90,50}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPortRad[nParallelDem]
    "Heat port for radiative heat transfer with room radiation temperature"
    annotation (Placement(transformation(extent={{90,-50},{110,-30}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPortCon[nParallelDem]
    "Heat port for convective heat transfer with room air temperature"
    annotation (Placement(transformation(extent={{90,30},{110,50}}),
        iconTransformation(extent={{90,30},{110,50}})));
  BESMod.Systems.Hydraulical.Interfaces.TransferOutputs
    outBusTra if not use_openModelica
    annotation (Placement(transformation(extent={{-10,-114},{10,-94}})));
  Interfaces.TransferControlBus traControlBus
    annotation (Placement(transformation(extent={{-10,90},{10,110}})));
  BESMod.Systems.Electrical.Interfaces.InternalElectricalPinOut
    internalElectricalPin
    annotation (Placement(transformation(extent={{62,-108},{82,-88}})));
  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(graphics,
        coordinateSystem(preserveAspectRatio=false)));
end PartialTransfer;
