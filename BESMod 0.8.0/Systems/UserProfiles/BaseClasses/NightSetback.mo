within BESMod.Systems.UserProfiles.BaseClasses;
block NightSetback
  "Generate pulse signal for night setback, possibly depending on outdoor air temperature"
  parameter Modelica.Units.SI.TemperatureDifference dTSetBack=0
    "Temperature difference of set-back";
  parameter Modelica.Units.SI.Time startTimeSetBack(displayUnit="h")=79200
                                                      "Start time of set back";
  parameter Modelica.Units.SI.Time timeSetBack(displayUnit="h", min=0)=28800
    "Number of hours the set-back lasts, maximum 24";
  parameter Modelica.Units.SI.Temperature TZone_nominal=293.15 "Nominal zone temperature";

  parameter Boolean useTOda=true "=false to disable outdoor air check";
  parameter Modelica.Units.SI.Temperature TOdaMin=253.15
    "Minimal outdoor air temperature below which no setback is performed"
    annotation(Dialog(enable=useTOda));

  parameter Modelica.Units.SI.Time period(
    min=Modelica.Constants.small,
    start=1)=86400   "Time for one period" annotation(Dialog(tab="Advanced"));
  parameter Integer nperiod=-1
    "Number of periods (< 0 means infinite number of periods)"
    annotation(Dialog(tab="Advanced"));
  extends Modelica.Blocks.Interfaces.SignalSource(
    final offset=TZone_nominal, final startTime=startTimeSetBack,
    y(unit="K", displayUnit="degC"));
  Modelica.Blocks.Interfaces.RealInput TOda(final unit="K", final displayUnit="degC")
    if useTOda
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Sources.Constant constTOda(final k=TOdaMin + 1, y(unit="K"))
    if not useTOda "Constant outdoor air temperature"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Modelica.Blocks.Routing.RealPassThrough TOda_internal(y(unit="K"))
    "Used outdoor air temperature"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
protected
  Modelica.Units.SI.Time T_width=period*(100*timeSetBack/3600/24)/100;
  Modelica.Units.SI.Time T_start "Start time of current period";
  Integer count "Period count";
  Modelica.Units.SI.TemperatureDifference dTSetBackApp;
initial algorithm
  count := integer((time - startTime)/period);
  T_start := startTime + count*period;
  dTSetBackApp := dTSetBack;
equation
  when integer((time - startTime)/period) > pre(count) then
    count = pre(count) + 1;
    T_start = time;
    if TOda_internal.y > TOdaMin then
      dTSetBackApp = dTSetBack;
    else
      dTSetBackApp = 0;
    end if;
  end when;
  y = offset + (if (time < startTime or nperiod == 0 or (nperiod > 0 and
    count >= nperiod)) then 0 else if time < T_start + T_width then -dTSetBackApp
     else 0);
  connect(TOda_internal.u, TOda)
    annotation (Line(points={{-42,0},{-120,0}}, color={0,0,127}));
  connect(TOda_internal.u, constTOda.y) annotation (Line(points={{-42,0},{-54,0},
          {-54,-30},{-59,-30}}, color={0,0,127}));
  annotation (
    Icon(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}), graphics={
        Line(points={{-80,68},{-80,-80}}, color={192,192,192}),
        Polygon(
          points={{-80,90},{-88,68},{-72,68},{-80,90}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-90,-70},{82,-70}}, color={192,192,192}),
        Polygon(
          points={{90,-70},{68,-62},{68,-78},{90,-70}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-80,-70},{-40,-70},{-40,44},{0,44},{0,-70},{40,-70},{40,
              44},{79,44}}),
        Text(
          extent={{-147,-152},{153,-112}},
          textString="period=%period")}),
    Documentation(info="<html>
<p>
Model for night setback pulse, which is deactivated if the outdoor air temperature at the start of the scheduled setback is lower than a pre-defined threshold <code>TOdaMin</code>.
</p>
</html>"));
end NightSetback;
