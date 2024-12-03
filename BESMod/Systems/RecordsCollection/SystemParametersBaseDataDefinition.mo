within BESMod.Systems.RecordsCollection;
record SystemParametersBaseDataDefinition
  "Parameters globally used on all systems"
  extends Modelica.Icons.Record;

  // Heat demand levels
  parameter Integer nZones=1 "Number of zones to transfer heat to"  annotation(Dialog(group="Heat demand"));
  parameter Modelica.Units.SI.HeatFlowRate QBui_flow_nominal[nZones]=fill(0, nZones)
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

  parameter Modelica.Units.SI.HeatFlowRate QBuiOld_flow_design[nZones]=QBui_flow_nominal
    "Nominal design heating load at outdoor air temperature of each zone in the old builing state"
    annotation (Dialog(group="Old / before retrofit"));
  parameter Modelica.Units.SI.Temperature THydSupOld_design[nZones](
    each min=233.15,
    each max=373.15,
    each start=313.15) = THydSup_nominal
    "Hydraulic supply temperature at design condition in the transfer system in the old builing state"
    annotation (Dialog(group="Old / before retrofit"));

  annotation (defaultComponentName = "baseParameterAssumptions", Icon(graphics,
                                                                      coordinateSystem(preserveAspectRatio=false)), Diagram(graphics,
        coordinateSystem(preserveAspectRatio=false)));
  annotation (Documentation(info="<html>
<p>This record contains the basic parameters used globally in all BESMod systems. 
It defines temperature levels, heat demand characteristics, and system configuration parameters 
for building energy system simulations.</p>

<h4>Important Parameters</h4>
<h5>Heat Demand</h5>
<ul>
  <li><code>nZones</code>: Number of building zones (default: 1)</li>
  <li><code>QBui_flow_nominal</code>: Nominal heating load per zone [W]</li>
</ul>

<h5>Temperature Levels</h5>
<ul>
  <li><code>TOda_nominal</code>: Nominal outdoor air temperature [K]</li>
  <li><code>TSetZone_nominal</code>: Nominal zone setpoint temperatures [K]</li>
  <li><code>THydSup_nominal</code>: Nominal hydraulic supply temperatures [K]</li>
  <li><code>TVenSup_nominal</code>: Nominal ventilation supply temperatures [K]</li>
  <li><code>TEleSup_nominal</code>: Nominal electrical heating supply temperatures [K]</li>
  <li><code>TSetDHW</code>: DHW setpoint temperature [K]</li>
  <li><code>TDHWWaterCold</code>: Cold water inlet temperature [K]</li>
  <li><code>TAmbHyd</code>: Ambient temperature for hydraulic system [K]</li>
  <li><code>TAmbVen</code>: Ambient temperature for ventilation system [K]</li>
  <li><code>TAmbEle</code>: Ambient temperature for electrical system [K]</li>
</ul>

<h5>System Configuration</h5>
<ul>
  <li><code>use_hydraulic</code>: Enable/disable hydraulic subsystem</li>
  <li><code>use_ventilation</code>: Enable/disable ventilation subsystem</li>
  <li><code>use_dhw</code>: Enable/disable DHW subsystem</li>
  <li><code>use_elecHeating</code>: Enable/disable electrical heating</li>
</ul>

<h5>Retrofit Parameters</h5>
<ul>
  <li><code>QBuiOld_flow_design</code>: Design heating load before retrofit [W]</li>
  <li><code>THydSupOld_design</code>: Design hydraulic supply temperatures before retrofit [K]</li>
</ul>

<h5>Weather Data</h5>
<ul>
  <li><code>filNamWea</code>: Weather data file name</li>
</ul>
</html>"));
end SystemParametersBaseDataDefinition;
