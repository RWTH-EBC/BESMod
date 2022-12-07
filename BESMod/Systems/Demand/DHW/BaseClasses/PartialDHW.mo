within BESMod.Systems.Demand.DHW.BaseClasses;
partial model PartialDHW "Partial model for domestic hot water (DHW)"
  extends BESMod.Systems.BaseClasses.PartialFluidSubsystem;
  extends BESMod.Utilities.Icons.DHWIcon;
  parameter Boolean subsystemDisabled "To enable the icon if the subsystem is disabled" annotation (Dialog(tab="Graphics"));
  parameter Modelica.Units.SI.MassFlowRate mDHW_flow_nominal
    "Nominal mass flow rate"
                            annotation (Dialog(group="Design - Bottom Up: Parameters are defined by the subsystem"));
  parameter Modelica.Units.SI.Temperature TDHW_nominal
    "Nominal DHW temperature"
                             annotation (Dialog(group="Design - Bottom Up: Parameters are defined by the subsystem"));
  parameter Modelica.Units.SI.Temperature TDHWCold_nominal
    "Nominal DHW temperature of cold city water"
                                                annotation (Dialog(group="Design - Bottom Up: Parameters are defined by the subsystem"));
  parameter Modelica.Units.SI.Volume VDHWDay "Daily volume of DHW tapping"
                                                                          annotation (Dialog(group="Design - Bottom Up: Parameters are defined by the subsystem"));
  parameter Modelica.Units.SI.HeatFlowRate QDHW_flow_nominal = mDHW_flow_nominal * cp * (TDHW_nominal - TDHWCold_nominal) "Nominal heat flow rate of DHW system" annotation (Dialog(group=
          "Design - Bottom Up: Parameters are defined by the subsystem"));
  parameter Modelica.Units.SI.Time tCrit(displayUnit="h") "Time for critical period. Based on EN 15450" annotation (Dialog(group="Design - Bottom Up: Parameters are defined by the subsystem", enable=designType <> BESMod.Systems.Hydraulical.Distribution.Types.DHWDesignType.NoStorage));
  parameter Real QCrit "Energy demand in kWh during critical period. Based on EN 15450" annotation (Dialog(group="Design - Bottom Up: Parameters are defined by the subsystem", enable=designType == BESMod.Systems.Hydraulical.Distribution.Types.DHWDesignType.PartStorage));

  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare final package Medium
      = Medium) "Inlet for the demand of DHW" annotation (Placement(
        transformation(extent={{-110,50},{-90,70}}),  iconTransformation(extent={{-110,50},
            {-90,70}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare final package Medium
      = Medium) "Outlet of the demand of DHW" annotation (Placement(
        transformation(extent={{-110,-70},{-90,-50}}), iconTransformation(
          extent={{-110,-70},{-90,-50}})));
  BESMod.Systems.Interfaces.DHWOutputs outBusDHW if not use_openModelica
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));

  BESMod.Systems.Interfaces.UseProBus useProBus annotation (
      Placement(transformation(extent={{-22,82},{20,116}}), iconTransformation(
          extent={{44,88},{66,112}})));
  Electrical.Interfaces.InternalElectricalPinOut internalElectricalPin
    annotation (Placement(transformation(extent={{60,-108},{80,-88}})));
equation

  annotation (Icon(
      graphics,                                 coordinateSystem(preserveAspectRatio=false)), Diagram(graphics,
        coordinateSystem(preserveAspectRatio=false)));
end PartialDHW;
