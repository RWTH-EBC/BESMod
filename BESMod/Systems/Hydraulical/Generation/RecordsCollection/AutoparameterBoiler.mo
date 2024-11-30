within BESMod.Systems.Hydraulical.Generation.RecordsCollection;
record AutoparameterBoiler "Boiler with automated sizing"
  extends AixLib.DataBase.Boiler.General.BoilerTwoPointBaseDataDefinition(
    name="Autoscaling based on Vitocal in AixLib",
    volume= 6E-07 * Q_nom,
    a=if Q_nom<=72250 then -103783 * Q_nom + 1E+10 elseif (72250<Q_nom and Q_nom<165750) then 2.76E8 else 9.1132E7,
    Q_min=Q_nom * 0.3,
    eta=[0.3,0.93; 1.0,0.93]);

  annotation (Documentation(info="<html>
<p>All Vitodens boilers have the same Q_min of 30 &percnt; of Q_nom. A linear regression was used to estimate the pressure drop (R2=0,9315) and volume (R2=0,9751). </p>
</html>"));
end AutoparameterBoiler;
