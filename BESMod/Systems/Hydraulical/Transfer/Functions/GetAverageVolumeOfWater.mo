within BESMod.Systems.Hydraulical.Transfer.Functions;
function GetAverageVolumeOfWater
  "Calculate the average water volume for the whole heating unit based on the type of the unit and the installed heating load"
  input Modelica.SIunits.HeatFlowRate Q_flow_nominal "Nominal heat flow rate";
  input BESMod.Systems.Hydraulical.Transfer.Types.HeatTransferSystemType traType "Heat transfer system type";
  output Modelica.SIunits.Volume vol "Average water volume of heating system";
protected
  Real QFlow_nominal_internal=Q_flow_nominal/1000 "Used for conversion W to kW (unit of x-axis in diagram)";
  parameter Real slope=0.8613286803324769 "Constant for every number of registers.";
  Real vol_internal "Used for conversion l (unit of y-axis in diagram) to m3";
  Real offset "Output of the table";
algorithm
  if (traType == BESMod.Systems.Hydraulical.Transfer.Types.HeatTransferSystemType.FloorHeating) then
    offset :=  3.490635525069636;
  elseif (traType == BESMod.Systems.Hydraulical.Transfer.Types.HeatTransferSystemType.SteelRadiator) then
    offset :=  3.3077920048238503;
  elseif (traType == BESMod.Systems.Hydraulical.Transfer.Types.HeatTransferSystemType.CastRadiator) then
    offset :=  3.113249710054262;
  elseif (traType == BESMod.Systems.Hydraulical.Transfer.Types.HeatTransferSystemType.PanelRadiators) then
    offset :=  2.7190012280738522;
  elseif (traType == BESMod.Systems.Hydraulical.Transfer.Types.HeatTransferSystemType.Convectors) then
    offset :=  2.3351465455057547;
  end if;
  vol_internal := Modelica.Constants.e^(slope * Modelica.Math.log(QFlow_nominal_internal) + offset);
  vol := vol_internal/1000;
  annotation (Documentation(info="<html>
<p>Calculate the average volume of water in the heating system for a given type of heating system. Based on tables in [1, p. 3].</p>
<p><img src=\"modelica://HVACAndBuidlingCoupling/Resources/Images/Library/DesignParameters/AverageVolumeOfWater.png\"/></p>
<p>[1] MHG HEIZTECHNIK GMBH: Auslegung von Druckausgleichsgef&auml;&szlig;en: MHG-Information. 2006; <a href=\"https://mhg.de/fileadmin/redaktion_upload/geschuetzter_Download/MHG_Info_Ausleg-Druckausgl_dt_2006-07.pdf\">Link to pdf</a></p>
</html>"));
end GetAverageVolumeOfWater;
