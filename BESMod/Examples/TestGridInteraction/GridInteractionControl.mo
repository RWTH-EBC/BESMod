within BESMod.Examples.TestGridInteraction;
model GridInteractionControl
  "Basic gird interaction control (implementing of EVU-Sperre)"
  extends Systems.Control.BaseClasses.PartialControl;

 // parameter Real HP_EVU_blocking "Variable to store if the HP is allowed to operate or not (depending on the hour of the day, the EVU-Sperre intervents)";

parameter String filNam="D:/fwu-nmu/BESMod/table_EVU_Sperre_1.txt" "Name of weather data file" annotation (
    Dialog(loadSelector(filter="Weather files (*.mos)",
                        caption="Select weather file")));
protected
  final parameter Modelica.Units.SI.Time[2] timeSpan=
      IBPSA.BoundaryConditions.WeatherData.BaseClasses.getTimeSpanTMY3(filNam,
      "tab1") "Start time, end time of weather data";
  Modelica.Blocks.Tables.CombiTable1Ds datRea(
    final tableOnFile=true,
    table=[1,1; 1,2; 1,3; 1,4; 1,5; 1,6; 1,7; 1,8; 0,9; 0,10; 0,11; 1,12; 1,13;
        1,14; 1,15; 1,16; 0,17; 0,18; 0,19; 1,20; 1,21; 1,22; 1,23; 1,24],
    final tableName="tab1",
    final fileName="D:/fwu-nmu/BESMod/table_EVU_Sperre_test.txt",
    verboseRead=false,
    final smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments)
    "Data reader"
    annotation (Placement(transformation(extent={{16,22},{36,42}})));
  IBPSA.BoundaryConditions.WeatherData.BaseClasses.ConvertTime conTim(final
      weaDatStaTim=timeSpan[1], final weaDatEndTim=timeSpan[2])
    "Convert simulation time to calendar time"
    annotation (Placement(transformation(extent={{-30,22},{-10,42}})));
  IBPSA.Utilities.Time.ModelTime modTim "Model time"
    annotation (Placement(transformation(extent={{-80,22},{-60,42}})));
equation
  connect(conTim.modTim, modTim.y)
    annotation (Line(points={{-32,32},{-59,32}}, color={0,0,127}));
  connect(conTim.calTim, datRea.u)
    annotation (Line(points={{-9,32},{14,32}},             color={0,0,127}));
  connect(datRea.y[1], sigBusHyd.HP_mode_EVU_Sperre) annotation (Line(points=
          {{37,32},{70,32},{70,-82},{-79,-82},{-79,-101}}, color={0,0,127}),
      Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
end GridInteractionControl;
