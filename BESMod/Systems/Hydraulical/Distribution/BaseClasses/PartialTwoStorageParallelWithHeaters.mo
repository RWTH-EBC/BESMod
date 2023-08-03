within BESMod.Systems.Hydraulical.Distribution.BaseClasses;
partial model PartialTwoStorageParallelWithHeaters
  "Partial two storage model with heaters"
  extends BaseClasses.PartialTwoStorageParallel;
  parameter Modelica.Units.SI.HeatFlowRate QHRAftBuf_flow_nominal
    "Nominal heat flow rate of heating rod after DHW storage"
    annotation (Dialog(group="Component data", enable=heaAftBufTyp == BESMod.Systems.Hydraulical.Distribution.Types.HeaterType.HeatingRod));
  parameter BESMod.Systems.Hydraulical.Distribution.Types.HeaterType heaAftBufTyp=BESMod.Systems.Hydraulical.Distribution.Types.HeaterType.No
    "Type of heater after the buffer storage"
    annotation(Dialog(group="Component choices"));

  replaceable parameter Generation.RecordsCollection.HeatingRodBaseDataDefinition
    parHeaRodAftBuf if heaAftBufTyp == BESMod.Systems.Hydraulical.Distribution.Types.HeaterType.HeatingRod
    "Parameters for heating rod after buffer storage" annotation (
    Dialog(group="Component data", enable=heaAftBufTyp == BESMod.Systems.Hydraulical.Distribution.Types.HeaterType.HeatingRod),
    choicesAllMatching=true,
    Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={50,38})));
  parameter Real etaTem[:,2]=[293.15,1.09; 303.15,1.08; 313.15,1.05; 323.15,1.; 373.15,
      0.99] if heaAftBufTyp == BESMod.Systems.Hydraulical.Distribution.Types.HeaterType.Boiler
      "Temperature based efficiency"
        annotation(Dialog(group="Component data"));

  replaceable parameter AixLib.DataBase.Boiler.General.BoilerTwoPointBaseDataDefinition
    parBoi if heaAftBufTyp == BESMod.Systems.Hydraulical.Distribution.Types.HeaterType.Boiler
    "Parameters for Boiler"
    annotation(Placement(transformation(extent={{64,124},{80,140}})),
      choicesAllMatching=true, Dialog(group="Component data"));

  BESMod.Systems.Hydraulical.Components.HeatingRodWithSecurityControl hea(
    redeclare package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m_flow_nominal[1],
    final m_flow_small=1E-4*abs(m_flow_nominal[1]),
    final show_T=show_T,
    final dp_nominal=parHeaRodAftBuf.dp_nominal,
    final tau=30,
    final energyDynamics=energyDynamics,
    final p_start=p_start,
    final T_start=T_start,
    final Q_flow_nominal=QHRAftBuf_flow_nominal,
    final V=parHeaRodAftBuf.V_hr,
    final eta=parHeaRodAftBuf.eta_hr) if heaAftBufTyp == BESMod.Systems.Hydraulical.Distribution.Types.HeaterType.HeatingRod
                                                                   annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={50,90})));

  AixLib.Fluid.Interfaces.PassThroughMedium pasThrHeaRodBuf(redeclare package
      Medium = Medium, allowFlowReversal=allowFlowReversal) if heaAftBufTyp ==
    BESMod.Systems.Hydraulical.Distribution.Types.HeaterType.No
    annotation (Placement(transformation(extent={{40,54},{60,74}})));

  Utilities.KPIs.EnergyKPICalculator eneKPICalAftBufHeaRod(use_inpCon=true)
    if heaAftBufTyp == BESMod.Systems.Hydraulical.Distribution.Types.HeaterType.HeatingRod          annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={30,-130})));

  AixLib.Fluid.BoilerCHP.BoilerNoControl boi(
    redeclare package Medium = AixLib.Media.Water,
    final allowFlowReversal=true,
    final m_flow_nominal=m_flow_nominal[1],
    final m_flow_small=1E-4*abs(m_flow_nominal[1]),
    final show_T=show_T,
    final initType=Modelica.Blocks.Types.Init.NoInit,
    final transferHeat=false,
    final rho_default=rho,
    final p_start=p_start,
    final T_start=T_start,
    final etaLoadBased=parBoi.eta,
    final G=0.003*parBoi.Q_nom/50,
    final C=1.5*parBoi.Q_nom,
    final Q_nom=parBoi.Q_nom,
    final V=parBoi.volume,
    final etaTempBased=[293.15,1.09; 303.15,1.08; 313.15,1.05; 323.15,1.; 373.15,0.99],
    final paramBoiler=parBoi) if heaAftBufTyp == BESMod.Systems.Hydraulical.Distribution.Types.HeaterType.Boiler
                              "Boiler with external control"
    annotation (Placement(transformation(extent={{40,110},{60,130}})));

  Utilities.KPIs.EnergyKPICalculator KPIBoi(use_inpCon=false, y=boi.thermalPower)
 if heaAftBufTyp == BESMod.Systems.Hydraulical.Distribution.Types.HeaterType.Boiler
    "Boiler heat flow KPI"
    annotation (Placement(transformation(extent={{-60,-200},{-40,-180}})));
equation
  connect(hea.Pel, eneKPICalAftBufHeaRod.u) annotation (Line(points={{61,96},{61,
          94},{66,94},{66,104},{114,104},{114,-130},{41.8,-130}}, color={0,0,127}));
  connect(eneKPICalAftBufHeaRod.KPI, outBusDist.PEleHRAftBuf) annotation (Line(
        points={{17.8,-130},{0,-130},{0,-100}}, color={135,135,135}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(hea.u, sigBusDistr.uHRAftBuf) annotation (Line(points={{38,96},{32,96},
          {32,100},{0,100},{0,101}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(boi.u_rel, sigBusDistr.yBoi) annotation (Line(points={{43,127},{0,127},{
          0,101}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(KPIBoi.KPI, outBusDist.QBoi_flow) annotation (Line(points={{-37.8,-190},
          {-24,-190},{-24,-192},{0,-192},{0,-100}}, color={135,135,135}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(stoBuf.fluidportTop2, pasThrHeaRodBuf.port_a) annotation (Line(points={{
          -29,40.2},{-29,60},{32,60},{32,64},{40,64}}, color={0,127,255}));
  connect(stoBuf.fluidportTop2, hea.port_a) annotation (Line(points={{-29,40.2},{-29,
          60},{32,60},{32,90},{40,90}}, color={0,127,255}));
  connect(stoBuf.fluidportTop2, boi.port_a) annotation (Line(points={{-29,40.2},{-29,
          60},{32,60},{32,96},{34,96},{34,120},{40,120}}, color={0,127,255}));
  connect(boi.port_b, senTBuiSup.port_a) annotation (Line(points={{60,120},{66,120},
          {66,102},{64,102},{64,82},{62,82},{62,80},{66,80}}, color={0,127,255}));
  connect(hea.port_b, senTBuiSup.port_a) annotation (Line(points={{60,90},{60,86},
          {66,86},{66,80}}, color={0,127,255}));
  connect(pasThrHeaRodBuf.port_b, senTBuiSup.port_a)
    annotation (Line(points={{60,64},{66,64},{66,80}}, color={0,127,255}));
  annotation (Diagram(coordinateSystem(extent={{-100,-180},{100,140}})));
end PartialTwoStorageParallelWithHeaters;
