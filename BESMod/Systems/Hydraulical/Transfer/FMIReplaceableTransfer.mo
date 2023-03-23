within BESMod.Systems.Hydraulical.Transfer;
model FMIReplaceableTransfer
  "FMI export container for hydraulic transfer models"
  extends BESMod.Utilities.FMI.PartialHeatPorts(
    final nHeatPorts=transfer.nParallelDem);

  replaceable package Medium =
    Modelica.Media.Interfaces.PartialMedium
      constrainedby Modelica.Media.Interfaces.PartialMedium
                                            "Medium in the building"
                                            annotation (
      __Dymola_choicesAllMatching=true);
  parameter Boolean allowFlowReversal = transfer.allowFlowReversal
    "= true to allow flow reversal, false restricts to design direction (inlet -> outlet)
    Adds an input to specify the Temperatur of the backwards flow."
    annotation(Dialog(tab="Assumptions"), Evaluate=true);

  parameter Boolean use_p_in=true
    "= true to use a pressure from connector, false to output Medium.p_default"
    annotation(Evaluate=true);

  parameter Boolean use_p_ref=true
    "= true to set a reference pressure at transfer.portTra_in.";

  replaceable BaseClasses.PartialTransfer transfer
    constrainedby
    BESMod.Systems.Hydraulical.Transfer.BaseClasses.PartialTransfer(
      redeclare final package Medium=Medium)
    annotation (Placement(transformation(extent={{-30,-30},{30,32}})));
  IBPSA.Fluid.FMI.Adaptors.Inlet bouInlTra[transfer.nParallelSup](
    redeclare each final package Medium = Medium,
    each final allowFlowReversal=allowFlowReversal,
    each final use_p_in=use_p_in and not use_p_ref)
    annotation (Placement(transformation(extent={{-70,20},{-50,40}})));
  IBPSA.Fluid.FMI.Adaptors.Outlet bouOutTra[transfer.nParallelSup](
    redeclare each final package Medium = Medium,
    each final allowFlowReversal=allowFlowReversal,
    each final use_p_in=use_p_in and not use_p_ref)
    annotation (Placement(transformation(extent={{-50,-20},{-70,-40}})));
  IBPSA.Fluid.FMI.Interfaces.Inlet portTra_in[transfer.nParallelSup](
    redeclare each final package Medium = Medium,
    each final allowFlowReversal=allowFlowReversal,
    each final use_p_in=use_p_in and not use_p_ref)
    annotation (Placement(transformation(extent={{-120,20},{-100,40}})));
  IBPSA.Fluid.FMI.Interfaces.Outlet portTra_out[transfer.nParallelSup](
    redeclare each final package Medium = Medium,
    each final allowFlowReversal=allowFlowReversal,
    each final use_p_in=use_p_in and not use_p_ref)
    annotation (Placement(transformation(extent={{-100,-40},{-120,-20}})));

  Modelica.Blocks.Math.Feedback pOutTra[transfer.nParallelSup] if use_p_in  and not use_p_ref
    "Pressure at component outlet" annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=270,
        origin={-60,0})));

    Modelica.Blocks.Sources.RealExpression dpTra[transfer.nParallelSup](y=
        transfer.portTra_in.p-transfer.portTra_out.p) if use_p_in  and not use_p_ref
    "Pressure drop of the component"
    annotation (Placement(transformation(extent={{-96,-10},{-76,10}})));


  Interfaces.TransferOutputs outBusTra
    annotation (Placement(transformation(extent={{-40,-114},{-20,-94}})));
  Electrical.Interfaces.InternalElectricalPinOut internalElectricalPin1
    annotation (Placement(transformation(extent={{26,-112},{46,-92}})));
  IBPSA.Fluid.Sources.Boundary_pT bou_ref[transfer.nParallelSup](
    each final use_p_in=use_p_in,
    each final nPorts=1,
    redeclare final package Medium = Medium) if use_p_ref annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-30,68}), visible=use_p_ref));
  input Interfaces.TransferControlBus traControlBus
    annotation (Placement(transformation(extent={{-8,92},{12,112}})));
  Modelica.Blocks.Interfaces.RealInput p_ref_in[size(bou_ref, 1)]
    if use_p_ref and use_p_in "Prescribed boundary pressure" annotation (
      Placement(transformation(extent={{-136,66},{-96,106}}), visible=use_p_in
           and use_p_ref));
    Modelica.Blocks.Sources.RealExpression portTra_out_p[transfer.nParallelSup](
     y=transfer.portTra_out.p) if use_p_ref and use_p_in
    "Output pressure component"
    annotation (Placement(transformation(extent={{-58,-70},{-78,-50}}), visible
        =use_p_in and use_p_ref));
  Modelica.Blocks.Interfaces.RealOutput p_out[size(portTra_out_p, 1)]
    "Pressure output of the System" annotation (Placement(
      transformation(extent={{-100,-76},{-132,-44}}),
      iconTransformation(extent={{-100,-76},{-132,-44}}),
      visible=use_p_in and use_p_ref));
equation
  connect(portTra_in, bouInlTra.inlet)
    annotation (Line(points={{-110,30},{-71,30}}, color={0,0,255}));
  connect(bouOutTra.outlet, portTra_out)
    annotation (Line(points={{-71,-30},{-110,-30}}, color={0,0,255}));
  connect(bouOutTra.port_a, transfer.portTra_out) annotation (Line(points={{-50,
          -30},{-38,-30},{-38,-12.02},{-30,-12.02}}, color={0,127,255}));
  connect(heatPortRad_QtoT.heatPort, transfer.heatPortRad) annotation (Line(
        points={{58,-30},{44,-30},{44,-10},{30,-10},{30,-11.4}}, color={191,0,0}));

  connect(heatPortRad_TtoQ.heatPort, transfer.heatPortRad) annotation (Line(
        points={{58,-30},{44,-30},{44,-10},{32,-10},{32,-11.4},{30,-11.4}},
        color={191,0,0}));
  connect(transfer.heatPortCon, heatPortCon_TtoQ.heatPort) annotation (Line(
        points={{30,13.4},{30,12},{44,12},{44,30},{58,30}}, color={191,0,0}));
  connect(transfer.heatPortCon, heatPortCon_QtoT.heatPort) annotation (Line(
        points={{30,13.4},{30,12},{44,12},{44,30},{58,30}}, color={191,0,0}));
  connect(transfer.outBusTra, outBusTra) annotation (Line(
      points={{0,-31.24},{-30,-31.24},{-30,-104}},
      color={255,204,51},
      thickness=0.5));
  connect(transfer.internalElectricalPin, internalElectricalPin1) annotation (
      Line(
      points={{21.6,-29.38},{36,-29.38},{36,-102}},
      color={0,0,0},
      thickness=1));
  connect(bouInlTra.port_b, transfer.portTra_in) annotation (Line(points={{-50,
          30},{-38,30},{-38,13.4},{-30,13.4}}, color={0,127,255}));
  connect(transfer.portTra_in, bou_ref.ports[1]);
  connect(bouInlTra.p, pOutTra.u1)
    annotation (Line(points={{-60,19},{-60,4.8}}, color={0,127,127}));
  connect(dpTra.y, pOutTra.u2) annotation (Line(points={{-75,0},{-69.9,0},{-69.9,
          8.88178e-16},{-64.8,8.88178e-16}}, color={0,0,127}));
  connect(pOutTra.y, bouOutTra.p)
    annotation (Line(points={{-60,-5.4},{-60,-18}}, color={0,0,127}));
  connect(transfer.traControlBus, traControlBus) annotation (Line(
      points={{0,32},{2,32},{2,102}},
      color={255,204,51},
      thickness=0.5));
  connect(bou_ref.p_in, p_ref_in) annotation (Line(
      points={{-22,80},{-22,86},{-116,86}},
      color={0,0,127},
      visible=use_p_in and use_p_ref));
  connect(portTra_out_p.y, p_out)
    annotation (Line(
      points={{-79,-60},{-116,-60}},
      color={0,0,127},
      visible=use_p_in and use_p_ref));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={28,108,200},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
          Rectangle(
          extent={{-86,90},{88,-30}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
                 Bitmap(extent={{-66,-96},{54,-34}},fileName=
            "modelica://IBPSA/Resources/Images/Fluid/FMI/FMI_icon.png"),
        Line(
          points={{-74,64},{-22,30},{-22,64},{-74,30},{-74,64}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{-48,48},{-48,82}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{-38,82},{-58,82}},
          color={0,0,0},
          thickness=0.5),
        Rectangle(
          extent={{-12,76},{4,-16}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{14,76},{30,-16}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{40,76},{56,-16}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{66,76},{82,-16}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid)}),                      Diagram(
        coordinateSystem(preserveAspectRatio=false), graphics={Line(
          points={{-30,58},{-30,14}},
          color={0,127,255},
          visible=use_p_ref)}));
end FMIReplaceableTransfer;
