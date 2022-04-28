within BESMod.Systems.RecordsCollection;
record SupplySystemBaseDataDefinition
  extends Modelica.Icons.Record;

  parameter Integer nZones(min=1) "Number of zones supplied by hydraulic system" annotation (Dialog(group="Building"));
  parameter Modelica.Units.SI.HeatFlowRate Q_flow_nominal[nZones]
    "Nominal heat demand of each zone" annotation (Dialog(group="Building"));
  parameter Modelica.Units.SI.Temperature TOda_nominal
    "Nominal outdoor air temperature"
    annotation (Dialog(group="Temperature levels"));

  parameter Modelica.Units.SI.Temperature TSup_nominal[nZones]
    "Nominal supply temperature" annotation (Dialog(group="Temperatur levels"));
  parameter Modelica.Units.SI.Temperature TZone_nominal[nZones]
    "Nominal supply temperature" annotation (Dialog(group="Temperatur levels"));
  parameter Modelica.Units.SI.Temperature TAmb
    "Ambient temperature of system. Used to calculate default heat loss."
    annotation (Dialog(group="Temperatur levels"));
  parameter Modelica.Units.SI.Area AZone[nZones] "Area of zones/rooms"
    annotation (Dialog(group="Building"));
  parameter Modelica.Units.SI.Height hZone[nZones] "Height of zones"
    annotation (Dialog(group="Building"));
  parameter Modelica.Units.SI.Area ABui "Ground area of building"
    annotation (Dialog(group="Building"));
  parameter Modelica.Units.SI.Height hBui "Height of building"
    annotation (Dialog(group="Building"));

end SupplySystemBaseDataDefinition;
