within BESMod.Systems.Demand.DHW.BaseClasses;
partial model PartialDHW "Partial model for domestic hot water (DHW)"
  extends BESMod.Systems.BaseClasses.PartialFluidSubsystem;
  extends BESMod.Utilities.Icons.DHWIcon;
  replaceable parameter RecordsCollection.DHWDesignParameters parameters;
  parameter Boolean subsystemDisabled "To enable the icon if the subsystem is disabled" annotation (Dialog(tab="Graphics"));

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

  annotation (Icon(
      Ellipse(
        visible=subsystemDisabled,
        extent={{-82,82},{78,-78}},
        lineColor={215,215,215},
        fillColor={255,0,0},
        fillPattern=FillPattern.Solid),
      Ellipse(
        visible=subsystemDisabled,
        extent={{-57,57},{53,-53}},
        lineColor={255,255,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Rectangle(
        visible=subsystemDisabled,
        extent={{-60,14},{60,-14}},
        lineColor={255,0,0},
        fillColor={255,0,0},
        fillPattern=FillPattern.Solid,
        rotation=45,
          origin={-4,0}),                       coordinateSystem(preserveAspectRatio=false)), Diagram(graphics,
        coordinateSystem(preserveAspectRatio=false)));
end PartialDHW;
