within BESMod.Examples.TestControlStrategiesGridConnection;
model SupervisoryControl_1
  extends Systems.Control.BaseClasses.PartialControl;

 parameter Real B_cons = 3500 "threshold for switching off HP";
  parameter Real B_inj = -3500 "threshold for switching on HP";
  parameter Real SOC_start = 0.5 "boundary condition for SOC";
    parameter Real SOC_stop = 0.7 "boundary condition for SOC";
end SupervisoryControl_1;
