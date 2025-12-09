within BESMod.BESRules.BaseClasses;
partial model PartialHeatPumpDesign4D
  "Partial design with 4D table data"
  extends PartialHeatPumpDesign3D(
    QHeaPum_flow_A2W35=evaluate(
        extTabQUse_flow,
        {y_A2W35, 273.15 + 35,273.15 + 2, 5},
        interpMethod,
        extrapMethod) *
        scalingFactor,
    QPriAtTOdaNom_flow_nominal=evaluate(
        extTabQUse_flow,
        { 1,
          TSupAtOda_nominal,
          TOda_nominal,
          if TSupAtOda_nominal>=273.15 + 55 then 10 elseif TSupAtOda_nominal >= 273.15 + 45 then 8 else 5},
        interpMethod,
        extrapMethod) * scalingFactor,
    PEle_A2W35 = evaluate(
    extTabPEle,
    {y_A2W35, 273.15 + 35,273.15 + 2, 5},
    interpMethod,
    extrapMethod) * scalingFactor);

end PartialHeatPumpDesign4D;
