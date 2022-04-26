within BESMod.Systems.UserProfiles;
model NoUser "No user"
  extends BaseClasses.PartialUserProfiles;

  parameter Real T_const "Constant outdoor air temperature";

  Modelica.Blocks.Sources.Constant constZero[3](each k=0)
    annotation (Placement(transformation(extent={{-14,-20},{24,18}})));
  Modelica.Blocks.Sources.Constant constTDHW(k=systemParameters.TDHWWaterCold)
    annotation (Placement(transformation(extent={{-14,-82},{26,-42}})));
  Modelica.Blocks.Sources.Constant constZeroMFlow(k=0)
    annotation (Placement(transformation(extent={{-14,40},{20,74}})));
  Modelica.Blocks.Sources.Constant const[systemParameters.nZones](k=
        systemParameters.TSetZone_nominal) "Profiles for internal gains"
    annotation (Placement(transformation(
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
  connect(constZeroMFlow.y, useProBus.mDHWDemand_flow) annotation (Line(points=
          {{21.7,57},{115,57},{115,-1}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(constTDHW.y, useProBus.TDHWDemand) annotation (Line(points={{28,-62},
          {115,-62},{115,-1}}, color={0,0,127}), Text(
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
