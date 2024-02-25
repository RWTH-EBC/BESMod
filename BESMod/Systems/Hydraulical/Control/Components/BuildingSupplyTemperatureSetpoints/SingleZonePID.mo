within BESMod.Systems.Hydraulical.Control.Components.BuildingSupplyTemperatureSetpoints;
model SingleZonePID
  "Single zone PID controller"
  extends BaseClasses.PartialSetpoint(nZones=1);

  replaceable parameter RecordsCollection.PIDBaseDataDefinition parPID
    constrainedby RecordsCollection.PIDBaseDataDefinition "PID parameters"
    annotation (choicesAllMatching=true, Placement(transformation(extent={{42,22},
            {58,38}})));
  Modelica.Blocks.Continuous.LimPID PI(
    final controllerType=Modelica.Blocks.Types.SimpleController.PI,
    final k=parPID.P,
    final Ti=parPID.timeInt*parPID.P,
    final Td=parPID.timeDer/parPID.P,
    final yMax=parPID.yMax,
    final yMin=parPID.yMin,
    final wp=1,
    final Ni=parPID.Ni,
    final Nd=parPID.Nd,
    y_start=parPID.y_start,
    homotopyType=Modelica.Blocks.Types.LimiterHomotopy.NoHomotopy)
                        "PI control"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
initial equation
  assert(nZones==1, "Model only supports single zones", AssertionLevel.error);
equation
  connect(PI.y, TSet) annotation (Line(points={{11,0},{110,0}}, color={0,0,127}));
  connect(PI.u_s, TZoneSet[1]) annotation (Line(points={{-12,0},{-30,0},{-30,-80},
          {-120,-80}}, color={0,0,127}));
  connect(PI.u_m, TZoneMea[1]) annotation (Line(points={{0,-12},{0,-32},{-70,-32},
          {-70,80},{-120,80}}, color={0,0,127}));
end SingleZonePID;
