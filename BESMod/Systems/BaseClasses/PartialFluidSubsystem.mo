within BESMod.Systems.BaseClasses;
model PartialFluidSubsystem
  "Model for a partial subsystem based on the IBPSA fluid core"
  extends IBPSA.Fluid.Interfaces.LumpedVolumeDeclarations;

  parameter Boolean allowFlowReversal=true
    "= false to simplify equations, assuming, but not enforcing, no flow reversal"
    annotation (Dialog(tab="Assumptions"));
  parameter Boolean show_T=false
    "= true, if actual temperature at port is computed"
    annotation (Dialog(tab="Advanced", group="Diagnostics"));
  parameter Modelica.SIunits.Density rho = Medium.density(sta_nominal)
      "Density of medium / fluid in heat distribution system"
      annotation(Dialog(tab="Assumptions", group="General"));
  parameter Modelica.SIunits.SpecificHeatCapacity cp = Medium.specificHeatCapacityCp(sta_nominal)
      "Specific heat capacaity of medium / fluid in heat distribution system"
      annotation(Dialog(tab="Assumptions", group="General"));

protected
  parameter Medium.ThermodynamicState sta_nominal=Medium.setState_pTX(
      T=Medium.T_default, p=Medium.p_default, X=Medium.X_default) "Nominal / default state of medium";
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialFluidSubsystem;
