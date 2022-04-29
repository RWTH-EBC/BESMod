within BESMod.Systems.UserProfiles.Tests;
partial model PartialTest "Partial Test model"
  extends Modelica.Icons.Example;
  replaceable BaseClasses.PartialUserProfiles userProfiles
    constrainedby BaseClasses.PartialUserProfiles(final systemParameters=
        systemParameters) annotation (Placement(transformation(extent={{-50,-54},
            {48,44}})), choicesAllMatching=true);
  replaceable RecordsCollection.SystemParametersBaseDataDefinition
    systemParameters constrainedby
    RecordsCollection.SystemParametersBaseDataDefinition annotation (Placement(
        transformation(extent={{-98,-98},{-78,-78}})), choicesAllMatching=true);
  annotation (experiment(
      StopTime=86400,
      Interval=1,
      __Dymola_Algorithm="Dassl"));
end PartialTest;
