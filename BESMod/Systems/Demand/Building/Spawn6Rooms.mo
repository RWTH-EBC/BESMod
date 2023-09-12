within BESMod.Systems.Demand.Building;
model Spawn6Rooms
  extends BaseClasses.PartialDemand(nZones=6);
   final parameter Modelica.Units.SI.Area AFlo=AFloCor + AFloSou + AFloNor +
      AFloEas + AFloWes "Total floor area";

  parameter Boolean use_windPressure=true
    "Set to true to enable wind pressure";

  parameter Real kIntNor(min=0, max=1) = 1
    "Gain factor to scale internal heat gain in north zone";
  parameter String idfName=Modelica.Utilities.Files.loadResource(
    "modelica://Buildings/Resources/Data/ThermalZones/EnergyPlus_9_6_0/Examples/RefBldgSmallOffice/RefBldgSmallOfficeNew2004_Chicago.idf")
    "Name of the IDF file";
  parameter String epwName=Modelica.Utilities.Files.loadResource(
    "modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.epw")
    "Name of the weather file";
  parameter String weaName=Modelica.Utilities.Files.loadResource(
    "modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos")
    "Name of the weather file";
  parameter Modelica.Units.SI.Volume VRooCor=456.455
                                             "Room volume corridor";
  parameter Modelica.Units.SI.Volume VRooSou=346.022
                                             "Room volume south";
  parameter Modelica.Units.SI.Volume VRooNor=346.022
                                             "Room volume north";
  parameter Modelica.Units.SI.Volume VRooEas=205.265
                                             "Room volume east";
  parameter Modelica.Units.SI.Volume VRooWes=205.265
                                             "Room volume west";

  parameter Modelica.Units.SI.Area AFloCor=cor.AFlo
                                           "Floor area corridor";
  parameter Modelica.Units.SI.Area AFloSou=sou.AFlo
                                           "Floor area south";
  parameter Modelica.Units.SI.Area AFloNor=nor.AFlo
                                           "Floor area north";
  parameter Modelica.Units.SI.Area AFloEas=eas.AFlo
                                           "Floor area east";
  parameter Modelica.Units.SI.Area AFloWes=wes.AFlo
                                           "Floor area west";
  Buildings.Examples.VAVReheat.BaseClasses.RoomLeakage leaSou(
    s=27.69/18.46,
    redeclare package Medium = MediumZone,
    VRoo=VRooSou,
    azi=Buildings.Types.Azimuth.S,
    final use_windPressure=use_windPressure)
    "Model for air infiltration through the envelope"
    annotation (Placement(transformation(extent={{-198,-76},{-162,-36}})));
  Buildings.Examples.VAVReheat.BaseClasses.RoomLeakage leaEas(
    s=18.46/27.69,
    redeclare package Medium = MediumZone,
    VRoo=VRooEas,
    azi=Buildings.Types.Azimuth.E,
    final use_windPressure=use_windPressure)
    "Model for air infiltration through the envelope"
    annotation (Placement(transformation(extent={{-198,-116},{-162,-76}})));
  Buildings.Examples.VAVReheat.BaseClasses.RoomLeakage leaNor(
    s=27.69/18.46,
    redeclare package Medium = MediumZone,
    VRoo=VRooNor,
    azi=Buildings.Types.Azimuth.N,
    final use_windPressure=use_windPressure)
    "Model for air infiltration through the envelope"
    annotation (Placement(transformation(extent={{-196,-156},{-160,-116}})));
  Buildings.Examples.VAVReheat.BaseClasses.RoomLeakage leaWes(
    s=18.46/27.69,
    redeclare package Medium = MediumZone,
    VRoo=VRooWes,
    azi=Buildings.Types.Azimuth.W,
    final use_windPressure=use_windPressure)
    "Model for air infiltration through the envelope"
    annotation (Placement(transformation(extent={{-196,-196},{-160,-156}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temAirSou
    "Air temperature sensor"
    annotation (Placement(transformation(extent={{150,-116},{170,-96}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temAirEas
    "Air temperature sensor"
    annotation (Placement(transformation(extent={{152,-146},{172,-126}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temAirNor
    "Air temperature sensor"
    annotation (Placement(transformation(extent={{152,-176},{172,-156}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temAirWes
    "Air temperature sensor"
    annotation (Placement(transformation(extent={{152,-208},{172,-188}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temAirCor
    "Air temperature sensor"
    annotation (Placement(transformation(extent={{154,-238},{174,-218}})));
  Modelica.Blocks.Routing.Multiplex5 multiplex5_1
    annotation (Placement(transformation(extent={{200,-176},{220,-156}})));
  Buildings.Airflow.Multizone.DoorOpen
                             opeSouCor(wOpe=9, redeclare package Medium =
        MediumZone)
    "Opening between perimeter1 and core"
    annotation (Placement(transformation(extent={{-56,-456},{-36,-436}})));
  Buildings.Airflow.Multizone.DoorOpen
                             opeEasCor(wOpe=4, redeclare package Medium =
        MediumZone)
    "Opening between perimeter2 and core"
    annotation (Placement(transformation(extent={{110,-418},{130,-398}})));
  Buildings.Airflow.Multizone.DoorOpen
                             opeNorCor(wOpe=9, redeclare package Medium =
        MediumZone)
    "Opening between perimeter3 and core"
    annotation (Placement(transformation(extent={{-60,-382},{-40,-362}})));
  Buildings.Airflow.Multizone.DoorOpen
                             opeWesCor(wOpe=4, redeclare package Medium =
        MediumZone)
    "Opening between perimeter3 and core"
    annotation (Placement(transformation(extent={{-120,-476},{-100,-456}})));
  Buildings.Fluid.Sensors.RelativePressure senRelPre(redeclare package Medium
      = MediumZone)
    "Building pressure measurement"
    annotation (Placement(transformation(extent={{-80,-216},{-100,-196}})));
  Buildings.Fluid.Sources.Outside out(nPorts=1, redeclare package Medium =
        MediumZone)
    annotation (Placement(transformation(extent={{-198,-216},{-178,-196}})));
  Buildings.ThermalZones.EnergyPlus_9_6_0.ThermalZone sou(
    redeclare package Medium = MediumZone,
    nPorts=5,
    zoneName="Perimeter_ZN_1")
    "South zone"
    annotation (Placement(transformation(extent={{4,-500},{44,-460}})));
  Buildings.ThermalZones.EnergyPlus_9_6_0.ThermalZone eas(
    redeclare package Medium = MediumZone,
    nPorts=5,
    zoneName="Perimeter_ZN_2")
    "East zone"
    annotation (Placement(transformation(extent={{160,-388},{200,-348}})));
  Buildings.ThermalZones.EnergyPlus_9_6_0.ThermalZone nor(
    redeclare package Medium = MediumZone,
    zoneName="Perimeter_ZN_3",
    nPorts=5)                  "North zone"
    annotation (Placement(transformation(extent={{2,-306},{42,-266}})));
  Buildings.ThermalZones.EnergyPlus_9_6_0.ThermalZone wes(
    redeclare package Medium = MediumZone,
    zoneName="Perimeter_ZN_4",
    nPorts=5)
    "West zone"
    annotation (Placement(transformation(extent={{-128,-392},{-88,-352}})));
  Buildings.ThermalZones.EnergyPlus_9_6_0.ThermalZone cor(
    redeclare package Medium = MediumZone,
    nPorts=11,
    zoneName="Core_ZN")
    "Core zone"
    annotation (Placement(transformation(extent={{4,-396},{44,-356}})));
  Buildings.ThermalZones.EnergyPlus_9_6_0.ThermalZone att(
    redeclare package Medium = MediumZone,
    zoneName="Attic",
    nPorts=2,
    T_start=275.15)
    "Attic zone"
    annotation (Placement(transformation(extent={{160,-516},{200,-476}})));
  Utilities.Electrical.ZeroLoad        zeroLoad annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={34,-60})));
protected
  inner Buildings.ThermalZones.EnergyPlus_9_6_0.Building building(
    idfName=idfName,
    epwName=epwName,
    weaName=weaName,
    computeWetBulbTemperature=false)
    "Building-level declarations"
    annotation (Placement(transformation(extent={{-14,54},{6,74}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant qGai_flow[3](k={0,0,0})
    "Internal heat gain (computed already in EnergyPlus)"
    annotation (Placement(transformation(extent={{-280,-496},{-260,-476}})));
equation
  connect(nor.ports[1], portVent_in[1]) annotation (Line(points={{20.4,-305.1},
          {20.4,33.8333},{100,33.8333}}, color={0,127,255}));
  connect(eas.ports[1], portVent_in[2]) annotation (Line(points={{178.4,-387.1},
          {178.4,-400},{140,-400},{140,32},{116,32},{116,35.5},{100,35.5}},
        color={0,127,255}));
  connect(sou.ports[1], portVent_in[3]) annotation (Line(points={{22.4,-499.1},
          {22.4,37.1667},{100,37.1667}}, color={0,127,255}));
  connect(wes.ports[1], portVent_in[4]) annotation (Line(points={{-109.6,-391.1},
          {-109.6,38.8333},{100,38.8333}}, color={0,127,255}));
  connect(cor.ports[1], portVent_in[5]) annotation (Line(points={{22.1818,
          -395.1},{22.1818,-392},{60,-392},{60,-112},{52,-112},{52,32},{100,32},
          {100,40.5}}, color={0,127,255}));
  connect(att.ports[1], portVent_in[6]) annotation (Line(points={{179,-515.1},{
          179,-528},{140,-528},{140,32},{100,32},{100,42.1667}}, color={0,127,
          255}));
  connect(nor.ports[2], portVent_out[1]) annotation (Line(points={{21.2,-305.1},
          {20,-305.1},{20,32},{80,32},{80,-44.1667},{100,-44.1667}}, color={0,
          127,255}));
  connect(eas.ports[2], portVent_out[2]) annotation (Line(points={{179.2,-387.1},
          {179.2,-384},{176,-384},{176,-400},{140,-400},{140,-42.5},{100,-42.5}},
        color={0,127,255}));
  connect(sou.ports[2], portVent_out[3]) annotation (Line(points={{23.2,-499.1},
          {23.2,-512},{92,-512},{92,-56},{80,-56},{80,-40.8333},{100,-40.8333}},
        color={0,127,255}));
  connect(wes.ports[2], portVent_out[4]) annotation (Line(points={{-108.8,
          -391.1},{-108.8,-404},{-16,-404},{-16,-40},{20,-40},{20,32},{80,32},{
          80,-39.1667},{100,-39.1667}}, color={0,127,255}));
  connect(cor.ports[2], portVent_out[5]) annotation (Line(points={{22.5455,
          -395.1},{22.5455,-392},{60,-392},{60,-112},{52,-112},{52,-37.5},{100,
          -37.5}}, color={0,127,255}));
  connect(att.ports[2], portVent_out[6]) annotation (Line(points={{181,-515.1},
          {181,-512},{176,-512},{176,-528},{140,-528},{140,-35.8333},{100,
          -35.8333}}, color={0,127,255}));
  connect(weaBus, leaSou.weaBus) annotation (Line(
      points={{-47,98},{-44,98},{-44,40},{-208,40},{-208,-56},{-198,-56}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(weaBus, leaEas.weaBus) annotation (Line(
      points={{-47,98},{-44,98},{-44,40},{-208,40},{-208,-96},{-198,-96}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(weaBus, leaNor.weaBus) annotation (Line(
      points={{-47,98},{-44,98},{-44,40},{-208,40},{-208,-136},{-196,-136}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(weaBus, leaWes.weaBus) annotation (Line(
      points={{-47,98},{-44,98},{-44,40},{-208,40},{-208,-176},{-196,-176}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(weaBus, out.weaBus) annotation (Line(
      points={{-47,98},{-44,98},{-44,40},{-208,40},{-208,-205.8},{-198,-205.8}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));

  connect(qGai_flow.y, wes.qGai_flow) annotation (Line(points={{-258,-486},{
          -140,-486},{-140,-362},{-130,-362}}, color={0,0,127}));
  connect(qGai_flow.y, nor.qGai_flow) annotation (Line(points={{-258,-486},{
          -140,-486},{-140,-412},{-8,-412},{-8,-316},{-12,-316},{-12,-276},{0,
          -276}}, color={0,0,127}));
  connect(qGai_flow.y, eas.qGai_flow) annotation (Line(points={{-258,-486},{
          -140,-486},{-140,-412},{-8,-412},{-8,-344},{144,-344},{144,-358},{158,
          -358}}, color={0,0,127}));
  connect(qGai_flow.y, sou.qGai_flow) annotation (Line(points={{-258,-486},{-8,
          -486},{-8,-470},{2,-470}}, color={0,0,127}));
  connect(qGai_flow.y, cor.qGai_flow) annotation (Line(points={{-258,-486},{
          -140,-486},{-140,-412},{-8,-412},{-8,-366},{2,-366}}, color={0,0,127}));
  connect(qGai_flow.y, att.qGai_flow) annotation (Line(points={{-258,-486},{-8,
          -486},{-8,-344},{144,-344},{144,-486},{158,-486}}, color={0,0,127}));
  connect(heatPortCon[1], nor.heaPorAir) annotation (Line(points={{-100,55.8333},
          {-100,-32},{-12,-32},{-12,-76},{48,-76},{48,-252},{52,-252},{52,-286},
          {22,-286}}, color={191,0,0}));
  connect(heatPortCon[2], eas.heaPorAir) annotation (Line(points={{-100,57.5},{
          -100,-32},{-12,-32},{-12,-76},{48,-76},{48,-252},{52,-252},{52,-288},
          {180,-288},{180,-368}}, color={191,0,0}));
  connect(heatPortCon[3], sou.heaPorAir) annotation (Line(points={{-100,59.1667},
          {-100,-32},{-12,-32},{-12,-76},{48,-76},{48,-252},{52,-252},{52,-288},
          {64,-288},{64,-480},{24,-480}}, color={191,0,0}));
  connect(heatPortCon[4], wes.heaPorAir) annotation (Line(points={{-100,60.8333},
          {-100,-32},{-68,-32},{-68,-372},{-108,-372}}, color={191,0,0}));
  connect(heatPortCon[5], cor.heaPorAir) annotation (Line(points={{-100,62.5},{
          -100,-32},{-68,-32},{-68,-388},{0,-388},{0,-400},{24,-400},{24,-376}},
        color={191,0,0}));
  connect(heatPortCon[6], att.heaPorAir) annotation (Line(points={{-100,64.1667},
          {-100,-32},{-68,-32},{-68,-388},{0,-388},{0,-400},{64,-400},{64,-288},
          {180,-288},{180,-336},{212,-336},{212,-496},{180,-496}}, color={191,0,
          0}));
  connect(heatPortRad[1], nor.heaPorAir) annotation (Line(points={{-100,
          -64.1667},{-100,-32},{-12,-32},{-12,-76},{48,-76},{48,-252},{52,-252},
          {52,-286},{22,-286}}, color={191,0,0}));
  connect(heatPortRad[2], eas.heaPorAir) annotation (Line(points={{-100,-62.5},
          {-100,-32},{-12,-32},{-12,-76},{48,-76},{48,-252},{52,-252},{52,-288},
          {180,-288},{180,-368}}, color={191,0,0}));
  connect(heatPortRad[3], sou.heaPorAir) annotation (Line(points={{-100,
          -60.8333},{-100,-32},{-12,-32},{-12,-76},{48,-76},{48,-252},{52,-252},
          {52,-288},{64,-288},{64,-480},{24,-480}}, color={191,0,0}));
  connect(heatPortRad[4], wes.heaPorAir) annotation (Line(points={{-100,
          -59.1667},{-108,-59.1667},{-108,-372}}, color={191,0,0}));
  connect(heatPortRad[5], cor.heaPorAir) annotation (Line(points={{-100,-57.5},
          {-68,-57.5},{-68,-388},{0,-388},{0,-400},{24,-400},{24,-376}}, color=
          {191,0,0}));
  connect(heatPortRad[6], att.heaPorAir) annotation (Line(points={{-100,
          -55.8333},{-68,-55.8333},{-68,-388},{0,-388},{0,-400},{64,-400},{64,
          -288},{180,-288},{180,-336},{212,-336},{212,-496},{180,-496}}, color=
          {191,0,0}));
  connect(temAirNor.port, nor.heaPorAir) annotation (Line(points={{152,-166},{
          48,-166},{48,-252},{52,-252},{52,-286},{22,-286}}, color={191,0,0}));
  connect(temAirEas.port, eas.heaPorAir) annotation (Line(points={{152,-136},{
          148,-136},{148,-148},{188,-148},{188,-332},{180,-332},{180,-368}},
        color={191,0,0}));
  connect(temAirSou.port, sou.heaPorAir) annotation (Line(points={{150,-106},{
          88,-106},{88,-284},{64,-284},{64,-480},{24,-480}}, color={191,0,0}));
  connect(temAirWes.port, wes.heaPorAir) annotation (Line(points={{152,-198},{
          -68,-198},{-68,-372},{-108,-372}}, color={191,0,0}));
  connect(temAirCor.port, cor.heaPorAir) annotation (Line(points={{154,-228},{
          -20,-228},{-20,-388},{0,-388},{0,-400},{24,-400},{24,-376}}, color={
          191,0,0}));
  connect(temAirSou.T, multiplex5_1.u1[1]) annotation (Line(points={{171,-106},
          {182,-106},{182,-156},{198,-156}}, color={0,0,127}));
  connect(temAirEas.T, multiplex5_1.u2[1]) annotation (Line(points={{173,-136},
          {176,-136},{176,-161},{198,-161}}, color={0,0,127}));
  connect(temAirNor.T, multiplex5_1.u3[1])
    annotation (Line(points={{173,-166},{198,-166}}, color={0,0,127}));
  connect(temAirWes.T, multiplex5_1.u4[1]) annotation (Line(points={{173,-198},
          {184,-198},{184,-171},{198,-171}}, color={0,0,127}));
  connect(temAirCor.T, multiplex5_1.u5[1]) annotation (Line(points={{175,-228},
          {198,-228},{198,-176}}, color={0,0,127}));
  connect(multiplex5_1.y, buiMeaBus.TZoneMea) annotation (Line(points={{221,
          -166},{228,-166},{228,56},{12,56},{12,44},{0,44},{0,99}}, color={0,0,
          127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(zeroLoad.internalElectricalPin, internalElectricalPin) annotation (
      Line(
      points={{44,-60},{64,-60},{64,-76},{70,-76},{70,-96}},
      color={0,0,0},
      thickness=1));
  connect(leaNor.port_b, nor.ports[3]) annotation (Line(points={{-160,-136},{22,
          -136},{22,-305.1}}, color={0,127,255}));
  connect(leaEas.port_b, eas.ports[3]) annotation (Line(points={{-162,-96},{-26,
          -96},{-26,-300},{180,-300},{180,-387.1}}, color={0,127,255}));
  connect(leaSou.port_b, sou.ports[3]) annotation (Line(points={{-162,-56},{-42,
          -56},{-42,-202},{24,-202},{24,-499.1}}, color={0,127,255}));
  connect(leaWes.port_b, wes.ports[3]) annotation (Line(points={{-160,-176},{
          -144,-176},{-144,-400},{-136,-400},{-136,-404},{-108,-404},{-108,
          -391.1}}, color={0,127,255}));
  connect(out.ports[1], senRelPre.port_b) annotation (Line(points={{-178,-206},
          {-178,-224},{-112,-224},{-112,-206},{-100,-206}}, color={0,127,255}));
  connect(senRelPre.port_a, cor.ports[3]) annotation (Line(points={{-80,-206},{
          60,-206},{60,-395.1},{22.9091,-395.1}}, color={0,127,255}));
  connect(opeNorCor.port_b1, nor.ports[4]) annotation (Line(points={{-40,-366},
          {-4,-366},{-4,-305.1},{22.8,-305.1}}, color={0,127,255}));
  connect(opeNorCor.port_a2, nor.ports[5]) annotation (Line(points={{-40,-378},
          {-24,-378},{-24,-364},{-4,-364},{-4,-305.1},{23.6,-305.1}}, color={0,
          127,255}));
  connect(opeNorCor.port_a1, cor.ports[4]) annotation (Line(points={{-60,-366},
          {-60,-352},{24,-352},{24,-340},{60,-340},{60,-395.1},{23.2727,-395.1}},
        color={0,127,255}));
  connect(opeNorCor.port_b2, cor.ports[5]) annotation (Line(points={{-60,-378},
          {-64,-378},{-64,-352},{24,-352},{24,-340},{60,-340},{60,-395.1},{
          23.6364,-395.1}}, color={0,127,255}));
  connect(opeSouCor.port_b1, cor.ports[6]) annotation (Line(points={{-36,-440},
          {16,-440},{16,-395.1},{24,-395.1}}, color={0,127,255}));
  connect(opeSouCor.port_a2, cor.ports[7]) annotation (Line(points={{-36,-452},
          {-36,-464},{-16,-464},{-16,-440},{16,-440},{16,-395.1},{24.3636,
          -395.1}}, color={0,127,255}));
  connect(opeSouCor.port_a1, sou.ports[4]) annotation (Line(points={{-56,-440},
          {-64,-440},{-64,-508},{24.8,-508},{24.8,-499.1}}, color={0,127,255}));
  connect(opeSouCor.port_b2, sou.ports[5]) annotation (Line(points={{-56,-452},
          {-64,-452},{-64,-508},{25.6,-508},{25.6,-499.1}}, color={0,127,255}));
  connect(opeWesCor.port_b1, cor.ports[8]) annotation (Line(points={{-100,-460},
          {-100,-424},{-24,-424},{-24,-440},{16,-440},{16,-395.1},{24.7273,
          -395.1}}, color={0,127,255}));
  connect(opeWesCor.port_a2, cor.ports[9]) annotation (Line(points={{-100,-472},
          {-76,-472},{-76,-424},{-24,-424},{-24,-440},{16,-440},{16,-395.1},{
          25.0909,-395.1}}, color={0,127,255}));
  connect(opeWesCor.port_a1, wes.ports[4]) annotation (Line(points={{-120,-460},
          {-128,-460},{-128,-404},{-107.2,-404},{-107.2,-391.1}}, color={0,127,
          255}));
  connect(opeWesCor.port_b2, wes.ports[5]) annotation (Line(points={{-120,-472},
          {-128,-472},{-128,-404},{-106.4,-404},{-106.4,-391.1}}, color={0,127,
          255}));
  connect(opeEasCor.port_b1, eas.ports[4]) annotation (Line(points={{130,-402},
          {130,-396},{180.8,-396},{180.8,-387.1}}, color={0,127,255}));
  connect(opeEasCor.port_a2, eas.ports[5]) annotation (Line(points={{130,-414},
          {136,-414},{136,-396},{181.6,-396},{181.6,-387.1}}, color={0,127,255}));
  connect(opeEasCor.port_a1, cor.ports[10]) annotation (Line(points={{110,-402},
          {60,-402},{60,-395.1},{25.4545,-395.1}}, color={0,127,255}));
  connect(opeEasCor.port_b2, cor.ports[11]) annotation (Line(points={{110,-414},
          {96,-414},{96,-400},{60,-400},{60,-395.1},{25.8182,-395.1}}, color={0,
          127,255}));
 annotation (Diagram(coordinateSystem(extent={{-340,-580},{320,100}})), Icon(
        coordinateSystem(extent={{-340,-580},{320,100}})));
end Spawn6Rooms;
