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
  Modelica.Blocks.Sources.RealExpression NoElectricalLoad
    annotation (Placement(transformation(extent={{2,-104},{22,-84}})));
  Utilities.Electrical.RealToElecCon realToElecCon
    annotation (Placement(transformation(extent={{32,-104},{52,-84}})));
equation
  connect(portVent_in, portVent_out) annotation (Line(points={{-100,42},{-80,42},
          {-80,-40},{-100,-40}}, color={0,127,255}));
  connect(NoElectricalLoad.y, realToElecCon.PElec)
    annotation (Line(points={{23,-94},{31.4,-94}}, color={0,0,127}));
  connect(realToElecCon.internalElectricalPin, internalElectricalPin)
    annotation (Line(
      points={{52.2,-93.8},{58.1,-93.8},{58.1,-98},{70,-98}},
      color={0,0,0},
      thickness=1));
end NoVentilation;
