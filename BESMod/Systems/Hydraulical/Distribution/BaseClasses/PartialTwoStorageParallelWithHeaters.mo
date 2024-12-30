within BESMod.Systems.Hydraulical.Distribution.BaseClasses;
partial model PartialTwoStorageParallelWithHeaters
  "Partial two storage model with heaters"
  extends PartialTwoStorageParallel(
    dpBufToDem_design=
      if heaAftBufTyp == BESMod.Systems.Hydraulical.Distribution.Types.HeaterType.Boiler then dpBoi_design
      elseif heaAftBufTyp == BESMod.Systems.Hydraulical.Distribution.Types.HeaterType.ElectricHeater then parEleHeaAftBuf.dp_nominal
      else 0,
    final use_secHeaCoiDHWSto=false,
    multiSum(nu=if heaAftBufTyp == BESMod.Systems.Hydraulical.Distribution.Types.HeaterType.ElectricHeater then 5 else 4));

  parameter Modelica.Units.SI.HeatFlowRate QHeaAftBuf_flow_nominal=0
    "Nominal heat flow rate of heater after DHW storage"
    annotation (Dialog(group="Component data", enable=heaAftBufTyp <> BESMod.Systems.Hydraulical.Distribution.Types.HeaterType.No));
  parameter BESMod.Systems.Hydraulical.Distribution.Types.HeaterType heaAftBufTyp=BESMod.Systems.Hydraulical.Distribution.Types.HeaterType.No
    "Type of heater after the buffer storage"
    annotation(Dialog(group="Component choices"));
  parameter Real etaTem[:,2]=[293.15,1.09; 303.15,1.08; 313.15,1.05; 323.15,1.; 373.15,
      0.99] if heaAftBufTyp == BESMod.Systems.Hydraulical.Distribution.Types.HeaterType.Boiler
      "Temperature based efficiency"
        annotation(Dialog(group="Component data", enable=heaAftBufTyp == BESMod.Systems.Hydraulical.Distribution.Types.HeaterType.Boiler));

  replaceable parameter
    BESMod.Systems.Hydraulical.Generation.RecordsCollection.ElectricHeater.DefaultElectricHeater
    parEleHeaAftBuf(iconName="Heater")
    constrainedby
    BESMod.Systems.Hydraulical.Generation.RecordsCollection.ElectricHeater.Generic
    "Parameters for electric heater after buffer storage" annotation (
    Dialog(group="Component data", enable=heaAftBufTyp == BESMod.Systems.Hydraulical.Distribution.Types.HeaterType.ElectricHeater),
    choicesAllMatching=true,
    Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={90,130})));


  replaceable parameter
    BESMod.Systems.Hydraulical.Generation.RecordsCollection.AutoparameterBoiler
      parBoi
    constrainedby
    AixLib.DataBase.Boiler.General.BoilerTwoPointBaseDataDefinition(
      Q_nom=max(11000, QHeaAftBuf_flow_nominal))
    "Parameters for Boiler"
    annotation(Placement(transformation(extent={{24,164},{36,176}})),
      choicesAllMatching=true,
      Dialog(
        group="Component data",
        enable=heaAftBufTyp == BESMod.Systems.Hydraulical.Distribution.Types.HeaterType.Boiler));

  BESMod.Systems.Hydraulical.Components.ElectricHeaterWithSecurityControl hea(
    redeclare package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=mDem_flow_design[1],
    final m_flow_small=1E-4*abs(mDem_flow_design[1]),
    final show_T=show_T,
    final dp_nominal=parEleHeaAftBuf.dp_nominal,
    final tau=30,
    final energyDynamics=energyDynamics,
    final p_start=p_start,
    final T_start=T_start,
    final Q_flow_nominal=QHeaAftBuf_flow_nominal,
    final V=parEleHeaAftBuf.V_hr,
    final eta=parEleHeaAftBuf.eta)
      if heaAftBufTyp == BESMod.Systems.Hydraulical.Distribution.Types.HeaterType.ElectricHeater
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={50,90})));

  AixLib.Fluid.Interfaces.PassThroughMedium pasThrEleHeaBuf(redeclare package
      Medium = Medium, allowFlowReversal=allowFlowReversal) if heaAftBufTyp ==
    BESMod.Systems.Hydraulical.Distribution.Types.HeaterType.No
    annotation (Placement(transformation(extent={{40,54},{60,74}})));

  Utilities.KPIs.EnergyKPICalculator eneKPICalAftBufEleHea(use_inpCon=false, y=
        hea.Pel) if heaAftBufTyp == BESMod.Systems.Hydraulical.Distribution.Types.HeaterType.ElectricHeater
    "Electric heater after buffer KPIs"                                                                 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={30,-130})));

  AixLib.Fluid.BoilerCHP.BoilerNoControl boi(
    redeclare package Medium = AixLib.Media.Water,
    final allowFlowReversal=true,
    final m_flow_nominal=mDem_flow_design[1],
    final m_flow_small=1E-4*abs(mDem_flow_design[1]),
    final show_T=show_T,
    final tau=parTemSen.tau,
    final initType=parTemSen.initType,
    final transferHeat=parTemSen.transferHeat,
    final TAmb=parTemSen.TAmb,
    final tauHeaTra=parTemSen.tauHeaTra,
    final dp_nominal=dpBoi_design,
    final rho_default=rho,
    final p_start=p_start,
    final T_start=T_start,
    final etaLoadBased=parBoi.eta,
    final G=0.003*parBoi.Q_nom/50,
    final C=1.5*parBoi.Q_nom,
    final Q_nom=parBoi.Q_nom,
    final V=parBoi.volume,
    final etaTempBased=[293.15,1.09; 303.15,1.08; 313.15,1.05; 323.15,1.; 373.15,0.99],
    final paramBoiler=parBoi)
      if heaAftBufTyp == BESMod.Systems.Hydraulical.Distribution.Types.HeaterType.Boiler
        "Boiler with external control"
    annotation (Placement(transformation(extent={{40,110},{60,130}})));

  Utilities.KPIs.EnergyKPICalculator KPIBoi(use_inpCon=false, y=boi.thermalPower)
 if heaAftBufTyp == BESMod.Systems.Hydraulical.Distribution.Types.HeaterType.Boiler
    "Boiler heat flow KPI"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=180,
        origin={50,-150})));
  Utilities.KPIs.EnergyKPICalculator eneKPICalAftBufBoi(use_inpCon=false, y=boi.fuelPower)
    if heaAftBufTyp == BESMod.Systems.Hydraulical.Distribution.Types.HeaterType.Boiler
    "Boiler after buffer KPIs" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={30,-170})));
protected
  parameter Modelica.Units.SI.PressureDifference dpBoi_design=
    parBoi.a*(mDem_flow_design[1]/rho)^parBoi.n
    "Design pressure difference of boiler, re-calculated as component is conditional";

equation
  connect(eneKPICalAftBufEleHea.KPI, outBusDist.PEleHeaAftBuf) annotation (Line(
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
  connect(boi.u_rel, sigBusDistr.yBoi) annotation (Line(points={{43,127},{8,127},
          {8,120},{0,120},{0,101}},
                   color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(KPIBoi.KPI, outBusDist.QBoi_flow) annotation (Line(points={{37.8,-150},
          {0,-150},{0,-100}},                       color={135,135,135}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(stoBuf.fluidportTop2, pasThrEleHeaBuf.port_a) annotation (Line(points={{-29,
          40.2},{-29,44},{32,44},{32,64},{40,64}},     color={0,127,255}));
  connect(stoBuf.fluidportTop2, hea.port_a) annotation (Line(points={{-29,40.2},
          {-29,44},{32,44},{32,90},{40,90}},
                                        color={0,127,255}));
  connect(stoBuf.fluidportTop2, boi.port_a) annotation (Line(points={{-29,40.2},
          {-29,44},{32,44},{32,120},{40,120}},            color={0,127,255}));
  connect(boi.port_b, senTBuiSup.port_a) annotation (Line(points={{60,120},{66,
          120},{66,80}},                                      color={0,127,255}));
  connect(hea.port_b, senTBuiSup.port_a) annotation (Line(points={{60,90},{66,
          90},{66,80}},     color={0,127,255}));
  connect(pasThrEleHeaBuf.port_b, senTBuiSup.port_a)
    annotation (Line(points={{60,64},{66,64},{66,80}}, color={0,127,255}));
  connect(eneKPICalAftBufBoi.KPI, outBusDist.PBoiAftBuf) annotation (Line(points={{17.8,
          -170},{0,-170},{0,-100}},       color={135,135,135}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(hea.Pel, multiSum.u[5]) annotation (Line(points={{61,96},{76,96},{76,102},
          {-126,102},{-126,-111},{-58,-111}}, color={0,0,127}));
end PartialTwoStorageParallelWithHeaters;
