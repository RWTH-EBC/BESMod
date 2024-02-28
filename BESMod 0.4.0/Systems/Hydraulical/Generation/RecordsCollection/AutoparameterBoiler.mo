within BESMod.Systems.Hydraulical.Generation.RecordsCollection;
record AutoparameterBoiler "Boiler with automated sizing"
  extends AixLib.DataBase.Boiler.General.BoilerTwoPointBaseDataDefinition(
    name="Autoscaling based on Vitocal in AixLib",
    volume= 2E-07 * Q_nom + 0.0041,
    pressureDrop=-200983 * Q_nom + 1E+10,
    Q_min=Q_nom * 0.3,
    eta=[0.3,0.93; 1.0,0.93]);
  annotation (Documentation(info="<html>
<p>All Vitodens boilers have the same Q_min of 30 &percnt; of Q_nom. A linear regression was used to estimate the pressure drop (R2=0,9315) and volume (R2=0,9751). </p>
</html>"));
end AutoparameterBoiler;
