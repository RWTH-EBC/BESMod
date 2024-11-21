within BESMod.Systems.Hydraulical.Generation.RecordsCollection.HeatPumps;
partial record Generic
  extends Modelica.Icons.Record;
  parameter Modelica.Units.SI.PressureDifference dpCon_nominal
    "Pressure drop at nominal mass flow rate";
  parameter Modelica.Units.SI.Time tauCon=30
    "Condenser heat transfer time constant at nominal flow";
  parameter Boolean use_conCap=false
    "=true if using capacitor model for condenser heat loss estimation";
  parameter Modelica.Units.SI.HeatCapacity CCon=0
    "Heat capacity of the condenser"
    annotation(Dialog(enable=use_conCap));
  parameter Modelica.Units.SI.ThermalConductance GConOut=0
    "Outer thermal conductance for condenser heat loss calculations"
    annotation(Dialog(enable=use_conCap));
  parameter Modelica.Units.SI.ThermalConductance GConIns=0
    "Inner thermal conductance for condenser heat loss calculations"
    annotation(Dialog(enable=use_conCap));
  parameter Modelica.Units.SI.TemperatureDifference dTEva_nominal
    "Nominal temperature difference in evaporator medium, used to calculate mass flow rate";
  parameter Modelica.Units.SI.PressureDifference dpEva_nominal
    "Pressure drop at nominal mass flow rate";
  parameter Modelica.Units.SI.Time tauEva=30
    "Evaporator heat transfer time constant at nominal flow";
  parameter Boolean use_evaCap=false
    "=true if using capacitor model for evaporator heat loss estimation";
  parameter Modelica.Units.SI.HeatCapacity CEva=0
    "Heat capacity of the evaporator"
    annotation(Dialog(enable=use_evaCap));
  parameter Modelica.Units.SI.ThermalConductance GEvaOut=0
    "Outer thermal conductance for evaporator heat loss calculations"
    annotation(Dialog(enable=use_evaCap));
  parameter Modelica.Units.SI.ThermalConductance GEvaIns=0
    "Inner thermal conductance for evaporator heat loss calculations"
    annotation(Dialog(enable=use_evaCap));
  annotation (Documentation(info="<html>
<h4>Information</h4>
<p>Generic parameter record for heat pumps. 
Contains basic parameters describing the condenser and evaporator behavior 
including pressure drops, heat transfer time constants, and optional heat loss calculations 
using a capacitor model approach.</p>
</html>"));
end Generic;
