within BESMod.Systems.Hydraulical.Transfer.RecordsCollection;
record DefaultUFHData_NoDivZero  "For a well insulated retrofit building"
  extends UFHData(
    T_floor=281.65,
    final diameter=18e-3,
    c_top_ratio=fill(0.19, nZones),
    C_ActivatedElement=fill(380000, nZones),
    k_down=fill(0.37, nZones),
    k_top=fill(4.47, nZones),
    is_groundFloor=fill(true, nZones),
    area=fill(0, nZones));
end DefaultUFHData_NoDivZero;
