within BESMod.Systems.Hydraulical.Transfer.RecordsCollection;
partial record TransferDataBaseDefinition_forUFH
  "Data record for hydraulic heat transfer system"
  extends Modelica.Icons.Record;
  // Building
  parameter Integer nZones "Numer of zones heated"
                                                  annotation(Dialog(group=
          "Building"));
  parameter Modelica.Units.SI.HeatFlowRate Q_flow_nominal[nZones]
    "Nominal heat flow rate" annotation (Dialog(group="Building"));
  parameter Modelica.Units.SI.Area AFloor "Net floor area of one floor"
    annotation (Dialog(group="Building"));
  parameter Modelica.Units.SI.Length heiBui "Building height"
    annotation (Dialog(group="Building"));

  // Volume
  parameter BESMod.Systems.Hydraulical.Transfer.Types.HeatTransferSystemType traType
    "Heat transfer system type"                                                                                   annotation(Dialog(group=
          "Volume"));
  parameter Modelica.Units.SI.Volume vol=
      BESMod.Systems.Hydraulical.Transfer.Functions.GetAverageVolumeOfWater(sum(
      Q_flow_nominal), traType)
    "Volume of water in whole heat distribution and transfer system"
    annotation (Dialog(group="Volume"));
  // Pressure
  parameter BESMod.Systems.Hydraulical.Transfer.Types.PressureDropPerLength pressureDropPerLen(min=Modelica.Constants.eps)
      "Pressure drop per m that is allowed maximal within whole heat distribution system (typical value: 100 Pa/m). TODO: Calculate based on Figure 2.6.3-12 in Taschenbuch für HEIZUNG + KLIMATECHNIK 2019"
      annotation(Dialog(group="Pressure"));
  parameter BESMod.Systems.Hydraulical.Transfer.Types.HydraulicResistanceType typeOfHydRes
    "Type of the hydraulic restistances to be considered for parameter zf"                                                                                        annotation(Dialog(group="Pressure"), choicesAllMatching=true, Dialog(descriptionLabel=true));
  parameter Real zf(min=1.0, max=10.0, unit="1") = BESMod.Systems.Hydraulical.Transfer.Functions.GetSurchargeFactorForHydraulicResistances(typeOfHydRes)
      "Factor for additional pressure resistances in piping network such as bows. Acc. to [Babusch, 2009]"
      annotation(Dialog(group="Pressure"));
  parameter Modelica.Units.SI.PressureDifference dpHeaDistr_nominal(min=Modelica.Constants.eps)=
      pressureDropPerLen*zf*2*(2*sqrt(AFloor) + heiBui)
    "Pressure difference of heat distribuition system including piping plus pressure resistances but excluding UFH piping / heating circuit distributor. Actually L * W * H (factor 2 for flow and return)."
    annotation (Dialog(group="Pressure"));

  // UFH
  parameter Modelica.Units.SI.PressureDifference dpUFH_nominal[nZones](each min=Modelica.Constants.eps)
    "Pressure drop at nominal mass flow rate in UFH"
    annotation (Dialog(group="UFH"));
  // Valves
  parameter Real valveAutho[nZones](each min=0.2, each max=0.8, each unit="1") "Assumed valve authority (typical value: 0.5)" annotation(Dialog(group="Thermostatic Valve"));
  parameter Modelica.Units.SI.PressureDifference dpHeaSysValve_nominal[nZones](each min=Modelica.Constants.eps)=
      valveAutho .* (dpUFH_nominal .+ dpHeaSysPreValve_nominal) ./ (1 .- valveAutho)
    "Nominal pressure drop over valve when fully opened at m_flowValve_nominal"
    annotation (Dialog(group="Thermostatic Valve"));
  parameter Boolean use_hydrBalAutom = true "Use automatic hydraluic balancing to set dpHeaSysPreValve_nominal" annotation(Dialog(group="Thermostatic Valve"));
  parameter Modelica.Units.SI.PressureDifference dpHeaSysPreValve_nominal[
    nZones]=if use_hydrBalAutom then max(dpUFH_nominal) .- (dpUFH_nominal)
       else fill(0, nZones)
    "Pressure difference of each branch in heat distribution system as pre set value for valves (hydraulic balance)"
    annotation (Dialog(group="Thermostatic Valve", enable=use_hydrBalAutom));
  parameter Real leakageOpening = 0.0001
    "may be useful for simulation stability. Always check the influence it has on your results" annotation(Dialog(group="Thermostatic Valve"));
  // Pump
  parameter Modelica.Units.SI.MassFlowRate mUFH_flow_nominal[nZones] "Nominal mass flow rate in each radiator";
  parameter Modelica.Units.SI.MassFlowRate mHeaCir_flow_nominal=sum(mUFH_flow_nominal) "Total mass flow rate of heating ciruit";
  final parameter Modelica.Units.SI.Pressure dp_nominal[nZones]=dpUFH_nominal .+ dpHeaSysValve_nominal .+ dpHeaDistr_nominal .+ dpHeaSysPreValve_nominal "Pressure difference array of all parallel radiators";
  final parameter Modelica.Units.SI.Pressure dpPumpHeaCir_nominal = (mHeaCir_flow_nominal / sum({sqrt(mUFH_flow_nominal[i]^2/dp_nominal[i])  for i in 1:nZones}))^2
    "Nominal pressure difference the pump has to achieve for the single heating circuit with multiple parallel radiators";

  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(graphics,
        coordinateSystem(preserveAspectRatio=false)));
end TransferDataBaseDefinition_forUFH;
