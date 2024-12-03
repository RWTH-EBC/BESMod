within BESMod.Systems.Hydraulical.Generation.Types;
type GenerationDesign = enumeration(
    Monovalent "Monovalent",
    BivalentAlternativ "Bivalent alternativ",
    BivalentParallel "Bivalent parallel",
    BivalentPartParallel "Bivalent partly parallel")
  "Choose between different design options for primary generation"
  annotation (Documentation(info="<html>
<h4>Information</h4>
<p>
Enumeration type for choosing the design configuration for 
the primary heat generation system.
Depending on the selected design, one or two heat generators 
can operate in different control schemes.
</p>

<h4>Possible design options:</h4>
<ul>
  <li><b>Monovalent</b>: Operation with a single heat generator only</li>  
  <li><b>BivalentAlternativ</b>: Two heat generators operating exclusively (either one or the other)</li>
  <li><b>BivalentParallel</b>: Two heat generators that can run simultaneously</li>
  <li><b>BivalentPartParallel</b>: Two heat generators that run partly in parallel operation</li>
</ul>
</html>"));
