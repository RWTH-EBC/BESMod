within BESMod.Systems.UserProfiles;
model Case600Profiles "Case600FF profiles"
  extends BaseClasses.PartialUserProfiles;

  Modelica.Blocks.Sources.Constant const[nZones](final k=
        TSetZone_nominal)                  "Profiles for internal gains"
    annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-90,-70})));
  Modelica.Blocks.Sources.Constant qLatGai_flow(k=0) "Latent heat gain"
    annotation (Placement(transformation(extent={{-100,0},{-80,20}})));
  Modelica.Blocks.Sources.Constant qConGai_flow(k=80/48) "Convective heat gain"
    annotation (Placement(transformation(extent={{-100,28},{-80,48}})));
  Modelica.Blocks.Sources.Constant qRadGai_flow(k=120/48) "Radiative heat gain"
    annotation (Placement(transformation(extent={{-100,60},{-80,80}})));
  Modelica.Blocks.Routing.Multiplex3 multiplex3_1
    "Multiplex for internal gains"
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));
  Modelica.Blocks.Sources.Constant uSha(k=0)
    "Control signal for the shading device"
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
equation
  connect(const.y, useProBus.TZoneSet) annotation (Line(points={{-79,-70},{115,
          -70},{115,-1}},     color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(qConGai_flow.y,multiplex3_1. u2[1]) annotation (Line(
      points={{-79,38},{-34,38},{-34,30},{-22,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(qLatGai_flow.y,multiplex3_1. u3[1])  annotation (Line(
      points={{-79,10},{-22,10},{-22,23}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(qRadGai_flow.y,multiplex3_1. u1[1])  annotation (Line(
      points={{-79,70},{-30,70},{-30,37},{-22,37}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(multiplex3_1.y, useProBus.intGains) annotation (Line(points={{1,30},{
          74,30},{74,-1},{115,-1}},
                              color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(uSha.y, useProBus.uSha) annotation (Line(points={{-19,-10},{74,-10},{
          74,-1},{115,-1}},
                     color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
end Case600Profiles;
