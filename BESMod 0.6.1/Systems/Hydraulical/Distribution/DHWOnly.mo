within BESMod.Systems.Hydraulical.Distribution;
model DHWOnly "only loads DHW"
  extends BaseClasses.PartialDistribution(
    final VStoDHW=0,
    final fFullSto=0,
    final dpDHW_nominal=0,
    final QDHWStoLoss_flow=0,
    final designType=BESMod.Systems.Hydraulical.Distribution.Types.DHWDesignType.NoStorage,
    nParallelDem=1,
    final dpDem_nominal=fill(0, nParallelDem),
    final dpSup_nominal=fill(0, nParallelSup),
    final dTTraDHW_nominal=0,
    final QLoss_flow_nominal=f_design .* Q_flow_nominal .- Q_flow_nominal,
    final f_design=fill(1, nParallelDem),
    final dTLoss_nominal=fill(0, nParallelDem),
    final m_flow_nominal=mSup_flow_nominal,
    final TSup_nominal=TDem_nominal .+ dTLoss_nominal .+ dTTra_nominal,
    redeclare package MediumGen = Medium,
    redeclare package MediumDHW = Medium,
    final dTTra_nominal=fill(0, nParallelDem),
    final nParallelSup=1);
  BESMod.Utilities.Electrical.ZeroLoad zeroLoad
    annotation (Placement(transformation(extent={{24,-108},{44,-88}})));
equation
  connect(portDHW_out, portGen_in[1]) annotation (Line(points={{100,-22},{2,-22},
          {2,80},{-100,80}}, color={0,127,255}));
  connect(portGen_out[1], portDHW_in) annotation (Line(points={{-100,40},{-6,40},
          {-6,-82},{100,-82}}, color={0,127,255}));
  connect(portBui_out, portBui_in) annotation (Line(points={{100,80},{84,80},{
          84,40},{100,40}}, color={0,127,255}));
  connect(zeroLoad.internalElectricalPin, internalElectricalPin) annotation (
      Line(
      points={{44,-98},{56,-98},{56,-96},{70,-96},{70,-98}},
      color={0,0,0},
      thickness=1));
end DHWOnly;
