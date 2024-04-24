within BESMod.Systems.RecordsCollection;
record SystemParametersBaseDataDefinition
  "Parameters globally used on all systems"
  extends Modelica.Icons.Record;

  // Heat demand levels
  parameter Integer nZones=1 "Number of zones to transfer heat to"  annotation(Dialog(group="Heat demand"));
  parameter Modelica.Units.SI.HeatFlowRate QBui_flow_nominal[nZones]=fill(
      9710.1, nZones)
    "Nominal heating load at outdoor air temperature of each zone"
    annotation (Dialog(group="Heat demand"));

  // Temperature Levels
  parameter Modelica.Units.SI.Temperature TOda_nominal(
    min=233.15,
    max=373.15,
    start=273.15) "Nominal outdoor air temperature"
    annotation (Dialog(group="Temperature levels"));
  parameter Modelica.Units.SI.Temperature TSetZone_nominal[nZones]=fill(293.15,
      nZones) "Nominal set temerature of zones"
    annotation (Dialog(group="Temperature levels"));

  parameter Modelica.Units.SI.Temperature THydSup_nominal[nZones](
    each min=233.15,
    each max=373.15,
    each start=313.15)
    "Hydraulic supply temperature at nominal condition in the transfer system"
    annotation (Dialog(group="Temperature levels"));
  parameter Modelica.Units.SI.Temperature TVenSup_nominal[nZones](
    each min=233.15,
    each max=373.15,
    each start=293.15) = TSetZone_nominal
    "Ventilation supply temperature at nominal condition"
    annotation (Dialog(group="Temperature levels"));
  parameter Modelica.Units.SI.Temperature TEleSup_nominal[nZones](
    each min=233.15,
    each max=373.15,
    each start=293.15) = TSetZone_nominal
    "Electrical supply temperature at nominal condition"
    annotation (Dialog(group="Temperature levels"));

  parameter Modelica.Units.SI.Temperature TSetDHW=323.15
    "Constant DHW demand temperature for design"
    annotation (Dialog(group="Temperature levels"));
  parameter Modelica.Units.SI.Temperature TDHWWaterCold=283.15
    "Cold water temperature (new water)"
    annotation (Dialog(group="Temperature levels"));

  parameter Modelica.Units.SI.Temperature TAmbHyd=min(TSetZone_nominal)
    "Ambient temperature of hydraulic system"
    annotation (Dialog(group="Temperature levels"));
  parameter Modelica.Units.SI.Temperature TAmbVen=min(TSetZone_nominal)
    "Ambient temperature of ventilation system"
    annotation (Dialog(group="Temperature levels"));
  parameter Modelica.Units.SI.Temperature TAmbEle=min(TSetZone_nominal)
    "Ambient temperature of electrical system"
    annotation (Dialog(group="Temperature levels"));
  // Boundary conditions
  parameter String filNamWea
    "Name of weather data file"
    annotation (Dialog(group="Weather data"));

  // Subsystems
  parameter Boolean use_hydraulic=true "=false to disable hydraulic subsystem" annotation(Dialog(group="System layout"));
  parameter Boolean use_ventilation=true "=false to disable ventilation subsystem" annotation(Dialog(group="System layout"));
  parameter Boolean use_dhw=use_hydraulic "=false to disable DHW subsystem" annotation(Dialog(group="System layout", enable=use_hydraulic));
  parameter Boolean use_elecHeating=true "= false to disable heating using the electric system" annotation(Dialog(group="System layout"));

  parameter Modelica.Units.SI.HeatFlowRate QBuiNoRetrofit_flow_nominal[nZones]=QBui_flow_nominal
    "Nominal heating load at outdoor air temperature of each zone befor retrofits"
    annotation (Dialog(group="Partial retrofit"));
  parameter Modelica.Units.SI.Temperature THydSupNoRetrofit_nominal[nZones](
    each min=233.15,
    each max=373.15,
    each start=313.15) = THydSup_nominal
    "Hydraulic supply temperature at nominal condition in the transfer system befor retrofits"
    annotation (Dialog(group="Partial retrofit"));

  annotation (defaultComponentName = "baseParameterAssumptions", Icon(graphics,
                                                                      coordinateSystem(preserveAspectRatio=false)), Diagram(graphics,
        coordinateSystem(preserveAspectRatio=false)));
end SystemParametersBaseDataDefinition;
