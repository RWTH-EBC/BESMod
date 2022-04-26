within BESMod.Systems.Electrical.Distribution.Components;
model FixedInitialBatterySimple
  "Add fixed initial conditions to BuildingSystems"

extends BuildingSystems.Technologies.ElectricalStorages.BatterySimple;
initial equation

  EAva = c*SOC_start*E_nominal;
  EBou = (1.0-c)*SOC_start*E_nominal;
  E = E_nominal * SOC_start;
  E_charged = E_start;
  E_discharged = E_start;
end FixedInitialBatterySimple;
