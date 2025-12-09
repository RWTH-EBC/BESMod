within BESMod.Systems.UserProfiles.Tests;
partial model PartialTest "Partial Test model"
  replaceable BaseClasses.PartialUserProfiles userProfiles constrainedby
    BaseClasses.PartialUserProfiles annotation (Placement(transformation(extent=
           {{-50,-54},{48,44}})), choicesAllMatching=true);
  IBPSA.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
        Modelica.Utilities.Files.loadResource(
        "modelica://BESMod/Resources/WeatherData/TRY2015_522361130393_Jahr_City_Potsdam.mos"))
    "Weather data reader"
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
equation
  connect(weaDat.weaBus, userProfiles.weaBus) annotation (Line(
      points={{-60,-70},{-1,-70},{-1,-52.775}},
      color={255,204,51},
      thickness=0.5));
  annotation (experiment(
      StopTime=86400,
      Interval=1,
      __Dymola_Algorithm="Dassl"));
end PartialTest;
