within BESMod.Systems.UserProfiles;
model TEASERInputsStoIntGai
  "TEASER inputs with option for stochastic internal gains"
  extends BESMod.Systems.UserProfiles.TEASERProfiles(gain={1,0,0});
  parameter String fileNameElePro=Modelica.Utilities.Files.loadResource(
      "modelica://BESMod/Resources/custom_inputs.txt")
    "File name for elecricity profiles"
    annotation(Dialog(enable=use_absIntGai));

  parameter Real fac_conv = (0.5 + 0.75) / 2 "TEASER uses 0.75 for machines and 0.5 for lights. As the electricity profiles
  // do not specify the type, we assume the average of both." annotation(Dialog(enable=use_absIntGai));
  parameter Boolean use_absIntGai=true
    "=true to use stochastic electricity profiles";
  Modelica.Blocks.Sources.CombiTimeTable tabGaiLigMach(
    final tableOnFile=true,
    final extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    final tableName="ElectricityGains",
    final fileName=fileNameElePro,
    columns={2}) if use_absIntGai
     "Profiles for internal gains of machines and lights in W"
    annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-10,-10})));
  Modelica.Blocks.Math.Gain gainElePro[2](k={fac_conv,1 - fac_conv})
    if use_absIntGai
    "Gain for electricity profiles, (convective, radiative)" annotation (
      Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={30,-10})));
equation
  connect(gainElePro[2].y, useProBus.absIntGaiRad) annotation (Line(points={{41,
          -10},{80,-10},{80,-1},{115,-1}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(gainElePro[1].y, useProBus.absIntGaiConv) annotation (Line(points={{
          41,-10},{90,-10},{90,-1},{115,-1}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(gainElePro[1].u, tabGaiLigMach.y[1])
    annotation (Line(points={{18,-10},{1,-10}}, color={0,0,127}));
  connect(tabGaiLigMach.y[1], gainElePro[2].u)
    annotation (Line(points={{1,-10},{18,-10}}, color={0,0,127}));
end TEASERInputsStoIntGai;
