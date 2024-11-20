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
  "Determines the quality of insualtion of the storage tank";
  annotation (Documentation(info="<html>
This is an enumerator type that specifies different energy 
efficiency labels, commonly used to classify energy efficiency 
of storage tanks or other hydraulic components. 
The labels range from A+ (most efficient) to G (least efficient). TODO: Add doc with reference?
</html>"));