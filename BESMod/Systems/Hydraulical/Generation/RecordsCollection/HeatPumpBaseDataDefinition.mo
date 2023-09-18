within BESMod.Systems.Hydraulical.Generation.RecordsCollection;
partial record HeatPumpBaseDataDefinition
  extends Modelica.Icons.Record;

  parameter Modelica.Units.SI.HeatFlowRate QGen_flow_nominal
    "Nominal heating load at outdoor air temperature"
    annotation (Dialog(group="Design"));

  // Temperature Levels
  parameter Modelica.Units.SI.Temperature TOda_nominal
    "Nominal outdoor air temperature" annotation (Dialog(group="Design"));
  parameter Modelica.Units.SI.Temperature TBiv=TOda_nominal
    "Bivalence temperature. Equals TOda_nominal for monovalent systems."
    annotation (Dialog(enable=genDesTyp <> Systems.Hydraulical.Generation.Types.GenerationDesign.Monovalent,
        group="Design"));
  parameter Modelica.Units.SI.Temperature THeaTresh "Heating treshhold"
    annotation (Dialog(group="Design"));
  parameter
    BESMod.Systems.Hydraulical.Generation.Types.GenerationDesign
    genDesTyp "Type of generation system design" annotation (Dialog(
      group="Design"));

  parameter Modelica.Units.SI.HeatFlowRate QPriAtTOdaNom_flow_nominal=0
    "Nominal heat flow rate of primary generation device at 
    nominal outdoor air temperature, required for bivalent parallel design.
    Default of 0 equals a part-parallel design with cut-off equal to TOda_nominal"
    annotation (Dialog(group="Design",
    enable=genDesTyp == Systems.Hydraulical.Generation.Types.GenerationDesign.BivalentParallel));

  parameter Modelica.Units.SI.HeatFlowRate QGenBiv_flow_nominal=
      QGen_flow_nominal*(TBiv - THeaTresh)/(TOda_nominal - THeaTresh)
    "Nominal heat flow rate at bivalence temperature"
    annotation (Dialog(group="Design"));

  parameter Modelica.Units.SI.HeatFlowRate QPri_flow_nominal=if genDesTyp ==
      Systems.Hydraulical.Generation.Types.GenerationDesign.Monovalent then
      QGen_flow_nominal else QGenBiv_flow_nominal
    "Nominal heat flow rate of primary generation component (e.g. heat pump)"
    annotation (Dialog(group="Design"));
  parameter Modelica.Units.SI.HeatFlowRate QSec_flow_nominal=if genDesTyp ==
      Systems.Hydraulical.Generation.Types.GenerationDesign.Monovalent then 0
       elseif genDesTyp == Systems.Hydraulical.Generation.Types.GenerationDesign.BivalentAlternativ
       then QGen_flow_nominal elseif genDesTyp == Systems.Hydraulical.Generation.Types.GenerationDesign.BivalentParallel
       then max(0, QGen_flow_nominal - QPriAtTOdaNom_flow_nominal) else QGen_flow_nominal
    "Nominal heat flow rate of secondary generation component (e.g. auxilliar heater)"
    annotation (Dialog(group="Design"));

  // Generation: Heat Pump
  parameter Real scalingFactor=1 "Scaling-factor of vapour compression machine";
  parameter Modelica.Units.SI.MassFlowRate mEva_flow_nominal=1
    "Mass flow rate through evaporator";
  parameter Modelica.Units.SI.Volume VEva=0.004
    "Manual input of the evaporator volume (if not automatically calculated)";
  parameter Modelica.Units.SI.Volume VCon=0.001
    "Manual input of the condenser volume";
  parameter Modelica.Units.SI.PressureDifference dpCon_nominal=1000
    "Pressure difference";
  parameter Modelica.Units.SI.PressureDifference dpEva_nominal=1000
    "Pressure difference";
   parameter Boolean use_refIne=false
    "Consider the inertia of the refrigerant cycle";
  parameter Modelica.Units.SI.Frequency refIneFre_constant=0
    "Cut off frequency for inertia of refrigerant cycle";
  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(graphics,
        coordinateSystem(preserveAspectRatio=false)));
end HeatPumpBaseDataDefinition;
