within BESMod.Systems.Ventilation.Control;
model SummerPIDByPass "Bypass the HEX in summer"
  extends BaseClasses.PartialControl;
  parameter Boolean use_bypass = true "=false to disable the bypass";

  Components.SummerByPass                     summerByPass
                                        if use_bypass
    annotation (Placement(transformation(extent={{-30,-14},{22,36}})));
  Modelica.Blocks.Sources.Constant constZero(k=0) if not use_bypass
    "Bypass is not used"
    annotation (Placement(transformation(extent={{-6,-54},{14,-34}})));

  Modelica.Blocks.Math.MinMax minMaxMea(final nu=distributionParameters.nParallelDem)
    annotation (Placement(transformation(extent={{-88,32},{-68,52}})));
  Modelica.Blocks.Sources.Constant constZero1(k=distributionParameters.TDem_nominal[
        1])
    "Bypass is not used"
    annotation (Placement(transformation(extent={{-82,-30},{-62,-10}})));
equation
  connect(summerByPass.TOda, weaBus.TDryBul) annotation (Line(points={{-35.2,26},
          {-44,26},{-44,68},{1,68},{1,98}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(constZero.y, sigBusGen.uByPass) annotation (Line(
      points={{15,-44},{60,-44},{60,-100}},
      color={0,0,127},
      pattern=LinePattern.Dash), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(summerByPass.y, sigBusGen.uByPass) annotation (Line(points={{24.6,11},
          {60,11},{60,-100}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(minMaxMea.u, buiMeaBus.TZoneMea) annotation (Line(points={{-88,42},{-104,
          42},{-104,79},{-102,79}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(minMaxMea.yMax, summerByPass.TMea) annotation (Line(points={{-67,48},{
          -52,48},{-52,11},{-35.2,11}}, color={0,0,127}));
  connect(summerByPass.TZoneSet, constZero1.y) annotation (Line(points={{-35.2,
          -4},{-34,-4},{-34,-20},{-61,-20}}, color={0,0,127}));
end SummerPIDByPass;
