within BESMod.BESRules.BaseClasses;
model PartialHeatPumpDesign
  parameter Real y_A2W35 = 0.5 "y at A2W35, a typical point of manufacturer data. 50 % compressor speed is 
        used, as manufacturers typically sell devices at part load for higher COP. DIN V 18599-5 specifies 40 to 60 % and these values match with MA Julius";
  parameter Real scalingFactor;
  parameter Modelica.Units.SI.Temperature TSupAtOda_nominal "Nominal radiator temperature";
  parameter Modelica.Units.SI.Temperature TOda_nominal "Nominal outdoor air temperature";
  parameter Modelica.Units.SI.HeatFlowRate QHeaPum_flow_A2W35 "QHeaPum_flow at A2W35";
  parameter Modelica.Units.SI.Power PEle_A2W35 "PEle at A2W35";
  parameter Modelica.Units.SI.HeatFlowRate QPriAtTOdaNom_flow_nominal "Heat pump capacity at nominal outdoor air conditions";
  parameter Modelica.Units.SI.Power COP_A2W35=QHeaPum_flow_A2W35/PEle_A2W35;
  parameter Modelica.Units.SI.Temperature tableOpeEnv[:,2];
  parameter Modelica.Units.SI.TemperatureDifference dTOpeEnv_extra=0 "Extra temperature difference for ope env at design point to avoid table extrapolation";
protected
  parameter Modelica.Units.SI.Temperature TBiv "Bivalence temperature";
  parameter Modelica.Units.SI.Temperature TOpeEnvAtBiv_table=Modelica.Blocks.Tables.Internal.getTable1DValueNoDer2(
    tableIDOpeEnv,
    1,
    TBiv) - dTOpeEnv_extra;
  parameter Modelica.Blocks.Types.ExternalCombiTable1D tableIDOpeEnv=
    Modelica.Blocks.Types.ExternalCombiTable1D(
      "NoName",
      "NoName",
      tableOpeEnv,
      2:size(tableOpeEnv, 2),
      Modelica.Blocks.Types.Smoothness.LinearSegments,
      Modelica.Blocks.Types.Extrapolation.LastTwoPoints,
      false) "External table object";

initial algorithm
  assert(tableOpeEnv[1, 1] < TBiv, "Bivalence temperature is lower than operational envelope", AssertionLevel.error);

end PartialHeatPumpDesign;
