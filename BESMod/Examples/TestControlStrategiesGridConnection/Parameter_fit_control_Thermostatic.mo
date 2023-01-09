within BESMod.Examples.TestControlStrategiesGridConnection;
model Parameter_fit_control_Thermostatic
  extends
    BESMod.Systems.Hydraulical.Control.BaseClasses.SystemWithThermostaticValveControl;

  replaceable
    Systems.Hydraulical.Control.Components.DHWSetControl.BaseClasses.PartialTSet_DHW_Control
    TSet_DHW constrainedby
    Systems.Hydraulical.Control.Components.DHWSetControl.BaseClasses.PartialTSet_DHW_Control(
      final T_DHW=distributionParameters.TDHW_nominal) annotation (
      choicesAllMatching=true, Placement(transformation(extent={{-154,24},{-130,
            48}})));
  Utilities.SupervisoryControl.SupervisoryControl        supervisoryControlDHW(ctrlType=
        supCtrlTypeDHWSet)
    annotation (Placement(transformation(extent={{-20,34},{4,56}})));
    parameter BESMod.Utilities.SupervisoryControl.Types.SupervisoryControlType
    supCtrlTypeDHWSet=BESMod.Utilities.SupervisoryControl.Types.SupervisoryControlType.Local
    "Type of supervisory control for DHW Setpoint";

   replaceable parameter
    Systems.Hydraulical.Control.RecordsCollection.BivalentHeatPumpControlDataDefinition
    bivalentControlData constrainedby
    Systems.Hydraulical.Control.RecordsCollection.BivalentHeatPumpControlDataDefinition(
    final TOda_nominal=generationParameters.TOda_nominal,
    TSup_nominal=generationParameters.TSup_nominal[1],
    TSetRoomConst=sum(transferParameters.TDem_nominal)/transferParameters.nParallelDem);

  Modelica.Blocks.Math.Add add_dT_LoadingDHW
    annotation (Placement(transformation(extent={{46,30},{64,48}})));
  Modelica.Blocks.Sources.Constant const_dT_loading2(k=distributionParameters.dTTraDHW_nominal
         + bivalentControlData.dTHysDHW/2) annotation (Placement(transformation(
        extent={{6,-6},{-6,6}},
        rotation=180,
        origin={26,34})));
    Systems.Hydraulical.Control.Components.HeatPumpNSetController.PI_InverterHeatPumpController
    HP_nSet_Controller_winter_mode(
    P=bivalentControlData.k,
    nMin=bivalentControlData.nMin,
    T_I=bivalentControlData.T_I)   annotation (choicesAllMatching=true,
      Placement(transformation(extent={{92,10},{130,46}})));
  Modelica.Blocks.Sources.BooleanStep                   booleanStep(startTime=
       86400, startValue=false)
    annotation (Placement(transformation(extent={{-18,-10},{2,10}})));
  Modelica.Blocks.Sources.Constant constZero(final k=0) annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-186,-66})));
  Modelica.Blocks.Logical.Not bufOn "buffer is charged" annotation (Placement(
        transformation(
        extent={{-5,-5},{5,5}},
        rotation=270,
        origin={-67,-1})));
  Modelica.Blocks.Math.BooleanToReal booleanToReal annotation (Placement(
        transformation(
        extent={{-7,-7},{7,7}},
        rotation=270,
        origin={-67,-31})));
  Modelica.Blocks.Sources.Constant constZero1(final k=1)
                                                        annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-192,-36})));
equation
  connect(const_dT_loading2.y, add_dT_LoadingDHW.u2) annotation (Line(points={{32.6,
          34},{40,34},{40,33.6},{44.2,33.6}}, color={0,0,127}));
  connect(supervisoryControlDHW.y, add_dT_LoadingDHW.u1) annotation (Line(
        points={{6.4,45},{25.5,45},{25.5,44.4},{44.2,44.4}}, color={0,0,127}));
  connect(add_dT_LoadingDHW.y, HP_nSet_Controller_winter_mode.T_Set)
    annotation (Line(points={{64.9,39},{64.9,38.8},{88.2,38.8}}, color={0,0,127}));
  connect(HP_nSet_Controller_winter_mode.T_Meas, sigBusGen.THeaPumOut)
    annotation (Line(points={{111,6.4},{110,6.4},{110,-66},{-152,-66},{-152,-99}},
        color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(TSet_DHW.TSet_DHW, supervisoryControlDHW.uLoc) annotation (Line(
        points={{-128.8,36},{-32,36},{-32,36.2},{-22.4,36.2}}, color={0,0,127}));
  connect(sigBusHyd.TSetDHW, supervisoryControlDHW.uSup) annotation (Line(
      points={{-28,101},{-22.4,101},{-22.4,53.8}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(supervisoryControlDHW.actInt, sigBusHyd.overwriteTSetDHW) annotation (
     Line(points={{-22.4,45},{-28,45},{-28,101}}, color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(HP_nSet_Controller_winter_mode.n_Set, sigBusGen.yHeaPumSet)
    annotation (Line(points={{131.9,28},{148,28},{148,-66},{-152,-66},{-152,-99}},
        color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(sigBusDistr, TSet_DHW.sigBusDistr) annotation (Line(
      points={{1,-100},{0,-100},{0,-118},{-254,-118},{-254,35.88},{-154,35.88}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));

  connect(booleanStep.y, HP_nSet_Controller_winter_mode.HP_On) annotation (
      Line(points={{3,0},{78,0},{78,28},{88.2,28}}, color={255,0,255}));
  connect(booleanStep.y, HP_nSet_Controller_winter_mode.IsOn)
    annotation (Line(points={{3,0},{99.6,0},{99.6,6.4}}, color={255,0,255}));
  connect(constZero.y, sigBusGen.uHeaRod) annotation (Line(points={{-175,-66},
          {-152,-66},{-152,-99}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  connect(TSet_DHW.y, bufOn.u) annotation (Line(points={{-128.8,29.04},{
          -128.8,28},{-67,28},{-67,5}}, color={255,0,255}));
  connect(bufOn.y, booleanToReal.u)
    annotation (Line(points={{-67,-6.5},{-67,-22.6}}, color={255,0,255}));
  connect(booleanToReal.y, sigBusDistr.uThrWayVal) annotation (Line(points={{
          -67,-38.7},{-67,-58},{1,-58},{1,-100}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(constZero1.y, sigBusGen.uPump) annotation (Line(points={{-181,-36},
          {-166,-36},{-166,-32},{-152,-32},{-152,-99}}, color={0,0,127}),
      Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
end Parameter_fit_control_Thermostatic;
