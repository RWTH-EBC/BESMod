within BESMod.Systems.RecordsCollection.ParameterStudy;
record NoStudy "Don't study anything"
  extends ParameterStudyBaseDefinition;
  annotation (Documentation(info="<html>
<p>
Model which should be used if no parameter study is needed.
</p>
</html>"));
end NoStudy;
