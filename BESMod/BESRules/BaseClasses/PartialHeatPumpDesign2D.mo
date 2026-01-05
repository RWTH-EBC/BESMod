within BESMod.BESRules.BaseClasses;
partial model PartialHeatPumpDesign2D
  "Partial design with 2D table data"
  extends PartialHeatPumpDesign(
    QHeaPum_flow_A2W35=Modelica.Blocks.Tables.Internal.getTable2DValueNoDer2(
        tabIdeQUse_flow,
        35 + 273.15,
        2 + 273.15) * scalingFactor * y_A2W35,
    QPriAtTOdaNom_flow_nominal=Modelica.Blocks.Tables.Internal.getTable2DValueNoDer2(
        tabIdeQUse_flow,
        TSupAtOda_nominal,
        TOda_nominal) * scalingFactor,
    PEle_A2W35 = Modelica.Blocks.Tables.Internal.getTable2DValueNoDer2(
        tabIdePEle,
        35 + 273.15,
        2 + 273.15) * scalingFactor * y_A2W35);

protected
  parameter Modelica.Blocks.Types.ExternalCombiTable2D tabIdeQUse_flow;
  parameter Modelica.Blocks.Types.ExternalCombiTable2D tabIdePEle;
end PartialHeatPumpDesign2D;
