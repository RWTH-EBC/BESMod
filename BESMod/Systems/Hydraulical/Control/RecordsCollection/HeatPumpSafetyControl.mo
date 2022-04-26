within BESMod.Systems.Hydraulical.Control.RecordsCollection;
partial record HeatPumpSafetyControl
  extends Modelica.Icons.Record;
  parameter Boolean use_minRunTime=true
    "False if minimal runtime of HP is not considered"
  annotation (Dialog(group="HP-Security: OnOffControl"), choices(checkBox=true));
  parameter Modelica.SIunits.Time minRunTime=600
                                               "Mimimum runtime of heat pump"
    annotation (Dialog(group="HP-Security: OnOffControl",enable=use_minRunTime));
  parameter Boolean use_minLocTime=true
    "False if minimal locktime of HP is not considered"
    annotation (Dialog(group="HP-Security: OnOffControl"), choices(checkBox=true));
  parameter Modelica.SIunits.Time minLocTime=1200
                                               "Minimum lock time of heat pump"
    annotation (Dialog(group="HP-Security: OnOffControl", enable=use_minLocTime));
  parameter Boolean use_runPerHou=true
    "False if maximal runs per hour HP are not considered"
    annotation (Dialog(group="HP-Security: OnOffControl"), choices(checkBox=true));
  parameter Integer maxRunPerHou=3 "Maximal number of on/off cycles in one hour. Source: German law"
    annotation (Dialog(group="HP-Security: OnOffControl", enable=use_runPerHou));
  parameter Boolean pre_n_start_hp=true
    "Start value of pre(n) at initial time of heat pump security control"
    annotation (Dialog(group="HP-Security: OnOffControl", descriptionLabel=true),                                                                                             choices(checkBox=true));
  parameter Real tableUpp[:,2]=[-40,70; 40,70] "Upper boundary of envelope" annotation (Dialog(group="HP-Security: Operational Envelope"));
  parameter Boolean use_opeEnv=true
    "False to allow HP to run out of operational envelope" annotation (Dialog(group="HP-Security: Operational Envelope"));

  parameter Real dT_opeEnv=5
    "Delta value for operational envelope used for upper hysteresis. Used to avoid state-events and to model the real world high pressure pressostat." annotation (Dialog(group="HP-Security: Operational Envelope"));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end HeatPumpSafetyControl;
