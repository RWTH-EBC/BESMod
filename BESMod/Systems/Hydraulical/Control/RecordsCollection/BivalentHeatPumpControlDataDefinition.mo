within BESMod.Systems.Hydraulical.Control.RecordsCollection;
partial record BivalentHeatPumpControlDataDefinition
  extends Modelica.Icons.Record;

  parameter Modelica.SIunits.TemperatureDifference dTHysBui
    "Hysteresis for building demand control"                                                            annotation(Dialog(group="General"));
  parameter Modelica.SIunits.TemperatureDifference dTHysDHW
    "Hysteresis for DHW demand control"                                                            annotation(Dialog(group="General"));
      parameter Real k     "Proportional gain of Primary PID Controller"
                                                                  annotation(Dialog(group="Primary PID Control",
      enable=use_hydraulic or use_ventilation));
  parameter Modelica.SIunits.Time T_I
    "Time constant of Integrator block of PI control"                                       annotation(Dialog(
      group="Primary PID Control",
      enable=use_hydraulic or use_ventilation));

  parameter Modelica.SIunits.Time Ni
    "Anti wind up constant of PID control"                                       annotation(Dialog(
      group="Primary PID Control",
      enable=use_hydraulic or use_ventilation));

  parameter Modelica.SIunits.TemperatureDifference dTOffSetHeatCurve
    "Additional Offset of heating curve"                                                                  annotation(Evaluate=true, Dialog(group=
          "Heating Curve"));
  parameter Modelica.SIunits.Temperature TOda_nominal "Nominal outdoor air temperature";
  parameter Modelica.SIunits.Temperature TSup_nominal "Nominal supply temperature of primary energy system";
  parameter Modelica.SIunits.Temperature TSetRoomConst=293.15
    "Room set temerature";
  parameter Modelica.SIunits.Temperature TBiv=
    TOda_nominal "Nominal bivalence temperature. = TOda_nominal for monovalent systems.";

  parameter Real gradientHeatCurve=((TSup_nominal) - (TSetRoomConst + dTOffSetHeatCurve))/(TSetRoomConst-TOda_nominal)  "Heat curve gradient"    annotation(Evaluate=true, Dialog(group=
          "Heating Curve"));
  parameter Modelica.SIunits.Time dtHeaRodBui
    "Seconds for regulation when hr should be activated: If lower set temperature is hurt for more than this time period"                                               annotation(group="Heat Pumps",Dialog(
        group="Secondary RBC"));

  parameter Real addSet_dtHeaRodBui
    "Each time dt_hr passes, the output of the heating rod is increased by this amount in percentage. Maximum and default is 100 (on-off hr)%" annotation(Dialog(group=
          "Secondary RBC"));
  parameter Modelica.SIunits.Time dtHeaRodDHW
    "Seconds for regulation when hr should be activated: If lower set temperature is hurt for more than this time period"                                               annotation(group="Heat Pumps",Dialog(
        group="Secondary RBC"));

  parameter Real addSet_dtHeaRodDHW
    "Each time dt_hr passes, the output of the heating rod is increased by this amount in percentage. Maximum and default is 100 (on-off hr)%" annotation(Dialog(group=
          "Secondary RBC"));
  parameter Real nMin
    "Minimum relative input signal of primary device PID control"
    annotation (Dialog(group="Primary PID Control"));

end BivalentHeatPumpControlDataDefinition;
