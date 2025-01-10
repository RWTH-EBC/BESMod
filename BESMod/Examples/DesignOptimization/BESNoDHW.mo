within BESMod.Examples.DesignOptimization;
model BESNoDHW "Example to demonstrate usage without DHW"
  extends BES(systemParameters(use_dhw=false), DHW(redeclare
        BESMod.Systems.Demand.DHW.RecordsCollection.NoDHW DHWProfile));

  extends Modelica.Icons.Example;

  annotation (experiment(StopTime=172800,
     Interval=600,
     Tolerance=1e-06),
   __Dymola_Commands(file="modelica://BESMod/Resources/Scripts/Dymola/Examples/DesignOptimization/BESNoDHW.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>In this case, DHW is disabled which is currently only supported for the distribution systems X and Y. However, you can create your own distribution modules if this is a relevant use case for you. </p>
<p>As Modelica does not allow conditional variables outside of connect and the DHW parameters are used as bottom-up and top-down, this workaround is needed.</p>
</html>"));
end BESNoDHW;
