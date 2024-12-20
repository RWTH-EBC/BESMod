within BESMod.Systems.Hydraulical.Distribution;
model DHWOnly "Only loads DHW"
  extends BaseClasses.PartialDistribution(
    final VStoDHW=0,
    final fFullSto=0,
    final dpDHW_nominal=0,
    final QDHWStoLoss_flow=0,
    final designType=BESMod.Systems.Hydraulical.Distribution.Types.DHWDesignType.NoStorage,
    nParallelDem=1,
    final dTTraDHW_nominal=0,
    final QLoss_flow_nominal=f_design .* Q_flow_nominal .- Q_flow_nominal,
    final f_design=fill(1, nParallelDem),
    final dTLoss_nominal=fill(0, nParallelDem),
    final TSup_nominal=TDem_nominal .+ dTLoss_nominal .+ dTTra_nominal,
    redeclare package MediumGen = Medium,
    redeclare package MediumDHW = Medium,
    final dTTra_nominal=fill(0, nParallelDem),
    final nParallelSup=1);
  replaceable parameter
    BESMod.Systems.RecordsCollection.Movers.MoverBaseDataDefinition parPum
    "Parameters for pump" annotation (
    Dialog(group="Component data"),
    choicesAllMatching=true,
    Placement(transformation(extent={{-76,4},{-62,16}})));
  IBPSA.Fluid.Sources.Boundary_pT bouTra(
    redeclare package Medium = Medium,
    final p=p_start,
    final T=T_start,
    final nPorts=1)
    "Pressure boundary for disabled transfer system to avoid singularity"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={50,40})));
  Utilities.Electrical.ZeroLoad             zeroLoad
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={50,-70})));
equation
  connect(portDHW_out, portGen_in[1]) annotation (Line(points={{100,-22},{2,-22},
          {2,80},{-100,80}}, color={0,127,255}));
  connect(portBui_out, portBui_in) annotation (Line(points={{100,80},{84,80},{
          84,40},{100,40}}, color={0,127,255}));
  connect(portBui_in[1], bouTra.ports[1])
    annotation (Line(points={{100,40},{60,40}}, color={0,127,255}));
  connect(portGen_out[1], portDHW_in) annotation (Line(points={{-100,40},{-12,40},
          {-12,-82},{100,-82}}, color={0,127,255}));
  connect(zeroLoad.internalElectricalPin, internalElectricalPin) annotation (
      Line(
      points={{60,-70},{66,-70},{66,-84},{70,-84},{70,-98}},
      color={0,0,0},
      thickness=1));
end DHWOnly;
