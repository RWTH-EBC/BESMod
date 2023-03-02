within BESMod.Systems.Ventilation;
model NoVentilation
  extends BaseClasses.PartialVentilationSystem(redeclare BESMod.Systems.Ventilation.Generation.NoVentilation generation, redeclare BESMod.Systems.Ventilation.Distribution.SimpleDistribution distribution(
        m_flow_nominal={1}),                                                                                                                                                                                                        redeclare BESMod.Systems.Ventilation.Control.NoControl control);
  annotation (Documentation(info="<html>
<p>This class is meant to be selected, when no ventilation system is needed.</p>
</html>"));
end NoVentilation;
