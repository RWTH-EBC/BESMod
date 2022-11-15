within BESMod.Systems.Demand.Building;
model BuildingsRoomCase600FF
  "Detailed room model from the buildings library according to BESTEST Case600FF"
  extends BaseClasses.PartialDemand(
    ARoo=roo.AFlo*sqrt(2),
    hBui=roo.hRoo,
    hZone={roo.hRoo},
    ABui=roo.AFlo,
    AZone={roo.AFlo},
    nZones=1);
  parameter Modelica.Units.SI.TemperatureDifference dTComfort=2
    "Temperature difference to room set temperature at which the comfort is still acceptable. In DIN EN 15251, all temperatures below 22 °C - 2 K count as discomfort. Hence the default value. If your room set temperature is lower, consider using smaller values.";

  parameter Real natInf = 0.5 "Infiltration rate";
  parameter Modelica.Units.SI.Angle S_=Buildings.Types.Azimuth.S
    "Azimuth for south walls";
  parameter Modelica.Units.SI.Angle E_=Buildings.Types.Azimuth.E
    "Azimuth for east walls";
  parameter Modelica.Units.SI.Angle W_=Buildings.Types.Azimuth.W
    "Azimuth for west walls";
  parameter Modelica.Units.SI.Angle N_=Buildings.Types.Azimuth.N
    "Azimuth for north walls";
  parameter Modelica.Units.SI.Angle C_=Buildings.Types.Tilt.Ceiling
    "Tilt for ceiling";
  parameter Modelica.Units.SI.Angle F_=Buildings.Types.Tilt.Floor
    "Tilt for floor";
  parameter Modelica.Units.SI.Angle Z_=Buildings.Types.Tilt.Wall
    "Tilt for wall";
  parameter Integer nConExtWin = 1 "Number of constructions with a window";
  parameter Integer nConBou = 1
    "Number of surface that are connected to constructions that are modeled inside the room";
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Type of energy balance for zone air: dynamic (3 initialization options) or steady state";
  parameter Modelica.Fluid.Types.Dynamics massDynamics=energyDynamics
    "Type of mass balance for zone air: dynamic (3 initialization options) or steady state";
  parameter Buildings.HeatTransfer.Data.OpaqueConstructions.Generic matExtWal(
    nLay=3,
    absIR_a=0.9,
    absIR_b=0.9,
    absSol_a=0.6,
    absSol_b=0.6,
    material={Buildings.HeatTransfer.Data.Solids.Generic(
        x=0.009,
        k=0.140,
        c=900,
        d=530,
        nStaRef=Buildings.ThermalZones.Detailed.Validation.BESTEST.nStaRef),Buildings.HeatTransfer.Data.Solids.Generic(
        x=0.066,
        k=0.040,
        c=840,
        d=12,
        nStaRef=Buildings.ThermalZones.Detailed.Validation.BESTEST.nStaRef),Buildings.HeatTransfer.Data.Solids.Generic(
        x=0.012,
        k=0.160,
        c=840,
        d=950,
        nStaRef=Buildings.ThermalZones.Detailed.Validation.BESTEST.nStaRef)}) "Exterior wall"
    annotation (Placement(transformation(extent={{-46,-94},{-32,-80}})));
  parameter Buildings.HeatTransfer.Data.OpaqueConstructions.Generic
    matFlo(
      final nLay=2,
      absIR_a=0.9,
      absIR_b=0.9,
      absSol_a=0.6,
      absSol_b=0.6,
    material={Buildings.HeatTransfer.Data.Solids.Generic(
        x=1.003,
        k=0.040,
        c=0,
        d=0,
        nStaRef=Buildings.ThermalZones.Detailed.Validation.BESTEST.nStaRef),Buildings.HeatTransfer.Data.Solids.Generic(
        x=0.025,
        k=0.140,
        c=1200,
        d=650,
        nStaRef=Buildings.ThermalZones.Detailed.Validation.BESTEST.nStaRef)}) "Floor"
    annotation (Placement(transformation(extent={{14,-94},{28,-80}})));
   parameter Buildings.HeatTransfer.Data.Solids.Generic soil(
    x=2,
    k=1.3,
    c=800,
    d=1500) "Soil properties"
    annotation (Placement(transformation(extent={{34,-96},{54,-76}})));

  Buildings.ThermalZones.Detailed.MixedAir roo(
    redeclare package Medium = MediumZone,
    hRoo=2.7,
    nConExtWin=nConExtWin,
    nConBou=1,
    AFlo=48,
    datConBou(
      layers={matFlo},
      each A=48,
      each til=F_),
    datConExt(
      layers={roof,matExtWal,matExtWal,matExtWal},
      A={48,6*2.7,6*2.7,8*2.7},
      til={C_,Z_,Z_,Z_},
      azi={S_,W_,E_,N_}),
    nConExt=4,
    nConPar=0,
    nSurBou=0,
    datConExtWin(
      layers={matExtWal},
      A={8*2.7},
      glaSys={window600},
      wWin={2*3},
      hWin={2},
      fFra={0.001},
      til={Z_},
      azi={S_}),
    energyDynamics=energyDynamics,
    nPorts=if use_ventilation then 5 else 3)                                                                              "Room model"
    annotation (Placement(transformation(extent={{30,-30},{-40,36}})));
  Modelica.Blocks.Routing.Replicator replicator(nout=max(1,nConExtWin))
    annotation (Placement(transformation(extent={{-4,-4},{4,4}},
        rotation=270,
        origin={48,64})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature TSoi[nConBou](each T=
        283.15) "Boundary condition for construction"
                                          annotation (Placement(transformation(
        extent={{0,0},{-16,16}},
        origin={40,-68})));
  parameter Buildings.HeatTransfer.Data.OpaqueConstructions.Generic roof(
    nLay=3,
    absIR_a=0.9,
    absIR_b=0.9,
    absSol_a=0.6,
    absSol_b=0.6,
    material={Buildings.HeatTransfer.Data.Solids.Generic(
        x=0.019,
        k=0.140,
        c=900,
        d=530,
        nStaRef=Buildings.ThermalZones.Detailed.Validation.BESTEST.nStaRef),Buildings.HeatTransfer.Data.Solids.Generic(
        x=0.1118,
        k=0.040,
        c=840,
        d=12,
        nStaRef=Buildings.ThermalZones.Detailed.Validation.BESTEST.nStaRef),Buildings.HeatTransfer.Data.Solids.Generic(
        x=0.010,
        k=0.160,
        c=840,
        d=950,
        nStaRef=Buildings.ThermalZones.Detailed.Validation.BESTEST.nStaRef)}) "Roof"
    annotation (Placement(transformation(extent={{-6,-94},{8,-80}})));
  parameter Buildings.ThermalZones.Detailed.Validation.BESTEST.Data.Win600 window600(
    UFra=3,
    haveExteriorShade=false,
    haveInteriorShade=false) "Window"
    annotation (Placement(transformation(extent={{-26,-94},{-12,-80}})));
  Buildings.HeatTransfer.Conduction.SingleLayer soi(
    A=48,
    material=soil,
    steadyStateInitial=true,
    stateAtSurface_a=false,
    stateAtSurface_b=true,
    T_a_start=283.15,
    T_b_start=283.75) "2m deep soil (per definition on p.4 of ASHRAE 140-2007)"
    annotation (Placement(transformation(
        extent={{10,-12.5},{-6,7.5}},
        rotation=-90,
        origin={8.5,-46})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor TRooAir
    "Room air temperature"
    annotation (Placement(transformation(extent={{9,-9},{-9,9}},
        rotation=270,
        origin={-1,59})));
  replaceable parameter
    Buildings.ThermalZones.Detailed.Validation.BESTEST.Data.StandardResultsFreeFloating
      staRes(
        minT( Min=-18.8+273.15, Max=-15.6+273.15, Mean=-17.6+273.15),
        maxT( Min=64.9+273.15,  Max=69.5+273.15,  Mean=66.2+273.15),
        meanT(Min=24.2+273.15,  Max=25.9+273.15,  Mean=25.1+273.15))
          constrainedby Modelica.Icons.Record
    "Reference results from ASHRAE/ANSI Standard 140"
    annotation (Placement(transformation(extent={{-70,-96},{-56,-82}})));

  Modelica.Blocks.Math.Product product1
    "Product to compute infiltration mass flow rate"
    annotation (Placement(transformation(extent={{-42,-52},{-32,-42}})));
  Buildings.Fluid.Sensors.Density density(redeclare package Medium = MediumZone,
      warnAboutOnePortConnection=false)
    "Air density inside the building"
    annotation (Placement(transformation(extent={{-24,-66},{-34,-56}})));
  Buildings.Fluid.Sources.Outside souInf(redeclare package Medium = MediumZone,
      nPorts=1) "Source model for air infiltration"
           annotation (Placement(transformation(extent={{-70,-42},{-58,-30}})));
  Modelica.Blocks.Math.MultiSum multiSum(nu=1)
    "Multi sum for infiltration air flow rate"
    annotation (Placement(transformation(extent={{-62,-70},{-50,-58}})));
  Modelica.Blocks.Sources.Constant InfiltrationRate(final k=-roo.hRoo*roo.AFlo*
        natInf/3600)
    "0.41 ACH adjusted for the altitude (0.5 at sea level)"
    annotation (Placement(transformation(extent={{-80,-68},{-72,-60}})));
  Buildings.Fluid.Sources.MassFlowSource_T sinInf(
    redeclare package Medium = MediumZone,
    m_flow=1,
    use_m_flow_in=true,
    use_T_in=false,
    use_X_in=false,
    use_C_in=false,
    nPorts=1) "Sink model for air infiltration"
    annotation (Placement(transformation(extent={{-22,-56},{-10,-44}})));
  BESMod.Utilities.Electrical.ZeroLoad zeroLoad annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={108,-92})));
  BESMod.Utilities.KPIs.ComfortCalculator comfortCalculatorHea[nZones](TComBou=
        TSetZone_nominal .- dTComfort, each for_heating=true)
    annotation (Placement(transformation(extent={{66,0},{80,14}})));
  BESMod.Utilities.KPIs.ComfortCalculator comfortCalculatorCool[nZones](TComBou=
       TSetZone_nominal .+ dTComfort, each for_heating=false)
    annotation (Placement(transformation(extent={{66,-18},{80,-4}})));
equation
  connect(roo.uSha, replicator.y) annotation (Line(
      points={{32.8,32.7},{32.8,38},{48,38},{48,59.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TSoi[1].port, soi.port_a) annotation (Line(
      points={{24,-60},{6,-60},{6,-56}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(soi.port_b, roo.surf_conBou[1]) annotation (Line(
      points={{6,-40},{6,-31.7},{-15.5,-31.7},{-15.5,-23.4}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(roo.heaPorAir, TRooAir.port)  annotation (Line(
      points={{-3.25,3},{-3.25,2},{-2,2},{-2,44},{-1,44},{-1,50}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(roo.qGai_flow, useProBus.intGains) annotation (Line(points={{32.8,
          16.2},{50,16.2},{50,84},{51,84},{51,101}},
        color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(replicator.u, useProBus.uSha) annotation (Line(points={{48,68.8},{51,68.8},
          {51,101}},                               color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(TRooAir.T, buiMeaBus.TZoneMea[1]) annotation (Line(points={{-1,68.9},
          {-1,83.5},{0,83.5},{0,99}},                color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(heatPortCon[1], roo.heaPorAir) annotation (Line(points={{-100,60},{-94,
          60},{-94,58},{-86,58},{-86,3},{-3.25,3}}, color={191,0,0}));
  connect(roo.heaPorRad, heatPortRad[1]) annotation (Line(points={{-3.25,-3.27},
          {-84,-3.27},{-84,-60},{-100,-60}}, color={191,0,0}));
  connect(roo.weaBus, weaBus) annotation (Line(
      points={{-36.325,32.535},{-62,32.535},{-62,98},{-47,98}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  if use_ventilation then
    connect(roo.ports[5], portVent_in[1]) annotation (Line(points={{21.25,-13.5},
            {60,-13.5},{60,32},{100,32},{100,38}},color={0,127,255}));
    connect(roo.ports[4], portVent_out[1]) annotation (Line(points={{21.25,-13.5},
            {60,-13.5},{60,-40},{100,-40}},       color={0,127,255}));
  end if;
  connect(density.d, product1.u2) annotation (Line(
      points={{-34.5,-61},{-40,-61},{-40,-50},{-43,-50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(multiSum.y, product1.u1) annotation (Line(
      points={{-48.98,-64},{-42,-64},{-42,-44},{-43,-44}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(InfiltrationRate.y,multiSum. u[1]) annotation (Line(
      points={{-71.6,-64},{-62,-64}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(product1.y, sinInf.m_flow_in) annotation (Line(points={{-31.5,-47},{-23.35,
          -47},{-23.35,-45.2},{-23.2,-45.2}}, color={0,0,127}));
  connect(souInf.weaBus, weaBus) annotation (Line(
      points={{-70,-35.88},{-74,-35.88},{-74,-38},{-78,-38},{-78,98},{-47,98}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));

  connect(souInf.ports[1], roo.ports[1]) annotation (Line(points={{-58,-36},{32,
          -36},{32,-13.5},{21.25,-13.5}}, color={0,127,255}));
  connect(density.port, roo.ports[2]) annotation (Line(points={{-29,-66},{-29,-70},
          {30,-70},{30,-13.5},{21.25,-13.5}}, color={0,127,255}));
  connect(sinInf.ports[1], roo.ports[3]) annotation (Line(points={{-10,-50},{-6,
          -50},{-6,-40},{32,-40},{32,-15.7},{21.25,-15.7},{21.25,-13.5}}, color=
         {0,127,255}));
  connect(zeroLoad.internalElectricalPin, internalElectricalPin) annotation (
      Line(
      points={{98,-92},{88,-92},{88,-96},{70,-96}},
      color={0,0,0},
      thickness=1));
  connect(comfortCalculatorHea.dTComSec, outBusDem.dTComHea) annotation (Line(
        points={{80.7,7},{100,7},{100,-2},{98,-2}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(comfortCalculatorCool.dTComSec, outBusDem.dTComCoo) annotation (Line(
        points={{80.7,-11},{100,-11},{100,-2},{98,-2}},
                                                    color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(TRooAir.T, comfortCalculatorHea[1].TZone) annotation (Line(points={{-1,68.9},
          {40,68.9},{40,7},{64.6,7}},   color={0,0,127}));
  connect(TRooAir.T, comfortCalculatorCool[1].TZone) annotation (Line(points={{-1,68.9},
          {-2,68.9},{-2,70},{0,70},{0,68},{40,68},{40,-11},{64.6,-11}},   color=
         {0,0,127}));

  annotation (
experiment(Tolerance=1e-06, StopTime=3.1536e+07),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/Detailed/Validation/BESTEST/Cases6xx/Case600FF.mos"
        "Simulate and plot"), Documentation(info="<html>
<p>This model is based on the Buildings Library v 0.8.1 and used for the test case 600FF of the BESTEST validation suite. </p>
</html>", revisions="<html>
<ul>
<li>
January 21, 2020, by Michael Wetter:<br/>
Changed calculation of time averaged values to use
<a href=\"modelica://Buildings.Controls.OBC.CDL.Continuous.MovingMean\">
Buildings.Controls.OBC.CDL.Continuous.MovingMean</a>
because this does not trigger a time event every hour.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1714\">issue 1714</a>.
</li>
<li>
October 29, 2016, by Michael Wetter:<br/>
Placed a capacity at the room-facing surface
to reduce the dimension of the nonlinear system of equations,
which generally decreases computing time.<br/>
Removed the pressure drop element which is not needed.<br/>
Linearized the radiative heat transfer, which is the default in
the library, and avoids a large nonlinear system of equations.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/565\">issue 565</a>.
</li>
<li>
December 22, 2014 by Michael Wetter:<br/>
Removed <code>Modelica.Fluid.System</code>
to address issue
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/311\">#311</a>.
</li>
<li>
October 9, 2013, by Michael Wetter:<br/>
Implemented soil properties using a record so that <code>TSol</code> and
<code>TLiq</code> are assigned.
This avoids an error when the model is checked in the pedantic mode.
</li>
<li>
July 15, 2012, by Michael Wetter:<br/>
Added reference results.
Changed implementation to make this model the base class
for all BESTEST cases.
Added computation of hourly and annual averaged room air temperature.
</li>
<li>
October 6, 2011, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end BuildingsRoomCase600FF;
