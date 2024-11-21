within BESMod.Systems.Hydraulical.Distribution.Types;
type EnergyLabel = enumeration(
    APlus "A+",
    A "A",
    B "B",
    C "C",
    D "D",
    E "E",
    F "F",
    G "G")
  "Determines the quality of insualtion of the storage tank"
  annotation (Documentation(info="<html>
<p>This is an enumerator type that specifies different energy 
efficiency labels, commonly used to classify energy efficiency 
of storage tanks or other hydraulic components. 
The labels range from A+ (most efficient) to G (least efficient). 
Based on:
<p>
  DELEGATED REGULATION (EU) 812/2013 of 18 February 2013 supplementing Directive 2010/30/EU 
  with regard to the energy labelling of water heaters, 
  hot water storage tanks and packages of water heater and solar device
</p>
</html>"));
