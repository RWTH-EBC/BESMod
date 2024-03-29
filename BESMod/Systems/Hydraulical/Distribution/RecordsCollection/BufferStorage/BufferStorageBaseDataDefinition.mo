within BESMod.Systems.Hydraulical.Distribution.RecordsCollection.BufferStorage;
record BufferStorageBaseDataDefinition
  extends
    Systems.Hydraulical.Distribution.RecordsCollection.PartialStorageBaseDataDefinition;

  // Heating rod:
  parameter Boolean use_hr=false annotation (Dialog(group="Heating Rod"));
  parameter Modelica.Units.SI.Power QHR_flow_nominal=0
    annotation (Dialog(group="Heating Rod"));
  parameter Integer nLayerHR = integer(floor(nLayer/2)) "Layer of heating rod" annotation (Dialog(group="Heating Rod"));
  parameter Integer discretizationStepsHR=0 "Number of steps to dicretize the heating rod. =0 modulating, =1 resembels an on-off controller. =2 would sample 0, 0.5 and 1" annotation (Dialog(group="Heating Rod"));
  // Heating coil 2:
  parameter Boolean use_HC2 "=false to disable heating coil 2"  annotation (Dialog(group="Loading"));
  parameter Modelica.Units.SI.TemperatureDifference dTLoadingHC2
    "Temperature difference for loading of first heating coil"
    annotation (Dialog(group="Loading", enable=use_HC2));
  parameter Real fHeiHC2=1 "Percentage of the storage height used for the heating coil" annotation (Dialog(group="Loading", enable=use_HC2));
  parameter Real fDiaHC2=1 "Percentage of the storage diameter used for the heating coil" annotation (Dialog(group="Loading", enable=use_HC2));
  parameter Modelica.Units.SI.HeatFlowRate QHC2_flow_nominal=Q_flow_nominal
    "Nominal heat flow rate in first heating coil"
    annotation (Dialog(group="Loading", enable=use_HC2));
  parameter Modelica.Units.SI.Length lengthHC2=floor((h*fHeiHC2/pipeHC2.d_o))*
      pipeHC2.d_o/sin(atan(pipeHC2.d_o/(d*fDiaHC2))) "Lenght of first HC"
    annotation (Dialog(
      tab="Calculated",
      group="Loading",
      enable=use_HC2));
  parameter Modelica.Units.SI.MassFlowRate mHC2_flow_nominal
    "Nominal mass flow rate of HC fluid"
    annotation (Dialog(group="Loading", enable=use_HC2));
  replaceable parameter AixLib.DataBase.Pipes.Copper.Copper_12x0_6 pipeHC2   constrainedby
    AixLib.DataBase.Pipes.PipeBaseDataDefinition                                                                                           "Type of Pipe for HC2" annotation (choicesAllMatching=true, Dialog(group="Loading", enable=use_HC2));
  parameter Modelica.Units.SI.CoefficientOfHeatTransfer hConHC2=(2/pipeHC2.d_i
       + 2/pipeHC2.d_o)/(((max(dTLoadingHC2, dTLoaMin)*2*Modelica.Constants.pi*
      lengthHC2)/QHC2_flow_nominal) - (1/pipeHC2.lambda*log(pipeHC2.d_o/pipeHC2.d_i)))
    "Model assumptions Coefficient of Heat Transfer HC2 <-> Heating Water"
    annotation (Dialog(
      tab="Calculated",
      group="Loading",
      enable=use_HC2));
  parameter Modelica.Units.SI.Velocity vHC2_nominal=mHC2_flow_nominal/(rho*(
      pipeHC2.d_i*Modelica.Constants.pi/2)^2)
    "Fluid velocity in pipe of HC 1 at nominal conditions" annotation (Dialog(
      tab="Calculated",
      group="Loading",
      enable=use_HC2));

end BufferStorageBaseDataDefinition;
