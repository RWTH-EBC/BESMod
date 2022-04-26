within BESMod.Systems.Demand.DHW.BaseClasses;
partial model PartialDHW "Partial model for domestic hot water (DHW)"
  extends BESMod.Systems.BaseClasses.PartialFluidSubsystem;
  extends BESMod.Utilities.Icons.DHWIcon;
  replaceable parameter RecordsCollection.DHWDesignParameters parameters;

  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare final package Medium =
        Medium) "Inlet for the demand of DHW" annotation (Placement(
        transformation(extent={{-110,50},{-90,70}}),  iconTransformation(extent={{-110,50},
            {-90,70}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare final package Medium =
        Medium) "Outlet of the demand of DHW" annotation (Placement(
        transformation(extent={{-110,-70},{-90,-50}}), iconTransformation(
          extent={{-110,-70},{-90,-50}})));
  BESMod.Systems.Interfaces.DHWOutputs outBusDHW
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));

  BESMod.Systems.Interfaces.UseProBus useProBus annotation (
      Placement(transformation(extent={{-22,82},{20,116}}), iconTransformation(
          extent={{44,88},{66,112}})));
  Electrical.Interfaces.InternalElectricalPin internalElectricalPin
    annotation (Placement(transformation(extent={{60,-108},{80,-88}})));
equation

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialDHW;
