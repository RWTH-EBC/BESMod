within BESMod.Systems.Electrical.Distribution.BaseClasses;
partial model PartialDistribution
  parameter Boolean use_openModelica=false
    "=true to disable features which 
    are not available in open modelica" annotation(Dialog(tab="Advanced"));
  parameter Integer nSubSys(min=2)
    "Number of subsystems with electrical load / generation";
  Interfaces.DistributionOutputs OutputDistr if not use_openModelica
                                             annotation (Placement(
        transformation(extent={{-10,-108},{10,-88}}), iconTransformation(extent=
           {{-10,-108},{10,-88}})));
  Interfaces.DistributionControlBus sigBusDistr annotation (Placement(
        transformation(extent={{-16,78},{18,112}}), iconTransformation(extent={{
            -16,78},{18,112}})));
  Interfaces.InternalElectricalPinIn internalElectricalPin[nSubSys]
    annotation (Placement(transformation(extent={{40,90},{60,110}})));
  Interfaces.ExternalElectricalPin externalElectricalPin
    annotation (Placement(transformation(extent={{40,-108},{60,-88}})));
  Utilities.KPIs.EnergyKPICalculator eneKPILoa(final use_inpCon=true)
    "Load on grid" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-30,-60})));
  Utilities.Electrical.ElecConToReal elecConToReal annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={10,-70})));
  Utilities.KPIs.EnergyKPICalculator eneKPIGen "Load on grid" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-30,-80})));
equation
  connect(elecConToReal.internalElectricalPin, externalElectricalPin)
    annotation (Line(
      points={{19.8,-70.2},{50,-70.2},{50,-98}},
      color={0,0,0},
      thickness=1));
  connect(eneKPILoa.u, elecConToReal.PElecGen) annotation (Line(points={{-18.2,
          -60},{-10,-60},{-10,-66},{-2,-66}}, color={0,0,127}));
  connect(elecConToReal.PElecLoa, eneKPIGen.u) annotation (Line(points={{-2,-74},
          {-4,-74},{-4,-72},{-8,-72},{-8,-80},{-18.2,-80}}, color={0,0,127}));
  connect(eneKPIGen.KPI, OutputDistr.PEleGen) annotation (Line(points={{-42.2,
          -80},{-64,-80},{-64,-98},{0,-98}}, color={135,135,135}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(eneKPILoa.KPI, OutputDistr.PEleLoa) annotation (Line(points={{-42.2,
          -60},{-64,-60},{-64,-98},{0,-98}}, color={135,135,135}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
                              Text(
          extent={{-100,-74},{104,-170}},
          lineColor={0,0,0},
          textString="%name%"),
        Rectangle(
          extent={{-60,34},{66,-42}},
          lineColor={0,0,0},
          lineThickness=1,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{28,14},{40,-24}},
          lineThickness=1,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-6,19},{6,-19}},
          lineThickness=1,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={33,-6},
          rotation=-90,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-6,19},{6,-19}},
          lineThickness=1,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={-25,-6},
          rotation=-90,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-46,54},{-24,40}},
          pattern=LinePattern.None,
          lineThickness=1,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Rectangle(
          extent={{24,54},{46,40}},
          pattern=LinePattern.None,
          lineThickness=1,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0})}),                                  Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialDistribution;
