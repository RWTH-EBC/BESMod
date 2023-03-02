within BESMod.Systems.Hydraulical.Distribution;
model BuildingOnly "Only loads building"
  extends BaseClasses.PartialDistribution(
    use_dhw=false,
    final fFullSto=0,
    final QDHWBefSto_flow_nominal=Modelica.Constants.eps,
    final VStoDHW=0,
    QCrit=0,
    tCrit=0,
    final QDHWStoLoss_flow=0,
    final designType=BESMod.Systems.Hydraulical.Distribution.Types.DHWDesignType.NoStorage,
    QDHW_flow_nominal=Modelica.Constants.eps,
    final dpDem_nominal=fill(0, nParallelDem),
    final dpSup_nominal=fill(0, nParallelSup),
    final nParallelSup=1,
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
  Modelica.Blocks.Sources.RealExpression reaExpTStoBufTopMea(y=
        Medium.temperature(Medium.setState_phX(
        portGen_in[1].p,
        inStream(portGen_in[1].h_outflow),
        inStream(portGen_in[1].Xi_outflow))))
    "Use storage name as all controls use this variable"
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
equation
  connect(zeroLoad.internalElectricalPin, internalElectricalPin) annotation (
      Line(
      points={{50,-98},{70,-98}},
      color={0,0,0},
      thickness=1));
  connect(reaExpTStoBufTopMea.y, sigBusDistr.TStoBufTopMea) annotation (Line(
        points={{-59,10},{0,10},{0,101}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(portGen_out[1], portBui_in[1])
    annotation (Line(points={{-100,40},{100,40}}, color={0,127,255}));
  connect(portGen_in[1], portBui_out[1])
    annotation (Line(points={{-100,80},{100,80}}, color={0,127,255}));
  annotation (Documentation(info="<html>
<p>Generation system directly supplys the building with heat without using storage tanks and no creation of DHW.</p>
</html>"));
end BuildingOnly;
