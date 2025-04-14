within BESMod.Systems.Hydraulical.Transfer.RecordsCollection;
record RadiatorTransferData
  extends Modelica.Icons.Record;

  parameter Integer nEle=5 "Number of elements used in the discretization";
  parameter Real fraRad=0.35 "Fraction radiant heat transfer";
  parameter Real n=1.24 "Exponent for heat transfer";
  parameter Real perPreLosRad(min=Modelica.Constants.eps)=0.05
    "Percentage of pressure loss in radiator relative to overall pressure loss";

end RadiatorTransferData;
