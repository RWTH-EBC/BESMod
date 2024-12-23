within BESMod.Systems.Ventilation.Distribution;
model SimpleDistribution "Most basic distribution model"
  extends BaseClasses.PartialDistribution(
    final QLoss_flow_nominal=f_design .* Q_flow_nominal .- Q_flow_nominal,
    final f_design=fill(1, nParallelDem),
    final dTLoss_nominal=fill(0, nParallelDem),
    final dTTra_nominal=fill(0, nParallelDem),
    final nParallelSup=1);
  IBPSA.Fluid.FixedResistances.PressureDrop resSup[nParallelDem](
    redeclare final package Medium = Medium,
    each final dp_nominal=100,
    final m_flow_nominal=mDem_flow_nominal)
    "Hydraulic resistance of supply" annotation (Placement(transformation(
        extent={{-7.5,-10},{7.5,10}},
        rotation=180,
        origin={0.5,60})));
  IBPSA.Fluid.FixedResistances.PressureDrop resExh[nParallelDem](
    redeclare final package Medium = Medium,
    each final dp_nominal=100,
    final m_flow_nominal=mDem_flow_nominal)
    "Hydraulic resistance of exhaust" annotation (Placement(transformation(
        extent={{-7.5,-10},{7.5,10}},
        rotation=0,
        origin={0.5,-60})));
  BESMod.Utilities.Electrical.ZeroLoad zeroLoad
    annotation (Placement(transformation(extent={{20,-100},{40,-80}})));
equation
  connect(resExh.port_a, portExh_in)
    annotation (Line(points={{-7,-60},{-100,-60}}, color={0,127,255}));
  for i in 1:nParallelDem loop
    connect(resSup[i].port_a, portSupply_in[1]) annotation (Line(points={{8,60},{56,60},
          {56,60},{100,60}}, color={0,127,255}));
    connect(resExh[i].port_b, portExh_out[1]) annotation (Line(points={{8,-60},{54,-60},
          {54,-60},{100,-60}}, color={0,127,255}));
  end for;
  connect(resSup.port_b, portSupply_out)
    annotation (Line(points={{-7,60},{-100,60}}, color={0,127,255}));
  connect(zeroLoad.internalElectricalPin, internalElectricalPin) annotation (
      Line(
      points={{40,-90},{56,-90},{56,-84},{70,-84},{70,-98}},
      color={0,0,0},
      thickness=1));
end SimpleDistribution;
