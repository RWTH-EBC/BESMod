within BESMod.Systems.Hydraulical.Generation;
model DetailedSolarThermalWithHeatPump
  "Detailed solar thermal model with monoenergetic heat pump"
  extends HeatPumpAndElectricHeater(
    m_flow_nominal={Q_flow_nominal[1]*f_design[1]/dTTra_nominal[1]/4184,
        solarThermalParas.m_flow_nominal},
    redeclare package Medium = IBPSA.Media.Water,
                                dTTra_nominal={if TDem_nominal[1] > 273.15 + 55
         then 10 elseif TDem_nominal[1] > 44.9 then 8 else 5,solarThermalParas.dTMax},
         final nParallelDem=2,
         final dp_nominal={heatPump.dpCon_nominal +dpEleHea_nominal,  dpST_nominal});
  parameter Modelica.Units.SI.Length lengthPipSolThe=30 "Length of all pipes to and from solar thermal"
    annotation (Dialog(tab="Pressure losses", group="Solar Thermal"));
  parameter Real facFitSolThe=8*facPerBend
    "Factor to take into account resistance of bends, fittings etc. for solar thermal"
    annotation (Dialog(tab="Pressure losses", group="Solar Thermal"));

  replaceable parameter
    BESMod.Systems.Hydraulical.Generation.RecordsCollection.SolarThermal.Generic
    solarThermalParas constrainedby
    BESMod.Systems.Hydraulical.Generation.RecordsCollection.SolarThermal.Generic(
      final c_p=cp) annotation (
    Dialog(group="Component data"),
    choicesAllMatching=true,
    Placement(transformation(extent={{-86,-62},{-66,-42}})));
  replaceable parameter
    BESMod.Systems.RecordsCollection.Movers.MoverBaseDataDefinition parPumSolThe
    "Parameters for solar thermal pump" annotation (
    Dialog(group="Component data"),
    choicesAllMatching=true,
    Placement(transformation(extent={{-80,-158},{-66,-144}})));
  Buildings.Fluid.SolarCollectors.EN12975 solCol(
    redeclare final package Medium = Medium,
    final energyDynamics=energyDynamics,
    final allowFlowReversal=true,
    final m_flow_small=1E-4*abs(solarThermalParas.m_flow_nominal),
    final show_T=false,
    final T_start=T_start,
    final p_start=p_start,
    nSeg=5,
    azi=0,
    til=0.5235987755983,
    rho=0.2,
    use_shaCoe_in=false,
    shaCoe=0,
    nColType=Buildings.Fluid.SolarCollectors.Types.NumberSelection.Area,
    totalArea=solarThermalParas.A,
    sysConfig=Buildings.Fluid.SolarCollectors.Types.SystemConfiguration.Series,
    per=Buildings.Fluid.SolarCollectors.Data.GenericSolarCollector(
        ATyp=Buildings.Fluid.SolarCollectors.Types.Area.Aperture,
        A=4.302,
        mDry=484,
        V=4.4/1000,
        dp_nominal=100,
        mperA_flow_nominal=solarThermalParas.m_flow_nominal/solarThermalParas.A,
        B0=0,
        B1=0,
        y_intercept=solarThermalParas.eta_zero,
        slope=0,
        IAMDiff=0.133,
        C1=solarThermalParas.c1,
        C2=solarThermalParas.c2,
        G_nominal=solarThermalParas.GMax,
        dT_nominal=solarThermalParas.dTMax))                 annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-30,-170})));

  Utilities.KPIs.EnergyKPICalculator KPIQSol(use_inpCon=false, y=sum(solCol.vol.heatPort.Q_flow))
    "Solar thermal KPI"
    annotation (Placement(transformation(extent={{-60,-120},{-40,-100}})));

  IBPSA.Fluid.FixedResistances.HydraulicDiameter resSolThe(
    redeclare final package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m_flow_design[2],
    final show_T=show_T,
    final from_dp=false,
    final linearized=false,
    final dh=dPip_design[2],
    length=lengthPipSolThe,
    final ReC=ReC,
    final v_nominal=v_design[2],
    final roughness=roughness,
    fac=facFitSolThe)          "Pressure drop model for solar thermal pipes"
    annotation (Placement(transformation(extent={{20,-180},{40,-160}})));
protected
  parameter Modelica.Units.SI.PressureDifference dpST_nominal=solarThermalParas.m_flow_nominal
      ^2*solarThermalParas.pressureDropCoeff/(rho^2)
    "Pressure drop at nominal mass flow rate";
equation

  connect(solCol.port_b, portGen_out[2]) annotation (Line(points={{-40,-170},{
          -50,-170},{-50,-194},{56,-194},{56,-46},{116,-46},{116,78},{106,78},{
          106,82.5},{100,82.5}},                 color={0,127,255}));

  connect(weaBus, solCol.weaBus) annotation (Line(
      points={{-101,80},{-101,-6},{-104,-6},{-104,-108},{-108,-108},{-108,-184},
          {-20,-184},{-20,-179.6}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(KPIQSol.KPI, outBusGen.QSolThe_flow) annotation (Line(points={{-37.8,
          -110},{0,-110},{0,-100}}, color={135,135,135}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(resSolThe.port_a, solCol.port_a)
    annotation (Line(points={{20,-170},{-20,-170}}, color={0,127,255}));
  connect(resSolThe.port_b, portGen_in[2]) annotation (Line(points={{40,-170},{
          48,-170},{48,-34},{100,-34},{100,0.5}}, color={0,127,255}));
  annotation (Diagram(coordinateSystem(extent={{-220,-200},{100,100}}),
        graphics={Text(
          extent={{-216,-122},{-152,-140}},
          textColor={0,0,0},
          textString="Solar Thermal"), Rectangle(
          extent={{94,-198},{-218,-136}},
          lineColor={0,0,0},
          lineThickness=1)}));
end DetailedSolarThermalWithHeatPump;
