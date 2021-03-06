within BESMod.Systems.Hydraulical.Distribution.RecordsCollection.SimpleStorage;
partial record SimpleStorageBaseDataDefinition
  extends
    Systems.Hydraulical.Distribution.RecordsCollection.PartialStorageBaseDataDefinition(final
      use_HC1=true);

  parameter Modelica.Units.SI.Volume V_HE=lengthHC1*(pipeHC1.d_i/2)^2*Modelica.Constants.pi
    "heat exchanger volume based on pipe length and diameter"
    annotation (Dialog(group="Loading"));
  parameter Modelica.Units.SI.CoefficientOfHeatTransfer k_HE=QHC1_flow_nominal/
      (A_HE*max(dTLoadingHC1, dTLoaMin))
    "heat exchanger heat transfer coefficient"
    annotation (Dialog(group="Loading"));
  parameter Modelica.Units.SI.Area A_HE=lengthHC1*((pipeHC1.d_i + pipeHC1.d_o)/
      2)*Modelica.Constants.pi
    "heat exchanger area based on length and average diameter"
    annotation (Dialog(group="Loading"));
  parameter Modelica.Units.SI.RelativePressureCoefficient beta;
  parameter Real kappa;

end SimpleStorageBaseDataDefinition;
