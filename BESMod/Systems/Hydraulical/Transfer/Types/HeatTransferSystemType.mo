within BESMod.Systems.Hydraulical.Transfer.Types;
type HeatTransferSystemType = enumeration(
    FloorHeating,
    SteelRadiator,
    CastRadiator,
    PanelRadiators,
    Convectors)
  "Type of the heating system for calculating volume of distribution and transfer system"
  annotation (Documentation(info="<html>
<p>
Enumeration type for defining different heat transfer systems in buildings. 
This type is used to calculate the volume of the distribution and 
transfer system based on the selected heating system type.
</p>

<p>The enumeration includes the following options:</p>
<ul>
  <li><code>FloorHeating</code>: Floor heating system with pipes embedded in floor construction</li>
  <li><code>SteelRadiator</code>: Steel panel radiators</li>
  <li><code>CastRadiator</code>: Cast iron radiators</li>
  <li><code>PanelRadiators</code>: Panel type radiators</li>
  <li><code>Convectors</code>: Convector heating units</li>
</ul>
</html>"));