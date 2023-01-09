within BESMod.Examples.TestControlStrategiesGridConnection;
model Parameter_fit_control
  extends Systems.Hydraulical.Control.BaseClasses.PartialControl;

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

end Parameter_fit_control;
