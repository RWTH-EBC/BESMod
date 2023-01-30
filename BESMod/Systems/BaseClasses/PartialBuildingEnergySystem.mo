within BESMod.Systems.BaseClasses;
partial model PartialBuildingEnergySystem "Partial BES"

  parameter Boolean use_openModelica=false
    "=true to disable features which 
    are not available in open modelica" annotation(Dialog(tab="Advanced"));

  // Replaceable packages
  replaceable package MediumHyd = IBPSA.Media.Water constrainedby
    Modelica.Media.Interfaces.PartialMedium annotation (
      __Dymola_choicesAllMatching=true);
  replaceable package MediumZone = IBPSA.Media.Air constrainedby
    Modelica.Media.Interfaces.PartialMedium annotation (choices(
        choice(redeclare package Medium = IBPSA.Media.Air "Moist air"),
        choice(redeclare package Medium = IBPSA.Media.Water "Water"),
        choice(redeclare package Medium =
            IBPSA.Media.Antifreeze.PropyleneGlycolWater (
              property_T=293.15,
              X_a=0.40)
              "Propylene glycol water, 40% mass fraction")));
  replaceable package MediumDHW = IBPSA.Media.Water constrainedby
    Modelica.Media.Interfaces.PartialMedium
    annotation (__Dymola_choicesAllMatching=true);
  // Parameters
  replaceable parameter
    BESMod.Systems.RecordsCollection.SystemParametersBaseDataDefinition
    systemParameters constrainedby
    RecordsCollection.SystemParametersBaseDataDefinition
                     "Parameters relevant for the whole energy system"
    annotation (choicesAllMatching=true, Placement(transformation(extent={{-278,
            -38},{-224,18}})));
  replaceable parameter RecordsCollection.ParameterStudy.ParameterStudyBaseDefinition
    parameterStudy "Parameters changed in the study / analysis" annotation (
      choicesAllMatching=true, Placement(transformation(extent={{-278,-118},{
            -224,-62}})));

  // Subsystems
  replaceable
    BESMod.Systems.Demand.Building.BaseClasses.PartialDemand
    building   constrainedby
    BESMod.Systems.Demand.Building.BaseClasses.PartialDemand(
      redeclare final package MediumZone = MediumZone,
      final nZones=systemParameters.nZones,
      final TSetZone_nominal=systemParameters.TSetZone_nominal,
      final use_hydraulic=systemParameters.use_hydraulic,
      final use_ventilation=systemParameters.use_ventilation,
      final use_openModelica=use_openModelica) annotation (
      choicesAllMatching=true, Placement(transformation(extent={{2,2},{76,78}})));
  replaceable BESMod.Systems.UserProfiles.BaseClasses.PartialUserProfiles
    userProfiles constrainedby UserProfiles.BaseClasses.PartialUserProfiles(
    final nZones=systemParameters.nZones,
    final TSetZone_nominal=systemParameters.TSetZone_nominal)
    "Replacable model to specify your user profiles" annotation (
      choicesAllMatching=true, Placement(transformation(extent={{-280,124},{
            -224,178}})));
  replaceable BESMod.Systems.Demand.DHW.BaseClasses.PartialDHW
    DHW if systemParameters.use_hydraulic constrainedby
    Demand.DHW.BaseClasses.PartialDHW(
    redeclare final package Medium = MediumDHW,
    final TDHW_nominal=systemParameters.TSetDHW,
    final TDHWCold_nominal=systemParameters.TDHWWaterCold,
    final subsystemDisabled=not systemParameters.use_dhw)
                                              annotation (choicesAllMatching=true, Placement(
        transformation(extent={{2,-118},{78,-42}})));
  replaceable Electrical.BaseClasses.PartialElectricalSystem electrical
    constrainedby Electrical.BaseClasses.PartialElectricalSystem(
    final nLoadsExtSubSys=4,
    final use_elecHeating=systemParameters.use_elecHeating,
    redeclare final
      BESMod.Systems.Electrical.RecordsCollection.ElectricalSystemBaseDataDefinition
      electricalSystemParameters(
      final nZones=systemParameters.nZones,
      final Q_flow_nominal=systemParameters.QBui_flow_nominal,
      final TOda_nominal=systemParameters.TOda_nominal,
      final TSup_nominal=systemParameters.TEleSup_nominal,
      final TZone_nominal=systemParameters.TSetZone_nominal,
      final TAmb=systemParameters.TAmbEle,
      final AZone=building.AZone,
      final hZone=building.hZone,
      final ABui=building.ABui,
      final ARoo=building.ARoo,
      final hBui=building.hBui),
      final use_openModelica=use_openModelica)                                 annotation (Placement(
        transformation(extent={{-198,40},{-42,136}})), choicesAllMatching=true);
  replaceable BESMod.Systems.Hydraulical.BaseClasses.PartialHydraulicSystem hydraulic
    if systemParameters.use_hydraulic constrainedby
    Hydraulical.BaseClasses.PartialHydraulicSystem(
    redeclare package Medium = MediumHyd,
    final subsystemDisabled=not systemParameters.use_hydraulic,
    final use_dhw=systemParameters.use_dhw,
    redeclare final package MediumDHW = MediumDHW,
    redeclare final
      BESMod.Systems.Hydraulical.RecordsCollection.HydraulicSystemBaseDataDefinition
      hydraulicSystemParameters(
      final nZones=systemParameters.nZones,
      final Q_flow_nominal=systemParameters.QBui_flow_nominal,
      final TOda_nominal=systemParameters.TOda_nominal,
      final TSup_nominal=systemParameters.THydSup_nominal,
      final TZone_nominal=systemParameters.TSetZone_nominal,
      final TAmb=systemParameters.TAmbHyd,
      final AZone=building.AZone,
      final hZone=building.hZone,
      final ABui=building.ABui,
      final ARoo=building.ARoo,
      final hBui=building.hBui,
      final mDHW_flow_nominal=DHW.mDHW_flow_nominal,
      final TDHW_nominal=DHW.TDHW_nominal,
      final tCrit=DHW.tCrit,
      final QCrit=DHW.QCrit,
      final TDHWCold_nominal=DHW.TDHWCold_nominal,
      final QDHW_flow_nominal=DHW.QDHW_flow_nominal,
      final VDHWDay=DHW.VDHWDay),
      final use_openModelica=use_openModelica)
    annotation (choicesAllMatching=true, Placement(transformation(extent={{-198,
            -98},{-42,-2}})));

  replaceable
    BESMod.Systems.Ventilation.BaseClasses.PartialVentilationSystem
    ventilation if systemParameters.use_ventilation constrainedby
    Ventilation.BaseClasses.PartialVentilationSystem(
    redeclare final package Medium = MediumZone,
    final subsystemDisabled=not systemParameters.use_ventilation,
    redeclare final BESMod.Systems.RecordsCollection.SupplySystemBaseDataDefinition
      ventilationSystemParameters(
      final nZones=systemParameters.nZones,
      final Q_flow_nominal=systemParameters.QBui_flow_nominal,
      final TOda_nominal=systemParameters.TOda_nominal,
      final TSup_nominal=systemParameters.TVenSup_nominal,
      final TZone_nominal=systemParameters.TSetZone_nominal,
      final TAmb=systemParameters.TAmbVen,
      final AZone=building.AZone,
      final hZone=building.hZone,
      final ABui=building.ABui,
      final ARoo=building.ARoo,
      final hBui=building.hBui),
      final use_openModelica=use_openModelica)         annotation (choicesAllMatching=true,
      Placement(transformation(extent={{122,2},{196,78}})));

  // Outputs
  BESMod.Systems.Interfaces.SystemOutputs outputs if not use_openModelica
    annotation (Placement(transformation(extent={{252,-30},{318,30}})));
  IBPSA.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(final filNam=
        systemParameters.filNamWea)
    "Weather data reader"
    annotation (Placement(transformation(extent={{-280,40},{-220,100}})));

  replaceable Control.BaseClasses.PartialControl control constrainedby
    Control.BaseClasses.PartialControl(
      final use_openModelica=use_openModelica) annotation (Placement(transformation(
          extent={{2,124},{78,198}})),  choicesAllMatching=true);

  Electrical.Interfaces.ExternalElectricalPin electricalGrid annotation (
      Placement(transformation(extent={{270,40},{300,76}}), iconTransformation(
          extent={{270,40},{300,76}})));
protected
  BESMod.Utilities.Electrical.ZeroLoad hydraulicZeroElecLoad
    if not systemParameters.use_hydraulic "Internal helper";
  BESMod.Utilities.Electrical.ZeroLoad ventilationZeroElecLoad
    if not systemParameters.use_ventilation "Internal helper";
  BESMod.Utilities.Electrical.ZeroLoad dhwZeroElecLoad
    if not systemParameters.use_dhw "Internal helper";

equation
  connect(building.weaBus, weaDat.weaBus) annotation (Line(
      points={{17.54,78.76},{24,78.76},{24,88},{-16,88},{-16,206},{-214,206},{
          -214,70},{-220,70}},
      color={255,204,51},
      thickness=0.5));
  connect(building.outBusDem, outputs.building) annotation (Line(
      points={{75.26,39.24},{75.26,38},{96,38},{96,0},{285,0}},
      color={175,175,175},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(userProfiles.useProBus,building. useProBus) annotation (Line(
      points={{-225.167,150.775},{-32,150.775},{-32,88},{59.35,88},{59.35,78}},
      color={0,127,0},
      thickness=0.5));

  if systemParameters.use_hydraulic then
    connect(building.buiMeaBus, hydraulic.buiMeaBus) annotation (Line(
      points={{39,77.62},{44,77.62},{44,88},{-26,88},{-26,10},{-86.7474,10},{
            -86.7474,-2.34286}},
      color={255,128,0},
      thickness=0.5));
    connect(weaDat.weaBus, hydraulic.weaBus) annotation (Line(
        points={{-220,70},{-214,70},{-214,-50},{-197.179,-50}},
        color={255,204,51},
        thickness=0.5));
    connect(hydraulic.outBusHyd, outputs.hydraulic) annotation (Line(
        points={{-124.516,-98.6857},{-124.516,-100},{-124,-100},{-124,-124},{
            244,-124},{244,0},{285,0}},
        color={175,175,175},
        thickness=0.5), Text(
        string="%second",
        index=1,
        extent={{-3,-6},{-3,-6}},
        horizontalAlignment=TextAlignment.Right));
    connect(hydraulic.heatPortRad,building.heatPortRad) annotation (Line(
          points={{-42,-50},{-42,-48},{-18,-48},{-18,18},{0,18},{0,17.2},{2,
            17.2}},                                                  color={191,
            0,0}));
    connect(hydraulic.heatPortCon,building.heatPortCon) annotation (Line(
          points={{-42,-23.2571},{-42,-24},{-20,-24},{-20,62.8},{2,62.8}},color=
           {191,0,0}));
    connect(userProfiles.useProBus, hydraulic.useProBus) annotation (Line(
      points={{-225.167,150.775},{-214,150.775},{-214,16},{-157.358,16},{
            -157.358,-2}},
      color={0,127,0},
      thickness=0.5));
    connect(control.sigBusHyd, hydraulic.sigBusHyd) annotation (Line(
      points={{9.98,123.63},{8,123.63},{8,88},{-28,88},{-28,14},{-109.737,14},{
            -109.737,-2}},
      color={215,215,215},
      thickness=0.5));
    connect(userProfiles.useProBus, DHW.useProBus) annotation (Line(
      points={{-225.167,150.775},{-32,150.775},{-32,-36},{60.9,-36},{60.9,-42}},
      color={0,127,0},
      thickness=0.5));
    connect(hydraulic.portDHW_out, DHW.port_a) annotation (Line(points={{
            -42.8211,-72.6286},{-2,-72.6286},{-2,-57.2},{2,-57.2}},
                                                              color={0,127,255}));
    connect(hydraulic.portDHW_in, DHW.port_b) annotation (Line(points={{
            -42.8211,-86.3429},{-2,-86.3429},{-2,-102.8},{2,-102.8}},
                                                              color={0,127,255}));
    connect(DHW.internalElectricalPin, electrical.internalElectricalPin[3])   annotation (Line(
    points={{66.6,-117.24},{66.6,-126},{72,-126},{72,-140},{-210,-140},{-210,
            118},{-198,118},{-198,118.171}},
    color={0,0,0},
    thickness=1));
    connect(DHW.outBusDHW, outputs.DHW) annotation (Line(
      points={{78,-80},{244,-80},{244,0},{285,0}},
      color={175,175,175},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));

    connect(electrical.internalElectricalPin[1], hydraulic.internalElectricalPin)
  annotation (Line(
    points={{-198,118.171},{-198,118},{-210,118},{-210,-140},{-56,-140},{-56,
            -124},{-54.3158,-124},{-54.3158,-98}},
    color={0,0,0},
    thickness=1));
  else
    connect(dhwZeroElecLoad.internalElectricalPin, electrical.internalElectricalPin[3]);
    connect(hydraulicZeroElecLoad.internalElectricalPin, electrical.internalElectricalPin[1]);
  end if;

  if systemParameters.use_ventilation then
    connect(building.portVent_in, ventilation.portVent_in) annotation (Line(
        points={{76,54.44},{84,54.44},{84,55.2},{122,55.2}},   color={0,127,255}));
    connect(building.portVent_out, ventilation.portVent_out) annotation (Line(
        points={{76,24.8},{84,24.8},{84,25.56},{122,25.56}},
                                                          color={0,127,255}));
    connect(ventilation.outBusVen, outputs.ventilation) annotation (Line(
      points={{159,2},{158,2},{158,-26},{244,-26},{244,0},{285,0}},
      color={175,175,175},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
    connect(weaDat.weaBus, ventilation.weaBus) annotation (Line(
      points={{-220,70},{-214,70},{-214,206},{206,206},{206,40},{196,40}},
      color={255,204,51},
      thickness=0.5));
    connect(userProfiles.useProBus, ventilation.useProBus) annotation (Line(
      points={{-225.167,150.775},{-214,150.775},{-214,206},{136,206},{136,88},{
            135.32,88},{135.32,78.38}},
      color={0,127,0},
      thickness=0.5));
    connect(building.buiMeaBus, ventilation.buiMeaBus) annotation (Line(
      points={{39,77.62},{44,77.62},{44,88},{177.87,88},{177.87,78.38}},
      color={255,128,0},
      thickness=0.5));
    connect(control.sigBusVen, ventilation.sigBusVen) annotation (Line(
      points={{70.4,124},{70.4,88},{159,88},{159,78}},
      color={215,215,215},
      thickness=0.5));
    connect(ventilation.internalElectricalPin, electrical.internalElectricalPin[2])
  annotation (Line(
    points={{184.9,2.76},{184.9,-26},{112,-26},{112,-140},{-210,-140},{-210,118},
            {-198,118},{-198,118.171}},
    color={0,0,0},
    thickness=1));
  else
    connect(ventilationZeroElecLoad.internalElectricalPin, electrical.internalElectricalPin[2]);
  end if;

  connect(building.internalElectricalPin, electrical.internalElectricalPin[4])
    annotation (Line(
      points={{64.9,3.52},{64.9,-26},{112,-26},{112,-140},{-210,-140},{-210,118},
          {-198,118},{-198,118.171}},
      color={0,0,0},
      thickness=1));
  if  systemParameters.use_elecHeating then
    connect(electrical.heatPortCon, building.heatPortCon) annotation (Line(points={{
            -41.0824,92.8},{-30,92.8},{-30,62.8},{2,62.8}},  color={191,0,0}));
    connect(electrical.heatPortRad, building.heatPortRad) annotation (Line(points={{
            -41.0824,67.4286},{-24,67.4286},{-24,17.2},{2,17.2}},
        color={191,0,0}));
  end if;
  connect(control.outBusCtrl, outputs.control) annotation (Line(
      points={{78.38,161},{78.38,160},{224,160},{224,0},{285,0}},
      color={175,175,175},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(userProfiles.useProBus, electrical.useProBus) annotation (Line(
      points={{-225.167,150.775},{-159.918,150.775},{-159.918,135.314}},
      color={0,127,0},
      thickness=0.5));
  connect(electrical.buiMeaBus, building.buiMeaBus) annotation (Line(
      points={{-83.2941,136},{-82,136},{-82,146},{-16,146},{-16,88},{44,88},{44,
          82},{39,82},{39,77.62}},
      color={255,128,0},
      thickness=0.5));
  connect(electrical.outBusElect, outputs.electrical) annotation (Line(
      points={{-114.953,40},{-114.953,28},{-114,28},{-114,14},{-28,14},{-28,-26},
          {244,-26},{244,0},{285,0}},
      color={175,175,175},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(electrical.weaBus, weaDat.weaBus) annotation (Line(
      points={{-198,103.429},{-198,102},{-214,102},{-214,70},{-220,70}},
      color={255,204,51},
      thickness=0.5));
  connect(control.sigBusEle, electrical.systemControlBus) annotation (Line(
      points={{2,161},{2,160},{-116.788,160},{-116.788,136.343}},
      color={215,215,215},
      thickness=0.5));

  connect(electricalGrid, electrical.externalElectricalPin1) annotation (Line(
      points={{285,58},{230,58},{230,212},{-28,212},{-28,120},{-41.0824,120},{
          -41.0824,118.857}},
      color={0,0,0},
      thickness=1));
  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false, extent={{-280,
            -140},{280,200}})),
                          Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-280,-140},{280,200}})));
end PartialBuildingEnergySystem;