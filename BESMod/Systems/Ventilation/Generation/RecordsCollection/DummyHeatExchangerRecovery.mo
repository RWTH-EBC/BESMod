within BESMod.Systems.Ventilation.Generation.RecordsCollection;
record DummyHeatExchangerRecovery "DummyVentilation"
  extends PartialHeatExchangerRecovery(dpHex_nominal(displayUnit="Pa") = 100,
                                                                epsHex=0.8);
  annotation (Documentation(info="<html>
<p>Dummy heat exchanger record for ventilation systems with fixed nominal pressure drop and heat recovery rate. 
</p>
<h4>Important Parameters</h4>
<ul>
  <li>dpHex_nominal = 100 Pa: Nominal pressure drop across heat exchanger</li>
  <li>epsHex = 0.8: Heat recovery rate/effectiveness of the heat exchanger</li>
</ul></html>"));
end DummyHeatExchangerRecovery;
