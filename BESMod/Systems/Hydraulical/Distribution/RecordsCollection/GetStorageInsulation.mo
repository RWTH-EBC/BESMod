within BESMod.Systems.Hydraulical.Distribution.RecordsCollection;
function GetStorageInsulation
  input Modelica.Units.SI.Thickness u "Thickness";
  input Modelica.Units.SI.HeatFlowRate QLoss_flow "Loss per day in W";
  input Modelica.Units.SI.TemperatureDifference dT_loss
    "Temperature spread of loss according to DIN EN 15332";
  input Modelica.Units.SI.CoefficientOfHeatTransfer hConOut
    "Convective heat tranfer on the outside";
  input Modelica.Units.SI.CoefficientOfHeatTransfer hConIn
    "Convective heat tranfer on the inside";
  input Modelica.Units.SI.ThermalConductivity lambda_ins
    "Insulation conductivity";
  input Modelica.Units.SI.Diameter d "Storage diameter";
  input Modelica.Units.SI.Height h "Storage heigth";
  output Real y "Percentage deviation";

algorithm
  y := 1 - dT_loss * (2*Modelica.Constants.pi*h/(1/(hConIn*d/2) + 1/lambda_ins*log((d/2 + u)/(d/2))
         + 1/(hConOut*(d/2 + u))) + 2 * (Modelica.Constants.pi * d ^ 2 / 4 * lambda_ins / u)) / (QLoss_flow);
  annotation (Documentation(info="<html>
<p>
Function to calculate the insulation accuracy of a storage tank. 
The function calculates the percentage deviation between calculated 
heat losses through specified insulation parameters and given heat losses.
</p>
<h4>References</h4>
<ul>
  <li>DIN EN 15332: Heating boilers - Energy assessment of hot water storage systems</li>
</ul>
</html>"));
end GetStorageInsulation;
