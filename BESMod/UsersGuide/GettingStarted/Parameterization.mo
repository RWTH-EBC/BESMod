within BESMod.UsersGuide.GettingStarted;
model Parameterization "Parameterization"

  annotation(Documentation(info="<html><p>
  The parameterization in BESMod is based on BESTPar (<a href=
  \"https://publications.ibpsa.org/proceedings/bausim/2022/papers/bausim2022_W%C3%BCllhorst_Fabian.pdf\">Wüllhorst
  et al. 2022</a>). This approach minimizes manual parameterization
  efforts by propagating system design parameters from the top down to
  each subsystem.
</p>
<h4>
  Top-Down Parameters
</h4>
<p>
  Top-down parameters are defined at the system level and propagated to
  subsystems. These parameters include:
</p>
<ul>
  <li>
    <strong>System Parameters Record</strong>:
    <ul>
      <li>
        <strong>Heat Demand</strong>: <code>QBui_flow_nominal</code>
      </li>
      <li>
        <strong>Temperature Levels</strong>:
        <ul>
          <li>Outdoor Temperature: <code>TOda_nominal</code>
          </li>
          <li>Hydraulic Supply Temperature:
          <code>THydSup_nominal</code>
          </li>
          <li>etc.
          </li>
        </ul>
      </li>
    </ul>
  </li>
  <li>
    <strong>Building Model Parameters</strong>
  </li>
  <li>
    <strong>DHW (Domestic Hot Water) System Parameters</strong>
  </li>
</ul>
<h4>
  Bottom-Up Parameters
</h4>
<p>
  Bottom-up parameters are defined within subsystems and propagated
  upwards to connected subsystems using <code>Sup_nominal</code> and
  <code>Dem_nominal</code> parameters. Nominal parameters of the
  subsystems are either directly set by top-down parameters or
  calculated using physics-based or rule-based equations. These
  <code>nominal</code> parameters are also propagated to the control
  systems.
</p>
<h4>
  Subsystem Design Parameters
</h4>
<p>
  Each subsystem has internal <code>design</code> parameters to define
  the actual design of components. Typically, design parameters are
  equivalent to nominal parameters but can be specified separately if
  needed. Both nominal and design parameters are used to parameterize
  components, either directly or through additional physics-based or
  rule-based equations and design-independent parameters.
</p>
<h4>
  Partially Retrofitted Hydraulic System
</h4>
<p>
  To facilitate minimal parameterization effort for a partially
  retrofitted hydraulic system, parameters representing an old building
  state can be set. These parameters include:
</p>
<ul>
  <li>
    <strong>Top-Down System Parameters for Old Building State</strong>:
    <ul>
      <li>
        <strong>Heat Demand of Old Building</strong>:
        <code>QBuiOld_flow_design</code>
      </li>
      <li>
        <strong>Hydraulic Supply Temperature of Old Building</strong>:
        <code>THydSupOld_design</code>
      </li>
    </ul>
  </li>
  <li>
    <strong>Subsystem Parameters for Old Building State</strong>:
    <ul>
      <li>
        <code>SupOld_design</code>
      </li>
      <li>
        <code>DemOld_design</code>
      </li>
    </ul>
  </li>
</ul>
<p>
  All <code>Old_design</code> parameters represent the complete old
  building state and are propagated similarly to <code>nominal</code>
  parameters, but not to control systems. With these parameters, each
  hydraulic subsystem has complete knowledge of both the old and
  operational building states.
</p>
<h4>
  Parameterization for Partially Retrofitted Systems
</h4>
<p>
  Subsystems that support automatic parameterization for partial
  retrofits include a <code>use_old_design</code> parameter. This
  parameter allows the subsystem to use either the old design
  parameters or the nominal parameters based on whether the subsystem
  or a parallel path within the subsystem has been retrofitted. If a
  parameter of this type does not exist or is set to final false the
  parameterization is done with the nominal values.
</p>
<p>
  Example usage:
</p>
<pre><code>Q_flow_design = {if use_old_design[i] then QOld_flow_design[i] else Q_flow_nominal[i] for i in 1:nParallelDem}</code></pre>
<p>
  Design parameters can be selectively applied to specific components,
  while others are always parameterized using nominal parameters. For
  example, the radiator transfer systems have a `use_oldRad_design`
  parameter and only the radiator is parameterized with the design
  parameters, while all other components like the pump and thermostat
  valve are parameterized with the nominal parameters.
</p>
</html>
"));
end Parameterization;
