within BESMod.Systems.RecordsCollection.Movers;
partial record MoverBaseDataDefinition
  extends BESMod.Utilities.Icons.RecordWithName;
   parameter Boolean addPowerToMedium
    "Set to false to avoid any power (=heat and flow work) being added to medium (may give simpler equations)";
  parameter Boolean use_riseTime
    "= true, if speed is filtered with a 2nd order CriticalDamping filter";
  parameter Modelica.Units.SI.Time riseTime
    "Rise time of the filter (time to reach 99.6 % of the speed)";
  parameter Modelica.Units.SI.Time tau
    "Time constant of fluid volume for nominal flow, used if energy or mass balance is dynamic";
  parameter BESMod.Systems.Hydraulical.Components.PreconfiguredControlledMovers.Types.ExternalControlType externalCtrlTyp=
      BESMod.Systems.Hydraulical.Components.PreconfiguredControlledMovers.Types.ExternalControlType.internal
    "External control interface type";
  parameter AixLib.Fluid.Movers.DpControlledMovers.Types.CtrlType ctrlType
    "Internal pump control mode";
  parameter Real dpVarBase_nominal = 0.5
    "Percentage of dp_nominal at minimal volume flow rate for dpVar"
    annotation(Dialog(enable=(ctrlType == AixLib.Fluid.Movers.DpControlledMovers.Types.CtrlType.dpVar)));
  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(graphics,
        coordinateSystem(preserveAspectRatio=false)));
end MoverBaseDataDefinition;
