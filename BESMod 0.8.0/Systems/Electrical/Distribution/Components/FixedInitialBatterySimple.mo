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
end FixedInitialBatterySimple;
