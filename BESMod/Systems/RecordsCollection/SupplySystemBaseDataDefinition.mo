within BESMod.Systems.RecordsCollection;
record SupplySystemBaseDataDefinition
  extends Modelica.Icons.Record;

  parameter Integer nZones(min=1) "Number of zones supplied by hydraulic system" annotation (Dialog(group="Building"));
  parameter Modelica.SIunits.HeatFlowRate Q_flow_nominal[nZones] "Nominal heat demand of each zone"  annotation (Dialog(group="Building"));
    parameter Modelica.SIunits.Temperature TOda_nominal "Nominal outdoor air temperature" annotation(Dialog(group="Temperature levels"));

  parameter Modelica.SIunits.Temperature TSup_nominal[nZones] "Nominal supply temperature"  annotation (Dialog(group="Temperatur levels"));
  parameter Modelica.SIunits.Temperature TZone_nominal[nZones] "Nominal supply temperature"  annotation (Dialog(group="Temperatur levels"));
  parameter Modelica.SIunits.Temperature TAmb "Ambient temperature of system. Used to calculate default heat loss." annotation (Dialog(group="Temperatur levels"));
  parameter Modelica.SIunits.Area AZone[nZones] "Area of zones/rooms"
    annotation (Dialog(group="Building"));
  parameter Modelica.SIunits.Height hZone[nZones] "Height of zones"
    annotation (Dialog(group="Building"));
  parameter Modelica.SIunits.Area ABui "Ground area of building"
    annotation (Dialog(group="Building"));
  parameter Modelica.SIunits.Height hBui "Height of building"
    annotation (Dialog(group="Building"));

end SupplySystemBaseDataDefinition;
