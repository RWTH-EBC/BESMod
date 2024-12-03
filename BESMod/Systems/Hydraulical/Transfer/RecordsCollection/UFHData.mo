within BESMod.Systems.Hydraulical.Transfer.RecordsCollection;
partial record UFHData
  extends Modelica.Icons.Record;

  parameter Integer nZones   "Number of zones to transfer heat to";
  parameter Modelica.Units.SI.Area area[nZones] "Room area";
  parameter Boolean is_groundFloor[nZones]                      "Indicate if the florr is connected to soil or other rooms";

  parameter Modelica.Units.SI.CoefficientOfHeatTransfer k_top[nZones]
    "Heat transfer coefficient for layers above tubes";
  parameter Modelica.Units.SI.CoefficientOfHeatTransfer k_down[nZones]
    "Heat transfer coefficient for layers underneath tubes";
  parameter AixLib.Fluid.HeatExchangers.ActiveWalls.BaseClasses.HeatCapacityPerArea C_ActivatedElement[nZones];
  parameter Real c_top_ratio[nZones];
  parameter Modelica.Units.SI.Diameter diameter "Pipe diameter";
  parameter Modelica.Units.SI.Temperature T_floor
    "Fixed temperature at floor (soil)";

  annotation (Documentation(info="<html>
<p>Partial record defining the core parameters of an underfloor 
heating system. This record is used as base class for more 
specialized underfloor heating configurations. 
It is a collection of parameters that define the geometric and 
thermodynamic properties of the underfloor heating system in 
multiple zones.</p>
</html>"));
end UFHData;
