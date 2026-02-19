within BESMod.Systems.Hydraulical.Transfer.BaseClasses;
partial model PartialWithPipingLosses
  "Partial model with piping pressure losses"
  extends PartialTransfer(
    dPip_design={12/1000 for i in 1:nParallelDem},
    dpSup_design={10},
    dpSupOld_design={10},
    dpSup_nominal={10},
    final nParallelSup=1);

  // Pressure
  parameter BESMod.Systems.Hydraulical.Transfer.Types.HydraulicResistanceType typeOfHydRes=BESMod.Systems.Hydraulical.Transfer.Types.HydraulicResistanceType.
       FittingAndThermostatAndCheckValve
    "Type of the hydraulic restistances to be considered for parameter zf"
    annotation(Dialog(tab="Pressure losses"));
  parameter Real facPip(unit="1")=
    BESMod.Systems.Hydraulical.Transfer.Functions.GetSurchargeFactorForHydraulicResistances(
     typeOfHydRes)
      "Factor for additional pressure resistances in piping network such as bows. Acc. to [Babusch, 2009]"
      annotation(Dialog(tab="Pressure losses"));
  parameter Modelica.Units.SI.Length lenDisToTra[nParallelSup]=fill(2*hBui, nParallelSup)
    "Length of main line between distribution pump and individual transfer units"
    annotation(Dialog(tab="Pressure losses"));
  parameter Modelica.Units.SI.Length lenDisPerUnit[nParallelDem]=fill(2*sqrt(ABui), nParallelDem)
    "Length between main line and each transfer system, default is worst point but leads to hydraulically balanced system (factor 2 for flow and return)"
    annotation(Dialog(tab="Pressure losses"));
  parameter Modelica.Units.SI.Velocity vSup_design[nParallelSup] = fill(max(v_design), nParallelSup)
    "Design velocity of main supply lines"
    annotation(Dialog(tab="Pressure losses"));
  IBPSA.Fluid.FixedResistances.HydraulicDiameter res(
    redeclare package Medium = Medium,
    final m_flow_nominal=mOld_flow_design[1],
    final show_T=show_T,
    final dh=dPip_design[1],
    final length=lenDisPerUnit[1],
    final ReC=ReC,
    final v_nominal=v_design[1],
    final roughness=roughness,
    final fac=facPip,
    disableComputeFlowResistance=true)
                           if withPressureLossPerZone
    "Hydraulic resistance of supply and radiator to set dp allways to m_flow_nominal"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-30,40})));
  IBPSA.Fluid.FixedResistances.HydraulicDiameter resMaiLin[nParallelSup](
    redeclare package Medium = Medium,
    final m_flow_nominal=mSupOld_flow_design,
    each final show_T=show_T,
    final dh=sqrt(4*mSupOld_flow_design ./ rho ./ vSup_design ./ Modelica.Constants.pi),
    final length=lenDisToTra,
    each final ReC=ReC,
    final v_nominal=vSup_design,
    each final roughness=roughness,
    each final fac=1) "Hydraulic resistance of main line" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-70,40})));

  parameter Modelica.Units.SI.PressureDifference dpPipSca_design[nParallelDem]
    "Pipe pressure losses scaled to design flow rate of radiators";
  parameter Modelica.Units.SI.PressureDifference dpPipSupSca_design[nParallelSup]
    "Pipe pressure losses scaled to design flow rate of radiators";
  parameter Modelica.Units.SI.PressureDifference dpPipSupSca_nominal[nParallelSup]
    "Pipe pressure losses scaled to design flow rate of radiators";
  parameter Boolean withPressureLossPerZone=true;
initial algorithm
  for i in 1:nParallelSup loop
    assert(dpSupOld_design[i] / (max(lenDisToTra) + max(lenDisPerUnit)) < 100, "Pressure drop per meter should roughly be below 100 Pa/m, but is " +
      String(dpSupOld_design[i] / (max(lenDisToTra) + max(lenDisPerUnit))) + " Pa/m for supply line" + String(i), AssertionLevel.warning);
  end for;

equation
  connect(resMaiLin.port_a, portTra_in) annotation (Line(points={{-80,40},{-86,40},
          {-86,38},{-100,38}}, color={0,127,255}));
annotation (Documentation(info="<html>
<p>This partial model adds the pressure losses through piping in the building from the distribution pump to the transfer units (e.g. radiators). </p><p>As a default assumption, the pipes are always desinged on the old heat load, as pipes in walls are typically never replaced. </p><p>It was a design choice to keep the piping which distributes water from the pump in the distrubution in the transfer system (even though it may be interpreted as distribution) as this piping heavily depends on the number of zones and building parameters. Furthermore, an automatic hydraulic balance requires less top-down and bottom-up parameters if all relevent pressure losses are inside the transfer system. </p>
</html>"));
end PartialWithPipingLosses;
