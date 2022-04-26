within BESMod.Systems.UserProfiles;
model Case600Profiles "Case600FF profiles"
  extends BaseClasses.PartialUserProfiles;

  Modelica.Blocks.Sources.CombiTimeTable combiTimeTableDHWInput(
    final tableOnFile=systemParameters.use_dhwCalc,
    final table=systemParameters.DHWProfile.table,
    final tableName=systemParameters.tableName,
    final fileName=systemParameters.fileName,
    final columns=2:5,
    final smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    final extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic)
    "Read the input data from the given file. " annotation (Placement(visible=true,
        transformation(
        extent={{-14,-14},{14,14}},
        rotation=0,
        origin={-106,86})));
  Modelica.Blocks.Sources.Constant const[systemParameters.nZones](final k=
        systemParameters.TSetZone_nominal) "Profiles for internal gains"
    annotation (Placement(transformation(
        extent={{23,23},{-23,-23}},
        rotation=180,
        origin={-87,-45})));
  Modelica.Blocks.Sources.Constant qLatGai_flow(k=0) "Latent heat gain"
    annotation (Placement(transformation(extent={{-94,8},{-86,16}})));
  Modelica.Blocks.Sources.Constant qConGai_flow(k=80/48) "Convective heat gain"
    annotation (Placement(transformation(extent={{-114,36},{-106,44}})));
  Modelica.Blocks.Sources.Constant qRadGai_flow(k=120/48) "Radiative heat gain"
    annotation (Placement(transformation(extent={{-102,44},{-94,52}})));
  Modelica.Blocks.Routing.Multiplex3 multiplex3_1
    "Multiplex for internal gains"
    annotation (Placement(transformation(extent={{-36,24},{-12,48}})));
  Modelica.Blocks.Sources.Constant uSha(k=0)
    "Control signal for the shading device"
    annotation (Placement(transformation(extent={{-36,-10},{-14,12}})));
equation
  connect(combiTimeTableDHWInput.y[4], useProBus.TDHWDemand) annotation (Line(
        points={{-90.6,86},{115,86},{115,-1}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(combiTimeTableDHWInput.y[2], useProBus.mDHWDemand_flow) annotation (
      Line(points={{-90.6,86},{116,86},{116,42},{115,42},{115,-1}}, color={0,0,
          127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(const.y, useProBus.TZoneSet) annotation (Line(points={{-61.7,-45},{
          115,-45},{115,-1}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(qConGai_flow.y,multiplex3_1. u2[1]) annotation (Line(
      points={{-105.6,40},{-46,40},{-46,36},{-38.4,36}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(qLatGai_flow.y,multiplex3_1. u3[1])  annotation (Line(
      points={{-85.6,12},{-38.4,12},{-38.4,27.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(qRadGai_flow.y,multiplex3_1. u1[1])  annotation (Line(
      points={{-93.6,48},{-46,48},{-46,44.4},{-38.4,44.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(multiplex3_1.y, useProBus.intGains) annotation (Line(points={{-10.8,36},
          {115,36},{115,-1}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(uSha.y, useProBus.uSha) annotation (Line(points={{-12.9,1},{-12.9,-1},
          {115,-1}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
end Case600Profiles;
