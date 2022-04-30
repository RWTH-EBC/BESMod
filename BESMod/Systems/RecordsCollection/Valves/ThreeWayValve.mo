within BESMod.Systems.RecordsCollection.Valves;
partial record ThreeWayValve
  extends Modelica.Icons.Record;

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal
    "Nominal mass flow rate";

  parameter Modelica.Units.SI.PressureDifference dp_nominal[2](displayUnit="Pa")
    "Nominal pressure drop of connected resistances without the valve";

  parameter Modelica.Units.SI.PressureDifference dpValve_nominal=max(dp_nominal)
      /(1 - valveAutho)
    "Nominal pressure drop of fully open valve, used if CvData=IBPSA.Fluid.Types.CvTypes.OpPoint";
  parameter Modelica.Units.SI.PressureDifference dpFixed_nominal[2]=max(
      dp_nominal) .- (dp_nominal)
    "Nominal pressure drop of pipes and other equipment in flow legs at port_1 and port_3";
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
  parameter Boolean use_inputFilter
    "= true, if opening is filtered with a 2nd order CriticalDamping filter";
  parameter Modelica.Units.SI.Time riseTime
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
