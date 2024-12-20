within BESMod.Systems.Hydraulical.Transfer.BaseClasses;
partial model PartialWithPipingLosses
  "Partial model with piping pressure losses"
  extends PartialTransfer(
    dPip_design=sqrt(4*mOld_flow_design ./ rho ./ v_design ./ Modelica.Constants.pi),
    dpSup_design={(mSup_flow_design[1]/sum({sqrt(m_flow_design[i]^2/dp_design[i]) for i in 1:nParallelDem})) ^2},
    dpSupOld_design={(mSupOld_flow_design[1]/sum({sqrt(mOld_flow_design[i]^2/dpOld_design[i]) for i in 1:nParallelDem})) ^2},
    dpSup_nominal={(mSup_flow_nominal[1]/sum({sqrt(m_flow_nominal[i]^2/dp_nominal[i]) for i in 1:nParallelDem})) ^2},
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
  parameter Modelica.Units.SI.Length lenDisToTra[nParallelDem]=fill(2*(2*sqrt(ABui) + hBui), nParallelDem)
    "Length between distribution pump and transfer system in each circuit, default is worst point but leads to hydraulically balanced system (factor 2 for flow and return)"
    annotation(Dialog(tab="Pressure losses"));

  IBPSA.Fluid.FixedResistances.HydraulicDiameter res[nParallelDem](redeclare
      package Medium =
               Medium,
    final m_flow_nominal=mOld_flow_design,
    final dh=dPip_design,
    final length=lenDisToTra,
    each final ReC=ReC,
    final v_nominal=v_design,
    each final roughness=roughness,
    each final fac=facPip)
    "Hydraulic resistance of supply and radiator to set dp allways to m_flow_nominal"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-50,40})));
protected
    parameter Modelica.Units.SI.PressureDifference dpPipSca_design[nParallelDem]=
    res.dp_nominal .* (m_flow_design ./ mOld_flow_design).^2
    "Pipe pressure losses scaled to design flow rate of radiators";

annotation (Documentation(info="<html>
<p>This partial model adds the pressure losses through piping in the building from the distribution pump to the transfer units (e.g. radiators). </p><p>As a default assumption, the pipes are always desinged on the old heat load, as pipes in walls are typically never replaced. </p><p>It was a design choice to keep the piping which distributes water from the pump in the distrubution in the transfer system (even though it may be interpreted as distribution) as this piping heavily depends on the number of zones and building parameters. Furthermore, an automatic hydraulic balance requires less top-down and bottom-up parameters if all relevent pressure losses are inside the transfer system. </p>
</html>"));
end PartialWithPipingLosses;
