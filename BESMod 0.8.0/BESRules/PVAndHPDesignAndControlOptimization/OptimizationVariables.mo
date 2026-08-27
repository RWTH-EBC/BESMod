within BESMod.BESRules.PVAndHPDesignAndControlOptimization;
record OptimizationVariables
  import BESRules;
  extends BESMod.BESRules.DesignOptimization.DesignOptimizationVariables;
  parameter Real f_design=1 "Share of PV Module area to half of the roof area (Gable Roof)" annotation (Evaluate=false);
  parameter Real BufOverheatdT=15 "Temperature increase of Buffer" annotation (Evaluate=false);
  parameter Real DHWOverheatTemp=333.15 "Overheat Temperature of DHW storage" annotation (Evaluate=false);
  parameter Real ShareOfPEleNominal=1 "Share of PEleNominal for the threshold of the PV hysteresis (1=100%)" annotation (Evaluate=false);

end OptimizationVariables;
