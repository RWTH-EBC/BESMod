within BESMod.Systems.Hydraulical.Transfer.Types;
type HydraulicResistanceType = enumeration(
    Fittings "Fittings only",
    Thermostat "Thermostatic valve",
    CheckValve "Check valve / gravity brake / mixing valve",
    FittingAndThermostat "Fittings + Thermostatic valve",
    FittingAndThermostatAndCheckValve "Fittings + Thermostatic valve + Check valve");
