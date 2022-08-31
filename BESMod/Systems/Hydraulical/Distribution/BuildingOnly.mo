within BESMod.Systems.Hydraulical.Distribution;
model BuildingOnly "Only loads building"
  extends BaseClasses.PartialDistribution(
    VStoDHW=0,
    QCrit=0,
    tCrit=0,
    QDHWStoLoss_flow=0,
    designType=BESMod.Systems.Hydraulical.Distribution.Types.DHWDesignType.NoStorage,

    QDHW_flow_nominal=0,
    final dpDem_nominal=fill(0, nParallelDem),
    final dpSup_nominal=fill(0, nParallelSup),
    final nParallelSup=nParallelDem,
    final dTTraDHW_nominal=0,
    final QLoss_flow_nominal=f_design .* Q_flow_nominal .- Q_flow_nominal,
    final f_design=fill(1, nParallelDem),
    final dTLoss_nominal=fill(0, nParallelDem),
    final m_flow_nominal=mSup_flow_nominal,
    final TSup_nominal=TDem_nominal .+ dTLoss_nominal .+ dTTra_nominal,
    redeclare package MediumGen = Medium,
    redeclare package MediumDHW = Medium,
    final dTTra_nominal=fill(0, nParallelDem));
  BESMod.Utilities.Electrical.ZeroLoad zeroLoad
    annotation (Placement(transformation(extent={{30,-108},{50,-88}})));
equation
  connect(portDHW_out, portDHW_in) annotation (Line(points={{100,-22},{88,-22},{
          88,-16},{76,-16},{76,-82},{100,-82}}, color={0,127,255}));
  connect(portGen_in, portBui_out)
    annotation (Line(points={{-100,80},{0,80},{0,80},{100,80}},
                                                  color={0,127,255}));
  connect(portGen_out, portBui_in)
    annotation (Line(points={{-100,40},{0,40},{0,40},{100,40}},
                                                  color={0,127,255}));
  connect(zeroLoad.internalElectricalPin, internalElectricalPin) annotation (
      Line(
      points={{50,-98},{70,-98}},
      color={0,0,0},
      thickness=1));
end BuildingOnly;
