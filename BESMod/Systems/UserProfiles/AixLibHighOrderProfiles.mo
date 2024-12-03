within BESMod.Systems.UserProfiles;
model AixLibHighOrderProfiles "Profiles for high order model in the AixLib"
  extends BaseClasses.PartialUserProfiles;
  parameter String fileNameIntGains=Modelica.Utilities.Files.loadResource("modelica://BESMod/Resources/InternalGainsHOM.txt")
    "File where matrix is stored" annotation (Dialog(tab="Inputs", group="Internal Gains"));
  replaceable parameter AixLib.DataBase.Profiles.ProfileBaseDataDefinition
    venPro
    constrainedby AixLib.DataBase.Profiles.ProfileBaseDataDefinition
    "Ventilation profile"
    annotation(choicesAllMatching=true);
  replaceable parameter AixLib.DataBase.Profiles.ProfileBaseDataDefinition
    TSetProfile constrainedby
    AixLib.DataBase.Profiles.ProfileBaseDataDefinition
    "Temperature profile"
    annotation(choicesAllMatching=true);
  parameter Real gain=1 "Gain value multiplied with internal gains. Used to e.g. disable single gains."          annotation (Dialog(group=
          "Internal Gains",                                                                                                 tab="Inputs"));

  Modelica.Blocks.Sources.CombiTimeTable tabIntGai(
    final tableOnFile=true,
    final extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    final tableName="Internals",
    final fileName=fileNameIntGains,
    columns=2:nZones + 1) "Profiles for internal gains" annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-30,10})));

  Modelica.Blocks.Math.Gain gainIntGains[nZones](each k=gain)
    "Profiles for internal gains" annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={30,10})));

  Modelica.Blocks.Sources.CombiTimeTable tabNatVen(
    columns={2,3,4,5,7},
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    tableOnFile=false,
    table=venPro.Profile)
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Modelica.Blocks.Sources.CombiTimeTable TSet(
    columns={2,3,4,5,6,7},
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    tableOnFile=false,
    table=TSetProfile.Profile)                                                                                                                                                              annotation(Placement(transformation(extent={{-40,-40},
            {-20,-20}})));
  Modelica.Blocks.Routing.RealPassThrough realPassThrough[10]
    annotation (Placement(transformation(extent={{20,40},{40,60}})));
  Modelica.Blocks.Routing.RealPassThrough realPassThrough1
                                                         [10]
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
equation
  connect(TSet.y[1], realPassThrough1[6].u) annotation (Line(points={{-19,-30},
          {18,-30}},                                                   color={0,
          0,127}));
  connect(TSet.y[1], realPassThrough1[1].u) annotation (Line(points={{-19,-30},
          {18,-30}},                                                     color={
          0,0,127}));

  connect(TSet.y[2], realPassThrough1[7].u) annotation (Line(points={{-19,-30},
          {18,-30}},                                                   color={0,
          0,127}));
  connect(TSet.y[2], realPassThrough1[2].u) annotation (Line(points={{-19,-30},
          {18,-30}},                                                     color={
          0,0,127}));

  connect(TSet.y[6], realPassThrough1[3].u) annotation (Line(points={{-19,-30},
          {18,-30}},                                                              color={
          0,0,127}));
  connect(TSet.y[6], realPassThrough1[8].u)  annotation (Line(points={{-19,-30},
          {18,-30}},                                                     color={
          0,0,127}));

  connect(TSet.y[4], realPassThrough1[9].u) annotation (Line(points={{-19,-30},
          {18,-30}},                                                   color={0,
          0,127}));
  connect(TSet.y[5], realPassThrough1[4].u) annotation (Line(points={{-19,-30},
          {18,-30}},                                                      color=
         {0,0,127}));

  connect(TSet.y[3], realPassThrough1[10].u) annotation (Line(points={{-19,-30},
          {18,-30}},
        color={0,0,127}));
  connect(TSet.y[3], realPassThrough1[5].u) annotation (Line(points={{-19,-30},
          {18,-30}},                                                      color=
         {0,0,127}));


  connect(tabNatVen.y[1], realPassThrough[1].u)
    annotation (Line(points={{-19,50},{18,50}}, color={0,0,127}));
  connect(tabNatVen.y[1], realPassThrough[6].u)
    annotation (Line(points={{-19,50},{18,50}}, color={0,0,127}));
  connect(tabNatVen.y[2], realPassThrough[2].u)
    annotation (Line(points={{-19,50},{18,50}}, color={0,0,127}));
  connect(tabNatVen.y[2], realPassThrough[7].u)
    annotation (Line(points={{-19,50},{18,50}}, color={0,0,127}));
  connect(tabNatVen.y[3], realPassThrough[4].u)
    annotation (Line(points={{-19,50},{18,50}}, color={0,0,127}));
  connect(tabNatVen.y[3], realPassThrough[9].u)
    annotation (Line(points={{-19,50},{18,50}}, color={0,0,127}));
  connect(tabNatVen.y[4], realPassThrough[5].u)
    annotation (Line(points={{-19,50},{18,50}}, color={0,0,127}));
  connect(tabNatVen.y[4], realPassThrough[10].u)
    annotation (Line(points={{-19,50},{18,50}}, color={0,0,127}));
  connect(tabNatVen.y[5], realPassThrough[3].u)
    annotation (Line(points={{-19,50},{18,50}}, color={0,0,127}));
  connect(tabNatVen.y[5], realPassThrough[8].u)
    annotation (Line(points={{-19,50},{18,50}}, color={0,0,127}));

  connect(tabIntGai.y, gainIntGains.u) annotation (Line(points={{-19,10},{-0.5,
          10},{-0.5,10},{18,10}}, color={0,0,127}));
  connect(gainIntGains.y, useProBus.intGains) annotation (Line(points={{41,10},
          {74,10},{74,-1},{115,-1}},                  color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(realPassThrough1.y, useProBus.TZoneSet) annotation (Line(points={{41,-30},
          {74,-30},{74,-1},{115,-1}},
                                    color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(realPassThrough.y, useProBus.natVent) annotation (Line(points={{41,50},
          {115,50},{115,-1}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  annotation (Documentation(info="<html>
<p>This model provides user profiles for the high order building model in the AixLib. 
It implements three types of profiles:</p>
<ul>
  <li>Internal gains from a text file</li>
  <li>Natural ventilation schedule</li>
  <li>Temperature setpoints</li>
</ul>

<h4>Important Parameters</h4>
<ul>
  <li><code>fileNameIntGains</code>: File path to internal gains profiles</li>
  <li><code>venPro</code>: Replaceable ventilation profile extending <a href=\"modelica://AixLib.DataBase.Profiles.ProfileBaseDataDefinition\">AixLib.DataBase.Profiles.ProfileBaseDataDefinition</a></li>
  <li><code>TSetProfile</code>: Replaceable temperature setpoint profile extending <a href=\"modelica://AixLib.DataBase.Profiles.ProfileBaseDataDefinition\">AixLib.DataBase.Profiles.ProfileBaseDataDefinition</a></li>
  <li><code>gain</code>: Multiplier for internal gains (can be used to disable gains by setting to 0)</li>
</ul>
</html>"));
end AixLibHighOrderProfiles;
