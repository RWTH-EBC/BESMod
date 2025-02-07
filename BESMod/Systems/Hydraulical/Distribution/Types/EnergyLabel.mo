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
  "Determines the quality of insualtion of the storage tank" annotation (
    Documentation(info="<html>
<p>Source: Annex 2, Table 2 in 
Commission Delegated Regulation (EU) No 812/2013 of 18 February 2013 supplementing Directive 
2010/30/EU of the European Parliament and of the Council with regard to the energy labelling 
of water heaters, hot water storage tanks and packages of water heater and solar device Text with EEA relevance
</p>
</html>"));
