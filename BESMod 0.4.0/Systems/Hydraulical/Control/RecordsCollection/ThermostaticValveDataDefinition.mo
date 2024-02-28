within BESMod.Systems.Hydraulical.Control.RecordsCollection;
record ThermostaticValveDataDefinition
  extends Modelica.Icons.Record;
    //Demand - Building
  parameter Real Kvs=1.2   "Kv value at full opening (=1)";
  parameter Real Kv_setT=1.4
    "Kv value when set temperature = measured temperature";
  parameter Real P = 2 "Deviation of P-controller when valve is closed";

  parameter Real leakageOpening = 0.0001
    "may be useful for simulation stability. Always check the influence it has on your results";
  parameter Real k=0.2
                     "Gain of controller";
  parameter Modelica.Units.SI.Time Ti=1800 "Time constant of Integrator block";

  parameter Modelica.Units.SI.PressureDifference dpFixed_nominal=1000
    "Pressure drop of pipe and other resistances that are in series";
  parameter Modelica.Units.SI.PressureDifference dpValve_nominal=1000
    "Nominal pressure drop of fully open valve, used if CvData=IBPSA.Fluid.Types.CvTypes.OpPoint";
  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(graphics,
        coordinateSystem(preserveAspectRatio=false)));
end ThermostaticValveDataDefinition;
