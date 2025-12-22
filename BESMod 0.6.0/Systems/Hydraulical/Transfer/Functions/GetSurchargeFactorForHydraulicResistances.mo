within BESMod.Systems.Hydraulical.Transfer.Functions;
function GetSurchargeFactorForHydraulicResistances
  "Returns the surcharge factor for a given hydraulic resistance to calculate the pump head"
  input
    BESMod.Systems.Hydraulical.Transfer.Types.HydraulicResistanceType
    resistance_type "Type of the hydraulic resistance";
  output Real surchargeFactor "Surcharge factor based on Babusch et.al.";
algorithm
  if resistance_type == BESMod.Systems.Hydraulical.Transfer.Types.HydraulicResistanceType.Fittings then
    surchargeFactor := 1.3;
  elseif resistance_type == BESMod.Systems.Hydraulical.Transfer.Types.HydraulicResistanceType.Thermostat then
    surchargeFactor := 1.7;
  elseif resistance_type == BESMod.Systems.Hydraulical.Transfer.Types.HydraulicResistanceType.CheckValve then
    surchargeFactor := 1.2;
  elseif resistance_type == BESMod.Systems.Hydraulical.Transfer.Types.HydraulicResistanceType.FittingAndThermostat then
    surchargeFactor := 2.2;
  elseif resistance_type == BESMod.Systems.Hydraulical.Transfer.Types.HydraulicResistanceType.FittingAndThermostatAndCheckValve then
    surchargeFactor := 2.6;
  end if;
  annotation (Documentation(info="<html>
<p>The surcharge factors are based on Babusch et. al. [1, p. 41].</p>
<p><br><br>[1] Babusch, Andr&eacute; ; Ebert, Thomas ; K&ouml;nig, Karl-Heinz ;Makoschey, Thomas; Millies, Andreas ; Oraschweski, Manfred ; Rudolph, Bernd: Grundlagen der Pumpentechnik: Pumpenfibel. 5. &uuml;berarbeitete und aktualisierte Auflage. Dortmund, 2009; <a href=\"http://wilo.cdn.mediamid.com/cdndoc/wilo6423/602980/wilo6423.pdf\">Link to pdf</a></p>
</html>"));
end GetSurchargeFactorForHydraulicResistances;
