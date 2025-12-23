within BESMod.Systems.Hydraulical.Transfer.BaseClasses;
partial model PartialTransfer "Partial transfer model for BES"
  extends BESMod.Utilities.Icons.TransferIcon;
  extends BESMod.Systems.BaseClasses.PartialSingleSideFluidSubsystemWithParameters(
    final useRoundPipes=true,
    v_design=fill(0.3,nParallelDem),
    TSup_nominal=fill(max(TTra_nominal),nParallelSup),
    TSupOld_design=fill(max(TTraOld_design),nParallelSup),
    dTTra_nominal={if TTra_nominal[i] > 64.9 + 273.15 then 15 elseif
      TTra_nominal[i] > 44.9 + 273.15 then 10 else 7 for i in 1:nParallelDem},
    dTTra_design={if TTra_design[i] > 64.9 + 273.15 then 15 elseif
      TTra_design[i] > 44.9 + 273.15 then 10 else 7 for i in 1:nParallelDem},
    dTTraOld_design={if TTraOld_design[i] > 64.9 + 273.15 then 15 elseif
      TTraOld_design[i] > 44.9 + 273.15 then 10 else 7 for i in 1:nParallelDem},
    mOld_flow_design=QOld_flow_design ./ (dTTraOld_design .* 4184),
    m_flow_nominal=Q_flow_nominal ./ (dTTra_nominal .* 4184),
    m_flow_design=Q_flow_design ./ (dTTra_design .* 4184));

  parameter Modelica.Units.SI.HeatFlowRate QSup_flow_nominal[nParallelSup]=fill(sum(
      Q_flow_nominal .* f_design), nParallelSup)
    "Nominal heat flow rate at supply ports to transfer system" annotation (Dialog(group=
          "Design - Bottom Up: Parameters are defined by the subsystem"));
  parameter Modelica.Units.SI.HeatFlowRate QSupOld_flow_design[nParallelSup]=fill(sum(
      QOld_flow_design .* f_design), nParallelSup)
    "Old design heat flow rate at supply ports to transfer system" annotation (Dialog(group=
          "Design - Bottom Up: Parameters are defined by the subsystem"));

  parameter Modelica.Units.SI.Temperature TTra_nominal[nParallelDem]
    "Nominal supply temperature to transfer systems"
   annotation(Dialog(group="Design - Top Down: Parameters are given by the parent system"));
  parameter Modelica.Units.SI.Temperature TTraOld_design[nParallelDem]
    "Old design nominal supply temperature to transfer systems"
   annotation(Dialog(group="Design - Top Down: Parameters are given by the parent system"));
  parameter Modelica.Units.SI.Temperature TTra_design[nParallelDem]=TTra_nominal
      "Nominal design supply temperature to transfer systems"
   annotation(Dialog(group="Design - Internal: Parameters are defined by the subsystem"));

  parameter Modelica.Units.SI.MassFlowRate mSup_flow_nominal[nParallelSup]=fill(sum(
      m_flow_nominal), nParallelSup)
   "Nominal mass flow rate of the supply ports to the transfer system"
   annotation (Dialog(group="Design - Bottom Up: Parameters are defined by the subsystem"));
  parameter Modelica.Units.SI.MassFlowRate mSup_flow_design[nParallelSup]=fill(sum(
      m_flow_design), nParallelSup)
   "Design mass flow rate of the supply ports to the transfer system"
   annotation (Dialog(group="Design - Bottom Up: Parameters are defined by the subsystem"));
  parameter Modelica.Units.SI.MassFlowRate mSupOld_flow_design[nParallelSup]=fill(sum(
      mOld_flow_design), nParallelSup)
   "Old design mass flow rate of the supply ports to the transfer system"
   annotation (Dialog(group="Design - Bottom Up: Parameters are defined by the subsystem"));

  parameter Modelica.Units.SI.PressureDifference dpSup_nominal[nParallelSup]
    "Nominal pressure loss to design the distribution system"
    annotation (Dialog(tab="Pressure losses", group=
          "Design - Bottom Up: Parameters are defined by the subsystem"));
  parameter Modelica.Units.SI.PressureDifference dpSup_design[nParallelSup]
    "Design pressure loss to design the distribution system"
    annotation (Dialog(tab="Pressure losses", group=
          "Design - Bottom Up: Parameters are defined by the subsystem"));
  parameter Modelica.Units.SI.PressureDifference dpSupOld_design[nParallelSup]
    "Old design pressure loss to design the distribution system"
    annotation (Dialog(tab="Pressure losses", group=
          "Design - Bottom Up: Parameters are defined by the subsystem"));
  parameter Real PercentMflowWorstPressureDropPath = 1
  "The Percentage of m_flow_nominal of the Path with the worst pressure drop. 
  Used for dp calculation of SingleZoneBuildings" annotation(Dialog(tab="Pressure losses", group="Design - Top Down: Parameters are given by the parent system"));

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
