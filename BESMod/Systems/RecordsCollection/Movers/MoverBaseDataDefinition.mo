within BESMod.Systems.RecordsCollection.Movers;
partial record MoverBaseDataDefinition
  extends Modelica.Icons.Record;
  parameter Real V_flowCurve[:]     "Relative V_flow curve to be used";
  parameter Real dpCurve[:]      "Relative dp curve to be used";
  parameter Modelica.Units.NonSI.AngularVelocity_rpm speed_rpm_nominal
    "Nominal rotational speed for flow characteristic";
   parameter Boolean addPowerToMedium
    "Set to false to avoid any power (=heat and flow work) being added to medium (may give simpler equations)";
  parameter Boolean use_inputFilter
    "= true, if speed is filtered with a 2nd order CriticalDamping filter";
  parameter Modelica.Units.SI.Time riseTimeInpFilter
    "Rise time of the filter (time to reach 99.6 % of the speed)";
  parameter Modelica.Units.SI.Time tau
    "Time constant of fluid volume for nominal flow, used if energy or mass balance is dynamic";

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end MoverBaseDataDefinition;
