within BESMod.Utilities.FMI;
partial model PartialHeatPorts
  "Definition of in and outputs of heat ports in BESMod for FMUs"

    parameter Boolean use_QtoT=false
  "= true to output the temperature of the heat port and use the heat flow as an
  input, false to output heat flow and use the temperature as the input.";

  parameter Integer nHeatPorts=1;

  Modelica.Thermal.HeatTransfer.Components.GeneralTemperatureToHeatFlowAdaptor
    heatPortRad_TtoQ[nHeatPorts](each final use_pder=false) if not use_QtoT
    annotation (Placement(transformation(extent={{88,12},{68,32}})));
  Modelica.Thermal.HeatTransfer.Components.GeneralTemperatureToHeatFlowAdaptor heatPortCon_TtoQ[nHeatPorts](
     each final use_pder=false) if not use_QtoT
    annotation (Placement(transformation(extent={{88,80},{68,100}})));
  Modelica.Blocks.Interfaces.RealInput TConIn[size(heatPortCon_TtoQ, 1)]
    if not use_QtoT
    "Input for Temperatur potential of the heat port for convection"
    annotation (Placement(
      transformation(extent={{120,86},{100,106}}),
      iconTransformation(extent={{120,86},{100,106}})));
  Modelica.Blocks.Interfaces.RealOutput QflowConOut[size(heatPortCon_TtoQ, 1)]
    if not use_QtoT "Output for flow"
    annotation (Placement(transformation(extent={{100,70},{120,90}})));
  Modelica.Thermal.HeatTransfer.Components.GeneralHeatFlowToTemperatureAdaptor
    heatPortCon_QtoT[nHeatPorts](each final use_pder=false) if use_QtoT
    annotation (Placement(
      transformation(extent={{68,46},{88,66}}),
      iconVisible=use_QtoT));
  Modelica.Thermal.HeatTransfer.Components.GeneralHeatFlowToTemperatureAdaptor
    heatPortRad_QtoT[nHeatPorts](each final use_pder=false) if use_QtoT
    annotation (Placement(transformation(extent={{68,-22},{88,-2}})));
  Modelica.Blocks.Interfaces.RealOutput TConOut[size(heatPortCon_QtoT, 1)]
    if use_QtoT
    "Output for potential"
    annotation (Placement(transformation(extent={{100,54},{120,74}})));
  Modelica.Blocks.Interfaces.RealInput QflowConIn[size(heatPortCon_QtoT, 1)]
    if use_QtoT
    "Input for flow" annotation (Placement(
      transformation(extent={{120,36},{100,56}}),
      iconTransformation(extent={{120,36},{100,56}})));
  Modelica.Blocks.Interfaces.RealInput TRadIn[size(heatPortRad_TtoQ, 1)]
    if not use_QtoT
    "Input for potential" annotation (Placement(
      transformation(extent={{120,20},{100,40}}),
      iconTransformation(extent={{120,20},{100,40}})));
  Modelica.Blocks.Interfaces.RealOutput QflowRadOut[size(heatPortRad_TtoQ, 1)]
    if not use_QtoT
    "Output for flow"
    annotation (Placement(transformation(extent={{102,4},{122,24}})));
  Modelica.Blocks.Interfaces.RealOutput TRadOut[size(heatPortRad_QtoT, 1)]
    if use_QtoT
    "Output for potential"
    annotation (Placement(transformation(extent={{100,-12},{120,8}})));
  Modelica.Blocks.Interfaces.RealInput QflowRadIn[size(heatPortRad_QtoT, 1)]
    if use_QtoT
    "Input for flow" annotation (Placement(
      transformation(extent={{90,-30},{110,-10}}),
      iconTransformation(extent={{90,-30},{110,-10}})));
equation
  connect(heatPortCon_TtoQ.p, TConIn) annotation (Line(
      points={{81,98},{80,98},{80,96},{110,96}},
      color={0,0,127}));
  connect(heatPortCon_TtoQ.f, QflowConOut) annotation (Line(
      points={{81,82},{80,82},{80,80},{110,80}},
      color={0,0,127}));
  connect(heatPortCon_QtoT.p, TConOut)
    annotation (Line(
      points={{81,64},{110,64}},
      color={0,0,127}));
  connect(heatPortCon_QtoT.f, QflowConIn) annotation (Line(
      points={{81,48},{82,48},{82,46},{110,46}},
      color={0,0,127}));
  connect(heatPortRad_TtoQ.p, TRadIn) annotation (Line(
      points={{81,30},{110,30}},
      color={0,0,127}));
  connect(heatPortRad_TtoQ.f,QflowRadOut)  annotation (Line(
      points={{81,14},{112,14}},
      color={0,0,127}));
  connect(heatPortRad_QtoT.p, TRadOut) annotation (Line(
      points={{81,-4},{80,-4},{80,-2},{110,-2}},
      color={0,0,127}));
  connect(heatPortRad_QtoT.f, QflowRadIn) annotation (Line(
      points={{81,-20},{100,-20}},
      color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialHeatPorts;
