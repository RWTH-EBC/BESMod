within BESMod.Systems.Hydraulical.Generation.BaseClasses;
model ModularPropagable "Modular model with propagable modules"
  extends
    AixLib.Fluid.HeatPumps.ModularReversible.BaseClasses.PartialReversibleRefrigerantMachine(
    final use_COP=true,
    final use_EER=use_rev,
    con(preDro(m_flow(nominal=QHea_flow_nominal/1000/10))),
    eva(preDro(m_flow(nominal=QHea_flow_nominal/1000/10))),
    final PEle_nominal=refCyc.refCycHeaPumHea.PEle_nominal,
    mCon_flow_nominal=QHea_flow_nominal/(dTCon_nominal*cpCon),
    mEva_flow_nominal=(QHea_flow_nominal - PEle_nominal)/(dTEva_nominal*cpEva),
    use_rev=false,
    redeclare AixLib.Fluid.HeatPumps.ModularReversible.BaseClasses.RefrigerantCycle refCyc(
      final allowDifferentDeviceIdentifiers=allowDifferentDeviceIdentifiers));
  parameter Modelica.Units.SI.HeatFlowRate QHea_flow_nominal(min=Modelica.Constants.eps)
    "Nominal heating capacity"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.HeatFlowRate QCoo_flow_nominal(max=0)=0
    "Nominal cooling capacity"
      annotation(Dialog(group="Nominal condition - Cooling", enable=use_rev));

  parameter Modelica.Units.SI.Temperature TConHea_nominal
    "Nominal temperature of the heated fluid"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Temperature TEvaHea_nominal
    "Nominal temperature of the cooled fluid"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Temperature TConCoo_nominal
    "Nominal temperature of the cooled fluid"
    annotation(Dialog(enable=use_rev, group="Nominal condition - Cooling"));
  parameter Modelica.Units.SI.Temperature TEvaCoo_nominal
    "Nominal temperature of the heated fluid"
    annotation(Dialog(enable=use_rev, group="Nominal condition - Cooling"));

  Modelica.Blocks.Sources.BooleanConstant conHea(final k=true)
    if not use_busConOnl and not use_rev
    "Locks the device in heating mode if designated to be not reversible" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,-130})));
  Modelica.Blocks.Interfaces.BooleanInput hea if not use_busConOnl and use_rev
    "=true for heating, =false for cooling"
    annotation (Placement(transformation(extent={{-164,-82},{-140,-58}}),
        iconTransformation(extent={{-120,-30},{-102,-12}})));
equation
  connect(conHea.y, sigBus.hea)
    annotation (Line(points={{-99,-130},{-76,-130},{-76,-40},{-140,-40},{-140,-41},
          {-141,-41}},          color={255,0,255}));
  connect(hea, sigBus.hea)
    annotation (Line(points={{-152,-70},{-128,-70},{-128,-40},{-134,-40},{-134,-41},
          {-141,-41}}, color={255,0,255}));
  connect(eff.QUse_flow, refCycIneCon.y) annotation (Line(points={{98,37},{48,37},
          {48,66},{8.88178e-16,66},{8.88178e-16,61}}, color={0,0,127}));
  connect(eff.hea, sigBus.hea) annotation (Line(points={{98,30},{48,30},{48,0},{
          26,0},{26,-30},{-20,-30},{-20,-41},{-141,-41}}, color={255,0,255}),
      Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  annotation (Icon(coordinateSystem(extent={{-100,-100},{100,100}}), graphics={
          Text(
          extent={{-100,-12},{-72,-30}},
          textColor={255,85,255},
          visible=not use_busConOnl and use_rev,
          textString="hea")}),
    Diagram(coordinateSystem(extent={{-140,-160},{140,160}})),
    Documentation(info="<html>
<p>This model is a near exact copy of 
<a href=\"AixLib.Fluid.HeatPumps.ModularReversible.Modular\">AixLib.Fluid.HeatPumps.ModularReversible.Modular</a>, 
but enabling the propagation of the refrigerant modules with a constrainedby 
clause and final modifiers. See 
<a href=\"BESMod.Systems.Hydraulical.Generation.BaseClasses.PartialHeatPump\">BESMod.Systems.Hydraulical.Generation.BaseClasses.PartialHeatPump</a>
for an exemplary usage.</p>
</html>"), revisions="
<html>
<ul>
  <li>
    <i>August 29, 2024,</i> by Fabian Wuellhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/RWTH-EBC/BESMod/issues/82\">#82</a>)
  </li>
</ul>
</html>");
end ModularPropagable;
