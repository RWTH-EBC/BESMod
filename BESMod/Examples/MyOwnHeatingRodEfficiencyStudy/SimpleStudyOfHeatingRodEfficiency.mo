within BESMod.Examples.MyOwnHeatingRodEfficiencyStudy;
record SimpleStudyOfHeatingRodEfficiency
  extends
    Systems.RecordsCollection.ParameterStudy.ParameterStudyBaseDefinition;

  parameter Real efficiceny_heating_rod = 1 annotation(Evaluate=false);

end SimpleStudyOfHeatingRodEfficiency;
