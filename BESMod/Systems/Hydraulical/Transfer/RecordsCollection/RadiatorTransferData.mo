within BESMod.Systems.Hydraulical.Transfer.RecordsCollection;
record RadiatorTransferData
  extends Modelica.Icons.Record;

  parameter Integer nEle=5 "Number of elements used in the discretization";
  parameter Real fraRad=0.35 "Fraction radiant heat transfer";
  parameter Real n=1.24 "Exponent for heat transfer";

  annotation (Documentation(info="<html>
<p>Record that contains the basic parameters to define a 
radiator's heat transfer characteristics in
 <a href=\"modelica://BESMod.Systems.Hydraulical.Transfer\">BESMod.Systems.Hydraulical.Transfer</a>.
</p>
</html>"));
end RadiatorTransferData;
