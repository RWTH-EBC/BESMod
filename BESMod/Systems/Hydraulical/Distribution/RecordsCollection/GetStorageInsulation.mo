within BESMod.Systems.Hydraulical.Distribution.RecordsCollection;
function GetStorageInsulation
  input Modelica.SIunits.Thickness u "Thickness";
  input Modelica.SIunits.HeatFlowRate QLoss_flow "Loss per day in W";
  input Modelica.SIunits.TemperatureDifference dT_loss "Temperature spread of loss according to DIN EN 15332";
  input Modelica.SIunits.CoefficientOfHeatTransfer hConOut "Convective heat tranfer on the outside";
  input Modelica.SIunits.CoefficientOfHeatTransfer hConIn "Convective heat tranfer on the inside";
  input Modelica.SIunits.ThermalConductivity lambda_ins "Insulation conductivity";
  input Modelica.SIunits.Diameter d "Storage diameter";
  input Modelica.SIunits.Height h "Storage heigth";
  output Real y "Percentage deviation";

algorithm
  y := 1 - dT_loss * (2*Modelica.Constants.pi*h/(1/(hConIn*d/2) + 1/lambda_ins*log((d/2 + u)/(d/2))
         + 1/(hConOut*(d/2 + u))) + 2 * (Modelica.Constants.pi * d ^ 2 / 4 * lambda_ins / u)) / (QLoss_flow);
end GetStorageInsulation;
