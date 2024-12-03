
within BESMod.Utilities.SupervisoryControl.Types;
type SupervisoryControlType = enumeration(
    Local "Local control only",
    Internal "Modelica internal supervisory control",
    External "External supervisory control (e.g. FMU, python)")
      "Enum for supervisory control type";
  annotation (Documentation(info="<html>
<p>Enumeration type that defines the supervisory control strategy for BES models:</p>
<ul>
<li><code>Local</code>: Uses only local signal</li>
<li><code>Internal</code>: Implements supervisory control using internal Modelica logic</li>
<li><code>External</code>: Enables supervisory control via external tools (e.g. FMUs, Python scripts)</li>
</ul>

<h4>Related Models</h4>
<ul>
<li><a href=\"modelica://BESMod.Utilities.SupervisoryControl\">BESMod.Utilities.SupervisoryControl</a></li>
</ul>
</html>"));