within BESMod.Examples.SolarThermalSystem;
record SolarThermalDesignOptimization
  extends Systems.RecordsCollection.ParameterStudy.ParameterStudyBaseDefinition;

  parameter Modelica.SIunits.Area A=15
                                    "Area of solar collector";
  parameter Modelica.SIunits.Volume V=0.5 "Volume of storage";

  parameter Modelica.SIunits.Efficiency eta_zero=0.75   "Conversion factor/Efficiency at Q = 0";
  parameter Real c1=2                   "Loss coefficient c1";
  parameter Real c2=0.005                 "Loss coefficient c2";
annotation(Evaluate=false);
end SolarThermalDesignOptimization;
