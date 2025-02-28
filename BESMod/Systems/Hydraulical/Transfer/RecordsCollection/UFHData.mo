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
  parameter Real dpExp "Pressure drop exponent";
  parameter Real dpCoe "Pressure drop coefficient";
end UFHData;
