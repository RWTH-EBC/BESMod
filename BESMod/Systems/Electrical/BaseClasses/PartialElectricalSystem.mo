within BESMod.Systems.Electrical.BaseClasses;
partial model PartialElectricalSystem "Partial model for electrical system"
  parameter Boolean use_openModelica=false
    "=true to disable features which 
    are not available in open modelica" annotation(Dialog(tab="Advanced"));
  parameter Integer nLoadsExtSubSys(min=1) = 4 "Number of external subsystems which result in electrical load / generation";
  parameter Boolean use_elecHeating=true "=false to disable electric heating";
  replaceable parameter RecordsCollection.ElectricalSystemBaseDataDefinition
    electricalSystemParameters constrainedby
    RecordsCollection.ElectricalSystemBaseDataDefinition annotation (Placement(
        transformation(extent={{-180,-100},{-160,-80}})), choicesAllMatching=true);

  replaceable Distribution.BaseClasses.PartialDistribution distribution
    constrainedby Distribution.BaseClasses.PartialDistribution(nSubSys=
        nLoadsExtSubSys + 2,
    final use_openModelica=use_openModelica)
    annotation (choicesAllMatching=true, Placement(transformation(extent={{-40,
            -102},{52,36}})));
  replaceable Generation.BaseClasses.PartialGeneration generation
    constrainedby
    BESMod.Systems.Electrical.Generation.BaseClasses.PartialGeneration(
    final use_openModelica=use_openModelica)
    annotation (choicesAllMatching=true, Placement(transformation(extent={{-148,
            -102},{-62,36}})));
  AixLib.BoundaryConditions.WeatherData.Bus weaBus annotation (Placement(
        transformation(extent={{-200,24},{-160,66}}), iconTransformation(extent=
           {{-200,24},{-160,66}})));
  replaceable Transfer.BaseClasses.PartialTransfer transfer if use_elecHeating constrainedby
    Transfer.BaseClasses.PartialTransfer(final nParallelDem=
        electricalSystemParameters.nZones,
    final use_openModelica=use_openModelica)
    annotation (choicesAllMatching=true, Placement(transformation(extent={{68,-102},
            {144,36}})));
  replaceable Control.BaseClasses.PartialControl control constrainedby
    BESMod.Systems.Electrical.Control.BaseClasses.PartialControl(
    final use_openModelica=use_openModelica)
    annotation (choicesAllMatching=true, Placement(transformation(extent={{-146,
            56},{142,106}})));
  Interfaces.InternalElectricalPinIn internalElectricalPin[nLoadsExtSubSys]
    annotation (Placement(transformation(extent={{-190,78},{-170,98}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPortCon[
    electricalSystemParameters.nZones] if use_elecHeating
    "Heat port for convective heat transfer with room air temperature"
    annotation (Placement(transformation(extent={{152,4},{172,24}}),
        iconTransformation(extent={{152,4},{172,24}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPortRad[
    electricalSystemParameters.nZones] if use_elecHeating
    "Heat port for radiative heat transfer with room air temperature"
    annotation (Placement(transformation(extent={{152,-70},{172,-50}})));
  BESMod.Systems.Interfaces.UseProBus useProBus annotation (
      Placement(transformation(extent={{-120,120},{-74,156}}),
        iconTransformation(extent={{-120,120},{-74,156}})));
  BESMod.Systems.Interfaces.BuiMeaBus buiMeaBus annotation (
      Placement(transformation(extent={{48,124},{92,156}}), iconTransformation(
          extent={{48,124},{92,156}})));
  BESMod.Systems.Interfaces.ElectricalOutputs outBusElect
    if not use_openModelica
    annotation (Placement(transformation(extent={{-22,-160},{24,-120}}),
        iconTransformation(extent={{-22,-160},{24,-120}})));
  Interfaces.ExternalElectricalPin externalElectricalPin1
    annotation (Placement(transformation(extent={{152,80},{172,100}})));
  Interfaces.SystemControlBus systemControlBus annotation (Placement(
        transformation(extent={{-26,122},{20,160}}), iconTransformation(extent={
            {-26,122},{20,160}})));
protected
  BESMod.Utilities.Electrical.ZeroLoad zeroTraLoad if not use_elecHeating
    "Internal helper";
equation
  connect(generation.weaBus, weaBus) annotation (Line(
      points={{-148,19.44},{-162,19.44},{-162,42},{-180,42},{-180,45}},
      color={255,204,51},
      thickness=0.5));
  connect(control.generationControlBus, generation.controlBusGen) annotation (
      Line(
      points={{-104,56.5},{-104.57,56.5},{-104.57,34.62}},
      color={215,215,215},
      thickness=0.5));
  connect(control.distributionControlBus, distribution.sigBusDistr) annotation (
     Line(
      points={{4.6,56.25},{4.6,43.125},{6.46,43.125},{6.46,32.55}},
      color={215,215,215},
      thickness=0.5));

  connect(weaBus, control.weaBus) annotation (Line(
      points={{-180,45},{-180,42},{-162,42},{-162,86},{-146,86},{-146,85.5}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  connect(control.useProBus, useProBus) annotation (Line(
      points={{-69.8,106.5},{-69.8,123.25},{-97,123.25},{-97,138}},
      color={0,127,0},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(control.buiMeaBus, buiMeaBus) annotation (Line(
      points={{37,106.75},{37,124.375},{70,124.375},{70,140}},
      color={255,128,0},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(distribution.OutputDistr, outBusElect.dis) annotation (Line(
      points={{6,-100.62},{4,-100.62},{4,-140},{1,-140}},
      color={175,175,175},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));

  connect(generation.outBusGen, outBusElect.gen) annotation (Line(
      points={{-105,-101.31},{-105,-140},{1,-140}},
      color={175,175,175},
      thickness=0.5));
  connect(distribution.externalElectricalPin, externalElectricalPin1)
    annotation (Line(
      points={{29,-100.62},{28,-100.62},{28,-110},{62,-110},{62,50},{152,50},{
          152,78},{150,78},{150,90},{162,90}},
      color={0,0,0},
      thickness=1));
  connect(control.systemControlBus, systemControlBus) annotation (Line(
      points={{-2,106},{-2,141},{-3,141}},
      color={215,215,215},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(generation.internalElectricalPin, distribution.internalElectricalPin[2])
    annotation (Line(
      points={{-83.5,34.62},{-83.5,46},{29,46},{29,36}},
      color={0,0,0},
      thickness=1));
  for i in 1:nLoadsExtSubSys loop
   connect(internalElectricalPin[i], distribution.internalElectricalPin[2+i])
    annotation (Line(
      points={{-180,88},{-180,86},{-166,86},{-166,46},{30,46},{30,42},{29,42},{
            29,36}},
      color={0,0,0},
      thickness=1));
  end for;
  if use_elecHeating then
    connect(heatPortCon, transfer.heatPortCon) annotation (Line(points={{162,14},{
          162,-6},{144,-6},{144,-5.4}}, color={191,0,0}));
    connect(heatPortRad, transfer.heatPortRad) annotation (Line(points={{162,-60},
          {164,-60},{164,-38.52},{144,-38.52}}, color={191,0,0}));
    connect(control.transferControlBus, transfer.transferControlBus) annotation (
      Line(
      points={{104.2,56.25},{104.2,45.125},{106,45.125},{106,34.62}},
      color={215,215,215},
      thickness=0.5));
    connect(transfer.transferOutputs, outBusElect.tra) annotation (Line(
        points={{106,-101.31},{106,-140},{1,-140}},
        color={175,175,175},
        thickness=0.5), Text(
        string="%second",
        index=1,
        extent={{-3,-6},{-3,-6}},
        horizontalAlignment=TextAlignment.Right));
    connect(transfer.internalElectricalPin, distribution.internalElectricalPin[1])
    annotation (Line(
      points={{124.24,36},{124,36},{124,46},{29,46},{29,36}},
      color={0,0,0},
      thickness=1));
  else
    connect(zeroTraLoad.internalElectricalPin, distribution.internalElectricalPin[1]);
  end if;
  connect(control.controlOutputs, outBusElect.ctrl) annotation (Line(
      points={{141.4,81.25},{141.4,-24},{142,-24},{142,-130},{1,-130},{1,-140}},
      color={175,175,175},
      thickness=0.5));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-180,-140},
            {160,140}}), graphics={
        Rectangle(
          extent={{-180,140},{162,-140}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-36,104}},
          color={0,0,0},
          thickness=1,
          arrow={Arrow.None,Arrow.Filled}),
        Line(
          points={{-20,96},{-60,-20},{2,-20},{-16,-100},{80,14},{4,12},{30,96},
              {-20,96}},
          color={0,0,0},
          thickness=1),       Text(
          extent={{-98,-134},{106,-230}},
          lineColor={0,0,0},
          textString="%name%")}),                                Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-180,-140},{160,140}})));
end PartialElectricalSystem;
