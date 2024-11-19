within BESMod.Systems.BaseClasses;
model PartialFluidSubsystem
  "Model for a partial subsystem based on the IBPSA fluid core"
  extends IBPSA.Fluid.Interfaces.LumpedVolumeDeclarations;
  parameter Boolean use_openModelica=false
    "=true to disable features which 
    are not available in open modelica" annotation(Dialog(tab="Advanced"));

  parameter Boolean allowFlowReversal=true
    "= false to simplify equations, assuming, but not enforcing, no flow reversal"
    annotation (Dialog(tab="Assumptions"));
  parameter Boolean show_T=false
    "= true, if actual temperature at port is computed"
    annotation (Dialog(tab="Advanced", group="Diagnostics"));
  parameter Modelica.Units.SI.Density rho=Medium.density(sta_nominal)
    "Density of medium / fluid in heat distribution system"
    annotation (Dialog(tab="Assumptions", group="General"));
  parameter Modelica.Units.SI.SpecificHeatCapacity cp=
      Medium.specificHeatCapacityCp(sta_nominal)
    "Specific heat capacaity of medium / fluid in heat distribution system"
    annotation (Dialog(tab="Assumptions", group="General"));

protected
  parameter Medium.ThermodynamicState sta_nominal=Medium.setState_pTX(
      T=Medium.T_default, p=Medium.p_default, X=Medium.X_default) "Nominal / default state of medium";
  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(graphics,
        coordinateSystem(preserveAspectRatio=false)));
  annotation (Documentation(info="<html>

<p>This is a partial base class for fluid-based subsystems that extends the IBPSA fluid core components through <a href=\"modelica://IBPSA.Fluid.Interfaces.LumpedVolumeDeclarations\">IBPSA.Fluid.Interfaces.LumpedVolumeDeclarations</a>.</p>

<h4>Important Parameters</h4>
<ul>
  <li><code>use_openModelica</code>: Parameter to disable features not available in OpenModelica</li>
  <li><code>allowFlowReversal</code>: If false, equations are simplified by assuming (but not enforcing) no flow reversal</li>
  <li><code>show_T</code>: Enable computation of actual port temperatures</li>
  <li><code>rho</code>: Density of the heat distribution system fluid [kg/m³]</li>
  <li><code>cp</code>: Specific heat capacity of the heat distribution system fluid [J/(kg.K)]</li>
</ul>
</html>"));
end PartialFluidSubsystem;
