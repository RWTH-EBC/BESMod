within BESMod.Systems.Electrical.Distribution.Components;
model FixedInitialBatterySimple
  "Add fixed initial conditions to BuildingSystems"
  // Give some dummy to avoid errors in BuildingSystems
  extends BuildingSystems.Technologies.ElectricalStorages.BatterySimple(
      redeclare
      BuildingSystems.Technologies.ElectricalStorages.Data.LithiumIon.LithiumIonAquion
      batteryData);
initial equation

  EAva = c*SOC_start*E_nominal;
  EBou = (1.0-c)*SOC_start*E_nominal;
  E = E_nominal * SOC_start;
  E_charged = E_start;
  E_discharged = E_start;
  annotation (Documentation(info="<html>
<h4>Information</h4>
<p>
This model extends the <a href=\"modelica://BuildingSystems.Technologies.ElectricalStorages.BatterySimple\">BuildingSystems.Technologies.ElectricalStorages.BatterySimple</a> 
model with fixed initial conditions to enable regression tests in CI.
</p>
<h4>Initial Equations</h4>
<p>
The model sets fixed initial conditions for:
<ul>
  <li>Available energy (EAva)</li>
  <li>Bound energy (EBou)</li> 
  <li>Total energy (E)</li>
  <li>Charged energy (E_charged)</li>
  <li>Discharged energy (E_discharged)</li>
</ul>
</p>
</html>"));
end FixedInitialBatterySimple;
