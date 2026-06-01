within BESMod.Systems.Hydraulical.Transfer.RecordsCollection;
record DefaultUFHData_NormBased
  "For a well insulated retrofit building fst"
  extends BESMod.Systems.Hydraulical.Transfer.RecordsCollection.UFHData(
    dpCoe=0,
    dpExp=1.7,
    T_floor=291.15,
    final diameter=18e-3,
    c_top_ratio=fill(0.75, nZones),
    C_ActivatedElement=fill(108000, nZones),
    k_down=fill(0.4, nZones),
    k_top=fill(0, nZones),
    is_groundFloor=fill(true, nZones),
    area=fill(0, nZones));
  // c_top_ratio: EN 1264-4: 4,5cm Verlegetiefe, 6cm typische Dicke Estrich
  // C_ActivatedElement: Wärmekapazität von 6cm Heizestrich
  // k_down: EN 1264-4: R-Wert: 1.25 m²K/W, EnEV: U-Wert von 0,4 W/m²K
  // k_top: calculated in UFHTransferSystem
end DefaultUFHData_NormBased;
