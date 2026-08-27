within BESMod.Systems.Ventilation.Generation.RecordsCollection;
record DummyHeatExchangerRecovery "DummyVentilation"
  extends PartialHeatExchangerRecovery(dpHex_nominal(displayUnit="Pa") = 100,
                                                                epsHex=0.8);
end DummyHeatExchangerRecovery;
