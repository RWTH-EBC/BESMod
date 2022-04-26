within BESMod.Systems.Ventilation.Generation;
model NoVentilation "Model without any ventilation"
  extends BaseClasses.PartialGeneration(
    final QLoss_flow_nominal={0},
    final f_design={1},
    final dTLoss_nominal={0},
    final m_flow_nominal={0},
    final TSup_nominal=TDem_nominal,
    final dp_nominal={0},
    final dTTra_nominal={0},
    final nParallelSup=1,
    final nParallelDem=1);
  Utilities.Electrical.ZeroLoad zeroLoad
    annotation (Placement(transformation(extent={{20,-100},{40,-80}})));
equation
  connect(portVent_in, portVent_out) annotation (Line(points={{-100,42},{-80,42},
          {-80,-40},{-100,-40}}, color={0,127,255}));
  connect(zeroLoad.internalElectricalPin, internalElectricalPin) annotation (
      Line(
      points={{40,-90},{56,-90},{56,-84},{70,-84},{70,-98}},
      color={0,0,0},
      thickness=1));
end NoVentilation;
