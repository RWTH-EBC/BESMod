within BESMod.Systems.Demand.Building;
package Spawn
  model GroundFloor
    parameter Boolean use_openModelica=false
      "=true to disable features which 
    are not available in open modelica"   annotation(Dialog(tab="Advanced"));
    replaceable package MediumZone = IBPSA.Media.Air constrainedby
      Modelica.Media.Interfaces.PartialMedium;
    parameter Modelica.Units.SI.Volume VRooLiving1 = 59.98;
    parameter Modelica.Units.SI.Volume VRooHobby2 = 33.63;
    parameter Modelica.Units.SI.Volume VRooCorridor3 = 39.9;
    parameter Modelica.Units.SI.Volume VRooWC4 = 33.63;
    parameter Modelica.Units.SI.Volume VRooKitchen5 = 48.67;
    parameter Boolean use_windPressure = true;
    Buildings.Examples.VAVReheat.BaseClasses.RoomLeakage roomLeakageLivin1Nor(
      redeclare package Medium = MediumZone,
      VRoo=VRooLiving1,
      use_windPressure=use_windPressure,
      s=8.6/10.8,
      azi=Buildings.Types.Azimuth.N)
              annotation (Placement(transformation(extent={{-228,46},{-208,66}})));
    Buildings.Examples.VAVReheat.BaseClasses.RoomLeakage roomLeakageLiving1Wes(
      redeclare package Medium = MediumZone,
        VRoo=VRooLiving1, use_windPressure=use_windPressure,
      s=10.8/8.6,
      azi=Buildings.Types.Azimuth.W)
      annotation (Placement(transformation(extent={{-228,28},{-208,48}})));
    Buildings.Examples.VAVReheat.BaseClasses.RoomLeakage roomLeakageKitchen5Wes(
      redeclare package Medium = MediumZone,
      VRoo=VRooKitchen5,
      use_windPressure=use_windPressure,
      s=10.8/8.6,
      azi=Buildings.Types.Azimuth.W)
      annotation (Placement(transformation(extent={{-226,-106},{-206,-86}})));
    Buildings.Examples.VAVReheat.BaseClasses.RoomLeakage roomLeakageKitchen5Sou(
      redeclare package Medium = MediumZone,
      VRoo=VRooKitchen5,
      use_windPressure=use_windPressure,
      s=8.6/10.8,
      azi=Buildings.Types.Azimuth.S)
      annotation (Placement(transformation(extent={{-226,-130},{-206,-110}})));
    Buildings.Examples.VAVReheat.BaseClasses.RoomLeakage roomLeakageHobby2Nor(
      redeclare package Medium = MediumZone,
      VRoo=VRooHobby2,
      use_windPressure=use_windPressure,
      s=8.6/10.8,
      azi=Buildings.Types.Azimuth.N) annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=180,
          origin={64,58})));
    Buildings.Examples.VAVReheat.BaseClasses.RoomLeakage roomLeakageHobby2Eas(
      redeclare package Medium = MediumZone,
      VRoo=VRooHobby2,
      use_windPressure=use_windPressure,
      s=10.8/8.6,
      azi=Buildings.Types.Azimuth.E) annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=180,
          origin={64,38})));
    Buildings.Examples.VAVReheat.BaseClasses.RoomLeakage
      roomLeakageCorridor3Eas(
      redeclare package Medium = MediumZone,
      VRoo=VRooCorridor3,
      use_windPressure=use_windPressure,
      s=10.8/8.6,
      azi=Buildings.Types.Azimuth.E) annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=180,
          origin={64,-24})));
    Buildings.Examples.VAVReheat.BaseClasses.RoomLeakage roomLeakageWC4Eas(
      redeclare package Medium = MediumZone,
      VRoo=VRooWC4,
      use_windPressure=use_windPressure,
      s=10.8/8.6,
      azi=Buildings.Types.Azimuth.E) annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=180,
          origin={64,-98})));
    Buildings.Examples.VAVReheat.BaseClasses.RoomLeakage roomLeakageWC4Sou(
      redeclare package Medium = MediumZone,
      VRoo=VRooWC4,
      use_windPressure=use_windPressure,
      s=8.6/10.8,
      azi=Buildings.Types.Azimuth.S) annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=180,
          origin={64,-120})));
    Buildings.BoundaryConditions.WeatherData.Bus weaBus annotation (Placement(
          transformation(extent={{-162,80},{-122,120}}), iconTransformation(
            extent={{-128,90},{-108,110}})));
    Buildings.ThermalZones.EnergyPlus_9_6_0.ThermalZone zonLiving1(zoneName=
          "TKJwNLssk0WyOEqTNi9V3g",
      redeclare package Medium = MediumZone,
                                    nPorts=6)
      annotation (Placement(transformation(extent={{-176,26},{-136,66}})));
    Buildings.ThermalZones.EnergyPlus_9_6_0.ThermalZone zonKitchen5(zoneName=
          "ewAwLYZUK0GDV9RQVVrdsw",
      redeclare package Medium = MediumZone,
                                    nPorts=8)
      annotation (Placement(transformation(extent={{-172,-124},{-132,-84}})));
    Buildings.ThermalZones.EnergyPlus_9_6_0.ThermalZone zonHobby2(zoneName=
          "Jo5bB3uKtUesyY40h7buXA",
      redeclare package Medium = MediumZone,
                                    nPorts=6)
      annotation (Placement(transformation(extent={{-20,26},{20,66}})));
    Buildings.ThermalZones.EnergyPlus_9_6_0.ThermalZone zonCorridor3(zoneName=
          "VxcvwqdxJ0CrsbXjgBdn2A",
      redeclare package Medium = MediumZone,
                                    nPorts=11)
      annotation (Placement(transformation(extent={{-18,-46},{22,-6}})));
    Buildings.ThermalZones.EnergyPlus_9_6_0.ThermalZone zonWC4(zoneName=
          "8VvlyRmVH0C1HUd3CNvpWg",
      redeclare package Medium = MediumZone,
                                    nPorts=8)
      annotation (Placement(transformation(extent={{-16,-126},{24,-86}})));
    Modelica.Fluid.Interfaces.FluidPort_a port_a[5](redeclare package Medium =
          MediumZone)
      annotation (Placement(transformation(extent={{88,-154},{108,-134}})));
    Modelica.Fluid.Interfaces.FluidPort_b port_b[5](redeclare package Medium =
          MediumZone)
      annotation (Placement(transformation(extent={{88,-180},{108,-160}})));
    Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a GroundFloor[5]
      annotation (Placement(transformation(extent={{-278,-42},{-246,-10}}),
          iconTransformation(extent={{-278,-42},{-246,-10}})));
    Buildings.Airflow.Multizone.DoorOpen dooWC4Corr3(redeclare package Medium =
          MediumZone, wOpe=0.9)
      annotation (Placement(transformation(extent={{-58,-78},{-38,-58}})));
    Buildings.Airflow.Multizone.DoorOpen dooCorr3Hobby2(redeclare package Medium =
          MediumZone, wOpe=0.9)
      annotation (Placement(transformation(extent={{-58,0},{-38,20}})));
    Buildings.Airflow.Multizone.DoorOpen dooCorr3Kitch5(redeclare package Medium =
          MediumZone, wOpe=0.9)
      annotation (Placement(transformation(extent={{-124,-80},{-104,-60}})));
    Buildings.Airflow.Multizone.DoorOpen dooLiv1Corr3(redeclare package Medium =
          MediumZone, wOpe=0.9)
      annotation (Placement(transformation(extent={{-126,-4},{-106,16}})));
    Buildings.Airflow.Multizone.DoorOpen dooWC4Kitch5(redeclare package Medium =
          MediumZone, wOpe=0.9)
      annotation (Placement(transformation(extent={{-88,-116},{-68,-96}})));
    Modelica.Blocks.Interfaces.RealOutput TZoneMea[5]
      annotation (Placement(transformation(extent={{100,-38},{120,-18}})));
    Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor tempAirLiving1
      annotation (Placement(transformation(extent={{40,12},{54,26}})));
    Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor tempAirHobby2
      annotation (Placement(transformation(extent={{40,-14},{54,0}})));
    Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor tempAirCorr3
      annotation (Placement(transformation(extent={{40,-48},{54,-34}})));
    Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor tempAirWC4
      annotation (Placement(transformation(extent={{40,-68},{54,-54}})));
    Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor tempAirKitchen5
      annotation (Placement(transformation(extent={{40,-90},{56,-74}})));
    Modelica.Blocks.Routing.Multiplex5 multiplex5_1
      annotation (Placement(transformation(extent={{90,-62},{110,-42}})));
    Buildings.Controls.OBC.CDL.Continuous.Sources.Constant qGain[3](k={0,0,0})
      annotation (Placement(transformation(extent={{-272,-164},{-252,-144}})));
  equation
    connect(roomLeakageLivin1Nor.weaBus, weaBus) annotation (Line(
        points={{-228,56},{-234,56},{-234,74},{-142,74},{-142,100}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%second",
        index=1,
        extent={{6,3},{6,3}},
        horizontalAlignment=TextAlignment.Left));
    connect(roomLeakageLiving1Wes.weaBus, weaBus) annotation (Line(
        points={{-228,38},{-234,38},{-234,74},{-142,74},{-142,100}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%second",
        index=1,
        extent={{6,3},{6,3}},
        horizontalAlignment=TextAlignment.Left));
    connect(roomLeakageKitchen5Wes.weaBus, weaBus) annotation (Line(
        points={{-226,-96},{-234,-96},{-234,74},{-142,74},{-142,100}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%second",
        index=1,
        extent={{6,3},{6,3}},
        horizontalAlignment=TextAlignment.Left));
    connect(roomLeakageKitchen5Sou.weaBus, weaBus) annotation (Line(
        points={{-226,-120},{-234,-120},{-234,74},{-142,74},{-142,100}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%second",
        index=1,
        extent={{6,3},{6,3}},
        horizontalAlignment=TextAlignment.Left));
    connect(roomLeakageHobby2Nor.weaBus, weaBus) annotation (Line(
        points={{74,58},{80,58},{80,74},{-142,74},{-142,100}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%second",
        index=1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(roomLeakageHobby2Eas.weaBus, weaBus) annotation (Line(
        points={{74,38},{80,38},{80,74},{-142,74},{-142,100}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%second",
        index=1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(roomLeakageCorridor3Eas.weaBus, weaBus) annotation (Line(
        points={{74,-24},{80,-24},{80,74},{-142,74},{-142,100}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%second",
        index=1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(roomLeakageWC4Eas.weaBus, weaBus) annotation (Line(
        points={{74,-98},{80,-98},{80,74},{-142,74},{-142,100}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%second",
        index=1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(roomLeakageWC4Sou.weaBus, weaBus) annotation (Line(
        points={{74,-120},{80,-120},{80,74},{-142,74},{-142,100}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%second",
        index=1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(port_a[1], zonLiving1.ports[1]) annotation (Line(points={{98,-148},
            {-176,-148},{-176,20},{-157.667,20},{-157.667,26.9}},
                                                             color={0,127,255}));
    connect(port_b[1], zonLiving1.ports[2]) annotation (Line(points={{98,-174},
            {-176,-174},{-176,20},{-157,20},{-157,26.9}},    color={0,127,255}));
    connect(port_a[2], zonHobby2.ports[1]) annotation (Line(points={{98,-146},{
            -28,-146},{-28,20},{-1.66667,20},{-1.66667,26.9}},
                                                   color={0,127,255}));
    connect(port_b[2], zonHobby2.ports[2]) annotation (Line(points={{98,-172},{
            0,-172},{0,-144},{-28,-144},{-28,20},{-1,20},{-1,26.9}},   color={0,
            127,255}));
    connect(port_a[3], zonCorridor3.ports[1]) annotation (Line(points={{98,-144},{
            -28,-144},{-28,-54},{0.181818,-54},{0.181818,-45.1}}, color={0,127,
            255}));
    connect(port_b[3], zonCorridor3.ports[2]) annotation (Line(points={{98,-170},{
            0,-170},{0,-144},{-28,-144},{-28,-54},{0.545455,-54},{0.545455,
            -45.1}},                                                  color={0,
            127,255}));
    connect(port_a[4], zonWC4.ports[1]) annotation (Line(points={{98,-142},{
            2.25,-142},{2.25,-125.1}},
                                 color={0,127,255}));
    connect(port_b[4], zonWC4.ports[2]) annotation (Line(points={{98,-168},{0,
            -168},{0,-144},{2.75,-144},{2.75,-125.1}},
                                               color={0,127,255}));
    connect(port_a[5], zonKitchen5.ports[1]) annotation (Line(points={{98,-140},
            {2,-140},{2,-132},{-153.75,-132},{-153.75,-123.1}},
                                                           color={0,127,255}));
    connect(port_b[5], zonKitchen5.ports[2]) annotation (Line(points={{98,-166},
            {0,-166},{0,-144},{-28,-144},{-28,-132},{-153.25,-132},{-153.25,
            -123.1}},
          color={0,127,255}));
    connect(roomLeakageLivin1Nor.port_b, zonLiving1.ports[3]) annotation (Line(
          points={{-208,56},{-186,56},{-186,20},{-156.333,20},{-156.333,26.9}},
          color={0,127,255}));
    connect(roomLeakageLiving1Wes.port_b, zonLiving1.ports[4]) annotation (Line(
          points={{-208,38},{-186,38},{-186,20},{-155.667,20},{-155.667,26.9}},
          color={0,127,255}));
    connect(roomLeakageKitchen5Wes.port_b, zonKitchen5.ports[3]) annotation (
        Line(points={{-206,-96},{-182,-96},{-182,-132},{-152.75,-132},{-152.75,
            -123.1}}, color={0,127,255}));
    connect(roomLeakageKitchen5Sou.port_b, zonKitchen5.ports[4]) annotation (
        Line(points={{-206,-120},{-182,-120},{-182,-132},{-152.25,-132},{
            -152.25,-123.1}},
                      color={0,127,255}));
    connect(roomLeakageHobby2Nor.port_b, zonHobby2.ports[3]) annotation (Line(
          points={{54,58},{28,58},{28,20},{-0.333333,20},{-0.333333,26.9}},
                                                                color={0,127,
            255}));
    connect(roomLeakageHobby2Eas.port_b, zonHobby2.ports[4]) annotation (Line(
          points={{54,38},{28,38},{28,20},{0.333333,20},{0.333333,26.9}},
                                                                color={0,127,
            255}));
    connect(roomLeakageCorridor3Eas.port_b, zonCorridor3.ports[3]) annotation (
        Line(points={{54,-24},{28,-24},{28,-52},{0.909091,-52},{0.909091,-45.1}},
          color={0,127,255}));
    connect(roomLeakageWC4Eas.port_b, zonWC4.ports[3]) annotation (Line(points={{54,-98},
            {30,-98},{30,-132},{3.25,-132},{3.25,-125.1}},         color={0,127,
            255}));
    connect(roomLeakageWC4Sou.port_b, zonWC4.ports[4]) annotation (Line(points={{54,-120},
            {26,-120},{26,-126},{3.75,-126},{3.75,-125.1}},          color={0,
            127,255}));
    connect(GroundFloor[1], zonLiving1.heaPorAir) annotation (Line(points={{
            -262,-32.4},{-240,-32.4},{-240,80},{-156,80},{-156,46}}, color={191,
            0,0}));
    connect(GroundFloor[2], zonHobby2.heaPorAir) annotation (Line(points={{-262,
            -29.2},{-240,-29.2},{-240,80},{0,80},{0,46}}, color={191,0,0}));
    connect(GroundFloor[3], zonCorridor3.heaPorAir) annotation (Line(points={{
            -262,-26},{-240,-26},{-240,80},{84,80},{84,-26},{2,-26}}, color={
            191,0,0}));
    connect(GroundFloor[4], zonWC4.heaPorAir) annotation (Line(points={{-262,
            -22.8},{-240,-22.8},{-240,-138},{4,-138},{4,-106}}, color={191,0,0}));
    connect(GroundFloor[5], zonKitchen5.heaPorAir) annotation (Line(points={{
            -262,-19.6},{-240,-19.6},{-240,-104},{-152,-104}}, color={191,0,0}));
    connect(zonCorridor3.ports[4], dooWC4Corr3.port_b1) annotation (Line(points=
           {{1.27273,-45.1},{0,-45.1},{0,-54},{-28,-54},{-28,-62},{-38,-62}},
          color={0,127,255}));
    connect(zonCorridor3.ports[5], dooWC4Corr3.port_a2) annotation (Line(points=
           {{1.63636,-45.1},{0,-45.1},{0,-54},{-28,-54},{-28,-74},{-38,-74}},
          color={0,127,255}));
    connect(zonWC4.ports[5], dooWC4Corr3.port_a1) annotation (Line(points={{
            4.25,-125.1},{2,-125.1},{2,-132},{30,-132},{30,-78},{-32,-78},{-32,
            -84},{-64,-84},{-64,-62},{-58,-62}}, color={0,127,255}));
    connect(zonWC4.ports[6], dooWC4Corr3.port_b2) annotation (Line(points={{
            4.75,-125.1},{26,-125.1},{26,-120},{30,-120},{30,-78},{-32,-78},{
            -32,-84},{-64,-84},{-64,-74},{-58,-74}}, color={0,127,255}));
    connect(zonHobby2.ports[5], dooCorr3Hobby2.port_b1) annotation (Line(points=
           {{1,26.9},{1,20},{-28,20},{-28,16},{-38,16}}, color={0,127,255}));
    connect(zonHobby2.ports[6], dooCorr3Hobby2.port_a2) annotation (Line(points=
           {{1.66667,26.9},{1.66667,20},{-28,20},{-28,4},{-38,4}}, color={0,127,
            255}));
    connect(zonCorridor3.ports[6], dooCorr3Hobby2.port_a1) annotation (Line(
          points={{2,-45.1},{2,-44},{0,-44},{0,-54},{-32,-54},{-32,-6},{-64,-6},
            {-64,16},{-58,16}}, color={0,127,255}));
    connect(zonCorridor3.ports[7], dooCorr3Hobby2.port_b2) annotation (Line(
          points={{2.36364,-45.1},{2.36364,-44},{0,-44},{0,-54},{-32,-54},{-32,
            -6},{-64,-6},{-64,4},{-58,4}}, color={0,127,255}));
    connect(zonKitchen5.ports[5], dooCorr3Kitch5.port_a1) annotation (Line(
          points={{-151.75,-123.1},{-150,-123.1},{-150,-132},{-98,-132},{-98,
            -54},{-130,-54},{-130,-64},{-124,-64}}, color={0,127,255}));
    connect(zonKitchen5.ports[6], dooCorr3Kitch5.port_b2) annotation (Line(
          points={{-151.25,-123.1},{-150,-123.1},{-150,-132},{-98,-132},{-98,
            -54},{-130,-54},{-130,-76},{-124,-76}}, color={0,127,255}));
    connect(dooCorr3Kitch5.port_b1, zonCorridor3.ports[8]) annotation (Line(
          points={{-104,-64},{-68,-64},{-68,-52},{-30,-52},{-30,-54},{2.72727,
            -54},{2.72727,-45.1}}, color={0,127,255}));
    connect(dooCorr3Kitch5.port_a2, zonCorridor3.ports[9]) annotation (Line(
          points={{-104,-76},{-68,-76},{-68,-52},{-30,-52},{-30,-54},{3.09091,
            -54},{3.09091,-45.1}}, color={0,127,255}));
    connect(zonLiving1.ports[5], dooLiv1Corr3.port_a1) annotation (Line(points=
            {{-155,26.9},{-155,22},{-132,22},{-132,12},{-126,12}}, color={0,127,
            255}));
    connect(zonLiving1.ports[6], dooLiv1Corr3.port_b2) annotation (Line(points={{
            -154.333,26.9},{-154.333,22},{-132,22},{-132,0},{-126,0}},   color=
            {0,127,255}));
    connect(dooLiv1Corr3.port_b1, zonCorridor3.ports[10]) annotation (Line(
          points={{-106,12},{-64,12},{-64,-6},{-32,-6},{-32,-52},{-30,-52},{-30,
            -54},{3.45455,-54},{3.45455,-45.1}}, color={0,127,255}));
    connect(dooLiv1Corr3.port_a2, zonCorridor3.ports[11]) annotation (Line(
          points={{-106,0},{-64,0},{-64,-6},{-32,-6},{-32,-52},{-30,-52},{-30,
            -54},{3.81818,-54},{3.81818,-45.1}}, color={0,127,255}));
    connect(zonKitchen5.ports[7], dooWC4Kitch5.port_a1) annotation (Line(points=
           {{-150.75,-123.1},{-150,-123.1},{-150,-132},{-98,-132},{-98,-100},{
            -88,-100}}, color={0,127,255}));
    connect(zonKitchen5.ports[8], dooWC4Kitch5.port_b2) annotation (Line(points=
           {{-150.25,-123.1},{-150,-123.1},{-150,-132},{-98,-132},{-98,-112},{
            -88,-112}}, color={0,127,255}));
    connect(dooWC4Kitch5.port_b1, zonWC4.ports[7]) annotation (Line(points={{
            -68,-100},{-62,-100},{-62,-84},{-32,-84},{-32,-78},{30,-78},{30,
            -120},{26,-120},{26,-125.1},{5.25,-125.1}}, color={0,127,255}));
    connect(dooWC4Kitch5.port_a2, zonWC4.ports[8]) annotation (Line(points={{
            -68,-112},{-62,-112},{-62,-84},{-32,-84},{-32,-78},{30,-78},{30,
            -120},{26,-120},{26,-125.1},{5.75,-125.1}}, color={0,127,255}));
    connect(zonLiving1.heaPorAir, tempAirLiving1.port) annotation (Line(points=
            {{-156,46},{-26,46},{-26,19},{40,19}}, color={191,0,0}));
    connect(zonHobby2.heaPorAir, tempAirHobby2.port) annotation (Line(points={{
            0,46},{26,46},{26,0},{34,0},{34,-7},{40,-7}}, color={191,0,0}));
    connect(zonCorridor3.heaPorAir, tempAirCorr3.port) annotation (Line(points=
            {{2,-26},{2,-4},{32,-4},{32,-41},{40,-41}}, color={191,0,0}));
    connect(zonWC4.heaPorAir, tempAirWC4.port) annotation (Line(points={{4,-106},
            {4,-128},{28,-128},{28,-61},{40,-61}}, color={191,0,0}));
    connect(zonKitchen5.heaPorAir, tempAirKitchen5.port) annotation (Line(
          points={{-152,-104},{-90,-104},{-90,-94},{-26,-94},{-26,-76},{32,-76},
            {32,-82},{40,-82}}, color={191,0,0}));
    connect(TZoneMea, multiplex5_1.y) annotation (Line(points={{110,-28},{94,
            -28},{94,-52},{111,-52}}, color={0,0,127}));
    connect(tempAirLiving1.T, multiplex5_1.u1[1]) annotation (Line(points={{
            54.7,19},{54.7,18},{86,18},{86,-36},{82,-36},{82,-42},{88,-42}},
          color={0,0,127}));
    connect(tempAirHobby2.T, multiplex5_1.u2[1]) annotation (Line(points={{54.7,
            -7},{82,-7},{82,-47},{88,-47}}, color={0,0,127}));
    connect(tempAirCorr3.T, multiplex5_1.u3[1]) annotation (Line(points={{54.7,
            -41},{82,-41},{82,-52},{88,-52}}, color={0,0,127}));
    connect(tempAirWC4.T, multiplex5_1.u4[1]) annotation (Line(points={{54.7,
            -61},{82,-61},{82,-57},{88,-57}}, color={0,0,127}));
    connect(tempAirKitchen5.T, multiplex5_1.u5[1]) annotation (Line(points={{
            56.8,-82},{88,-82},{88,-62}}, color={0,0,127}));
    connect(qGain.y, zonLiving1.qGai_flow) annotation (Line(points={{-250,-154},{-236,
            -154},{-236,26},{-184,26},{-184,56},{-178,56}}, color={0,0,127}));
    connect(qGain.y, zonHobby2.qGai_flow) annotation (Line(points={{-250,-154},{-236,
            -154},{-236,26},{-184,26},{-184,68},{-30,68},{-30,56},{-22,56}},
          color={0,0,127}));
    connect(qGain.y, zonCorridor3.qGai_flow) annotation (Line(points={{-250,-154},
            {-236,-154},{-236,26},{-184,26},{-184,68},{-30,68},{-30,-16},{-20,-16}},
          color={0,0,127}));
    connect(qGain.y, zonWC4.qGai_flow) annotation (Line(points={{-250,-154},{-236,
            -154},{-236,26},{-184,26},{-184,68},{-30,68},{-30,-16},{-26,-16},{-26,
            -80},{-22,-80},{-22,-90},{-24,-90},{-24,-96},{-18,-96}}, color={0,0,127}));
    connect(qGain.y, zonKitchen5.qGai_flow) annotation (Line(points={{-250,-154},{
            -236,-154},{-236,-94},{-232,-94},{-232,-80},{-182,-80},{-182,-94},{-174,
            -94}}, color={0,0,127}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-260,-180},
              {100,100}})), Diagram(coordinateSystem(preserveAspectRatio=false,
            extent={{-260,-180},{100,100}})));
  end GroundFloor;

  model FirstFloor
    parameter Boolean use_openModelica=false
      "=true to disable features which 
    are not available in open modelica"   annotation(Dialog(tab="Advanced"));
    replaceable package MediumZone = IBPSA.Media.Air constrainedby
      Modelica.Media.Interfaces.PartialMedium;
    parameter Modelica.Units.SI.Volume VRooBedroom6 = 59.98;
    parameter Modelica.Units.SI.Volume VRooChildren7 = 33.63;
    parameter Modelica.Units.SI.Volume VRooCorridor8 = 39.9;
    parameter Modelica.Units.SI.Volume VRooBath9 = 33.63;
    parameter Modelica.Units.SI.Volume VRooChildren10 = 48.67;
    parameter Boolean use_windPressure = true;
    Buildings.Examples.VAVReheat.BaseClasses.RoomLeakage roomLeakageBedroom6Nor(
      redeclare package Medium = MediumZone,
      VRoo=VRooBedroom6,
      use_windPressure=use_windPressure,
      s=8.6/10.8,
      azi=Buildings.Types.Azimuth.N)
      annotation (Placement(transformation(extent={{-228,46},{-208,66}})));
    Buildings.Examples.VAVReheat.BaseClasses.RoomLeakage roomLeakageBedroom6Wes(
      redeclare package Medium = MediumZone,
      VRoo=VRooBedroom6,
      use_windPressure=use_windPressure,
      s=10.8/8.6,
      azi=Buildings.Types.Azimuth.W)
      annotation (Placement(transformation(extent={{-228,28},{-208,48}})));
    Buildings.Examples.VAVReheat.BaseClasses.RoomLeakage roomLeakageChildren10Wes(
      redeclare package Medium = MediumZone,
      VRoo=VRooChildren10,
      use_windPressure=use_windPressure,
      s=10.8/8.6,
      azi=Buildings.Types.Azimuth.W)
      annotation (Placement(transformation(extent={{-226,-106},{-206,-86}})));
    Buildings.Examples.VAVReheat.BaseClasses.RoomLeakage roomLeakageChildren10Sou(
      redeclare package Medium = MediumZone,
      VRoo=VRooChildren10,
      use_windPressure=use_windPressure,
      s=8.6/10.8,
      azi=Buildings.Types.Azimuth.S)
      annotation (Placement(transformation(extent={{-226,-130},{-206,-110}})));
    Buildings.Examples.VAVReheat.BaseClasses.RoomLeakage roomLeakageChildren7Nor(
      redeclare package Medium = MediumZone,
      VRoo=VRooChildren7,
      use_windPressure=use_windPressure,
      s=8.6/10.8,
      azi=Buildings.Types.Azimuth.N) annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=180,
          origin={64,58})));
    Buildings.Examples.VAVReheat.BaseClasses.RoomLeakage roomLeakageChildren7Eas(
      redeclare package Medium = MediumZone,
      VRoo=VRooChildren7,
      use_windPressure=use_windPressure,
      s=10.8/8.6,
      azi=Buildings.Types.Azimuth.E) annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=180,
          origin={64,38})));
    Buildings.Examples.VAVReheat.BaseClasses.RoomLeakage
      roomLeakageCorridor8Eas(
      redeclare package Medium = MediumZone,
      VRoo=VRooCorridor8,
      use_windPressure=use_windPressure,
      s=10.8/8.6,
      azi=Buildings.Types.Azimuth.E) annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=180,
          origin={64,-24})));
    Buildings.Examples.VAVReheat.BaseClasses.RoomLeakage roomLeakageBath9Eas(
      redeclare package Medium = MediumZone,
      VRoo=VRooBath9,
      use_windPressure=use_windPressure,
      s=10.8/8.6,
      azi=Buildings.Types.Azimuth.E) annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=180,
          origin={64,-98})));
    Buildings.Examples.VAVReheat.BaseClasses.RoomLeakage roomLeakageBath9Sou(
      redeclare package Medium = MediumZone,
      VRoo=VRooBath9,
      use_windPressure=use_windPressure,
      s=8.6/10.8,
      azi=Buildings.Types.Azimuth.S) annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=180,
          origin={64,-120})));
    Buildings.BoundaryConditions.WeatherData.Bus weaBus annotation (Placement(
          transformation(extent={{-162,80},{-122,120}}), iconTransformation(
            extent={{-128,90},{-108,110}})));
    Buildings.ThermalZones.EnergyPlus_9_6_0.ThermalZone zonBedroom6(
      zoneName="JIlBdoXH9kyILsDvu4wx8A",
      redeclare package Medium = MediumZone,
      nPorts=6)
      annotation (Placement(transformation(extent={{-176,26},{-136,66}})));
    Buildings.ThermalZones.EnergyPlus_9_6_0.ThermalZone zonChildren10(
      zoneName="uFb0fbIbnUCa0AXLT56UfA",
      redeclare package Medium = MediumZone,
      nPorts=6)
      annotation (Placement(transformation(extent={{-172,-124},{-132,-84}})));
    Buildings.ThermalZones.EnergyPlus_9_6_0.ThermalZone zonChildren7(
      zoneName="BGVPLnC4OUeqffvCvT6TTQ",
      redeclare package Medium = MediumZone,
      nPorts=6) annotation (Placement(transformation(extent={{-20,26},{20,66}})));
    Buildings.ThermalZones.EnergyPlus_9_6_0.ThermalZone zonCorridor8(
      zoneName="amiO3KhG402UMEU7Fs9xaA",
      redeclare package Medium = MediumZone,
                                    nPorts=11)
      annotation (Placement(transformation(extent={{-18,-46},{22,-6}})));
    Buildings.ThermalZones.EnergyPlus_9_6_0.ThermalZone zonBath9(
      zoneName="E4XJpmy03kW3qfdfjVrPLA",
      redeclare package Medium = MediumZone,
      nPorts=6)
      annotation (Placement(transformation(extent={{-16,-126},{24,-86}})));
    Modelica.Fluid.Interfaces.FluidPort_a port_a[5](redeclare package Medium =
          MediumZone)
      annotation (Placement(transformation(extent={{88,-154},{108,-134}})));
    Modelica.Fluid.Interfaces.FluidPort_b port_b[5](redeclare package Medium =
          MediumZone)
      annotation (Placement(transformation(extent={{88,-180},{108,-160}})));
    Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a FirstFloor[5] annotation (
       Placement(transformation(extent={{-278,-42},{-246,-10}}),
          iconTransformation(extent={{-278,-42},{-246,-10}})));
    Buildings.Airflow.Multizone.DoorOpen dooBath9Corr8(redeclare package Medium =
          MediumZone)
      annotation (Placement(transformation(extent={{-58,-78},{-38,-58}})));
    Buildings.Airflow.Multizone.DoorOpen dooCorr8Child7(redeclare package Medium =
          MediumZone)
      annotation (Placement(transformation(extent={{-58,0},{-38,20}})));
    Buildings.Airflow.Multizone.DoorOpen dooCorr8Child10(redeclare package Medium =
          MediumZone)
      annotation (Placement(transformation(extent={{-124,-80},{-104,-60}})));
    Buildings.Airflow.Multizone.DoorOpen dooBed6Corr8(redeclare package Medium =
          MediumZone)
      annotation (Placement(transformation(extent={{-126,-4},{-106,16}})));
    Modelica.Blocks.Interfaces.RealOutput TZoneMea[5]
      annotation (Placement(transformation(extent={{100,-38},{120,-18}})));
    Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor tempAirBedroom6
      annotation (Placement(transformation(extent={{40,12},{54,26}})));
    Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor tempAirChildren7
      annotation (Placement(transformation(extent={{40,-14},{54,0}})));
    Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor tempAirCorr8
      annotation (Placement(transformation(extent={{40,-48},{54,-34}})));
    Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor tempAirBath9
      annotation (Placement(transformation(extent={{40,-68},{54,-54}})));
    Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor tempAirChildren10
      annotation (Placement(transformation(extent={{40,-90},{56,-74}})));
    Modelica.Blocks.Routing.Multiplex5 multiplex5_1
      annotation (Placement(transformation(extent={{90,-62},{110,-42}})));
    Buildings.Controls.OBC.CDL.Continuous.Sources.Constant qGain[3](k={0,0,0})
      annotation (Placement(transformation(extent={{-272,-164},{-252,-144}})));
  equation
    connect(roomLeakageBedroom6Nor.weaBus, weaBus) annotation (Line(
        points={{-228,56},{-234,56},{-234,74},{-142,74},{-142,100}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%second",
        index=1,
        extent={{6,3},{6,3}},
        horizontalAlignment=TextAlignment.Left));
    connect(roomLeakageBedroom6Wes.weaBus, weaBus) annotation (Line(
        points={{-228,38},{-234,38},{-234,74},{-142,74},{-142,100}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%second",
        index=1,
        extent={{6,3},{6,3}},
        horizontalAlignment=TextAlignment.Left));
    connect(roomLeakageChildren10Wes.weaBus, weaBus) annotation (Line(
        points={{-226,-96},{-234,-96},{-234,74},{-142,74},{-142,100}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%second",
        index=1,
        extent={{6,3},{6,3}},
        horizontalAlignment=TextAlignment.Left));
    connect(roomLeakageChildren10Sou.weaBus, weaBus) annotation (Line(
        points={{-226,-120},{-234,-120},{-234,74},{-142,74},{-142,100}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%second",
        index=1,
        extent={{6,3},{6,3}},
        horizontalAlignment=TextAlignment.Left));
    connect(roomLeakageChildren7Nor.weaBus, weaBus) annotation (Line(
        points={{74,58},{80,58},{80,74},{-142,74},{-142,100}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%second",
        index=1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(roomLeakageChildren7Eas.weaBus, weaBus) annotation (Line(
        points={{74,38},{80,38},{80,74},{-142,74},{-142,100}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%second",
        index=1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(roomLeakageCorridor8Eas.weaBus, weaBus) annotation (Line(
        points={{74,-24},{80,-24},{80,74},{-142,74},{-142,100}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%second",
        index=1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(roomLeakageBath9Eas.weaBus, weaBus) annotation (Line(
        points={{74,-98},{80,-98},{80,74},{-142,74},{-142,100}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%second",
        index=1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(roomLeakageBath9Sou.weaBus, weaBus) annotation (Line(
        points={{74,-120},{80,-120},{80,74},{-142,74},{-142,100}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%second",
        index=1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(port_a[1], zonBedroom6.ports[1]) annotation (Line(points={{98,-148},
            {-176,-148},{-176,20},{-157.667,20},{-157.667,26.9}},
                                                            color={0,127,255}));
    connect(port_b[1], zonBedroom6.ports[2]) annotation (Line(points={{98,-174},{-176,
            -174},{-176,20},{-157,20},{-157,26.9}}, color={0,127,255}));
    connect(port_a[2], zonChildren7.ports[1]) annotation (Line(points={{98,-146},{
            -28,-146},{-28,20},{-1.66667,20},{-1.66667,26.9}}, color={0,127,255}));
    connect(port_b[2], zonChildren7.ports[2]) annotation (Line(points={{98,-172},{
            0,-172},{0,-144},{-28,-144},{-28,20},{-1,20},{-1,26.9}}, color={0,127,
            255}));
    connect(port_a[3],zonCorridor8. ports[1]) annotation (Line(points={{98,-144},{
            -28,-144},{-28,-54},{0.181818,-54},{0.181818,-45.1}}, color={0,127,
            255}));
    connect(port_b[3],zonCorridor8. ports[2]) annotation (Line(points={{98,-170},{
            0,-170},{0,-144},{-28,-144},{-28,-54},{0.545455,-54},{0.545455,
            -45.1}},                                                  color={0,
            127,255}));
    connect(port_a[4], zonBath9.ports[1]) annotation (Line(points={{98,-142},{2.33333,
            -142},{2.33333,-125.1}}, color={0,127,255}));
    connect(port_b[4], zonBath9.ports[2]) annotation (Line(points={{98,-168},{0,-168},
            {0,-144},{3,-144},{3,-125.1}}, color={0,127,255}));
    connect(port_a[5], zonChildren10.ports[1]) annotation (Line(points={{98,-140},
            {2,-140},{2,-132},{-153.667,-132},{-153.667,-123.1}}, color={0,127,255}));
    connect(port_b[5], zonChildren10.ports[2]) annotation (Line(points={{98,-166},
            {0,-166},{0,-144},{-28,-144},{-28,-132},{-153,-132},{-153,-123.1}},
          color={0,127,255}));
    connect(roomLeakageBedroom6Nor.port_b, zonBedroom6.ports[3]) annotation (Line(
          points={{-208,56},{-186,56},{-186,20},{-156.333,20},{-156.333,26.9}},
          color={0,127,255}));
    connect(roomLeakageBedroom6Wes.port_b, zonBedroom6.ports[4]) annotation (Line(
          points={{-208,38},{-186,38},{-186,20},{-155.667,20},{-155.667,26.9}},
          color={0,127,255}));
    connect(roomLeakageChildren10Wes.port_b, zonChildren10.ports[3]) annotation (
        Line(points={{-206,-96},{-182,-96},{-182,-132},{-152.333,-132},{
            -152.333,-123.1}},
          color={0,127,255}));
    connect(roomLeakageChildren10Sou.port_b, zonChildren10.ports[4]) annotation (
        Line(points={{-206,-120},{-182,-120},{-182,-132},{-151.667,-132},{
            -151.667,-123.1}},
                      color={0,127,255}));
    connect(roomLeakageChildren7Nor.port_b, zonChildren7.ports[3]) annotation (
        Line(points={{54,58},{28,58},{28,20},{-0.333333,20},{-0.333333,26.9}},
          color={0,127,255}));
    connect(roomLeakageChildren7Eas.port_b, zonChildren7.ports[4]) annotation (
        Line(points={{54,38},{28,38},{28,20},{0.333333,20},{0.333333,26.9}},
          color={0,127,255}));
    connect(roomLeakageCorridor8Eas.port_b,zonCorridor8. ports[3]) annotation (
        Line(points={{54,-24},{28,-24},{28,-52},{0.909091,-52},{0.909091,-45.1}},
          color={0,127,255}));
    connect(roomLeakageBath9Eas.port_b, zonBath9.ports[3]) annotation (Line(
          points={{54,-98},{30,-98},{30,-132},{3.66667,-132},{3.66667,-125.1}},
          color={0,127,255}));
    connect(roomLeakageBath9Sou.port_b, zonBath9.ports[4]) annotation (Line(
          points={{54,-120},{26,-120},{26,-126},{4.33333,-126},{4.33333,-125.1}},
          color={0,127,255}));
    connect(FirstFloor[1], zonBedroom6.heaPorAir) annotation (Line(points={{-262,-32.4},
            {-240,-32.4},{-240,80},{-156,80},{-156,46}}, color={191,0,0}));
    connect(FirstFloor[2], zonChildren7.heaPorAir) annotation (Line(points={{-262,
            -29.2},{-240,-29.2},{-240,80},{0,80},{0,46}}, color={191,0,0}));
    connect(FirstFloor[3], zonCorridor8.heaPorAir) annotation (Line(points={{-262,
            -26},{-240,-26},{-240,80},{84,80},{84,-26},{2,-26}}, color={191,0,0}));
    connect(FirstFloor[4], zonBath9.heaPorAir) annotation (Line(points={{-262,-22.8},
            {-240,-22.8},{-240,-138},{4,-138},{4,-106}}, color={191,0,0}));
    connect(FirstFloor[5], zonChildren10.heaPorAir) annotation (Line(points={{-262,
            -19.6},{-240,-19.6},{-240,-104},{-152,-104}}, color={191,0,0}));
    connect(zonCorridor8.ports[4], dooBath9Corr8.port_b1) annotation (Line(points=
           {{1.27273,-45.1},{0,-45.1},{0,-54},{-28,-54},{-28,-62},{-38,-62}},
          color={0,127,255}));
    connect(zonCorridor8.ports[5], dooBath9Corr8.port_a2) annotation (Line(points=
           {{1.63636,-45.1},{0,-45.1},{0,-54},{-28,-54},{-28,-74},{-38,-74}},
          color={0,127,255}));
    connect(zonBath9.ports[5], dooBath9Corr8.port_a1) annotation (Line(points={{5,
            -125.1},{2,-125.1},{2,-132},{30,-132},{30,-78},{-32,-78},{-32,-84},{-64,
            -84},{-64,-62},{-58,-62}}, color={0,127,255}));
    connect(zonBath9.ports[6], dooBath9Corr8.port_b2) annotation (Line(points={{5.66667,
            -125.1},{26,-125.1},{26,-120},{30,-120},{30,-78},{-32,-78},{-32,-84},{
            -64,-84},{-64,-74},{-58,-74}}, color={0,127,255}));
    connect(zonChildren7.ports[5], dooCorr8Child7.port_b1) annotation (Line(
          points={{1,26.9},{1,20},{-28,20},{-28,16},{-38,16}}, color={0,127,255}));
    connect(zonChildren7.ports[6], dooCorr8Child7.port_a2) annotation (Line(
          points={{1.66667,26.9},{1.66667,20},{-28,20},{-28,4},{-38,4}}, color={0,
            127,255}));
    connect(zonCorridor8.ports[6],dooCorr8Child7. port_a1) annotation (Line(
          points={{2,-45.1},{2,-44},{0,-44},{0,-54},{-32,-54},{-32,-6},{-64,-6},
            {-64,16},{-58,16}}, color={0,127,255}));
    connect(zonCorridor8.ports[7],dooCorr8Child7. port_b2) annotation (Line(
          points={{2.36364,-45.1},{2.36364,-44},{0,-44},{0,-54},{-32,-54},{-32,
            -6},{-64,-6},{-64,4},{-58,4}}, color={0,127,255}));
    connect(zonChildren10.ports[5], dooCorr8Child10.port_a1) annotation (Line(
          points={{-151,-123.1},{-150,-123.1},{-150,-132},{-98,-132},{-98,-54},{-130,
            -54},{-130,-64},{-124,-64}}, color={0,127,255}));
    connect(zonChildren10.ports[6], dooCorr8Child10.port_b2) annotation (Line(
          points={{-150.333,-123.1},{-150,-123.1},{-150,-132},{-98,-132},{-98,
            -54},{-130,-54},{-130,-76},{-124,-76}},
                                               color={0,127,255}));
    connect(dooCorr8Child10.port_b1, zonCorridor8.ports[8]) annotation (Line(
          points={{-104,-64},{-68,-64},{-68,-52},{-30,-52},{-30,-54},{2.72727,-54},
            {2.72727,-45.1}}, color={0,127,255}));
    connect(dooCorr8Child10.port_a2, zonCorridor8.ports[9]) annotation (Line(
          points={{-104,-76},{-68,-76},{-68,-52},{-30,-52},{-30,-54},{3.09091,-54},
            {3.09091,-45.1}}, color={0,127,255}));
    connect(zonBedroom6.ports[5], dooBed6Corr8.port_a1) annotation (Line(points={{
            -155,26.9},{-155,22},{-132,22},{-132,12},{-126,12}}, color={0,127,255}));
    connect(zonBedroom6.ports[6], dooBed6Corr8.port_b2) annotation (Line(points={{
            -154.333,26.9},{-154.333,22},{-132,22},{-132,0},{-126,0}}, color={0,127,
            255}));
    connect(dooBed6Corr8.port_b1,zonCorridor8. ports[10]) annotation (Line(
          points={{-106,12},{-64,12},{-64,-6},{-32,-6},{-32,-52},{-30,-52},{-30,
            -54},{3.45455,-54},{3.45455,-45.1}}, color={0,127,255}));
    connect(dooBed6Corr8.port_a2,zonCorridor8. ports[11]) annotation (Line(
          points={{-106,0},{-64,0},{-64,-6},{-32,-6},{-32,-52},{-30,-52},{-30,
            -54},{3.81818,-54},{3.81818,-45.1}}, color={0,127,255}));
    connect(zonBedroom6.heaPorAir, tempAirBedroom6.port) annotation (Line(points={
            {-156,46},{-26,46},{-26,19},{40,19}}, color={191,0,0}));
    connect(zonChildren7.heaPorAir, tempAirChildren7.port) annotation (Line(
          points={{0,46},{26,46},{26,0},{34,0},{34,-7},{40,-7}}, color={191,0,0}));
    connect(zonCorridor8.heaPorAir,tempAirCorr8. port) annotation (Line(points=
            {{2,-26},{2,-4},{32,-4},{32,-41},{40,-41}}, color={191,0,0}));
    connect(zonBath9.heaPorAir, tempAirBath9.port) annotation (Line(points={{4,-106},
            {4,-128},{28,-128},{28,-61},{40,-61}}, color={191,0,0}));
    connect(zonChildren10.heaPorAir, tempAirChildren10.port) annotation (Line(
          points={{-152,-104},{-90,-104},{-90,-94},{-26,-94},{-26,-76},{32,-76},{32,
            -82},{40,-82}}, color={191,0,0}));
    connect(TZoneMea, multiplex5_1.y) annotation (Line(points={{110,-28},{94,
            -28},{94,-52},{111,-52}}, color={0,0,127}));
    connect(tempAirBedroom6.T, multiplex5_1.u1[1]) annotation (Line(points={{54.7,
            19},{54.7,18},{86,18},{86,-36},{82,-36},{82,-42},{88,-42}}, color={0,0,
            127}));
    connect(tempAirChildren7.T, multiplex5_1.u2[1]) annotation (Line(points={{54.7,
            -7},{82,-7},{82,-47},{88,-47}}, color={0,0,127}));
    connect(tempAirCorr8.T, multiplex5_1.u3[1]) annotation (Line(points={{54.7,
            -41},{82,-41},{82,-52},{88,-52}}, color={0,0,127}));
    connect(tempAirBath9.T, multiplex5_1.u4[1]) annotation (Line(points={{54.7,-61},
            {82,-61},{82,-57},{88,-57}}, color={0,0,127}));
    connect(tempAirChildren10.T, multiplex5_1.u5[1])
      annotation (Line(points={{56.8,-82},{88,-82},{88,-62}}, color={0,0,127}));
    connect(qGain.y, zonBedroom6.qGai_flow) annotation (Line(points={{-250,-154},{
            -236,-154},{-236,26},{-184,26},{-184,56},{-178,56}}, color={0,0,127}));
    connect(qGain.y, zonChildren7.qGai_flow) annotation (Line(points={{-250,-154},
            {-236,-154},{-236,26},{-184,26},{-184,68},{-30,68},{-30,56},{-22,56}},
          color={0,0,127}));
    connect(qGain.y,zonCorridor8. qGai_flow) annotation (Line(points={{-250,-154},
            {-236,-154},{-236,26},{-184,26},{-184,68},{-30,68},{-30,-16},{-20,-16}},
          color={0,0,127}));
    connect(qGain.y, zonBath9.qGai_flow) annotation (Line(points={{-250,-154},{-236,
            -154},{-236,26},{-184,26},{-184,68},{-30,68},{-30,-16},{-26,-16},{-26,
            -80},{-22,-80},{-22,-90},{-24,-90},{-24,-96},{-18,-96}}, color={0,0,127}));
    connect(qGain.y, zonChildren10.qGai_flow) annotation (Line(points={{-250,-154},
            {-236,-154},{-236,-94},{-232,-94},{-232,-80},{-182,-80},{-182,-94},{-174,
            -94}}, color={0,0,127}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-260,-180},
              {100,100}})), Diagram(coordinateSystem(preserveAspectRatio=false,
            extent={{-260,-180},{100,100}})));
  end FirstFloor;

  model Attic
    parameter Boolean use_openModelica=false
      "=true to disable features which 
    are not available in open modelica"   annotation(Dialog(tab="Advanced"));
    replaceable package MediumZone = IBPSA.Media.Air constrainedby
      Modelica.Media.Interfaces.PartialMedium;
    parameter Modelica.Units.SI.Volume VRooAttic=199.99;
    parameter Modelica.Units.SI.MassFlowRate mOut_flow_nominal=1*VRooAttic*
        1.2/3600;
    Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a attic
      annotation (Placement(transformation(extent={{-108,-8},{-88,12}})));
    Buildings.BoundaryConditions.WeatherData.Bus weaBus annotation (Placement(
          transformation(extent={{-22,80},{18,120}}), iconTransformation(extent={{-10,90},
              {10,110}})));
    Modelica.Blocks.Interfaces.RealOutput TZoneMea
      annotation (Placement(transformation(extent={{96,-10},{116,10}})));
    Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium =
          MediumZone)
      annotation (Placement(transformation(extent={{90,-76},{110,-56}})));
    Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium =
          MediumZone)
      annotation (Placement(transformation(extent={{90,-98},{110,-78}})));
    Buildings.ThermalZones.EnergyPlus_9_6_0.ThermalZone zonAttic(
      zoneName="IfKJfrdT40ehbMFAOP2OHQ",
      redeclare package Medium = MediumZone,
      nPorts=4)
      annotation (Placement(transformation(extent={{-20,-22},{20,18}})));
    Buildings.Fluid.Sources.MassFlowSource_WeatherData freshAir(
      redeclare package Medium = MediumZone,
      m_flow=mOut_flow_nominal,
      nPorts=1)
      annotation (Placement(transformation(extent={{-66,-50},{-46,-30}})));
    Buildings.Fluid.Sources.Boundary_pT Atm(redeclare package Medium =
          MediumZone, nPorts=1)
      annotation (Placement(transformation(extent={{-66,-82},{-46,-62}})));
    Buildings.Fluid.FixedResistances.PressureDrop res(
      redeclare package Medium = MediumZone,
      m_flow_nominal=mOut_flow_nominal,
      dp_nominal=100) annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=180,
          origin={-24,-74})));
    Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor tempAttic
      annotation (Placement(transformation(extent={{48,-10},{68,10}})));
    Buildings.Controls.OBC.CDL.Continuous.Sources.Constant qGain[3](k={0,0,0})
      annotation (Placement(transformation(extent={{-110,-84},{-90,-64}})));
  equation
    connect(port_a, zonAttic.ports[1]) annotation (Line(points={{100,-66},{-1.5,
            -66},{-1.5,-21.1}}, color={0,127,255}));
    connect(port_b, zonAttic.ports[2]) annotation (Line(points={{100,-88},{-0.5,
            -88},{-0.5,-21.1}}, color={0,127,255}));
    connect(attic, zonAttic.heaPorAir) annotation (Line(points={{-98,2},{-28,2},
            {-28,22},{0,22},{0,-2}}, color={191,0,0}));
    connect(weaBus, freshAir.weaBus) annotation (Line(
        points={{-2,100},{-2,24},{-30,24},{-30,-26},{-74,-26},{-74,-39.8},{-66,
            -39.8}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{6,3},{6,3}},
        horizontalAlignment=TextAlignment.Left));

    connect(freshAir.ports[1], zonAttic.ports[3]) annotation (Line(points={{-46,
            -40},{0.5,-40},{0.5,-21.1}}, color={0,127,255}));
    connect(res.port_b, Atm.ports[1]) annotation (Line(points={{-34,-74},{-34,
            -72},{-46,-72}}, color={0,127,255}));
    connect(res.port_a, zonAttic.ports[4]) annotation (Line(points={{-14,-74},{
            1.5,-74},{1.5,-21.1}}, color={0,127,255}));
    connect(zonAttic.heaPorAir, tempAttic.port) annotation (Line(points={{0,-2},
            {0,22},{42,22},{42,0},{48,0}}, color={191,0,0}));
    connect(tempAttic.T, TZoneMea)
      annotation (Line(points={{69,0},{106,0}}, color={0,0,127}));
    connect(qGain.y, zonAttic.qGai_flow) annotation (Line(points={{-88,-74},{
            -76,-74},{-76,8},{-22,8}}, color={0,0,127}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end Attic;

  model GroundFloor2
    parameter Boolean use_openModelica=false
      "=true to disable features which 
    are not available in open modelica"   annotation(Dialog(tab="Advanced"));
    replaceable package MediumZone = IBPSA.Media.Air constrainedby
      Modelica.Media.Interfaces.PartialMedium;
    parameter Modelica.Units.SI.Volume VRooLiving1 = 59.98;
    parameter Modelica.Units.SI.Volume VRooHobby2 = 33.63;
    parameter Modelica.Units.SI.Volume VRooCorridor3 = 39.9;
    parameter Modelica.Units.SI.Volume VRooWC4 = 33.63;
    parameter Modelica.Units.SI.Volume VRooKitchen5 = 48.67;
    parameter Modelica.Units.SI.MassFlowRate mflow_inf_living1 = 0.5*VRooLiving1*1.2/3600;
    parameter Modelica.Units.SI.MassFlowRate mflow_inf_hobby2 = 0.5*VRooHobby2*1.2/3600;
    parameter Modelica.Units.SI.MassFlowRate mflow_inf_corridor3 = 0.5*VRooCorridor3*1.2/3600;
    parameter Modelica.Units.SI.MassFlowRate mflow_inf_WC4 = 0.5*VRooWC4*1.2/3600;
    parameter Modelica.Units.SI.MassFlowRate mflow_inf_kitchen5 = 0.5*VRooKitchen5*1.2/3600;
    parameter Boolean use_windPressure = true;
    Buildings.Fluid.Sources.MassFlowSource_WeatherData freshAir_living1(
      redeclare package Medium = MediumZone,
      m_flow=mflow_inf_living1,
      nPorts=1)
      annotation (Placement(transformation(extent={{-228,46},{-208,66}})));
    Buildings.Fluid.Sources.MassFlowSource_WeatherData freshAir_Kitchen5(
      redeclare package Medium = MediumZone,
      m_flow=mflow_inf_kitchen5,
      nPorts=1)
      annotation (Placement(transformation(extent={{-226,-106},{-206,-86}})));
    Buildings.BoundaryConditions.WeatherData.Bus weaBus annotation (Placement(
          transformation(extent={{-162,80},{-122,120}}), iconTransformation(
            extent={{-128,90},{-108,110}})));
    Buildings.ThermalZones.EnergyPlus_9_6_0.ThermalZone zonLiving1(zoneName=
          "TKJwNLssk0WyOEqTNi9V3g",
      redeclare package Medium = MediumZone,
                                    nPorts=6)
      annotation (Placement(transformation(extent={{-176,26},{-136,66}})));
    Buildings.ThermalZones.EnergyPlus_9_6_0.ThermalZone zonKitchen5(zoneName=
          "ewAwLYZUK0GDV9RQVVrdsw",
      redeclare package Medium = MediumZone,
                                    nPorts=8)
      annotation (Placement(transformation(extent={{-172,-124},{-132,-84}})));
    Buildings.ThermalZones.EnergyPlus_9_6_0.ThermalZone zonHobby2(zoneName=
          "Jo5bB3uKtUesyY40h7buXA",
      redeclare package Medium = MediumZone,
                                    nPorts=6)
      annotation (Placement(transformation(extent={{-20,26},{20,66}})));
    Buildings.ThermalZones.EnergyPlus_9_6_0.ThermalZone zonCorridor3(zoneName=
          "VxcvwqdxJ0CrsbXjgBdn2A",
      redeclare package Medium = MediumZone,
                                    nPorts=12)
      annotation (Placement(transformation(extent={{-18,-46},{22,-6}})));
    Buildings.ThermalZones.EnergyPlus_9_6_0.ThermalZone zonWC4(zoneName=
          "8VvlyRmVH0C1HUd3CNvpWg",
      redeclare package Medium = MediumZone,
                                    nPorts=8)
      annotation (Placement(transformation(extent={{-16,-126},{24,-86}})));
    Modelica.Fluid.Interfaces.FluidPort_a port_a[5](redeclare package Medium =
          MediumZone)
      annotation (Placement(transformation(extent={{88,-154},{108,-134}})));
    Modelica.Fluid.Interfaces.FluidPort_b port_b[5](redeclare package Medium =
          MediumZone)
      annotation (Placement(transformation(extent={{88,-180},{108,-160}})));
    Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a GroundFloor[5]
      annotation (Placement(transformation(extent={{-278,-42},{-246,-10}}),
          iconTransformation(extent={{-278,-42},{-246,-10}})));
    Buildings.Airflow.Multizone.DoorOpen dooWC4Corr3(redeclare package Medium =
          MediumZone, wOpe=0.9)
      annotation (Placement(transformation(extent={{-58,-78},{-38,-58}})));
    Buildings.Airflow.Multizone.DoorOpen dooCorr3Hobby2(redeclare package
        Medium =
          MediumZone, wOpe=0.9)
      annotation (Placement(transformation(extent={{-66,0},{-46,20}})));
    Buildings.Airflow.Multizone.DoorOpen dooCorr3Kitch5(redeclare package
        Medium =
          MediumZone, wOpe=0.9)
      annotation (Placement(transformation(extent={{-124,-80},{-104,-60}})));
    Buildings.Airflow.Multizone.DoorOpen dooLiv1Corr3(redeclare package Medium =
          MediumZone, wOpe=0.9)
      annotation (Placement(transformation(extent={{-126,-4},{-106,16}})));
    Buildings.Airflow.Multizone.DoorOpen dooWC4Kitch5(redeclare package Medium =
          MediumZone, wOpe=0.9)
      annotation (Placement(transformation(extent={{-88,-116},{-68,-96}})));
    Modelica.Blocks.Interfaces.RealOutput TZoneMea[5]
      annotation (Placement(transformation(extent={{100,-38},{120,-18}})));
    Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor tempAirLiving1
      annotation (Placement(transformation(extent={{40,12},{54,26}})));
    Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor tempAirHobby2
      annotation (Placement(transformation(extent={{40,-14},{54,0}})));
    Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor tempAirCorr3
      annotation (Placement(transformation(extent={{40,-48},{54,-34}})));
    Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor tempAirWC4
      annotation (Placement(transformation(extent={{40,-68},{54,-54}})));
    Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor tempAirKitchen5
      annotation (Placement(transformation(extent={{40,-90},{56,-74}})));
    Modelica.Blocks.Routing.Multiplex5 multiplex5_1
      annotation (Placement(transformation(extent={{90,-62},{110,-42}})));
    Buildings.Controls.OBC.CDL.Continuous.Sources.Constant qGain[3](k={0,0,0})
      annotation (Placement(transformation(extent={{-272,-164},{-252,-144}})));
    Buildings.Fluid.FixedResistances.PressureDrop pressureDrop_living1(
      redeclare package Medium = MediumZone,
      m_flow_nominal=mflow_inf_living1,
      dp_nominal=100)
      annotation (Placement(transformation(extent={{-204,24},{-184,44}})));
    Buildings.Fluid.Sources.Boundary_pT Atm_living1(redeclare package Medium =
          MediumZone, nPorts=1)
      annotation (Placement(transformation(extent={{-230,24},{-210,44}})));
    Buildings.Fluid.FixedResistances.PressureDrop pressureDrop_Kitchen5(
      redeclare package Medium = MediumZone,
      m_flow_nominal=mflow_inf_kitchen5,
      dp_nominal=100)
      annotation (Placement(transformation(extent={{-204,-132},{-184,-112}})));
    Buildings.Fluid.Sources.Boundary_pT Atm_kitchen5(redeclare package Medium =
          MediumZone, nPorts=1)
      annotation (Placement(transformation(extent={{-232,-132},{-212,-112}})));
    Buildings.Fluid.Sources.MassFlowSource_WeatherData freshAir_hobby2(
      redeclare package Medium = MediumZone,
      m_flow=mflow_inf_hobby2,
      nPorts=1) annotation (Placement(transformation(
          extent={{-8,-8},{8,8}},
          rotation=180,
          origin={60,62})));
    Buildings.Fluid.FixedResistances.PressureDrop pressureDrop_hobby2(
      redeclare package Medium = MediumZone,
      m_flow_nominal=mflow_inf_hobby2,
      dp_nominal=100) annotation (Placement(transformation(
          extent={{-8,-9},{8,9}},
          rotation=180,
          origin={44,41})));
    Buildings.Fluid.Sources.Boundary_pT Atm_hobby2(redeclare package Medium =
          MediumZone, nPorts=1) annotation (Placement(transformation(
          extent={{-6,-6},{6,6}},
          rotation=180,
          origin={64,42})));
    Buildings.Fluid.Sources.MassFlowSource_WeatherData freshAir_corridor3(
      redeclare package Medium = MediumZone,
      m_flow=mflow_inf_corridor3,
      nPorts=1) annotation (Placement(transformation(
          extent={{-8,-8},{8,8}},
          rotation=180,
          origin={68,6})));
    Buildings.Fluid.Sources.Boundary_pT Atm_corridor3(redeclare package Medium =
          MediumZone, nPorts=1) annotation (Placement(transformation(
          extent={{-6,-6},{6,6}},
          rotation=180,
          origin={72,-16})));
    Buildings.Fluid.FixedResistances.PressureDrop pressureDrop_corridor3(
      redeclare package Medium = MediumZone,
      m_flow_nominal=mflow_inf_corridor3,
      dp_nominal=100) annotation (Placement(transformation(
          extent={{-8,-9},{8,9}},
          rotation=180,
          origin={52,-17})));
    Buildings.Fluid.Sources.MassFlowSource_WeatherData freshAir_WC4(
      redeclare package Medium = MediumZone,
      m_flow=mflow_inf_WC4,
      nPorts=1) annotation (Placement(transformation(
          extent={{-8,-8},{8,8}},
          rotation=180,
          origin={68,-98})));
    Buildings.Fluid.Sources.Boundary_pT Atm_WC4(redeclare package Medium =
          MediumZone, nPorts=1) annotation (Placement(transformation(
          extent={{-6,-6},{6,6}},
          rotation=180,
          origin={72,-120})));
    Buildings.Fluid.FixedResistances.PressureDrop pressureDrop_WC4(
      redeclare package Medium = MediumZone,
      m_flow_nominal=mflow_inf_WC4,
      dp_nominal=100) annotation (Placement(transformation(
          extent={{-8,-9},{8,9}},
          rotation=180,
          origin={52,-121})));
  equation
    connect(freshAir_living1.weaBus, weaBus) annotation (Line(
        points={{-228,56.2},{-234,56.2},{-234,74},{-142,74},{-142,100}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%second",
        index=1,
        extent={{6,3},{6,3}},
        horizontalAlignment=TextAlignment.Left));
    connect(freshAir_Kitchen5.weaBus, weaBus) annotation (Line(
        points={{-226,-95.8},{-234,-95.8},{-234,74},{-142,74},{-142,100}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%second",
        index=1,
        extent={{6,3},{6,3}},
        horizontalAlignment=TextAlignment.Left));
    connect(port_a[1], zonLiving1.ports[1]) annotation (Line(points={{98,-148},
            {-176,-148},{-176,20},{-157.667,20},{-157.667,26.9}},
                                                             color={0,127,255}));
    connect(port_b[1], zonLiving1.ports[2]) annotation (Line(points={{98,-174},
            {-176,-174},{-176,20},{-157,20},{-157,26.9}},    color={0,127,255}));
    connect(port_a[2], zonHobby2.ports[1]) annotation (Line(points={{98,-146},{
            -28,-146},{-28,20},{-1.66667,20},{-1.66667,26.9}},
                                                   color={0,127,255}));
    connect(port_b[2], zonHobby2.ports[2]) annotation (Line(points={{98,-172},{
            0,-172},{0,-144},{-28,-144},{-28,20},{-1,20},{-1,26.9}},   color={0,
            127,255}));
    connect(port_a[3], zonCorridor3.ports[1]) annotation (Line(points={{98,-144},
            {-28,-144},{-28,-54},{0.166667,-54},{0.166667,-45.1}},color={0,127,
            255}));
    connect(port_b[3], zonCorridor3.ports[2]) annotation (Line(points={{98,-170},
            {0,-170},{0,-144},{-28,-144},{-28,-54},{0.5,-54},{0.5,-45.1}},
                                                                      color={0,
            127,255}));
    connect(port_a[4], zonWC4.ports[1]) annotation (Line(points={{98,-142},{
            2.25,-142},{2.25,-125.1}},
                                 color={0,127,255}));
    connect(port_b[4], zonWC4.ports[2]) annotation (Line(points={{98,-168},{0,
            -168},{0,-144},{2.75,-144},{2.75,-125.1}},
                                               color={0,127,255}));
    connect(port_a[5], zonKitchen5.ports[1]) annotation (Line(points={{98,-140},
            {2,-140},{2,-132},{-153.75,-132},{-153.75,-123.1}},
                                                           color={0,127,255}));
    connect(port_b[5], zonKitchen5.ports[2]) annotation (Line(points={{98,-166},
            {0,-166},{0,-144},{-28,-144},{-28,-132},{-153.25,-132},{-153.25,
            -123.1}},
          color={0,127,255}));
    connect(GroundFloor[1], zonLiving1.heaPorAir) annotation (Line(points={{
            -262,-32.4},{-240,-32.4},{-240,80},{-156,80},{-156,46}}, color={191,
            0,0}));
    connect(GroundFloor[2], zonHobby2.heaPorAir) annotation (Line(points={{-262,
            -29.2},{-240,-29.2},{-240,80},{0,80},{0,46}}, color={191,0,0}));
    connect(GroundFloor[3], zonCorridor3.heaPorAir) annotation (Line(points={{
            -262,-26},{-240,-26},{-240,80},{84,80},{84,-26},{2,-26}}, color={
            191,0,0}));
    connect(GroundFloor[4], zonWC4.heaPorAir) annotation (Line(points={{-262,
            -22.8},{-240,-22.8},{-240,-138},{4,-138},{4,-106}}, color={191,0,0}));
    connect(GroundFloor[5], zonKitchen5.heaPorAir) annotation (Line(points={{
            -262,-19.6},{-240,-19.6},{-240,-104},{-152,-104}}, color={191,0,0}));
    connect(zonLiving1.heaPorAir, tempAirLiving1.port) annotation (Line(points=
            {{-156,46},{-26,46},{-26,19},{40,19}}, color={191,0,0}));
    connect(zonHobby2.heaPorAir, tempAirHobby2.port) annotation (Line(points={{
            0,46},{26,46},{26,0},{34,0},{34,-7},{40,-7}}, color={191,0,0}));
    connect(zonCorridor3.heaPorAir, tempAirCorr3.port) annotation (Line(points=
            {{2,-26},{2,-4},{32,-4},{32,-41},{40,-41}}, color={191,0,0}));
    connect(zonWC4.heaPorAir, tempAirWC4.port) annotation (Line(points={{4,-106},
            {4,-128},{28,-128},{28,-61},{40,-61}}, color={191,0,0}));
    connect(zonKitchen5.heaPorAir, tempAirKitchen5.port) annotation (Line(
          points={{-152,-104},{-90,-104},{-90,-94},{-26,-94},{-26,-76},{32,-76},
            {32,-82},{40,-82}}, color={191,0,0}));
    connect(TZoneMea, multiplex5_1.y) annotation (Line(points={{110,-28},{94,
            -28},{94,-52},{111,-52}}, color={0,0,127}));
    connect(tempAirLiving1.T, multiplex5_1.u1[1]) annotation (Line(points={{
            54.7,19},{54.7,18},{86,18},{86,-36},{82,-36},{82,-42},{88,-42}},
          color={0,0,127}));
    connect(tempAirHobby2.T, multiplex5_1.u2[1]) annotation (Line(points={{54.7,
            -7},{82,-7},{82,-47},{88,-47}}, color={0,0,127}));
    connect(tempAirCorr3.T, multiplex5_1.u3[1]) annotation (Line(points={{54.7,
            -41},{82,-41},{82,-52},{88,-52}}, color={0,0,127}));
    connect(tempAirWC4.T, multiplex5_1.u4[1]) annotation (Line(points={{54.7,
            -61},{82,-61},{82,-57},{88,-57}}, color={0,0,127}));
    connect(tempAirKitchen5.T, multiplex5_1.u5[1]) annotation (Line(points={{
            56.8,-82},{88,-82},{88,-62}}, color={0,0,127}));
    connect(qGain.y, zonLiving1.qGai_flow) annotation (Line(points={{-250,-154},{-236,
            -154},{-236,26},{-184,26},{-184,56},{-178,56}}, color={0,0,127}));
    connect(qGain.y, zonHobby2.qGai_flow) annotation (Line(points={{-250,-154},{-236,
            -154},{-236,26},{-184,26},{-184,68},{-30,68},{-30,56},{-22,56}},
          color={0,0,127}));
    connect(qGain.y, zonCorridor3.qGai_flow) annotation (Line(points={{-250,-154},
            {-236,-154},{-236,26},{-184,26},{-184,68},{-30,68},{-30,-16},{-20,-16}},
          color={0,0,127}));
    connect(qGain.y, zonWC4.qGai_flow) annotation (Line(points={{-250,-154},{-236,
            -154},{-236,26},{-184,26},{-184,68},{-30,68},{-30,-16},{-26,-16},{-26,
            -80},{-22,-80},{-22,-90},{-24,-90},{-24,-96},{-18,-96}}, color={0,0,127}));
    connect(qGain.y, zonKitchen5.qGai_flow) annotation (Line(points={{-250,-154},{
            -236,-154},{-236,-94},{-232,-94},{-232,-80},{-182,-80},{-182,-94},{-174,
            -94}}, color={0,0,127}));
    connect(Atm_living1.ports[1], pressureDrop_living1.port_a)
      annotation (Line(points={{-210,34},{-204,34}}, color={0,127,255}));
    connect(freshAir_living1.ports[1], zonLiving1.ports[3]) annotation (Line(
          points={{-208,56},{-182,56},{-182,36},{-178,36},{-178,26.9},{-156.333,
            26.9}},
          color={0,127,255}));
    connect(pressureDrop_living1.port_b, zonLiving1.ports[4]) annotation (Line(
          points={{-184,34},{-178,34},{-178,26.9},{-155.667,26.9}},
                                                                  color={0,127,255}));
    connect(Atm_kitchen5.ports[1], pressureDrop_Kitchen5.port_a)
      annotation (Line(points={{-212,-122},{-204,-122}}, color={0,127,255}));
    connect(freshAir_Kitchen5.ports[1], zonKitchen5.ports[3]) annotation (Line(
          points={{-206,-96},{-194,-96},{-194,-106},{-174,-106},{-174,-130},{
            -152.75,-130},{-152.75,-123.1}},
                                    color={0,127,255}));
    connect(pressureDrop_Kitchen5.port_b, zonKitchen5.ports[4]) annotation (Line(
          points={{-184,-122},{-178,-122},{-178,-106},{-174,-106},{-174,-130},{
            -152.25,-130},{-152.25,-123.1}},
                                  color={0,127,255}));
    connect(pressureDrop_hobby2.port_a, Atm_hobby2.ports[1]) annotation (Line(
          points={{52,41},{55,41},{55,42},{58,42}}, color={0,127,255}));
    connect(weaBus, freshAir_hobby2.weaBus) annotation (Line(
        points={{-142,100},{-142,72},{74,72},{74,61.84},{68,61.84}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(freshAir_hobby2.ports[1], zonHobby2.ports[3]) annotation (Line(
          points={{52,62},{28,62},{28,26.9},{-0.333333,26.9}}, color={0,127,255}));
    connect(pressureDrop_hobby2.port_b, zonHobby2.ports[4]) annotation (Line(
          points={{36,41},{36,40},{28,40},{28,26.9},{0.333333,26.9}}, color={0,
            127,255}));
    connect(weaBus, freshAir_corridor3.weaBus) annotation (Line(
        points={{-142,100},{-142,72},{74,72},{74,16},{82,16},{82,5.84},{76,5.84}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));

    connect(freshAir_corridor3.ports[1], zonCorridor3.ports[3]) annotation (
        Line(points={{60,6},{28,6},{28,-52},{0.833333,-52},{0.833333,-45.1}},
          color={0,127,255}));
    connect(Atm_corridor3.ports[1], pressureDrop_corridor3.port_a) annotation (
        Line(points={{66,-16},{63,-16},{63,-17},{60,-17}}, color={0,127,255}));
    connect(pressureDrop_corridor3.port_b, zonCorridor3.ports[4]) annotation (
        Line(points={{44,-17},{28,-17},{28,-52},{1.16667,-52},{1.16667,-45.1}},
          color={0,127,255}));
    connect(freshAir_WC4.ports[1], zonWC4.ports[3]) annotation (Line(points={{
            60,-98},{30,-98},{30,-132},{3.25,-132},{3.25,-125.1}}, color={0,127,
            255}));
    connect(pressureDrop_WC4.port_b, zonWC4.ports[4]) annotation (Line(points={
            {44,-121},{30,-121},{30,-132},{3.75,-132},{3.75,-125.1}}, color={0,
            127,255}));
    connect(pressureDrop_WC4.port_a, Atm_WC4.ports[1]) annotation (Line(points=
            {{60,-121},{63,-121},{63,-120},{66,-120}}, color={0,127,255}));
    connect(dooLiv1Corr3.port_a1, zonLiving1.ports[5]) annotation (Line(points=
            {{-126,12},{-128,12},{-128,26.9},{-155,26.9}}, color={0,127,255}));
    connect(dooLiv1Corr3.port_b2, zonLiving1.ports[6]) annotation (Line(points={{-126,0},
            {-128,0},{-128,26.9},{-154.333,26.9}},           color={0,127,255}));
    connect(dooLiv1Corr3.port_b1, zonCorridor3.ports[5]) annotation (Line(
          points={{-106,12},{-72,12},{-72,-50},{-30,-50},{-30,-54},{1.5,-54},{
            1.5,-45.1}}, color={0,127,255}));
    connect(dooLiv1Corr3.port_a2, zonCorridor3.ports[6]) annotation (Line(
          points={{-106,0},{-72,0},{-72,-50},{-30,-50},{-30,-54},{1.83333,-54},
            {1.83333,-45.1}}, color={0,127,255}));
    connect(zonHobby2.ports[5], dooCorr3Hobby2.port_a1) annotation (Line(points=
           {{1,26.9},{1,22},{-40,22},{-40,26},{-72,26},{-72,16},{-66,16}},
          color={0,127,255}));
    connect(zonHobby2.ports[6], dooCorr3Hobby2.port_b2) annotation (Line(points=
           {{1.66667,26.9},{1.66667,22},{-40,22},{-40,26},{-72,26},{-72,10},{
            -74,10},{-74,4},{-66,4}}, color={0,127,255}));
    connect(dooCorr3Hobby2.port_b1, zonCorridor3.ports[7]) annotation (Line(
          points={{-46,16},{-32,16},{-32,-50},{-30,-50},{-30,-54},{2.16667,-54},
            {2.16667,-45.1}}, color={0,127,255}));
    connect(dooCorr3Hobby2.port_a2, zonCorridor3.ports[8]) annotation (Line(
          points={{-46,4},{-32,4},{-32,-50},{-30,-50},{-30,-54},{2.5,-54},{2.5,
            -45.1}}, color={0,127,255}));
    connect(dooWC4Corr3.port_a1, zonWC4.ports[5]) annotation (Line(points={{-58,
            -62},{-64,-62},{-64,-96},{-26,-96},{-26,-134},{4.25,-134},{4.25,
            -125.1}}, color={0,127,255}));
    connect(dooWC4Corr3.port_b2, zonWC4.ports[6]) annotation (Line(points={{-58,
            -74},{-64,-74},{-64,-96},{-26,-96},{-26,-134},{4.75,-134},{4.75,
            -125.1}}, color={0,127,255}));
    connect(dooWC4Corr3.port_b1, zonCorridor3.ports[9]) annotation (Line(points=
           {{-38,-62},{-28,-62},{-28,-54},{2.83333,-54},{2.83333,-45.1}}, color=
           {0,127,255}));
    connect(dooWC4Corr3.port_a2, zonCorridor3.ports[10]) annotation (Line(
          points={{-38,-74},{-28,-74},{-28,-54},{3.16667,-54},{3.16667,-45.1}},
          color={0,127,255}));
    connect(dooCorr3Kitch5.port_a1, zonKitchen5.ports[5]) annotation (Line(
          points={{-124,-64},{-126,-64},{-126,-132},{-151.75,-132},{-151.75,
            -123.1}}, color={0,127,255}));
    connect(dooCorr3Kitch5.port_b2, zonKitchen5.ports[6]) annotation (Line(
          points={{-124,-76},{-126,-76},{-126,-132},{-151.25,-132},{-151.25,
            -123.1}}, color={0,127,255}));
    connect(dooCorr3Kitch5.port_b1, zonCorridor3.ports[11]) annotation (Line(
          points={{-104,-64},{-68,-64},{-68,-50},{-30,-50},{-30,-54},{3.5,-54},
            {3.5,-45.1}}, color={0,127,255}));
    connect(dooCorr3Kitch5.port_a2, zonCorridor3.ports[12]) annotation (Line(
          points={{-104,-76},{-68,-76},{-68,-50},{-30,-50},{-30,-54},{3.83333,
            -54},{3.83333,-45.1}}, color={0,127,255}));
    connect(zonKitchen5.ports[7], dooWC4Kitch5.port_a1) annotation (Line(points=
           {{-150.75,-123.1},{-150,-123.1},{-150,-132},{-126,-132},{-126,-100},
            {-88,-100}}, color={0,127,255}));
    connect(zonKitchen5.ports[8], dooWC4Kitch5.port_b2) annotation (Line(points=
           {{-150.25,-123.1},{-150,-123.1},{-150,-132},{-126,-132},{-126,-112},
            {-88,-112}}, color={0,127,255}));
    connect(dooWC4Kitch5.port_b1, zonWC4.ports[7]) annotation (Line(points={{
            -68,-100},{-62,-100},{-62,-96},{-26,-96},{-26,-134},{5.25,-134},{
            5.25,-125.1}}, color={0,127,255}));
    connect(dooWC4Kitch5.port_a2, zonWC4.ports[8]) annotation (Line(points={{
            -68,-112},{-62,-112},{-62,-96},{-26,-96},{-26,-134},{5.75,-134},{
            5.75,-125.1}}, color={0,127,255}));
    connect(weaBus, freshAir_WC4.weaBus) annotation (Line(
        points={{-142,100},{-142,72},{74,72},{74,16},{82,16},{82,-28},{78,-28},
            {78,-84},{82,-84},{82,-98.16},{76,-98.16}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-260,-180},
              {100,100}})), Diagram(coordinateSystem(preserveAspectRatio=false,
            extent={{-260,-180},{100,100}})),
      Documentation(info="<html>
<p>Ground floor of the HOM IDF model with a constant air infiltration</p>
</html>"));
  end GroundFloor2;

  model FirstFloor2
    parameter Boolean use_openModelica=false
      "=true to disable features which 
    are not available in open modelica"   annotation(Dialog(tab="Advanced"));
    replaceable package MediumZone = IBPSA.Media.Air constrainedby
      Modelica.Media.Interfaces.PartialMedium;
    parameter Modelica.Units.SI.Volume VRooBedroom6 = 59.98;
    parameter Modelica.Units.SI.Volume VRooChildren7 = 33.63;
    parameter Modelica.Units.SI.Volume VRooCorridor8 = 39.9;
    parameter Modelica.Units.SI.Volume VRooBath9 = 33.63;
    parameter Modelica.Units.SI.Volume VRooChildren10 = 48.67;
    parameter Modelica.Units.SI.MassFlowRate mflow_inf_bedroom6 = 0.5*VRooBedroom6*1.2/3600;
    parameter Modelica.Units.SI.MassFlowRate mflow_inf_children7 = 0.5*VRooChildren7*1.2/3600;
    parameter Modelica.Units.SI.MassFlowRate mflow_inf_corridor8 = 0.5*VRooCorridor8*1.2/3600;
    parameter Modelica.Units.SI.MassFlowRate mflow_inf_bath9 = 0.5*VRooBath9*1.2/3600;
    parameter Modelica.Units.SI.MassFlowRate mflow_inf_children10 = 0.5*VRooChildren10*1.2/3600;
    parameter Boolean use_windPressure = true;
    Buildings.Fluid.Sources.MassFlowSource_WeatherData freshAir_bedroom6(
      redeclare package Medium = MediumZone,
      m_flow=mflow_inf_bedroom6,
      nPorts=1)
      annotation (Placement(transformation(extent={{-228,46},{-208,66}})));
    Buildings.Fluid.Sources.MassFlowSource_WeatherData freshAir_children10(
      redeclare package Medium = MediumZone,
      m_flow=mflow_inf_children10,
      nPorts=1)
      annotation (Placement(transformation(extent={{-226,-106},{-206,-86}})));
    Buildings.BoundaryConditions.WeatherData.Bus weaBus annotation (Placement(
          transformation(extent={{-162,80},{-122,120}}), iconTransformation(
            extent={{-128,90},{-108,110}})));
    Buildings.ThermalZones.EnergyPlus_9_6_0.ThermalZone zonBedroom6(
      zoneName="JIlBdoXH9kyILsDvu4wx8A",
      redeclare package Medium = MediumZone,
                                    nPorts=6)
      annotation (Placement(transformation(extent={{-176,26},{-136,66}})));
    Buildings.ThermalZones.EnergyPlus_9_6_0.ThermalZone zonChildren10(
      zoneName="uFb0fbIbnUCa0AXLT56UfA",
      redeclare package Medium = MediumZone,
      nPorts=6)
      annotation (Placement(transformation(extent={{-172,-124},{-132,-84}})));
    Buildings.ThermalZones.EnergyPlus_9_6_0.ThermalZone zonChildren7(
      zoneName="BGVPLnC4OUeqffvCvT6TTQ",
      redeclare package Medium = MediumZone,
      nPorts=6)
      annotation (Placement(transformation(extent={{-20,26},{20,66}})));
    Buildings.ThermalZones.EnergyPlus_9_6_0.ThermalZone zonCorridor8(
      zoneName="amiO3KhG402UMEU7Fs9xaA",
      redeclare package Medium = MediumZone,
                                    nPorts=12)
      annotation (Placement(transformation(extent={{-18,-46},{22,-6}})));
    Buildings.ThermalZones.EnergyPlus_9_6_0.ThermalZone zonBath9(
      zoneName="E4XJpmy03kW3qfdfjVrPLA",
      redeclare package Medium = MediumZone,
      nPorts=6)
      annotation (Placement(transformation(extent={{-16,-126},{24,-86}})));
    Modelica.Fluid.Interfaces.FluidPort_a port_a[5](redeclare package Medium =
          MediumZone)
      annotation (Placement(transformation(extent={{88,-154},{108,-134}})));
    Modelica.Fluid.Interfaces.FluidPort_b port_b[5](redeclare package Medium =
          MediumZone)
      annotation (Placement(transformation(extent={{88,-180},{108,-160}})));
    Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a FirstFloor[5]
      annotation (Placement(transformation(extent={{-278,-42},{-246,-10}}),
          iconTransformation(extent={{-278,-42},{-246,-10}})));
    Buildings.Airflow.Multizone.DoorOpen dooBath9Corr8(redeclare package Medium =
          MediumZone, wOpe=0.9)
      annotation (Placement(transformation(extent={{-58,-78},{-38,-58}})));
    Buildings.Airflow.Multizone.DoorOpen dooCorr8Child7(redeclare package
        Medium =
          MediumZone, wOpe=0.9)
      annotation (Placement(transformation(extent={{-66,0},{-46,20}})));
    Buildings.Airflow.Multizone.DoorOpen dooCorr8Child10(redeclare package
        Medium = MediumZone, wOpe=0.9)
      annotation (Placement(transformation(extent={{-124,-80},{-104,-60}})));
    Buildings.Airflow.Multizone.DoorOpen dooBed6Corr8(redeclare package Medium =
          MediumZone, wOpe=0.9)
      annotation (Placement(transformation(extent={{-126,-4},{-106,16}})));
    Modelica.Blocks.Interfaces.RealOutput TZoneMea[5]
      annotation (Placement(transformation(extent={{100,-38},{120,-18}})));
    Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor tempAirBedroom6
      annotation (Placement(transformation(extent={{40,12},{54,26}})));
    Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor tempAirChildren7
      annotation (Placement(transformation(extent={{40,-14},{54,0}})));
    Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor tempAirCorr8
      annotation (Placement(transformation(extent={{40,-48},{54,-34}})));
    Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor tempAirBath9
      annotation (Placement(transformation(extent={{40,-68},{54,-54}})));
    Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor tempAirChildren10
      annotation (Placement(transformation(extent={{40,-90},{56,-74}})));
    Modelica.Blocks.Routing.Multiplex5 multiplex5_1
      annotation (Placement(transformation(extent={{90,-62},{110,-42}})));
    Buildings.Controls.OBC.CDL.Continuous.Sources.Constant qGain[3](k={0,0,0})
      annotation (Placement(transformation(extent={{-272,-164},{-252,-144}})));
    Buildings.Fluid.FixedResistances.PressureDrop pressureDrop_bedroom6(
      redeclare package Medium = MediumZone,
      m_flow_nominal=mflow_inf_bedroom6,
      dp_nominal=100)
      annotation (Placement(transformation(extent={{-204,24},{-184,44}})));
    Buildings.Fluid.Sources.Boundary_pT Atm_bedroom6(redeclare package Medium =
          MediumZone, nPorts=1)
      annotation (Placement(transformation(extent={{-230,24},{-210,44}})));
    Buildings.Fluid.FixedResistances.PressureDrop pressureDrop_Children10(
      redeclare package Medium = MediumZone,
      m_flow_nominal=mflow_inf_children10,
      dp_nominal=100)
      annotation (Placement(transformation(extent={{-204,-132},{-184,-112}})));
    Buildings.Fluid.Sources.Boundary_pT Atm_children10(redeclare package Medium =
          MediumZone, nPorts=1)
      annotation (Placement(transformation(extent={{-232,-132},{-212,-112}})));
    Buildings.Fluid.Sources.MassFlowSource_WeatherData freshAir_children7(
      redeclare package Medium = MediumZone,
      m_flow=mflow_inf_children7,
      nPorts=1) annotation (Placement(transformation(
          extent={{-8,-8},{8,8}},
          rotation=180,
          origin={60,62})));
    Buildings.Fluid.FixedResistances.PressureDrop pressureDrop_children7(
      redeclare package Medium = MediumZone,
      m_flow_nominal=mflow_inf_children7,
      dp_nominal=100) annotation (Placement(transformation(
          extent={{-8,-9},{8,9}},
          rotation=180,
          origin={44,41})));
    Buildings.Fluid.Sources.Boundary_pT Atm_children7(redeclare package Medium =
          MediumZone, nPorts=1) annotation (Placement(transformation(
          extent={{-6,-6},{6,6}},
          rotation=180,
          origin={64,42})));
    Buildings.Fluid.Sources.MassFlowSource_WeatherData freshAir_corridor8(
      redeclare package Medium = MediumZone,
      m_flow=mflow_inf_corridor8,
      nPorts=1) annotation (Placement(transformation(
          extent={{-8,-8},{8,8}},
          rotation=180,
          origin={68,6})));
    Buildings.Fluid.Sources.Boundary_pT Atm_corridor8(redeclare package Medium =
          MediumZone, nPorts=1) annotation (Placement(transformation(
          extent={{-6,-6},{6,6}},
          rotation=180,
          origin={72,-16})));
    Buildings.Fluid.FixedResistances.PressureDrop pressureDrop_corridor8(
      redeclare package Medium = MediumZone,
      m_flow_nominal=mflow_inf_corridor8,
      dp_nominal=100) annotation (Placement(transformation(
          extent={{-8,-9},{8,9}},
          rotation=180,
          origin={52,-17})));
    Buildings.Fluid.Sources.MassFlowSource_WeatherData freshAir_bath9(
      redeclare package Medium = MediumZone,
      m_flow=mflow_inf_bath9,
      nPorts=1) annotation (Placement(transformation(
          extent={{-8,-8},{8,8}},
          rotation=180,
          origin={68,-98})));
    Buildings.Fluid.Sources.Boundary_pT Atm_bath9(redeclare package Medium =
          MediumZone, nPorts=1) annotation (Placement(transformation(
          extent={{-6,-6},{6,6}},
          rotation=180,
          origin={72,-120})));
    Buildings.Fluid.FixedResistances.PressureDrop pressureDrop_bath9(
      redeclare package Medium = MediumZone,
      m_flow_nominal=mflow_inf_bath9,
      dp_nominal=100) annotation (Placement(transformation(
          extent={{-8,-9},{8,9}},
          rotation=180,
          origin={52,-121})));
  equation
    connect(freshAir_bedroom6.weaBus, weaBus) annotation (Line(
        points={{-228,56.2},{-234,56.2},{-234,74},{-142,74},{-142,100}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%second",
        index=1,
        extent={{6,3},{6,3}},
        horizontalAlignment=TextAlignment.Left));
    connect(freshAir_children10.weaBus, weaBus) annotation (Line(
        points={{-226,-95.8},{-234,-95.8},{-234,74},{-142,74},{-142,100}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%second",
        index=1,
        extent={{6,3},{6,3}},
        horizontalAlignment=TextAlignment.Left));
    connect(port_a[1], zonBedroom6.ports[1]) annotation (Line(points={{98,-148},
            {-176,-148},{-176,20},{-157.667,20},{-157.667,26.9}},
                                                             color={0,127,255}));
    connect(port_b[1], zonBedroom6.ports[2]) annotation (Line(points={{98,-174},{-176,
            -174},{-176,20},{-157,20},{-157,26.9}},          color={0,127,255}));
    connect(port_a[2], zonChildren7.ports[1]) annotation (Line(points={{98,-146},
            {-28,-146},{-28,20},{-1.66667,20},{-1.66667,26.9}}, color={0,127,
            255}));
    connect(port_b[2], zonChildren7.ports[2]) annotation (Line(points={{98,-172},
            {0,-172},{0,-144},{-28,-144},{-28,20},{-1,20},{-1,26.9}}, color={0,
            127,255}));
    connect(port_a[3],zonCorridor8. ports[1]) annotation (Line(points={{98,-144},{
            -28,-144},{-28,-54},{0.166667,-54},{0.166667,-45.1}}, color={0,127,
            255}));
    connect(port_b[3],zonCorridor8. ports[2]) annotation (Line(points={{98,-170},{
            0,-170},{0,-144},{-28,-144},{-28,-54},{0.5,-54},{0.5,-45.1}},
                                                                      color={0,
            127,255}));
    connect(port_a[4], zonBath9.ports[1]) annotation (Line(points={{98,-142},{
            2.33333,-142},{2.33333,-125.1}}, color={0,127,255}));
    connect(port_b[4], zonBath9.ports[2]) annotation (Line(points={{98,-168},{0,
            -168},{0,-144},{3,-144},{3,-125.1}}, color={0,127,255}));
    connect(port_a[5], zonChildren10.ports[1]) annotation (Line(points={{98,-140},
            {2,-140},{2,-132},{-153.667,-132},{-153.667,-123.1}},       color={
            0,127,255}));
    connect(port_b[5], zonChildren10.ports[2]) annotation (Line(points={{98,
            -166},{0,-166},{0,-144},{-28,-144},{-28,-132},{-153,-132},{-153,
            -123.1}}, color={0,127,255}));
    connect(FirstFloor[1], zonBedroom6.heaPorAir) annotation (Line(points={{-262,
            -32.4},{-240,-32.4},{-240,80},{-156,80},{-156,46}}, color={191,0,0}));
    connect(FirstFloor[2], zonChildren7.heaPorAir) annotation (Line(points={{-262,
            -29.2},{-240,-29.2},{-240,80},{0,80},{0,46}}, color={191,0,0}));
    connect(FirstFloor[3], zonCorridor8.heaPorAir) annotation (Line(points={{-262,
            -26},{-240,-26},{-240,80},{84,80},{84,-26},{2,-26}}, color={191,0,0}));
    connect(FirstFloor[4], zonBath9.heaPorAir) annotation (Line(points={{-262,-22.8},
            {-240,-22.8},{-240,-138},{4,-138},{4,-106}}, color={191,0,0}));
    connect(FirstFloor[5], zonChildren10.heaPorAir) annotation (Line(points={{-262,
            -19.6},{-240,-19.6},{-240,-104},{-152,-104}}, color={191,0,0}));
    connect(zonBedroom6.heaPorAir, tempAirBedroom6.port) annotation (Line(points=
            {{-156,46},{-26,46},{-26,19},{40,19}}, color={191,0,0}));
    connect(zonChildren7.heaPorAir, tempAirChildren7.port) annotation (Line(
          points={{0,46},{26,46},{26,0},{34,0},{34,-7},{40,-7}}, color={191,0,0}));
    connect(zonCorridor8.heaPorAir,tempAirCorr8. port) annotation (Line(points=
            {{2,-26},{2,-4},{32,-4},{32,-41},{40,-41}}, color={191,0,0}));
    connect(zonBath9.heaPorAir, tempAirBath9.port) annotation (Line(points={{4,
            -106},{4,-128},{28,-128},{28,-61},{40,-61}}, color={191,0,0}));
    connect(zonChildren10.heaPorAir, tempAirChildren10.port) annotation (Line(
          points={{-152,-104},{-90,-104},{-90,-94},{-26,-94},{-26,-76},{32,-76},
            {32,-82},{40,-82}}, color={191,0,0}));
    connect(TZoneMea, multiplex5_1.y) annotation (Line(points={{110,-28},{94,
            -28},{94,-52},{111,-52}}, color={0,0,127}));
    connect(tempAirBedroom6.T, multiplex5_1.u1[1]) annotation (Line(points={{
            54.7,19},{54.7,18},{86,18},{86,-36},{82,-36},{82,-42},{88,-42}},
          color={0,0,127}));
    connect(tempAirChildren7.T, multiplex5_1.u2[1]) annotation (Line(points={{
            54.7,-7},{82,-7},{82,-47},{88,-47}}, color={0,0,127}));
    connect(tempAirCorr8.T, multiplex5_1.u3[1]) annotation (Line(points={{54.7,
            -41},{82,-41},{82,-52},{88,-52}}, color={0,0,127}));
    connect(tempAirBath9.T, multiplex5_1.u4[1]) annotation (Line(points={{54.7,
            -61},{82,-61},{82,-57},{88,-57}}, color={0,0,127}));
    connect(tempAirChildren10.T, multiplex5_1.u5[1]) annotation (Line(points={{
            56.8,-82},{88,-82},{88,-62}}, color={0,0,127}));
    connect(qGain.y, zonBedroom6.qGai_flow) annotation (Line(points={{-250,-154},{-236,
            -154},{-236,26},{-184,26},{-184,56},{-178,56}}, color={0,0,127}));
    connect(qGain.y, zonChildren7.qGai_flow) annotation (Line(points={{-250,-154},
            {-236,-154},{-236,26},{-184,26},{-184,68},{-30,68},{-30,56},{-22,56}},
          color={0,0,127}));
    connect(qGain.y,zonCorridor8. qGai_flow) annotation (Line(points={{-250,-154},
            {-236,-154},{-236,26},{-184,26},{-184,68},{-30,68},{-30,-16},{-20,-16}},
          color={0,0,127}));
    connect(qGain.y, zonBath9.qGai_flow) annotation (Line(points={{-250,-154},{
            -236,-154},{-236,26},{-184,26},{-184,68},{-30,68},{-30,-16},{-26,-16},
            {-26,-80},{-22,-80},{-22,-90},{-24,-90},{-24,-96},{-18,-96}}, color=
           {0,0,127}));
    connect(qGain.y, zonChildren10.qGai_flow) annotation (Line(points={{-250,-154},
            {-236,-154},{-236,-94},{-232,-94},{-232,-80},{-182,-80},{-182,-94},
            {-174,-94}}, color={0,0,127}));
    connect(Atm_bedroom6.ports[1], pressureDrop_bedroom6.port_a)
      annotation (Line(points={{-210,34},{-204,34}}, color={0,127,255}));
    connect(freshAir_bedroom6.ports[1], zonBedroom6.ports[3]) annotation (Line(
          points={{-208,56},{-182,56},{-182,36},{-178,36},{-178,26.9},{-156.333,
            26.9}},
          color={0,127,255}));
    connect(pressureDrop_bedroom6.port_b, zonBedroom6.ports[4]) annotation (Line(
          points={{-184,34},{-178,34},{-178,26.9},{-155.667,26.9}},
                                                                  color={0,127,255}));
    connect(Atm_children10.ports[1], pressureDrop_Children10.port_a)
      annotation (Line(points={{-212,-122},{-204,-122}}, color={0,127,255}));
    connect(freshAir_children10.ports[1], zonChildren10.ports[3]) annotation (
        Line(points={{-206,-96},{-194,-96},{-194,-106},{-174,-106},{-174,-130},
            {-152.333,-130},{-152.333,-123.1}}, color={0,127,255}));
    connect(pressureDrop_Children10.port_b, zonChildren10.ports[4]) annotation (
       Line(points={{-184,-122},{-178,-122},{-178,-106},{-174,-106},{-174,-130},
            {-151.667,-130},{-151.667,-123.1}}, color={0,127,255}));
    connect(pressureDrop_children7.port_a, Atm_children7.ports[1]) annotation (
        Line(points={{52,41},{55,41},{55,42},{58,42}}, color={0,127,255}));
    connect(weaBus, freshAir_children7.weaBus) annotation (Line(
        points={{-142,100},{-142,72},{74,72},{74,61.84},{68,61.84}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(freshAir_children7.ports[1], zonChildren7.ports[3]) annotation (
        Line(points={{52,62},{28,62},{28,26.9},{-0.333333,26.9}}, color={0,127,
            255}));
    connect(pressureDrop_children7.port_b, zonChildren7.ports[4]) annotation (
        Line(points={{36,41},{36,40},{28,40},{28,26.9},{0.333333,26.9}}, color=
            {0,127,255}));
    connect(weaBus,freshAir_corridor8. weaBus) annotation (Line(
        points={{-142,100},{-142,72},{74,72},{74,16},{82,16},{82,5.84},{76,5.84}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));

    connect(freshAir_corridor8.ports[1],zonCorridor8. ports[3]) annotation (Line(
          points={{60,6},{28,6},{28,-52},{0.833333,-52},{0.833333,-45.1}}, color={
            0,127,255}));
    connect(Atm_corridor8.ports[1],pressureDrop_corridor8. port_a) annotation (
        Line(points={{66,-16},{63,-16},{63,-17},{60,-17}}, color={0,127,255}));
    connect(pressureDrop_corridor8.port_b,zonCorridor8. ports[4]) annotation (
        Line(points={{44,-17},{28,-17},{28,-52},{1.16667,-52},{1.16667,-45.1}},
          color={0,127,255}));
    connect(freshAir_bath9.ports[1], zonBath9.ports[3]) annotation (Line(points=
           {{60,-98},{30,-98},{30,-132},{3.66667,-132},{3.66667,-125.1}}, color=
           {0,127,255}));
    connect(pressureDrop_bath9.port_b, zonBath9.ports[4]) annotation (Line(
          points={{44,-121},{30,-121},{30,-132},{4.33333,-132},{4.33333,-125.1}},
          color={0,127,255}));
    connect(pressureDrop_bath9.port_a, Atm_bath9.ports[1]) annotation (Line(
          points={{60,-121},{63,-121},{63,-120},{66,-120}}, color={0,127,255}));
    connect(dooBed6Corr8.port_a1, zonBedroom6.ports[5]) annotation (Line(points={{-126,
            12},{-128,12},{-128,26.9},{-155,26.9}}, color={0,127,255}));
    connect(dooBed6Corr8.port_b2, zonBedroom6.ports[6]) annotation (Line(points={{-126,0},
            {-128,0},{-128,26.9},{-154.333,26.9}},    color={0,127,255}));
    connect(dooBed6Corr8.port_b1,zonCorridor8. ports[5]) annotation (Line(points={
            {-106,12},{-72,12},{-72,-50},{-30,-50},{-30,-54},{1.5,-54},{1.5,-45.1}},
          color={0,127,255}));
    connect(dooBed6Corr8.port_a2,zonCorridor8. ports[6]) annotation (Line(points={
            {-106,0},{-72,0},{-72,-50},{-30,-50},{-30,-54},{1.83333,-54},{1.83333,
            -45.1}}, color={0,127,255}));
    connect(zonChildren7.ports[5], dooCorr8Child7.port_a1) annotation (Line(
          points={{1,26.9},{1,22},{-40,22},{-40,26},{-72,26},{-72,16},{-66,16}},
          color={0,127,255}));
    connect(zonChildren7.ports[6], dooCorr8Child7.port_b2) annotation (Line(
          points={{1.66667,26.9},{1.66667,22},{-40,22},{-40,26},{-72,26},{-72,
            10},{-74,10},{-74,4},{-66,4}}, color={0,127,255}));
    connect(dooCorr8Child7.port_b1,zonCorridor8. ports[7]) annotation (Line(
          points={{-46,16},{-32,16},{-32,-50},{-30,-50},{-30,-54},{2.16667,-54},{2.16667,
            -45.1}}, color={0,127,255}));
    connect(dooCorr8Child7.port_a2,zonCorridor8. ports[8]) annotation (Line(
          points={{-46,4},{-32,4},{-32,-50},{-30,-50},{-30,-54},{2.5,-54},{2.5,-45.1}},
          color={0,127,255}));
    connect(dooBath9Corr8.port_a1, zonBath9.ports[5]) annotation (Line(points={
            {-58,-62},{-64,-62},{-64,-96},{-26,-96},{-26,-134},{5,-134},{5,
            -125.1}}, color={0,127,255}));
    connect(dooBath9Corr8.port_b2, zonBath9.ports[6]) annotation (Line(points={
            {-58,-74},{-64,-74},{-64,-96},{-26,-96},{-26,-134},{5.66667,-134},{
            5.66667,-125.1}}, color={0,127,255}));
    connect(dooBath9Corr8.port_b1, zonCorridor8.ports[9]) annotation (Line(
          points={{-38,-62},{-28,-62},{-28,-54},{2.83333,-54},{2.83333,-45.1}},
          color={0,127,255}));
    connect(dooBath9Corr8.port_a2, zonCorridor8.ports[10]) annotation (Line(
          points={{-38,-74},{-28,-74},{-28,-54},{3.16667,-54},{3.16667,-45.1}},
          color={0,127,255}));
    connect(dooCorr8Child10.port_a1, zonChildren10.ports[5]) annotation (Line(
          points={{-124,-64},{-126,-64},{-126,-132},{-151,-132},{-151,-123.1}},
          color={0,127,255}));
    connect(dooCorr8Child10.port_b2, zonChildren10.ports[6]) annotation (Line(
          points={{-124,-76},{-126,-76},{-126,-132},{-150.333,-132},{-150.333,
            -123.1}}, color={0,127,255}));
    connect(dooCorr8Child10.port_b1, zonCorridor8.ports[11]) annotation (Line(
          points={{-104,-64},{-68,-64},{-68,-50},{-30,-50},{-30,-54},{3.5,-54},
            {3.5,-45.1}}, color={0,127,255}));
    connect(dooCorr8Child10.port_a2, zonCorridor8.ports[12]) annotation (Line(
          points={{-104,-76},{-68,-76},{-68,-50},{-30,-50},{-30,-54},{3.83333,-54},
            {3.83333,-45.1}}, color={0,127,255}));
    connect(weaBus, freshAir_bath9.weaBus) annotation (Line(
        points={{-142,100},{-142,72},{74,72},{74,16},{82,16},{82,-28},{78,-28},
            {78,-84},{82,-84},{82,-98.16},{76,-98.16}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-260,-180},
              {100,100}})), Diagram(coordinateSystem(preserveAspectRatio=false,
            extent={{-260,-180},{100,100}})));
  end FirstFloor2;

  model GroundFloor3
    parameter Boolean use_openModelica=false
      "=true to disable features which 
    are not available in open modelica"   annotation(Dialog(tab="Advanced"));
    replaceable package MediumZone = IBPSA.Media.Air constrainedby
      Modelica.Media.Interfaces.PartialMedium;
    parameter Modelica.Units.SI.Volume VRooLiving1 = 59.98;
    parameter Modelica.Units.SI.Volume VRooHobby2 = 33.63;
    parameter Modelica.Units.SI.Volume VRooCorridor3 = 39.9;
    parameter Modelica.Units.SI.Volume VRooWC4 = 33.63;
    parameter Modelica.Units.SI.Volume VRooKitchen5 = 48.67;
    parameter Modelica.Units.SI.MassFlowRate mflow_inf_living1 = 0.5*VRooLiving1*1.2/3600;
    parameter Modelica.Units.SI.MassFlowRate mflow_inf_hobby2 = 0.5*VRooHobby2*1.2/3600;
    parameter Modelica.Units.SI.MassFlowRate mflow_inf_corridor3 = 0.000000001*VRooCorridor3*1.2/3600;
    parameter Modelica.Units.SI.MassFlowRate mflow_inf_WC4 = 0.5*VRooWC4*1.2/3600;
    parameter Modelica.Units.SI.MassFlowRate mflow_inf_kitchen5 = 0.5*VRooKitchen5*1.2/3600;
    parameter Boolean use_windPressure = true;
    Buildings.Fluid.Sources.MassFlowSource_WeatherData freshAir_living1(
      redeclare package Medium = MediumZone,
      m_flow=mflow_inf_living1,
      nPorts=1)
      annotation (Placement(transformation(extent={{-228,46},{-208,66}})));
    Buildings.Fluid.Sources.MassFlowSource_WeatherData freshAir_Kitchen5(
      redeclare package Medium = MediumZone,
      m_flow=mflow_inf_kitchen5,
      nPorts=1)
      annotation (Placement(transformation(extent={{-226,-106},{-206,-86}})));
    Buildings.BoundaryConditions.WeatherData.Bus weaBus annotation (Placement(
          transformation(extent={{-162,80},{-122,120}}), iconTransformation(
            extent={{-128,90},{-108,110}})));
    Buildings.ThermalZones.EnergyPlus_9_6_0.ThermalZone zonLiving1(zoneName=
          "TKJwNLssk0WyOEqTNi9V3g",
      redeclare package Medium = MediumZone,
                                    nPorts=4)
      annotation (Placement(transformation(extent={{-176,26},{-136,66}})));
    Buildings.ThermalZones.EnergyPlus_9_6_0.ThermalZone zonKitchen5(zoneName=
          "ewAwLYZUK0GDV9RQVVrdsw",
      redeclare package Medium = MediumZone,
                                    nPorts=4)
      annotation (Placement(transformation(extent={{-172,-124},{-132,-84}})));
    Buildings.ThermalZones.EnergyPlus_9_6_0.ThermalZone zonHobby2(zoneName=
          "Jo5bB3uKtUesyY40h7buXA",
      redeclare package Medium = MediumZone,
                                    nPorts=4)
      annotation (Placement(transformation(extent={{-20,26},{20,66}})));
    Buildings.ThermalZones.EnergyPlus_9_6_0.ThermalZone zonCorridor3(zoneName=
          "VxcvwqdxJ0CrsbXjgBdn2A",
      redeclare package Medium = MediumZone,
                                    nPorts=4)
      annotation (Placement(transformation(extent={{-18,-46},{22,-6}})));
    Buildings.ThermalZones.EnergyPlus_9_6_0.ThermalZone zonWC4(zoneName=
          "8VvlyRmVH0C1HUd3CNvpWg",
      redeclare package Medium = MediumZone,
                                    nPorts=4)
      annotation (Placement(transformation(extent={{-16,-126},{24,-86}})));
    Modelica.Fluid.Interfaces.FluidPort_a port_a[5](redeclare package Medium =
          MediumZone)
      annotation (Placement(transformation(extent={{88,-154},{108,-134}})));
    Modelica.Fluid.Interfaces.FluidPort_b port_b[5](redeclare package Medium =
          MediumZone)
      annotation (Placement(transformation(extent={{88,-180},{108,-160}})));
    Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a GroundFloor[5]
      annotation (Placement(transformation(extent={{-278,-42},{-246,-10}}),
          iconTransformation(extent={{-278,-42},{-246,-10}})));
    Modelica.Blocks.Interfaces.RealOutput TZoneMea[5]
      annotation (Placement(transformation(extent={{100,-38},{120,-18}})));
    Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor tempAirLiving1
      annotation (Placement(transformation(extent={{40,12},{54,26}})));
    Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor tempAirHobby2
      annotation (Placement(transformation(extent={{40,-14},{54,0}})));
    Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor tempAirCorr3
      annotation (Placement(transformation(extent={{40,-48},{54,-34}})));
    Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor tempAirWC4
      annotation (Placement(transformation(extent={{40,-68},{54,-54}})));
    Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor tempAirKitchen5
      annotation (Placement(transformation(extent={{40,-90},{56,-74}})));
    Modelica.Blocks.Routing.Multiplex5 multiplex5_1
      annotation (Placement(transformation(extent={{90,-62},{110,-42}})));
    Buildings.Controls.OBC.CDL.Continuous.Sources.Constant qGain[3](k={0,0,0})
      annotation (Placement(transformation(extent={{-272,-164},{-252,-144}})));
    Buildings.Fluid.FixedResistances.PressureDrop pressureDrop_living1(
      redeclare package Medium = MediumZone,
      m_flow_nominal=mflow_inf_living1,
      dp_nominal=100)
      annotation (Placement(transformation(extent={{-204,24},{-184,44}})));
    Buildings.Fluid.Sources.Boundary_pT Atm_living1(redeclare package Medium =
          MediumZone, nPorts=1)
      annotation (Placement(transformation(extent={{-230,24},{-210,44}})));
    Buildings.Fluid.FixedResistances.PressureDrop pressureDrop_Kitchen5(
      redeclare package Medium = MediumZone,
      m_flow_nominal=mflow_inf_kitchen5,
      dp_nominal=100)
      annotation (Placement(transformation(extent={{-204,-132},{-184,-112}})));
    Buildings.Fluid.Sources.Boundary_pT Atm_kitchen5(redeclare package Medium =
          MediumZone, nPorts=1)
      annotation (Placement(transformation(extent={{-232,-132},{-212,-112}})));
    Buildings.Fluid.Sources.MassFlowSource_WeatherData freshAir_hobby2(
      redeclare package Medium = MediumZone,
      m_flow=mflow_inf_hobby2,
      nPorts=1) annotation (Placement(transformation(
          extent={{-8,-8},{8,8}},
          rotation=180,
          origin={60,62})));
    Buildings.Fluid.FixedResistances.PressureDrop pressureDrop_hobby2(
      redeclare package Medium = MediumZone,
      m_flow_nominal=mflow_inf_hobby2,
      dp_nominal=100) annotation (Placement(transformation(
          extent={{-8,-9},{8,9}},
          rotation=180,
          origin={44,41})));
    Buildings.Fluid.Sources.Boundary_pT Atm_hobby2(redeclare package Medium =
          MediumZone, nPorts=1) annotation (Placement(transformation(
          extent={{-6,-6},{6,6}},
          rotation=180,
          origin={64,42})));
    Buildings.Fluid.Sources.MassFlowSource_WeatherData freshAir_corridor3(
      redeclare package Medium = MediumZone,
      m_flow=mflow_inf_corridor3,
      nPorts=1) annotation (Placement(transformation(
          extent={{-8,-8},{8,8}},
          rotation=180,
          origin={68,6})));
    Buildings.Fluid.Sources.Boundary_pT Atm_corridor3(redeclare package Medium =
          MediumZone, nPorts=1) annotation (Placement(transformation(
          extent={{-6,-6},{6,6}},
          rotation=180,
          origin={72,-16})));
    Buildings.Fluid.FixedResistances.PressureDrop pressureDrop_corridor3(
      redeclare package Medium = MediumZone,
      m_flow_nominal=mflow_inf_corridor3,
      dp_nominal=100) annotation (Placement(transformation(
          extent={{-8,-9},{8,9}},
          rotation=180,
          origin={52,-17})));
    Buildings.Fluid.Sources.MassFlowSource_WeatherData freshAir_WC4(
      redeclare package Medium = MediumZone,
      m_flow=mflow_inf_WC4,
      nPorts=1) annotation (Placement(transformation(
          extent={{-8,-8},{8,8}},
          rotation=180,
          origin={68,-98})));
    Buildings.Fluid.Sources.Boundary_pT Atm_WC4(redeclare package Medium =
          MediumZone, nPorts=1) annotation (Placement(transformation(
          extent={{-6,-6},{6,6}},
          rotation=180,
          origin={72,-120})));
    Buildings.Fluid.FixedResistances.PressureDrop pressureDrop_WC4(
      redeclare package Medium = MediumZone,
      m_flow_nominal=mflow_inf_WC4,
      dp_nominal=100) annotation (Placement(transformation(
          extent={{-8,-9},{8,9}},
          rotation=180,
          origin={52,-121})));
  equation
    connect(freshAir_living1.weaBus, weaBus) annotation (Line(
        points={{-228,56.2},{-234,56.2},{-234,74},{-142,74},{-142,100}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%second",
        index=1,
        extent={{6,3},{6,3}},
        horizontalAlignment=TextAlignment.Left));
    connect(freshAir_Kitchen5.weaBus, weaBus) annotation (Line(
        points={{-226,-95.8},{-234,-95.8},{-234,74},{-142,74},{-142,100}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%second",
        index=1,
        extent={{6,3},{6,3}},
        horizontalAlignment=TextAlignment.Left));
    connect(port_a[1], zonLiving1.ports[1]) annotation (Line(points={{98,-148},
            {-176,-148},{-176,20},{-157.5,20},{-157.5,26.9}},color={0,127,255}));
    connect(port_b[1], zonLiving1.ports[2]) annotation (Line(points={{98,-174},
            {-176,-174},{-176,20},{-156.5,20},{-156.5,26.9}},color={0,127,255}));
    connect(port_a[2], zonHobby2.ports[1]) annotation (Line(points={{98,-146},{
            -28,-146},{-28,20},{-1.5,20},{-1.5,26.9}},
                                                   color={0,127,255}));
    connect(port_b[2], zonHobby2.ports[2]) annotation (Line(points={{98,-172},{
            0,-172},{0,-144},{-28,-144},{-28,20},{-0.5,20},{-0.5,26.9}},
                                                                       color={0,
            127,255}));
    connect(port_a[3], zonCorridor3.ports[1]) annotation (Line(points={{98,-144},
            {-28,-144},{-28,-54},{0.5,-54},{0.5,-45.1}},          color={0,127,
            255}));
    connect(port_b[3], zonCorridor3.ports[2]) annotation (Line(points={{98,-170},
            {0,-170},{0,-144},{-28,-144},{-28,-54},{1.5,-54},{1.5,-45.1}},
                                                                      color={0,
            127,255}));
    connect(port_a[4], zonWC4.ports[1]) annotation (Line(points={{98,-142},{2.5,
            -142},{2.5,-125.1}}, color={0,127,255}));
    connect(port_b[4], zonWC4.ports[2]) annotation (Line(points={{98,-168},{0,
            -168},{0,-144},{3.5,-144},{3.5,-125.1}},
                                               color={0,127,255}));
    connect(port_a[5], zonKitchen5.ports[1]) annotation (Line(points={{98,-140},
            {2,-140},{2,-132},{-153.5,-132},{-153.5,-123.1}},
                                                           color={0,127,255}));
    connect(port_b[5], zonKitchen5.ports[2]) annotation (Line(points={{98,-166},
            {0,-166},{0,-144},{-28,-144},{-28,-132},{-152.5,-132},{-152.5,
            -123.1}},
          color={0,127,255}));
    connect(GroundFloor[1], zonLiving1.heaPorAir) annotation (Line(points={{
            -262,-32.4},{-240,-32.4},{-240,80},{-156,80},{-156,46}}, color={191,
            0,0}));
    connect(GroundFloor[2], zonHobby2.heaPorAir) annotation (Line(points={{-262,
            -29.2},{-240,-29.2},{-240,80},{0,80},{0,46}}, color={191,0,0}));
    connect(GroundFloor[3], zonCorridor3.heaPorAir) annotation (Line(points={{
            -262,-26},{-240,-26},{-240,80},{84,80},{84,-26},{2,-26}}, color={
            191,0,0}));
    connect(GroundFloor[4], zonWC4.heaPorAir) annotation (Line(points={{-262,
            -22.8},{-240,-22.8},{-240,-138},{4,-138},{4,-106}}, color={191,0,0}));
    connect(GroundFloor[5], zonKitchen5.heaPorAir) annotation (Line(points={{
            -262,-19.6},{-240,-19.6},{-240,-104},{-152,-104}}, color={191,0,0}));
    connect(zonLiving1.heaPorAir, tempAirLiving1.port) annotation (Line(points=
            {{-156,46},{-26,46},{-26,19},{40,19}}, color={191,0,0}));
    connect(zonHobby2.heaPorAir, tempAirHobby2.port) annotation (Line(points={{
            0,46},{26,46},{26,0},{34,0},{34,-7},{40,-7}}, color={191,0,0}));
    connect(zonCorridor3.heaPorAir, tempAirCorr3.port) annotation (Line(points=
            {{2,-26},{2,-4},{32,-4},{32,-41},{40,-41}}, color={191,0,0}));
    connect(zonWC4.heaPorAir, tempAirWC4.port) annotation (Line(points={{4,-106},
            {4,-128},{28,-128},{28,-61},{40,-61}}, color={191,0,0}));
    connect(zonKitchen5.heaPorAir, tempAirKitchen5.port) annotation (Line(
          points={{-152,-104},{-90,-104},{-90,-94},{-26,-94},{-26,-76},{32,-76},
            {32,-82},{40,-82}}, color={191,0,0}));
    connect(TZoneMea, multiplex5_1.y) annotation (Line(points={{110,-28},{94,
            -28},{94,-52},{111,-52}}, color={0,0,127}));
    connect(tempAirLiving1.T, multiplex5_1.u1[1]) annotation (Line(points={{
            54.7,19},{54.7,18},{86,18},{86,-36},{82,-36},{82,-42},{88,-42}},
          color={0,0,127}));
    connect(tempAirHobby2.T, multiplex5_1.u2[1]) annotation (Line(points={{54.7,
            -7},{82,-7},{82,-47},{88,-47}}, color={0,0,127}));
    connect(tempAirCorr3.T, multiplex5_1.u3[1]) annotation (Line(points={{54.7,
            -41},{82,-41},{82,-52},{88,-52}}, color={0,0,127}));
    connect(tempAirWC4.T, multiplex5_1.u4[1]) annotation (Line(points={{54.7,
            -61},{82,-61},{82,-57},{88,-57}}, color={0,0,127}));
    connect(tempAirKitchen5.T, multiplex5_1.u5[1]) annotation (Line(points={{
            56.8,-82},{88,-82},{88,-62}}, color={0,0,127}));
    connect(qGain.y, zonLiving1.qGai_flow) annotation (Line(points={{-250,-154},{-236,
            -154},{-236,26},{-184,26},{-184,56},{-178,56}}, color={0,0,127}));
    connect(qGain.y, zonHobby2.qGai_flow) annotation (Line(points={{-250,-154},{-236,
            -154},{-236,26},{-184,26},{-184,68},{-30,68},{-30,56},{-22,56}},
          color={0,0,127}));
    connect(qGain.y, zonCorridor3.qGai_flow) annotation (Line(points={{-250,-154},
            {-236,-154},{-236,26},{-184,26},{-184,68},{-30,68},{-30,-16},{-20,-16}},
          color={0,0,127}));
    connect(qGain.y, zonWC4.qGai_flow) annotation (Line(points={{-250,-154},{-236,
            -154},{-236,26},{-184,26},{-184,68},{-30,68},{-30,-16},{-26,-16},{-26,
            -80},{-22,-80},{-22,-90},{-24,-90},{-24,-96},{-18,-96}}, color={0,0,127}));
    connect(qGain.y, zonKitchen5.qGai_flow) annotation (Line(points={{-250,-154},{
            -236,-154},{-236,-94},{-232,-94},{-232,-80},{-182,-80},{-182,-94},{-174,
            -94}}, color={0,0,127}));
    connect(Atm_living1.ports[1], pressureDrop_living1.port_a)
      annotation (Line(points={{-210,34},{-204,34}}, color={0,127,255}));
    connect(freshAir_living1.ports[1], zonLiving1.ports[3]) annotation (Line(
          points={{-208,56},{-182,56},{-182,36},{-178,36},{-178,26.9},{-155.5,
            26.9}},
          color={0,127,255}));
    connect(pressureDrop_living1.port_b, zonLiving1.ports[4]) annotation (Line(
          points={{-184,34},{-178,34},{-178,26.9},{-154.5,26.9}}, color={0,127,255}));
    connect(Atm_kitchen5.ports[1], pressureDrop_Kitchen5.port_a)
      annotation (Line(points={{-212,-122},{-204,-122}}, color={0,127,255}));
    connect(freshAir_Kitchen5.ports[1], zonKitchen5.ports[3]) annotation (Line(
          points={{-206,-96},{-194,-96},{-194,-106},{-174,-106},{-174,-130},{
            -151.5,-130},{-151.5,-123.1}},
                                    color={0,127,255}));
    connect(pressureDrop_Kitchen5.port_b, zonKitchen5.ports[4]) annotation (Line(
          points={{-184,-122},{-178,-122},{-178,-106},{-174,-106},{-174,-130},{
            -150.5,-130},{-150.5,-123.1}},
                                  color={0,127,255}));
    connect(pressureDrop_hobby2.port_a, Atm_hobby2.ports[1]) annotation (Line(
          points={{52,41},{55,41},{55,42},{58,42}}, color={0,127,255}));
    connect(weaBus, freshAir_hobby2.weaBus) annotation (Line(
        points={{-142,100},{-142,72},{74,72},{74,61.84},{68,61.84}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(freshAir_hobby2.ports[1], zonHobby2.ports[3]) annotation (Line(points={{52,62},
            {28,62},{28,26.9},{0.5,26.9}},               color={0,127,255}));
    connect(pressureDrop_hobby2.port_b, zonHobby2.ports[4]) annotation (Line(
          points={{36,41},{36,40},{28,40},{28,26.9},{1.5,26.9}},      color={0,127,
            255}));
    connect(weaBus, freshAir_corridor3.weaBus) annotation (Line(
        points={{-142,100},{-142,72},{74,72},{74,16},{82,16},{82,5.84},{76,5.84}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));

    connect(freshAir_corridor3.ports[1], zonCorridor3.ports[3]) annotation (Line(
          points={{60,6},{28,6},{28,-52},{2.5,-52},{2.5,-45.1}},           color={
            0,127,255}));
    connect(Atm_corridor3.ports[1], pressureDrop_corridor3.port_a) annotation (
        Line(points={{66,-16},{63,-16},{63,-17},{60,-17}}, color={0,127,255}));
    connect(pressureDrop_corridor3.port_b, zonCorridor3.ports[4]) annotation (
        Line(points={{44,-17},{28,-17},{28,-52},{3.5,-52},{3.5,-45.1}},
          color={0,127,255}));
    connect(freshAir_WC4.ports[1], zonWC4.ports[3]) annotation (Line(points={{60,-98},
            {30,-98},{30,-132},{4.5,-132},{4.5,-125.1}},   color={0,127,255}));
    connect(pressureDrop_WC4.port_b, zonWC4.ports[4]) annotation (Line(points={{44,-121},
            {30,-121},{30,-132},{5.5,-132},{5.5,-125.1}},         color={0,127,255}));
    connect(pressureDrop_WC4.port_a, Atm_WC4.ports[1]) annotation (Line(points={{60,
            -121},{63,-121},{63,-120},{66,-120}}, color={0,127,255}));
    connect(weaBus, freshAir_WC4.weaBus) annotation (Line(
        points={{-142,100},{-142,72},{74,72},{74,16},{82,16},{82,-28},{78,-28},{78,
            -84},{82,-84},{82,-98.16},{76,-98.16}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-260,-180},
              {100,100}})), Diagram(coordinateSystem(preserveAspectRatio=false,
            extent={{-260,-180},{100,100}})),
      Documentation(info="<html>
<p>Ground floor of the HOM IDF model with a constant air infiltration</p>
</html>"));
  end GroundFloor3;

  model FirstFloor3
    parameter Boolean use_openModelica=false
      "=true to disable features which 
    are not available in open modelica"   annotation(Dialog(tab="Advanced"));
    replaceable package MediumZone = IBPSA.Media.Air constrainedby
      Modelica.Media.Interfaces.PartialMedium;
    parameter Modelica.Units.SI.Volume VRooBedroom6 = 59.98;
    parameter Modelica.Units.SI.Volume VRooChildren7 = 33.63;
    parameter Modelica.Units.SI.Volume VRooCorridor8 = 39.9;
    parameter Modelica.Units.SI.Volume VRooBath9 = 33.63;
    parameter Modelica.Units.SI.Volume VRooChildren10 = 48.67;
    parameter Modelica.Units.SI.MassFlowRate mflow_inf_bedroom6 = 0.5*VRooBedroom6*1.2/3600;
    parameter Modelica.Units.SI.MassFlowRate mflow_inf_children7 = 0.5*VRooChildren7*1.2/3600;
    parameter Modelica.Units.SI.MassFlowRate mflow_inf_corridor8 = 0.0000000001*VRooCorridor8*1.2/3600;
    parameter Modelica.Units.SI.MassFlowRate mflow_inf_bath9 = 0.5*VRooBath9*1.2/3600;
    parameter Modelica.Units.SI.MassFlowRate mflow_inf_children10 = 0.5*VRooChildren10*1.2/3600;
    parameter Boolean use_windPressure = true;
    Buildings.Fluid.Sources.MassFlowSource_WeatherData freshAir_bedroom6(
      redeclare package Medium = MediumZone,
      m_flow=mflow_inf_bedroom6,
      nPorts=1)
      annotation (Placement(transformation(extent={{-228,46},{-208,66}})));
    Buildings.Fluid.Sources.MassFlowSource_WeatherData freshAir_children10(
      redeclare package Medium = MediumZone,
      m_flow=mflow_inf_children10,
      nPorts=1)
      annotation (Placement(transformation(extent={{-226,-106},{-206,-86}})));
    Buildings.BoundaryConditions.WeatherData.Bus weaBus annotation (Placement(
          transformation(extent={{-162,80},{-122,120}}), iconTransformation(
            extent={{-128,90},{-108,110}})));
    Buildings.ThermalZones.EnergyPlus_9_6_0.ThermalZone zonBedroom6(
      zoneName="JIlBdoXH9kyILsDvu4wx8A",
      redeclare package Medium = MediumZone,
                                    nPorts=4)
      annotation (Placement(transformation(extent={{-176,26},{-136,66}})));
    Buildings.ThermalZones.EnergyPlus_9_6_0.ThermalZone zonChildren10(
      zoneName="uFb0fbIbnUCa0AXLT56UfA",
      redeclare package Medium = MediumZone,
      nPorts=4)
      annotation (Placement(transformation(extent={{-172,-124},{-132,-84}})));
    Buildings.ThermalZones.EnergyPlus_9_6_0.ThermalZone zonChildren7(
      zoneName="BGVPLnC4OUeqffvCvT6TTQ",
      redeclare package Medium = MediumZone,
      nPorts=4) annotation (Placement(transformation(extent={{-20,26},{20,66}})));
    Buildings.ThermalZones.EnergyPlus_9_6_0.ThermalZone zonCorridor8(
      zoneName="amiO3KhG402UMEU7Fs9xaA",
      redeclare package Medium = MediumZone,
                                    nPorts=4)
      annotation (Placement(transformation(extent={{-18,-46},{22,-6}})));
    Buildings.ThermalZones.EnergyPlus_9_6_0.ThermalZone zonBath9(
      zoneName="E4XJpmy03kW3qfdfjVrPLA",
      redeclare package Medium = MediumZone,
      nPorts=4)
      annotation (Placement(transformation(extent={{-16,-126},{24,-86}})));
    Modelica.Fluid.Interfaces.FluidPort_a port_a[5](redeclare package Medium =
          MediumZone)
      annotation (Placement(transformation(extent={{88,-154},{108,-134}})));
    Modelica.Fluid.Interfaces.FluidPort_b port_b[5](redeclare package Medium =
          MediumZone)
      annotation (Placement(transformation(extent={{88,-180},{108,-160}})));
    Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a FirstFloor[5] annotation (
       Placement(transformation(extent={{-278,-42},{-246,-10}}),
          iconTransformation(extent={{-278,-42},{-246,-10}})));
    Modelica.Blocks.Interfaces.RealOutput TZoneMea[5]
      annotation (Placement(transformation(extent={{100,-38},{120,-18}})));
    Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor tempAirBedroom6
      annotation (Placement(transformation(extent={{40,12},{54,26}})));
    Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor tempAirChildren7
      annotation (Placement(transformation(extent={{40,-14},{54,0}})));
    Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor tempAirCorr8
      annotation (Placement(transformation(extent={{40,-48},{54,-34}})));
    Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor tempAirBath9
      annotation (Placement(transformation(extent={{40,-68},{54,-54}})));
    Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor tempAirChildren10
      annotation (Placement(transformation(extent={{40,-90},{56,-74}})));
    Modelica.Blocks.Routing.Multiplex5 multiplex5_1
      annotation (Placement(transformation(extent={{90,-62},{110,-42}})));
    Buildings.Controls.OBC.CDL.Continuous.Sources.Constant qGain[3](k={0,0,0})
      annotation (Placement(transformation(extent={{-272,-164},{-252,-144}})));
    Buildings.Fluid.FixedResistances.PressureDrop pressureDrop_bedroom6(
      redeclare package Medium = MediumZone,
      m_flow_nominal=mflow_inf_bedroom6,
      dp_nominal=100)
      annotation (Placement(transformation(extent={{-204,24},{-184,44}})));
    Buildings.Fluid.Sources.Boundary_pT Atm_bedroom6(redeclare package Medium =
          MediumZone, nPorts=1)
      annotation (Placement(transformation(extent={{-230,24},{-210,44}})));
    Buildings.Fluid.FixedResistances.PressureDrop pressureDrop_Children10(
      redeclare package Medium = MediumZone,
      m_flow_nominal=mflow_inf_children10,
      dp_nominal=100)
      annotation (Placement(transformation(extent={{-204,-132},{-184,-112}})));
    Buildings.Fluid.Sources.Boundary_pT Atm_children10(redeclare package Medium =
          MediumZone, nPorts=1)
      annotation (Placement(transformation(extent={{-232,-132},{-212,-112}})));
    Buildings.Fluid.Sources.MassFlowSource_WeatherData freshAir_children7(
      redeclare package Medium = MediumZone,
      m_flow=mflow_inf_children7,
      nPorts=1) annotation (Placement(transformation(
          extent={{-8,-8},{8,8}},
          rotation=180,
          origin={60,62})));
    Buildings.Fluid.FixedResistances.PressureDrop pressureDrop_children7(
      redeclare package Medium = MediumZone,
      m_flow_nominal=mflow_inf_children7,
      dp_nominal=100) annotation (Placement(transformation(
          extent={{-8,-9},{8,9}},
          rotation=180,
          origin={44,41})));
    Buildings.Fluid.Sources.Boundary_pT Atm_children7(redeclare package Medium =
          MediumZone, nPorts=1) annotation (Placement(transformation(
          extent={{-6,-6},{6,6}},
          rotation=180,
          origin={64,42})));
    Buildings.Fluid.Sources.MassFlowSource_WeatherData freshAir_corridor8(
      redeclare package Medium = MediumZone,
      m_flow=mflow_inf_corridor8,
      nPorts=1) annotation (Placement(transformation(
          extent={{-8,-8},{8,8}},
          rotation=180,
          origin={68,6})));
    Buildings.Fluid.Sources.Boundary_pT Atm_corridor8(redeclare package Medium =
          MediumZone, nPorts=1) annotation (Placement(transformation(
          extent={{-6,-6},{6,6}},
          rotation=180,
          origin={72,-16})));
    Buildings.Fluid.FixedResistances.PressureDrop pressureDrop_corridor8(
      redeclare package Medium = MediumZone,
      m_flow_nominal=mflow_inf_corridor8,
      dp_nominal=100) annotation (Placement(transformation(
          extent={{-8,-9},{8,9}},
          rotation=180,
          origin={52,-17})));
    Buildings.Fluid.Sources.MassFlowSource_WeatherData freshAir_bath9(
      redeclare package Medium = MediumZone,
      m_flow=mflow_inf_bath9,
      nPorts=1) annotation (Placement(transformation(
          extent={{-8,-8},{8,8}},
          rotation=180,
          origin={68,-98})));
    Buildings.Fluid.Sources.Boundary_pT Atm_bath9(redeclare package Medium =
          MediumZone, nPorts=1) annotation (Placement(transformation(
          extent={{-6,-6},{6,6}},
          rotation=180,
          origin={72,-120})));
    Buildings.Fluid.FixedResistances.PressureDrop pressureDrop_bath9(
      redeclare package Medium = MediumZone,
      m_flow_nominal=mflow_inf_bath9,
      dp_nominal=100) annotation (Placement(transformation(
          extent={{-8,-9},{8,9}},
          rotation=180,
          origin={52,-121})));
  equation
    connect(freshAir_bedroom6.weaBus, weaBus) annotation (Line(
        points={{-228,56.2},{-234,56.2},{-234,74},{-142,74},{-142,100}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%second",
        index=1,
        extent={{6,3},{6,3}},
        horizontalAlignment=TextAlignment.Left));
    connect(freshAir_children10.weaBus, weaBus) annotation (Line(
        points={{-226,-95.8},{-234,-95.8},{-234,74},{-142,74},{-142,100}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%second",
        index=1,
        extent={{6,3},{6,3}},
        horizontalAlignment=TextAlignment.Left));
    connect(port_a[1], zonBedroom6.ports[1]) annotation (Line(points={{98,-148},
            {-176,-148},{-176,20},{-157.5,20},{-157.5,26.9}},color={0,127,255}));
    connect(port_b[1], zonBedroom6.ports[2]) annotation (Line(points={{98,-174},
            {-176,-174},{-176,20},{-156.5,20},{-156.5,26.9}},color={0,127,255}));
    connect(port_a[2], zonChildren7.ports[1]) annotation (Line(points={{98,-146},
            {-28,-146},{-28,20},{-1.5,20},{-1.5,26.9}},        color={0,127,255}));
    connect(port_b[2], zonChildren7.ports[2]) annotation (Line(points={{98,-172},
            {0,-172},{0,-144},{-28,-144},{-28,20},{-0.5,20},{-0.5,26.9}},
                                                                     color={0,127,
            255}));
    connect(port_a[3],zonCorridor8. ports[1]) annotation (Line(points={{98,-144},
            {-28,-144},{-28,-54},{0.5,-54},{0.5,-45.1}},          color={0,127,
            255}));
    connect(port_b[3],zonCorridor8. ports[2]) annotation (Line(points={{98,-170},
            {0,-170},{0,-144},{-28,-144},{-28,-54},{1.5,-54},{1.5,-45.1}},
                                                                      color={0,
            127,255}));
    connect(port_a[4], zonBath9.ports[1]) annotation (Line(points={{98,-142},{
            2.5,-142},{2.5,-125.1}},
                                  color={0,127,255}));
    connect(port_b[4], zonBath9.ports[2]) annotation (Line(points={{98,-168},{0,
            -168},{0,-144},{3.5,-144},{3.5,-125.1}},
                                                 color={0,127,255}));
    connect(port_a[5], zonChildren10.ports[1]) annotation (Line(points={{98,-140},
            {2,-140},{2,-132},{-153.5,-132},{-153.5,-123.1}},   color={0,127,255}));
    connect(port_b[5], zonChildren10.ports[2]) annotation (Line(points={{98,-166},
            {0,-166},{0,-144},{-28,-144},{-28,-132},{-152.5,-132},{-152.5,
            -123.1}},
          color={0,127,255}));
    connect(FirstFloor[1], zonBedroom6.heaPorAir) annotation (Line(points={{-262,-32.4},
            {-240,-32.4},{-240,80},{-156,80},{-156,46}}, color={191,0,0}));
    connect(FirstFloor[2], zonChildren7.heaPorAir) annotation (Line(points={{-262,
            -29.2},{-240,-29.2},{-240,80},{0,80},{0,46}}, color={191,0,0}));
    connect(FirstFloor[3], zonCorridor8.heaPorAir) annotation (Line(points={{-262,
            -26},{-240,-26},{-240,80},{84,80},{84,-26},{2,-26}}, color={191,0,0}));
    connect(FirstFloor[4], zonBath9.heaPorAir) annotation (Line(points={{-262,-22.8},
            {-240,-22.8},{-240,-138},{4,-138},{4,-106}}, color={191,0,0}));
    connect(FirstFloor[5], zonChildren10.heaPorAir) annotation (Line(points={{-262,
            -19.6},{-240,-19.6},{-240,-104},{-152,-104}}, color={191,0,0}));
    connect(zonBedroom6.heaPorAir, tempAirBedroom6.port) annotation (Line(points=
            {{-156,46},{-26,46},{-26,19},{40,19}}, color={191,0,0}));
    connect(zonChildren7.heaPorAir, tempAirChildren7.port) annotation (Line(
          points={{0,46},{26,46},{26,0},{34,0},{34,-7},{40,-7}}, color={191,0,0}));
    connect(zonCorridor8.heaPorAir,tempAirCorr8. port) annotation (Line(points=
            {{2,-26},{2,-4},{32,-4},{32,-41},{40,-41}}, color={191,0,0}));
    connect(zonBath9.heaPorAir, tempAirBath9.port) annotation (Line(points={{4,-106},
            {4,-128},{28,-128},{28,-61},{40,-61}}, color={191,0,0}));
    connect(zonChildren10.heaPorAir, tempAirChildren10.port) annotation (Line(
          points={{-152,-104},{-90,-104},{-90,-94},{-26,-94},{-26,-76},{32,-76},{32,
            -82},{40,-82}}, color={191,0,0}));
    connect(TZoneMea, multiplex5_1.y) annotation (Line(points={{110,-28},{94,
            -28},{94,-52},{111,-52}}, color={0,0,127}));
    connect(tempAirBedroom6.T, multiplex5_1.u1[1]) annotation (Line(points={{
            54.7,19},{54.7,18},{86,18},{86,-36},{82,-36},{82,-42},{88,-42}},
          color={0,0,127}));
    connect(tempAirChildren7.T, multiplex5_1.u2[1]) annotation (Line(points={{54.7,
            -7},{82,-7},{82,-47},{88,-47}}, color={0,0,127}));
    connect(tempAirCorr8.T, multiplex5_1.u3[1]) annotation (Line(points={{54.7,
            -41},{82,-41},{82,-52},{88,-52}}, color={0,0,127}));
    connect(tempAirBath9.T, multiplex5_1.u4[1]) annotation (Line(points={{54.7,-61},
            {82,-61},{82,-57},{88,-57}}, color={0,0,127}));
    connect(tempAirChildren10.T, multiplex5_1.u5[1])
      annotation (Line(points={{56.8,-82},{88,-82},{88,-62}}, color={0,0,127}));
    connect(qGain.y, zonBedroom6.qGai_flow) annotation (Line(points={{-250,-154},{-236,
            -154},{-236,26},{-184,26},{-184,56},{-178,56}}, color={0,0,127}));
    connect(qGain.y, zonChildren7.qGai_flow) annotation (Line(points={{-250,-154},
            {-236,-154},{-236,26},{-184,26},{-184,68},{-30,68},{-30,56},{-22,56}},
          color={0,0,127}));
    connect(qGain.y,zonCorridor8. qGai_flow) annotation (Line(points={{-250,-154},
            {-236,-154},{-236,26},{-184,26},{-184,68},{-30,68},{-30,-16},{-20,-16}},
          color={0,0,127}));
    connect(qGain.y, zonBath9.qGai_flow) annotation (Line(points={{-250,-154},{-236,
            -154},{-236,26},{-184,26},{-184,68},{-30,68},{-30,-16},{-26,-16},{-26,
            -80},{-22,-80},{-22,-90},{-24,-90},{-24,-96},{-18,-96}}, color={0,0,127}));
    connect(qGain.y, zonChildren10.qGai_flow) annotation (Line(points={{-250,-154},
            {-236,-154},{-236,-94},{-232,-94},{-232,-80},{-182,-80},{-182,-94},{-174,
            -94}}, color={0,0,127}));
    connect(Atm_bedroom6.ports[1], pressureDrop_bedroom6.port_a)
      annotation (Line(points={{-210,34},{-204,34}}, color={0,127,255}));
    connect(freshAir_bedroom6.ports[1], zonBedroom6.ports[3]) annotation (Line(
          points={{-208,56},{-182,56},{-182,36},{-178,36},{-178,26.9},{-155.5,
            26.9}},
          color={0,127,255}));
    connect(pressureDrop_bedroom6.port_b, zonBedroom6.ports[4]) annotation (Line(
          points={{-184,34},{-178,34},{-178,26.9},{-154.5,26.9}}, color={0,127,255}));
    connect(Atm_children10.ports[1], pressureDrop_Children10.port_a)
      annotation (Line(points={{-212,-122},{-204,-122}}, color={0,127,255}));
    connect(freshAir_children10.ports[1], zonChildren10.ports[3]) annotation (
        Line(points={{-206,-96},{-194,-96},{-194,-106},{-174,-106},{-174,-130},
            {-151.5,-130},{-151.5,-123.1}},
                                     color={0,127,255}));
    connect(pressureDrop_Children10.port_b, zonChildren10.ports[4]) annotation (
        Line(points={{-184,-122},{-178,-122},{-178,-106},{-174,-106},{-174,-130},
            {-150.5,-130},{-150.5,-123.1}},  color={0,127,255}));
    connect(pressureDrop_children7.port_a, Atm_children7.ports[1]) annotation (
        Line(points={{52,41},{55,41},{55,42},{58,42}}, color={0,127,255}));
    connect(weaBus, freshAir_children7.weaBus) annotation (Line(
        points={{-142,100},{-142,72},{74,72},{74,61.84},{68,61.84}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(freshAir_children7.ports[1], zonChildren7.ports[3]) annotation (Line(
          points={{52,62},{28,62},{28,26.9},{0.5,26.9}},       color={0,127,255}));
    connect(pressureDrop_children7.port_b, zonChildren7.ports[4]) annotation (
        Line(points={{36,41},{36,40},{28,40},{28,26.9},{1.5,26.9}},      color={0,
            127,255}));
    connect(weaBus,freshAir_corridor8. weaBus) annotation (Line(
        points={{-142,100},{-142,72},{74,72},{74,16},{82,16},{82,5.84},{76,5.84}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));

    connect(freshAir_corridor8.ports[1],zonCorridor8. ports[3]) annotation (Line(
          points={{60,6},{28,6},{28,-52},{2.5,-52},{2.5,-45.1}},           color={
            0,127,255}));
    connect(Atm_corridor8.ports[1],pressureDrop_corridor8. port_a) annotation (
        Line(points={{66,-16},{63,-16},{63,-17},{60,-17}}, color={0,127,255}));
    connect(pressureDrop_corridor8.port_b,zonCorridor8. ports[4]) annotation (
        Line(points={{44,-17},{28,-17},{28,-52},{3.5,-52},{3.5,-45.1}},
          color={0,127,255}));
    connect(freshAir_bath9.ports[1], zonBath9.ports[3]) annotation (Line(points={{60,-98},
            {30,-98},{30,-132},{4.5,-132},{4.5,-125.1}},           color={0,127,255}));
    connect(pressureDrop_bath9.port_b, zonBath9.ports[4]) annotation (Line(points={{44,-121},
            {30,-121},{30,-132},{5.5,-132},{5.5,-125.1}},             color={0,127,
            255}));
    connect(pressureDrop_bath9.port_a, Atm_bath9.ports[1]) annotation (Line(
          points={{60,-121},{63,-121},{63,-120},{66,-120}}, color={0,127,255}));
    connect(weaBus, freshAir_bath9.weaBus) annotation (Line(
        points={{-142,100},{-142,72},{74,72},{74,16},{82,16},{82,-28},{78,-28},{78,
            -84},{82,-84},{82,-98.16},{76,-98.16}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-260,-180},
              {100,100}})), Diagram(coordinateSystem(preserveAspectRatio=false,
            extent={{-260,-180},{100,100}})));
  end FirstFloor3;
end Spawn;
