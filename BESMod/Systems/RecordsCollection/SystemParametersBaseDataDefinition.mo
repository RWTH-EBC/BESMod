within BESMod.Systems.RecordsCollection;
record SystemParametersBaseDataDefinition
  "Parameters globally used on all systems"
  extends Modelica.Icons.Record;

  // Heat demand levels
  parameter Integer nZones=1 "Number of zones to transfer heat to"  annotation(Dialog(group="Heat demand"));
  parameter Modelica.SIunits.HeatFlowRate QBui_flow_nominal[nZones]=fill(9710.1, nZones)
    "Nominal heating load at outdoor air temperature of each zone" annotation(Dialog(group="Heat demand"));
  parameter Modelica.SIunits.HeatFlowRate QDHW_flow_nomial=DHWProfile.m_flow_nominal * 4184 * (TSetDHW-TDHWWaterCold) "DHW heat demand" annotation(Dialog(group="Heat demand"));

  // Temperature Levels
  parameter Modelica.SIunits.Temperature TOda_nominal(min=233.15, max=373.15, start=273.15) "Nominal outdoor air temperature" annotation(Dialog(group="Temperature levels"));
  parameter Modelica.SIunits.Temperature TSetZone_nominal[nZones]=fill(293.15,
      nZones) "Nominal set temerature of zones"
                          annotation(Dialog(group="Temperature levels"));

  parameter Modelica.SIunits.Temperature THydSup_nominal[nZones](each min=233.15, each max=373.15, each start=313.15) "Hydraulic supply temperature at nominal condition in the transfer system"
    annotation (Dialog(group="Temperature levels"));
  parameter Modelica.SIunits.Temperature TVenSup_nominal[nZones](each min=233.15, each max=373.15, each start=293.15) = TSetZone_nominal "Ventilation supply temperature at nominal condition"
    annotation (Dialog(group="Temperature levels"));
  parameter Modelica.SIunits.Temperature TEleSup_nominal[nZones](each min=233.15, each max=373.15, each start=293.15) = TSetZone_nominal "Electrical supply temperature at nominal condition"
    annotation (Dialog(group="Temperature levels"));

  parameter Modelica.SIunits.Temperature TSetDHW=323.15   "Constant DHW demand temperature for design" annotation(Dialog(group="Temperature levels"));
  parameter Modelica.SIunits.Temperature TDHWWaterCold=283.15 "Cold water temperature (new water)" annotation(Dialog(group="Temperature levels"));

  parameter Modelica.SIunits.Temperature TAmbHyd=min(TSetZone_nominal)
                                                                    "Ambient temperature of hydraulic system"  annotation(Dialog(group="Temperature levels"));
  parameter Modelica.SIunits.Temperature TAmbVen=min(TSetZone_nominal)
                                                                    "Ambient temperature of ventilation system"  annotation(Dialog(group="Temperature levels"));
  parameter Modelica.SIunits.Temperature TAmbEle=min(TSetZone_nominal)
                                                                    "Ambient temperature of electrical system"  annotation(Dialog(group="Temperature levels"));
  // Boundary conditions
  parameter String filNamWea=Modelica.Utilities.Files.loadResource("modelica://BESMod/Resources/TRY2015_522361130393_Jahr_City_Potsdam.mos")
    "Name of weather data file"
    annotation (Dialog(tab="Inputs", group="Weather"));
  parameter String fileNameIntGains=Modelica.Utilities.Files.loadResource("modelica://BESMod/Resources/InternalGains.txt")
    "File where matrix is stored"
    annotation (Dialog(tab="Inputs", group="Internal Gains"));
  parameter Real intGains_gain=1 "Gain value multiplied with input signal" annotation (Dialog(group="Internal Gains", tab="Inputs"));

  // DHW
  replaceable parameter Systems.Demand.DHW.RecordsCollection.PartialDHWTap
    DHWProfile annotation (choicesAllMatching=true, Dialog(
      group="DHW",
      tab="Inputs",
      enable=not use_dhwCalc and use_dhw));
  parameter Boolean use_dhwCalc=false "=true to use the tables in DHWCalc. Will slow down the simulation, but represents DHW tapping more in a more realistic way."     annotation (Dialog(group="DHW", tab="Inputs", enable=use_dhw));
  parameter String tableName="DHWCalc" "Table name on file for DHWCalc"
    annotation (Dialog(group="DHW", tab="Inputs", enable=use_dhwCalc and use_dhw));
  parameter String fileName=Modelica.Utilities.Files.loadResource(
      "modelica://BESMod/Resources/DHWCalc.txt")
    "File where matrix is stored for DHWCalc"
    annotation (Dialog(group="DHW", tab="Inputs", enable=use_dhwCalc and use_dhw));
  parameter Modelica.SIunits.Volume V_dhwCalc_day=0 "Average daily tapping volume in DHWCalc table" annotation (Dialog(group="DHW", tab="Inputs", enable=use_dhwCalc));
  parameter Modelica.SIunits.Volume V_dhw_day=if use_dhwCalc then V_dhwCalc_day else DHWProfile.V_dhw_day "Average daily tapping volume"
      annotation (Dialog(group="DHW", tab="Inputs", enable=use_dhw));

  // HVAC-Subsystems
  parameter Boolean use_hydraulic=true "=false to disable hydraulic subsystem" annotation(Dialog(group="System layout"));
  parameter Boolean use_ventilation=true "=false to disable ventilation subsystem" annotation(Dialog(group="System layout"));
  parameter Boolean use_dhw=use_hydraulic "=false to disable DHW subsystem" annotation(Dialog(group="System layout", enable=use_hydraulic));

  annotation (defaultComponentName = "baseParameterAssumptions", Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end SystemParametersBaseDataDefinition;
