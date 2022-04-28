within BESMod.Systems.BaseClasses;
partial model PartialBuildingEnergySystem "Partial BES"

  extends Modelica.Icons.Example;
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
    systemParameters "Parameters relevant for the whole energy system"
    annotation (choicesAllMatching=true, Placement(transformation(extent={{-280,
            -24},{-228,40}})));
  replaceable parameter RecordsCollection.ParameterStudy.ParameterStudyBaseDefinition
    parameterStudy "Parameters changed in the study / analysis" annotation (
      choicesAllMatching=true, Placement(transformation(extent={{-280,-108},{-228,
            -42}})));

  // Subsystems
  replaceable
    BESMod.Systems.Demand.Building.BaseClasses.PartialDemand
    building   constrainedby
    BESMod.Systems.Demand.Building.BaseClasses.PartialDemand(
      redeclare final package MediumZone = MediumZone,
      final nZones=systemParameters.nZones,
      final TSetZone_nominal=systemParameters.TSetZone_nominal,
      final use_hydraulic=systemParameters.use_hydraulic,
      final use_ventilation=systemParameters.use_ventilation) annotation (
      choicesAllMatching=true, Placement(transformation(extent={{-10,0},{74,86}})));
  replaceable
    BESMod.Systems.UserProfiles.BaseClasses.PartialUserProfiles
    userProfiles constrainedby
    BESMod.Systems.UserProfiles.BaseClasses.PartialUserProfiles(
      final systemParameters=systemParameters)
    "Replacable model to specify your user profiles" annotation (
      choicesAllMatching=true, Placement(transformation(extent={{-280,128},{-226,
            178}})));
  replaceable BESMod.Systems.Demand.DHW.BaseClasses.PartialDHW
    DHW if systemParameters.use_hydraulic
    constrainedby BESMod.Systems.Demand.DHW.BaseClasses.PartialDHW(
                                                     redeclare final package
      Medium =               MediumDHW,
      final parameters(
       final mDHW_flow_nominal=systemParameters.DHWProfile.m_flow_nominal,
       final QDHW_flow_nominal=systemParameters.QDHW_flow_nomial,
       final TDHW_nominal=systemParameters.TSetDHW,
       final TDHWCold_nominal=systemParameters.TDHWWaterCold,
       final VDHWDay=systemParameters.V_dhw_day)) annotation (choicesAllMatching=true, Placement(
        transformation(extent={{-8,-108},{74,-32}})));
  replaceable Electrical.BaseClasses.PartialElectricalSystem electrical constrainedby
    Electrical.BaseClasses.PartialElectricalSystem(final nLoadsExtSubSys=4,
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
      final hBui=building.hBui))                                 annotation (Placement(
        transformation(extent={{-192,40},{-40,128}})), choicesAllMatching=true);
  replaceable BESMod.Systems.Hydraulical.BaseClasses.PartialHydraulicSystem hydraulic if systemParameters.use_hydraulic
  constrainedby BESMod.Systems.Hydraulical.BaseClasses.PartialHydraulicSystem(
    redeclare package Medium = MediumHyd,
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
      final dhwParas=DHW.parameters))
    annotation (choicesAllMatching=true, Placement(transformation(extent={{-192,
            -90},{-40,0}})));
  replaceable
    BESMod.Systems.Ventilation.BaseClasses.PartialVentilationSystem
    ventilation if systemParameters.use_ventilation constrainedby
    Ventilation.BaseClasses.PartialVentilationSystem(redeclare final package
      Medium = MediumZone, redeclare
      BESMod.Systems.RecordsCollection.SupplySystemBaseDataDefinition
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
      final hBui=building.hBui))         annotation (choicesAllMatching=true,
      Placement(transformation(extent={{120,-4},{212,86}})));

  // Outputs
  BESMod.Systems.Interfaces.SystemOutputs outputs
    annotation (Placement(transformation(extent={{252,-30},{318,30}})));
  IBPSA.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(final filNam=
        systemParameters.filNamWea)
    "Weather data reader"
    annotation (Placement(transformation(extent={{-282,52},{-224,118}})));

  replaceable Control.BaseClasses.PartialControl control constrainedby
    Control.BaseClasses.PartialControl annotation (Placement(transformation(
          extent={{-8,116},{76,182}})), choicesAllMatching=true);

  Electrical.Interfaces.ExternalElectricalPin electricalGrid annotation (
      Placement(transformation(extent={{270,40},{300,76}}), iconTransformation(
          extent={{270,40},{300,76}})));
protected
  BESMod.Utilities.Electrical.ZeroLoad hydraulicZeroElecLoad if not systemParameters.use_hydraulic "Internal helper";
  BESMod.Utilities.Electrical.ZeroLoad ventilationZeroElecLoad if not systemParameters.use_ventilation "Internal helper";
  BESMod.Utilities.Electrical.ZeroLoad dhwZeroElecLoad if not systemParameters.use_dhw "Internal helper";

equation
  connect(building.weaBus, weaDat.weaBus) annotation (Line(
      points={{7.64,86.86},{6,86.86},{6,100},{-22,100},{-22,138},{-204,138},{
          -204,84},{-216,84},{-216,85},{-224,85}},
      color={255,204,51},
      thickness=0.5));
  connect(building.outBusDem, outputs.building) annotation (Line(
      points={{73.16,42.14},{94,42.14},{94,-24},{246,-24},{246,0},{285,0}},
      color={175,175,175},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(userProfiles.useProBus,building. useProBus) annotation (Line(
      points={{-227.125,152.792},{-204,152.792},{-204,138},{-22,138},{-22,100},
          {55.1,100},{55.1,86}},
      color={0,127,0},
      thickness=0.5));

  if systemParameters.use_hydraulic then
    connect(building.buiMeaBus, hydraulic.buiMeaBus) annotation (Line(
      points={{32,85.57},{32,100},{-28,100},{-28,16},{-83.6,16},{-83.6,
          -0.321429}},
      color={255,128,0},
      thickness=0.5));
    connect(weaDat.weaBus, hydraulic.weaBus) annotation (Line(
        points={{-224,85},{-224,84},{-204,84},{-204,-46},{-198,-46},{-198,-45},
            {-191.2,-45}},
        color={255,204,51},
        thickness=0.5));
    connect(hydraulic.outBusHyd, outputs.hydraulic) annotation (Line(
        points={{-120.4,-90.6429},{-120.4,-90},{-120,-90},{-120,-124},{246,-124},
            {246,0},{285,0}},
        color={175,175,175},
        thickness=0.5), Text(
        string="%second",
        index=1,
        extent={{-3,-6},{-3,-6}},
        horizontalAlignment=TextAlignment.Right));
    connect(hydraulic.heatPortRad,building.heatPortRad) annotation (Line(
          points={{-40,-45},{-18,-45},{-18,17.2},{-10,17.2}},        color={191,
            0,0}));
    connect(hydraulic.heatPortCon,building.heatPortCon) annotation (Line(
          points={{-40,-19.9286},{-40,-14},{-22,-14},{-22,68.8},{-10,68.8}},
                                                                          color=
           {191,0,0}));
    connect(userProfiles.useProBus, hydraulic.useProBus) annotation (Line(
      points={{-227.125,152.792},{-204,152.792},{-204,16},{-152.4,16},{-152.4,
            7.10543e-15}},
      color={0,127,0},
      thickness=0.5));
    connect(control.sigBusHyd, hydraulic.sigBusHyd) annotation (Line(
      points={{0.82,115.67},{0.82,100},{-28,100},{-28,16},{-106,16},{-106,
          7.10543e-15}},
      color={215,215,215},
      thickness=0.5));
    if systemParameters.use_dhw then
      connect(DHW.outBusDHW, outputs.DHW) annotation (Line(
      points={{74,-70},{246,-70},{246,0},{285,0}},
      color={175,175,175},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
      connect(userProfiles.useProBus, DHW.useProBus) annotation (Line(
      points={{-227.125,152.792},{-204,152.792},{-204,16},{-28,16},{-28,-24},{
              55.55,-24},{55.55,-32}},
      color={0,127,0},
      thickness=0.5));
      connect(hydraulic.portDHW_out, DHW.port_a) annotation (Line(points={{-40.8,
              -66.2143},{-18,-66.2143},{-18,-47.2},{-8,-47.2}},
                                                              color={0,127,255}));
      connect(hydraulic.portDHW_in, DHW.port_b) annotation (Line(points={{-40.8,
              -79.0714},{-40.8,-74},{-18,-74},{-18,-92.8},{-8,-92.8}},
                                                              color={0,127,255}));
      connect(DHW.internalElectricalPin, electrical.internalElectricalPin[3])
  annotation (Line(
    points={{61.7,-107.24},{61.7,-124},{-204,-124},{-204,111.657},{-192,111.657}},
    color={0,0,0},
    thickness=1));
    else
      connect(hydraulicZeroElecLoad.internalElectricalPin, electrical.internalElectricalPin[1]);
    end if;
    connect(electrical.internalElectricalPin[1], hydraulic.internalElectricalPin)
  annotation (Line(
    points={{-192,111.657},{-204,111.657},{-204,-124},{-52,-124},{-52,-90}},
    color={0,0,0},
    thickness=1));
  else
    connect(dhwZeroElecLoad.internalElectricalPin, electrical.internalElectricalPin[3]);
    connect(hydraulicZeroElecLoad.internalElectricalPin, electrical.internalElectricalPin[1]);
  end if;

  if systemParameters.use_ventilation then
    connect(building.portVent_in, ventilation.portVent_in) annotation (Line(
        points={{74,59.34},{74,58},{106,58},{106,59},{120,59}},color={0,127,255}));
    connect(building.portVent_out, ventilation.portVent_out) annotation (Line(
        points={{74,25.8},{74,24},{106,24},{106,23.9},{120,23.9}},
                                                          color={0,127,255}));
    connect(ventilation.outBusVen, outputs.ventilation) annotation (Line(
      points={{166,-4},{166,-24},{246,-24},{246,0},{285,0}},
      color={175,175,175},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
    connect(weaDat.weaBus, ventilation.weaBus) annotation (Line(
      points={{-224,85},{-224,86},{-204,86},{-204,138},{-22,138},{-22,100},{220,
            100},{220,41},{212,41}},
      color={255,204,51},
      thickness=0.5));
    connect(userProfiles.useProBus, ventilation.useProBus) annotation (Line(
      points={{-227.125,152.792},{-204,152.792},{-204,138},{-22,138},{-22,100},
            {136.56,100},{136.56,86.45}},
      color={0,127,0},
      thickness=0.5));
    connect(building.buiMeaBus, ventilation.buiMeaBus) annotation (Line(
      points={{32,85.57},{32,100},{189.46,100},{189.46,86.45}},
      color={255,128,0},
      thickness=0.5));
    connect(control.sigBusVen, ventilation.sigBusVen) annotation (Line(
      points={{67.6,116},{67.6,100},{166,100},{166,86}},
      color={215,215,215},
      thickness=0.5));
    connect(ventilation.internalElectricalPin, electrical.internalElectricalPin[2])
  annotation (Line(
    points={{198.2,-3.1},{198.2,-24},{246,-24},{246,-124},{-204,-124},{-204,
            111.657},{-192,111.657}},
    color={0,0,0},
    thickness=1));
  else
    connect(ventilationZeroElecLoad.internalElectricalPin, electrical.internalElectricalPin[2]);
  end if;

  connect(building.internalElectricalPin, electrical.internalElectricalPin[4])
    annotation (Line(
      points={{61.4,1.72},{61.4,-24},{246,-24},{246,-124},{-204,-124},{-204,
          111.657},{-192,111.657}},
      color={0,0,0},
      thickness=1));
  connect(electrical.heatPortCon, building.heatPortCon) annotation (Line(points={{
          -39.1059,88.4},{-22,88.4},{-22,68.8},{-10,68.8}},  color={191,0,0}));
  connect(electrical.heatPortRad, building.heatPortRad) annotation (Line(points={{
          -39.1059,65.1429},{-18,65.1429},{-18,18},{-14,18},{-14,17.2},{-10,
          17.2}},
        color={191,0,0}));

  connect(control.outBusCtrl, outputs.control) annotation (Line(
      points={{76.42,149},{94,149},{94,-24},{246,-24},{246,0},{285,0}},
      color={175,175,175},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(userProfiles.useProBus, electrical.useProBus) annotation (Line(
      points={{-227.125,152.792},{-204,152.792},{-204,138},{-154.894,138},{
          -154.894,127.371}},
      color={0,127,0},
      thickness=0.5));
  connect(electrical.buiMeaBus, building.buiMeaBus) annotation (Line(
      points={{-80.2353,128},{-82,128},{-82,138},{-22,138},{-22,100},{32,100},{
          32,85.57}},
      color={255,128,0},
      thickness=0.5));
  connect(electrical.outBusElect, outputs.electrical) annotation (Line(
      points={{-111.082,40},{-112,40},{-112,16},{-28,16},{-28,-24},{246,-24},{
          246,0},{285,0}},
      color={175,175,175},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(electrical.weaBus, weaDat.weaBus) annotation (Line(
      points={{-192,98.1429},{-198,98.1429},{-198,98},{-204,98},{-204,85},{-224,
          85}},
      color={255,204,51},
      thickness=0.5));
  connect(control.sigBusEle, electrical.systemControlBus) annotation (Line(
      points={{-8,149},{-8,150},{-22,150},{-22,138},{-114,138},{-114,128.314},{
          -112.871,128.314}},
      color={215,215,215},
      thickness=0.5));

  connect(electricalGrid, electrical.externalElectricalPin1) annotation (Line(
      points={{285,58},{246,58},{246,-124},{-204,-124},{-204,34},{-188.424,34},
          {-188.424,41.2571}},
      color={0,0,0},
      thickness=1));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-280,-120},
            {280,180}})), Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-280,-120},{280,180}})));
end PartialBuildingEnergySystem;
