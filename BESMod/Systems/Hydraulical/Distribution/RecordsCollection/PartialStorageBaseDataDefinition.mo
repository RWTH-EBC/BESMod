within BESMod.Systems.Hydraulical.Distribution.RecordsCollection;
partial record PartialStorageBaseDataDefinition
  extends Modelica.Icons.Record;
  // Global parameters
  parameter Modelica.Units.SI.Density rho(displayUnit="kg/m3") = 1000
    "Density of liquid water";
  parameter Modelica.Units.SI.SpecificHeatCapacityAtConstantPressure c_p=4184
    "Heat capacity of water";
  parameter Modelica.Units.SI.HeatFlowRate Q_flow_nominal
    "Nominal heat flow rate";


  // Design
  parameter Real VPerQ_flow=23.5 "Litre per kW of nominal heat flow rate"  annotation (Dialog(group="Geometry"));
  parameter Real storage_H_dia_ratio = 2 "Storage tank height-diameter ration. SOURCE: Working Assumption of all paper before"  annotation (Dialog(group="Geometry"));
  parameter Integer nLayer = 4 "Number of layers in storage";
  parameter Modelica.Units.SI.Volume V=VPerQ_flow*Q_flow_nominal*1e-6
    "Volume of storage" annotation (Dialog(tab="Calculated", group="Geometry"));
  parameter Modelica.Units.SI.Diameter d=(V*4/(storage_H_dia_ratio*Modelica.Constants.pi))
      ^(1/3) "Diameter of storage"
    annotation (Dialog(tab="Calculated", group="Geometry"));
  parameter Modelica.Units.SI.Height h=d*storage_H_dia_ratio
    annotation (Dialog(tab="Calculated", group="Geometry"));

  // Heat transfer
  parameter Modelica.Units.SI.TemperatureDifference dTLoaMin=0.01
    "Minimal temperature difference for loading"
    annotation (Dialog(group="Loading"));
  parameter Boolean use_HC1 "=false to disable heating coil 1"  annotation (Dialog(group="Loading"));
  parameter Modelica.Units.SI.TemperatureDifference dTLoadingHC1
    "Temperature difference for loading of first heating coil"
    annotation (Dialog(group="Loading", enable=use_HC1));
  parameter Real fHeiHC1=1 "Percentage of the storage height used for the heating coil" annotation (Dialog(group="Loading", enable=use_HC1));
  parameter Real fDiaHC1=1 "Percentage of the storage diameter used for the heating coil" annotation (Dialog(group="Loading", enable=use_HC1));
  parameter Modelica.Units.SI.HeatFlowRate QHC1_flow_nominal=Q_flow_nominal
    "Nominal heat flow rate in first heating coil"
    annotation (Dialog(group="Loading", enable=use_HC1));
  parameter Modelica.Units.SI.Length lengthHC1=floor((h*fHeiHC1/pipeHC1.d_o))*
      pipeHC1.d_o/sin(atan(pipeHC1.d_o/(d*fDiaHC1))) "Lenght of first HC"
    annotation (Dialog(
      tab="Calculated",
      group="Loading",
      enable=use_HC1));
  parameter Modelica.Units.SI.MassFlowRate mHC1_flow_nominal
    "Nominal mass flow rate of HC fluid"
    annotation (Dialog(group="Loading", enable=use_HC1));
  replaceable parameter AixLib.DataBase.Pipes.Copper.Copper_12x0_6 pipeHC1 constrainedby
    AixLib.DataBase.Pipes.PipeBaseDataDefinition                                                                                         "Type of Pipe for HC1" annotation (choicesAllMatching=true, Dialog(group="Loading", enable=use_HC1));
  parameter Modelica.Units.SI.CoefficientOfHeatTransfer hConHC1=(2/pipeHC1.d_o)
      /(((max(dTLoadingHC1, dTLoaMin)*2*Modelica.Constants.pi*lengthHC1)/
      QHC1_flow_nominal) - (1/pipeHC1.lambda*log(pipeHC1.d_o/pipeHC1.d_i)))
    "Model assumptions Coefficient of Heat Transfer HC1 <-> Heating Water"
    annotation (Dialog(
      tab="Calculated",
      group="Loading",
      enable=use_HC1));
  parameter Modelica.Units.SI.Velocity vHC1_nominal=mHC1_flow_nominal/(rho*(
      pipeHC1.d_i*Modelica.Constants.pi/2)^2)
    "Fluid velocity in pipe of HC 1 at nominal conditions" annotation (Dialog(
      tab="Calculated",
      group="Loading",
      enable=use_HC1));

  // Heat losses

  parameter
    BESMod.Systems.Hydraulical.Distribution.Types.EnergyLabel
    EnergyLabel "Level of Storage Tank Insulation" annotation (Dialog(
      group="Insulation"));


      parameter Real QLosPerDay=if  EnergyLabel==
      Systems.Hydraulical.Distribution.Types.EnergyLabel.labelAPlus then (5.5+3.16*(V*1000)^(0.4))*0.024
       elseif EnergyLabel == Systems.Hydraulical.Distribution.Types.EnergyLabel.labelA
       then (7+ 3.705*(V*1000)^(0.4))*0.024 elseif EnergyLabel == Systems.Hydraulical.Distribution.Types.EnergyLabel.labelB
       then (10.25 + 5.09*(V*1000)^(0.4))*0.024 elseif EnergyLabel == Systems.Hydraulical.Distribution.Types.EnergyLabel.labelC
       then (14.33+ 7.13 *(V*1000)^(0.4))*0.024 elseif EnergyLabel == Systems.Hydraulical.Distribution.Types.EnergyLabel.labelD
       then (18.83 + 9.33*(V*1000)^(0.4))*0.024 elseif EnergyLabel == Systems.Hydraulical.Distribution.Types.EnergyLabel.labelE
       then (23.5 + 11.995*(V*1000)^(0.4))*0.024 elseif EnergyLabel == Systems.Hydraulical.Distribution.Types.EnergyLabel.labelF
       then (28.5+ 15.16*(V*1000)^(0.4))*0.024 elseif EnergyLabel == Systems.Hydraulical.Distribution.Types.EnergyLabel.labelG
       then (31 + 16.66*(V*1000)^(0.4))*0.024
       else 0
      "Heat loss per day. MUST BE IN kWh/d";

  parameter Modelica.Units.SI.Temperature T_m
    "Average storage temperature. Used to calculate default heat loss"
    annotation (Dialog(group="Insulation"));
  parameter Modelica.Units.SI.Temperature TAmb
    "Ambient temperature. Used to calculate default heat loss"
    annotation (Dialog(group="Insulation"));
  parameter Boolean use_QLos=false   "=true to use QLosPerDay instead of TLosPerDay" annotation (Dialog(group="Insulation"));

  parameter Real TLosPerDay=1 "Temperature decline per day in K/d" annotation (Dialog(enable=not use_QLos, group="Insulation"));
  parameter Modelica.Units.SI.CoefficientOfHeatTransfer hConIn=100
    "Model assumptions heat transfer coefficient water <-> wall"
    annotation (Dialog(group="Insulation"));
  parameter Modelica.Units.SI.CoefficientOfHeatTransfer hConOut=10
    "Model assumptions heat transfer coefficient insulation <-> air"
    annotation (Dialog(group="Insulation"));
  parameter Modelica.Units.SI.ThermalConductivity lambda_ins=0.045
    "thermal conductivity of insulation"
    annotation (tab="Calculated", Dialog(group="Insulation"));
  parameter Modelica.Units.SI.HeatFlowRate QLoss_flow=if use_QLos then
      QLosPerDay/24*1000 else rho*c_p*V*TLosPerDay/(86400)
    "Actual heat flow rate loss"
    annotation (Dialog(tab="Calculated", group="Insulation"));
  parameter Modelica.Units.SI.Thickness sIns=
      Modelica.Math.Nonlinear.solveOneNonlinearEquation(
      function
        BESMod.Systems.Hydraulical.Distribution.RecordsCollection.GetStorageInsulation(
        QLoss_flow=QLoss_flow,
        dT_loss=T_m - TAmb,
        hConOut=hConOut,
        hConIn=hConIn,
        lambda_ins=lambda_ins,
        d=d,
        h=h),
      1e-5,
      10) "thickness of insulation" annotation (Dialog(group="Insulation"));

 annotation (Icon(graphics,
                  coordinateSystem(preserveAspectRatio=false)), Diagram(graphics,
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p><img src=\"modelica://BESMod/Resources/Images/equations/heatTraNLayerWall.png\"/></p>
</html>"));
end PartialStorageBaseDataDefinition;
