within BESMod.Systems.Hydraulical.Generation.RecordsCollection;
record AutoparameterBoiler "Boiler with automated sizing"
  extends AixLib.DataBase.Boiler.General.BoilerTwoPointBaseDataDefinition(
    name="Autoscaling based on Viessmann Vitogas 200-F and Vitocrossal 200",
    volume= 6E-07 * Q_nom,
    a=if Q_nom<=72250 then -103783 * Q_nom + 1E+10 elseif (72250<Q_nom and Q_nom<165750) then 2.76E8 else 9.1132E7,
    n=2,
    Q_min=Q_nom * 0.3,
    eta=[0.3,0.93; 1.0,0.93]);
  annotation (Documentation(info="<html>
<p>Automated sizing based on Vitogas 200-F (11-60kW and 72-144kW) and Vitocrossal 200 (82-311kW). </p>
<p>These boilers have the same Q_min of 30 &percnt; of Q_nom. 
The pressure drop coefficent was estimatet with a linear regression for small powers and constant values for medium and high power boliers.
The volume was estimated with a linear regression over the total power range. (See AixLib/Resources/AutoparameterBoiler.xlsx)
Efficency is set to the constant Vitogas 200-F \"Norm-Nutzungsgrad nach DIN 4702-8 TV 75/RV 60 °C\" which is combined with a return temperature based efficency in the boiler model. 
</p>
</html>"));
end AutoparameterBoiler;
