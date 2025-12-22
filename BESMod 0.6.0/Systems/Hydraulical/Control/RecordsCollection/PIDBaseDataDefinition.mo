within BESMod.Systems.Hydraulical.Control.RecordsCollection;
partial record PIDBaseDataDefinition "Record for a PID controller"
  extends Modelica.Icons.Record;
  parameter Real yMax=1 "Upper limit of output";
  parameter Real yOff=0 "Constant output value if device is turned off";
  parameter Real y_start=0 "Initial value of output";
  parameter Real yMin=0
                      "Lower limit of relative speed";
  parameter Real P=1
                   "Gain of PID-controller";
  parameter Modelica.Units.SI.Time timeInt=Modelica.Constants.inf
                                           "Time constant of Integrator block";
  parameter Real Ni=0.9 "Ni*Ti is time constant of anti-windup compensation";
  parameter Modelica.Units.SI.Time timeDer "Time constant of Derivative block";
  parameter Real Nd=10 "The higher Nd, the more ideal the derivative block";

  annotation (Documentation(info="<html>
<p>Contains parameters to tune the PID control used in BESMod.</p>
</html>"));
end PIDBaseDataDefinition;
