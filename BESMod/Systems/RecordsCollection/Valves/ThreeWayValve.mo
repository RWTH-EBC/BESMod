within BESMod.Systems.RecordsCollection.Valves;
partial record ThreeWayValve
  extends BESMod.Utilities.Icons.RecordWithName;

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal
    "Nominal mass flow rate";

  parameter Modelica.Units.SI.PressureDifference dp_nominal[2](each displayUnit="Pa")=fill(0, 2)
    "Nominal pressure drop of connected resistances without the valve";
  parameter Modelica.Units.SI.PressureDifference dpFixedExtra_nominal[2]=fill(0, 2)
    "Nominal pressure drop of connected resistances but applied as dpFixed to improve algrebraic loop iterations";

  final parameter Modelica.Units.SI.PressureDifference dpMax_nominal = max(dp_nominal .+ dpFixedExtra_nominal)
    "Maximal nominal pressure loss of connected resistances, either modelled within (dpFixedExtra) or outside (dp_nominal) of the three way valve";
  final parameter Modelica.Units.SI.PressureDifference dpHydBal_nominal[2]=dpMax_nominal .- (dp_nominal .+ dpFixedExtra_nominal)
    "Nominal pressure drop used for automatic hydraulic balancing";

  parameter Modelica.Units.SI.PressureDifference dpValve_nominal=valveAutho*dpMax_nominal
      /(1 - valveAutho)
    "Nominal pressure drop of fully open valve, used if CvData=IBPSA.Fluid.Types.CvTypes.OpPoint";
  parameter Modelica.Units.SI.PressureDifference dpFixed_nominal[2]=dpHydBal_nominal .+ dpFixedExtra_nominal
    "Nominal pressure drop of connected resistances but applied as dpFixed to improve algrebraic loop iterations";

  parameter Modelica.Units.SI.PressureDifference dpPum_design=dpValve_nominal + dpMax_nominal
    "Pressure drop used to design the pump connected to the valve";


  parameter Real deltaM
    "Fraction of nominal flow rate where linearization starts, if y=1";
  parameter Real delta0
    "Range of significant deviation from equal percentage law";
  parameter Real R "Rangeability, R=50...100 typically";
  parameter Real l[2] "Valve leakage, l=Kv(y=0)/Kv(y=1)";
  parameter Real fraK
    "Fraction Kv(port_3&rarr;port_2)/Kv(port_1&rarr;port_2)";
  parameter Real valveAutho(unit="1")                   "Assumed valve authority (typical value: 0.5)";

  parameter Modelica.Units.SI.Time tau
    "Time constant at nominal flow for dynamic energy and momentum balance";
  parameter Boolean use_strokeTime
    "= true, if opening is filtered with a 2nd order CriticalDamping filter";
  parameter Modelica.Units.SI.Time strokeTime
    "Rise time of the filter (time to reach 99.6 % of an opening step)";
  parameter Integer order=2 "Order of filter";
  parameter Modelica.Blocks.Types.Init init
    "Type of initialization (no init/steady state/initial state/initial output)";
  parameter Real y_start "Initial value of output";

  parameter Boolean from_dp
    "= true, use m_flow = f(dp) else dp = f(m_flow)";
  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(graphics,
        coordinateSystem(preserveAspectRatio=false)));
end ThreeWayValve;
