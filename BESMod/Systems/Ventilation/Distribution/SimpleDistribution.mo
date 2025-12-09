within BESMod.Systems.Ventilation.Distribution;
model SimpleDistribution "Most basic distribution model"
  extends BaseClasses.PartialDistribution(
    final QLoss_flow_nominal=f_design .* Q_flow_nominal .- Q_flow_nominal,
    final f_design=fill(1, nParallelDem),
    final dTLoss_nominal=fill(0, nParallelDem),
    final dTTra_nominal=fill(0, nParallelDem),
    final nParallelSup=1);
  replaceable parameter BESMod.Systems.RecordsCollection.Movers.SpeedControlled fanData
    constrainedby BESMod.Systems.RecordsCollection.Movers.MoverBaseDataDefinition
    annotation (Placement(transformation(extent={{52,-12},{72,8}})),
      choicesAllMatching=true);

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
  BESMod.Systems.Hydraulical.Components.PreconfiguredControlledMovers.PreconfiguredDPControlled fanRet(
    redeclare final package Medium = Medium,
    final externalCtrlTyp=fanData.externalCtrlTyp,
    final ctrlType=fanData.ctrlType,
    final dpVarBase_nominal=fanData.dpVarBase_nominal,
    final energyDynamics=energyDynamics,
    final p_start=p_start,
    final T_start=T_start,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=mSup_flow_design[1],
    final dp_nominal=dpSup_nominal[1] / 2 + resExh[1].dp_nominal,
    final addPowerToMedium=fanData.addPowerToMedium,
    final use_riseTime=fanData.use_riseTime,
    final riseTime=fanData.riseTime,
    final y_start=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={50,-60})));
  BESMod.Systems.Hydraulical.Components.PreconfiguredControlledMovers.PreconfiguredDPControlled fanFlow(
    redeclare final package Medium = Medium,
    final externalCtrlTyp=fanData.externalCtrlTyp,
    final ctrlType=fanData.ctrlType,
    final dpVarBase_nominal=fanData.dpVarBase_nominal,
    final energyDynamics=energyDynamics,
    final p_start=p_start,
    final T_start=T_start,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=mSup_flow_design[1],
    final dp_nominal=dpSup_nominal[1]/2 + resSup[1].dp_nominal,
    final addPowerToMedium=fanData.addPowerToMedium,
    final use_riseTime=fanData.use_riseTime,
    final riseTime=fanData.riseTime,
    final y_start=1) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={50,60})));

  Modelica.Blocks.Sources.Constant yFan(k=1)
    "Transform Volume l to massflowrate" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={10,10})));
  Modelica.Blocks.Math.Add add
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
  BESMod.Utilities.Electrical.RealToElecCon        realToElecCon(use_souGen=false)
    annotation (Placement(transformation(extent={{-20,-30},{0,-10}})));

equation
  connect(resExh.port_a, portExh_in)
    annotation (Line(points={{-7,-60},{-100,-60}}, color={0,127,255}));
  for i in 1:nParallelDem loop
  connect(fanRet.port_a, resExh[i].port_b) annotation (Line(points={{40,-60},{8,
            -60}},                color={0,127,255}));
  connect(fanFlow.port_b, resSup[i].port_a) annotation (Line(points={{40,60},{8,
            60}},              color={0,127,255}));

  end for;
  connect(resSup.port_b, portSupply_out)
    annotation (Line(points={{-7,60},{-100,60}}, color={0,127,255}));
  connect(fanFlow.port_a, portSupply_in[1]) annotation (Line(points={{60,60},{100,
          60}},                  color={0,127,255}));
  connect(fanRet.port_b, portExh_out[1]) annotation (Line(points={{60,-60},{100,
          -60}},               color={0,127,255}));
  connect(yFan.y, fanFlow.y)
    annotation (Line(points={{21,10},{36,10},{36,82},{50,82},{50,72}},
                                                            color={0,0,127}));
  connect(yFan.y, fanRet.y) annotation (Line(points={{21,10},{46,10},{46,-40},{50,
          -40},{50,-48}},            color={0,0,127}));
  connect(add.y,realToElecCon. PEleLoa)
    annotation (Line(points={{-39,-10},{-32,-10},{-32,-16},{-22,-16}},
                                                   color={0,0,127}));
  connect(fanFlow.P, add.u1) annotation (Line(points={{39,66},{39,72},{30,72},{30,
          26},{-62,26},{-62,-4}}, color={0,0,127}));
  connect(fanRet.P, add.u2) annotation (Line(points={{61,-54},{64,-54},{64,-38},
          {-62,-38},{-62,-16}}, color={0,0,127}));
  connect(realToElecCon.internalElectricalPin, internalElectricalPin)
    annotation (Line(
      points={{0.2,-19.8},{70,-19.8},{70,-98}},
      color={0,0,0},
      thickness=1));
end SimpleDistribution;
