within BESMod.Systems.UserProfiles;
model NoUser "No user"
  extends BaseClasses.PartialUserProfiles;

  Modelica.Blocks.Sources.Constant constZero[3](each k=0)
    annotation (Placement(transformation(extent={{-14,-20},{24,18}})));
  Modelica.Blocks.Sources.Constant const[nZones](k=TSetZone_nominal)
    "Profiles for internal gains" annotation (Placement(transformation(
        extent={{23,23},{-23,-23}},
        rotation=180,
        origin={-93,-31})));
equation
  connect(constZero.y, useProBus.intGains) annotation (Line(points={{25.9,-1},{115,
          -1},{115,-1}},                 color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(const.y, useProBus.TZoneSet) annotation (Line(points={{-67.7,-31},{74,
          -31},{74,-1},{115,-1}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
end NoUser;
