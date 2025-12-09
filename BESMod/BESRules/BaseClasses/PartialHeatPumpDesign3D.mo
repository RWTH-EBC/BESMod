within BESMod.BESRules.BaseClasses;
partial model PartialHeatPumpDesign3D "Partial design with 3D table data"
  extends PartialHeatPumpDesign(
    QHeaPum_flow_A2W35=evaluate(
        extTabQUse_flow,
        {y_A2W35, 273.15 + 35,273.15 + 2},
        interpMethod,
        extrapMethod) *
        scalingFactor,
    QPriAtTOdaNom_flow_nominal=evaluate(
        extTabQUse_flow,
        {1,TSupAtOda_nominal,TOda_nominal},
        interpMethod,
        extrapMethod) * scalingFactor,
    PEle_A2W35 = evaluate(
    extTabPEle,
    {y_A2W35, 273.15 + 35,273.15 + 2},
    interpMethod,
    extrapMethod) * scalingFactor);
protected
  parameter SDF.Types.ExternalNDTable extTabQUse_flow;
  parameter SDF.Types.ExternalNDTable extTabPEle;
  parameter SDF.Types.InterpolationMethod interpMethod;
  parameter SDF.Types.ExtrapolationMethod extrapMethod;

  function evaluate
    input SDF.Types.ExternalNDTable table;
    input Real[:] params;
    input SDF.Types.InterpolationMethod interpMethod;
    input SDF.Types.ExtrapolationMethod extrapMethod;
    output Real value;
    external "C" value = ModelicaNDTable_evaluate(table, size(params, 1), params, interpMethod, extrapMethod) annotation (
      Include="#include <ModelicaNDTable.c>",
      IncludeDirectory="modelica://SDF/Resources/C-Sources");
  end evaluate;

end PartialHeatPumpDesign3D;
