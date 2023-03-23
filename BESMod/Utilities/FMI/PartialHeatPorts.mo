within BESMod.Utilities.FMI;
partial model PartialHeatPorts
  "Definition of in and outputs of heat ports in BESMod for FMUs"

    parameter Boolean use_QtoT=false
  "= true to output the temperature of the heat port and use the heat flow as an
  input, false to output heat flow and use the temperature as the input.";

  parameter Integer nHeatPorts=1;

  Modelica.Thermal.HeatTransfer.Components.GeneralTemperatureToHeatFlowAdaptor
    heatPortRad_TtoQ[nHeatPorts](each final use_pder=false) if not use_QtoT
    annotation (Placement(transformation(extent={{88,0},{68,20}}),    visible=
          not use_QtoT));
  Modelica.Thermal.HeatTransfer.Components.GeneralTemperatureToHeatFlowAdaptor heatPortCon_TtoQ[nHeatPorts](
     each final use_pder=false) if not use_QtoT
    annotation (Placement(transformation(extent={{88,60},{68,80}}), visible=
          not use_QtoT));
  Modelica.Blocks.Interfaces.RealInput TConIn[size(heatPortCon_TtoQ, 1)]
    if not use_QtoT
    "Input for Temperatur potential of the heat port for convection"
    annotation (Placement(
      transformation(extent={{120,70},{100,90}}),
      iconTransformation(extent={{120,70},{100,90}}),
      visible=not use_QtoT));
  Modelica.Blocks.Interfaces.RealOutput QflowConOut[size(heatPortCon_TtoQ, 1)]
    if not use_QtoT "Output for flow"
    annotation (Placement(transformation(extent={{100,50},{120,70}}), visible=
          not use_QtoT));
  Modelica.Thermal.HeatTransfer.Components.GeneralHeatFlowToTemperatureAdaptor
    heatPortCon_QtoT[nHeatPorts](each final use_pder=false) if use_QtoT
    annotation (Placement(
      transformation(extent={{50,20},{70,40}}),
      iconVisible=use_QtoT,
      visible=use_QtoT));
  Modelica.Thermal.HeatTransfer.Components.GeneralHeatFlowToTemperatureAdaptor
    heatPortRad_QtoT[nHeatPorts](each final use_pder=false) if use_QtoT
    annotation (Placement(transformation(extent={{50,-40},{70,-20}}),
      iconVisible=use_QtoT,
      visible=use_QtoT));
  Modelica.Blocks.Interfaces.RealOutput TConOut[size(heatPortCon_QtoT, 1)]
    if use_QtoT
    "Output for potential"
    annotation (Placement(transformation(extent={{100,30},{120,50}}), visible=
          use_QtoT));
  Modelica.Blocks.Interfaces.RealInput QflowConIn[size(heatPortCon_QtoT, 1)]
    if use_QtoT
    "Input for flow" annotation (Placement(
      transformation(extent={{120,10},{100,30}}),
      iconTransformation(extent={{120,10},{100,30}}),
      visible=use_QtoT));
  Modelica.Blocks.Interfaces.RealInput TRadIn[size(heatPortRad_TtoQ, 1)]
    if not use_QtoT
    "Input for potential" annotation (Placement(
      transformation(extent={{120,10},{100,30}}),
      iconTransformation(extent={{120,10},{100,30}}),
      visible=not use_QtoT));
  Modelica.Blocks.Interfaces.RealOutput OflowRadOut[size(heatPortRad_TtoQ, 1)]
    if not use_QtoT
    "Output for flow"
    annotation (Placement(transformation(extent={{100,-10},{120,10}}),  visible=
         not use_QtoT));
  Modelica.Blocks.Interfaces.RealOutput TRadOut[size(heatPortRad_QtoT, 1)]
    if use_QtoT
    "Output for potential"
    annotation (Placement(transformation(extent={{100,-30},{120,-10}}), visible=
         use_QtoT));
  Modelica.Blocks.Interfaces.RealInput QflowRadIn[size(heatPortRad_QtoT, 1)]
    if use_QtoT
    "Input for flow" annotation (Placement(
      transformation(extent={{90,-50},{110,-30}}),
      iconTransformation(extent={{90,-50},{110,-30}}),
      visible=use_QtoT));
equation
  connect(heatPortCon_TtoQ.p, TConIn) annotation (Line(
      points={{81,78},{80,78},{80,80},{110,80}},
      color={0,0,127},
      visible=not use_QtoT));
  connect(heatPortCon_TtoQ.f, QflowConOut) annotation (Line(
      points={{81,62},{80,62},{80,60},{110,60}},
      color={0,0,127},
      visible=not use_QtoT));
  connect(heatPortCon_QtoT.p, TConOut)
    annotation (Line(
      points={{63,38},{64,38},{64,40},{110,40}},
      color={0,0,127},
      visible=use_QtoT));
  connect(heatPortCon_QtoT.f, QflowConIn) annotation (Line(
      points={{63,22},{64,22},{64,20},{110,20}},
      color={0,0,127},
      visible=use_QtoT));
  connect(heatPortRad_TtoQ.p, TRadIn) annotation (Line(
      points={{81,18},{80,18},{80,20},{110,20}},
      color={0,0,127},
      visible=not use_QtoT));
  connect(heatPortRad_TtoQ.f, OflowRadOut) annotation (Line(
      points={{81,2},{80,2},{80,0},{110,0}},
      color={0,0,127},
      visible=not use_QtoT));
  connect(heatPortRad_QtoT.p, TRadOut) annotation (Line(
      points={{63,-22},{64,-22},{64,-20},{110,-20}},
      color={0,0,127},
      visible=use_QtoT));
  connect(heatPortRad_QtoT.f, QflowRadIn) annotation (Line(
      points={{63,-38},{62,-38},{62,-40},{100,-40}},
      color={0,0,127},
      visible=use_QtoT));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialHeatPorts;
