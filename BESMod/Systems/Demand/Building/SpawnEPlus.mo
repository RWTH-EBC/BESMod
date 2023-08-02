within BESMod.Systems.Demand.Building;
model SpawnEPlus
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
  parameter Modelica.Units.SI.Volume VRooCor "Room volume corridor";
  parameter Modelica.Units.SI.Volume VRooSou "Room volume south";
  parameter Modelica.Units.SI.Volume VRooNor "Room volume north";
  parameter Modelica.Units.SI.Volume VRooEas "Room volume east";
  parameter Modelica.Units.SI.Volume VRooWes "Room volume west";

  parameter Modelica.Units.SI.Area AFloCor "Floor area corridor";
  parameter Modelica.Units.SI.Area AFloSou "Floor area south";
  parameter Modelica.Units.SI.Area AFloNor "Floor area north";
  parameter Modelica.Units.SI.Area AFloEas "Floor area east";
  parameter Modelica.Units.SI.Area AFloWes "Floor area west";
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
  Buildings.Fluid.Sensors.RelativePressure senRelPre(redeclare package Medium =
        MediumZone)
    "Building pressure measurement"
    annotation (Placement(transformation(extent={{-80,-216},{-100,-196}})));
  Buildings.Fluid.Sources.Outside out(nPorts=1, redeclare package Medium =
        MediumZone)
    annotation (Placement(transformation(extent={{-198,-216},{-178,-196}})));
  Buildings.ThermalZones.EnergyPlus_9_6_0.ThermalZone sou(
    redeclare package Medium = MediumZone,
    nPorts=4,
    zoneName="Perimeter_ZN_1")
    "South zone"
    annotation (Placement(transformation(extent={{4,-500},{44,-460}})));
  Buildings.ThermalZones.EnergyPlus_9_6_0.ThermalZone eas(
    redeclare package Medium = MediumZone,
    nPorts=4,
    zoneName="Perimeter_ZN_2")
    "East zone"
    annotation (Placement(transformation(extent={{160,-388},{200,-348}})));
  Buildings.ThermalZones.EnergyPlus_9_6_0.ThermalZone nor(
    redeclare package Medium = MediumZone,
    nPorts=4,
    zoneName="Perimeter_ZN_3") "North zone"
    annotation (Placement(transformation(extent={{4,-340},{44,-300}})));
  Buildings.ThermalZones.EnergyPlus_9_6_0.ThermalZone wes(
    redeclare package Medium = MediumZone,
    nPorts=4,
    zoneName="Perimeter_ZN_4")
    "West zone"
    annotation (Placement(transformation(extent={{-128,-392},{-88,-352}})));
  Buildings.ThermalZones.EnergyPlus_9_6_0.ThermalZone cor(
    redeclare package Medium = MediumZone,
    nPorts=10,
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
    annotation (Placement(transformation(extent={{0,4},{20,24}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant qGai_flow[3](k={0,0,0})
    "Internal heat gain (computed already in EnergyPlus)"
    annotation (Placement(transformation(extent={{-280,-496},{-260,-476}})));
equation
  connect(temAirSou.T,multiplex5_1. u1[1]) annotation (Line(
      points={{171,-106},{188,-106},{188,-156},{198,-156}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(temAirEas.T,multiplex5_1. u2[1]) annotation (Line(
      points={{173,-136},{184,-136},{184,-161},{198,-161}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(temAirNor.T,multiplex5_1. u3[1]) annotation (Line(
      points={{173,-166},{198,-166}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(temAirWes.T,multiplex5_1. u4[1]) annotation (Line(
      points={{173,-198},{184,-198},{184,-171},{198,-171}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(temAirCor.T,multiplex5_1. u5[1]) annotation (Line(
      points={{175,-228},{192,-228},{192,-176},{198,-176}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(out.ports[1],senRelPre. port_b) annotation (Line(
      points={{-178,-206},{-100,-206}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(sou.heaPorAir,temAirSou.port)
    annotation (Line(points={{24,-480},{84,-480},{84,-356},{124,-356},{124,-106},
          {150,-106}},                                                                    color={191,0,0},smooth=Smooth.None));
  connect(eas.heaPorAir,temAirEas.port)
    annotation (Line(points={{180,-368},{146,-368},{146,-136},{152,-136}},
                                                                    color={191,0,0},smooth=Smooth.None));
  connect(nor.heaPorAir,temAirNor.port)
    annotation (Line(points={{24,-320},{24,-166},{152,-166}},         color={191,0,0},smooth=Smooth.None));
  connect(wes.heaPorAir,temAirWes.port)
    annotation (Line(points={{-108,-372},{-68,-372},{-68,-342},{46,-342},{46,-198},
          {152,-198}},                                                               color={191,0,0},smooth=Smooth.None));
  connect(cor.heaPorAir,temAirCor.port)
    annotation (Line(points={{24,-376},{24,-228},{154,-228}},
                                                           color={191,0,0},smooth=Smooth.None));
  connect(leaSou.port_b,sou.ports[2])
    annotation (Line(points={{-162,-56},{-142,-56},{-142,-528},{-6,-528},{-6,
          -510},{23.5,-510},{23.5,-499.1}},                                                         color={0,127,255},smooth=Smooth.None,thickness=0.5));
  connect(leaEas.port_b,eas.ports[2])
    annotation (Line(points={{-162,-96},{106,-96},{106,-387.1},{179.5,-387.1}},
                                                                        color={0,127,255},smooth=Smooth.None,thickness=0.5));
  connect(leaNor.port_b,nor.ports[2])
    annotation (Line(points={{-160,-136},{-2,-136},{-2,-339.1},{23.5,-339.1}},
                                                                          color={0,127,255},smooth=Smooth.None,thickness=0.5));
  connect(leaWes.port_b,wes.ports[2])
    annotation (Line(points={{-160,-176},{-138,-176},{-138,-391.1},{-108.5,
          -391.1}},                                                color={0,127,255},smooth=Smooth.None,thickness=0.5));
  connect(opeSouCor.port_b1,cor.ports[2])
    annotation (Line(points={{-36,-440},{24,-440},{24,-422},{22.6,-422},{22.6,
          -395.1}},                                                                  color={0,127,255},smooth=Smooth.None,thickness=0.5));
  connect(opeSouCor.port_a2,cor.ports[2])
    annotation (Line(points={{-36,-452},{24,-452},{24,-395.1},{22.6,-395.1}},
                                                                        color={0,127,255},smooth=Smooth.None,thickness=0.5));
  connect(opeSouCor.port_a1,sou.ports[2])
    annotation (Line(points={{-56,-440},{-66,-440},{-66,-476},{-6,-476},{-6,
          -510},{22,-510},{22,-502},{24,-502},{24,-499.1},{23.5,-499.1}},                                                          color={0,127,255},smooth=Smooth.None,thickness=0.5));
  connect(opeSouCor.port_b2,sou.ports[3])
    annotation (Line(points={{-56,-452},{-66,-452},{-66,-476},{-6,-476},{-6,
          -510},{24,-510},{24,-499.1},{24.5,-499.1}},                                                        color={0,127,255},smooth=Smooth.None,thickness=0.5));
  connect(opeEasCor.port_b1,eas.ports[2])
    annotation (Line(points={{130,-402},{150,-402},{150,-387.1},{179.5,-387.1}},
                                                                        color={0,127,255},smooth=Smooth.None,thickness=0.5));
  connect(opeEasCor.port_a2,eas.ports[3])
    annotation (Line(points={{130,-414},{150,-414},{150,-387.1},{180.5,-387.1}},
                                                                        color={0,127,255},smooth=Smooth.None,thickness=0.5));
  connect(opeEasCor.port_a1,cor.ports[3])
    annotation (Line(points={{110,-402},{50,-402},{50,-422},{2,-422},{2,-395.1},
          {23,-395.1}},                                                                     color={0,127,255},smooth=Smooth.None,thickness=0.5));
  connect(opeEasCor.port_b2,cor.ports[4])
    annotation (Line(points={{110,-414},{50,-414},{50,-422},{2,-422},{2,-395.1},
          {23.4,-395.1}},                                                               color={0,127,255},smooth=Smooth.None,thickness=0.5));
  connect(opeNorCor.port_b1,nor.ports[2])
    annotation (Line(points={{-40,-366},{-32,-366},{-32,-350},{24,-350},{24,
          -339.1},{23.5,-339.1}},                                                             color={0,127,255},smooth=Smooth.None,thickness=0.5));
  connect(opeNorCor.port_a2,nor.ports[3])
    annotation (Line(points={{-40,-378},{-32,-378},{-32,-350},{24,-350},{24,
          -339.1},{24.5,-339.1}},                                                             color={0,127,255},smooth=Smooth.None,thickness=0.5));
  connect(opeNorCor.port_a1,cor.ports[5])
    annotation (Line(points={{-60,-366},{-64,-366},{-64,-396},{2,-396},{2,
          -395.1},{23.8,-395.1}},                                                        color={0,127,255},smooth=Smooth.None));
  connect(opeNorCor.port_b2,cor.ports[6])
    annotation (Line(points={{-60,-378},{-64,-378},{-64,-396},{2,-396},{2,
          -395.1},{24.2,-395.1}},                                                        color={0,127,255},smooth=Smooth.None,thickness=0.5));
  connect(opeWesCor.port_b1,cor.ports[7])
    annotation (Line(points={{-100,-460},{-84,-460},{-84,-430},{24,-430},{24,
          -420},{24.6,-420},{24.6,-395.1}},                                                         color={0,127,255},smooth=Smooth.None,thickness=0.5));
  connect(opeWesCor.port_a2,cor.ports[8])
    annotation (Line(points={{-100,-472},{-84,-472},{-84,-430},{24,-430},{24,
          -395.1},{25,-395.1}},                                                            color={0,127,255},smooth=Smooth.None,thickness=0.5));
  connect(opeWesCor.port_a1,wes.ports[2])
    annotation (Line(points={{-120,-460},{-126,-460},{-126,-412},{-110,-412},{
          -110,-391.1},{-108.5,-391.1}},                                            color={0,127,255},smooth=Smooth.None,thickness=0.5));
  connect(opeWesCor.port_b2,wes.ports[3])
    annotation (Line(points={{-120,-472},{-126,-472},{-126,-412},{-110,-412},{
          -110,-391.1},{-107.5,-391.1}},                                              color={0,127,255},smooth=Smooth.None,thickness=0.5));
  connect(cor.ports[9],senRelPre. port_a)
    annotation (Line(points={{25.4,-395.1},{24,-395.1},{24,-432},{-12,-432},{
          -12,-206},{-80,-206}},                                                             color={0,127,255},smooth=Smooth.None,thickness=0.5));
  connect(sou.qGai_flow,qGai_flow.y)
    annotation (Line(points={{2,-470},{-76,-470},{-76,-486},{-258,-486}},
                                                                     color={0,0,127}));
  connect(wes.qGai_flow,qGai_flow.y)
    annotation (Line(points={{-130,-362},{-200,-362},{-200,-486},{-258,-486}},
                                                                    color={0,0,127}));
  connect(eas.qGai_flow,qGai_flow.y)
    annotation (Line(points={{158,-358},{60,-358},{60,-346},{-200,-346},{-200,-486},
          {-258,-486}},                                                                  color={0,0,127}));
  connect(cor.qGai_flow,qGai_flow.y)
    annotation (Line(points={{2,-366},{-10,-366},{-10,-346},{-200,-346},{-200,-486},
          {-258,-486}},                                                                  color={0,0,127}));
  connect(nor.qGai_flow,qGai_flow.y)
    annotation (Line(points={{2,-310},{-200,-310},{-200,-486},{-258,-486}},
                                                                       color={0,0,127}));
  connect(att.qGai_flow,qGai_flow.y)
    annotation (Line(points={{158,-486},{100,-486},{100,-536},{-200,-536},{-200,
          -486},{-258,-486}},                                                              color={0,0,127}));
  connect(multiplex5_1.y, buiMeaBus.TZoneMea) annotation (Line(points={{221,-166},
          {222,-166},{222,62},{0,62},{0,99}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(weaBus, leaSou.weaBus) annotation (Line(
      points={{-47,98},{-47,-44},{-120,-44},{-120,-56},{-198,-56}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(weaBus, out.weaBus) annotation (Line(
      points={{-47,98},{-47,-44},{-120,-44},{-120,-205.8},{-198,-205.8}},
      color={255,204,51},
      thickness=0.5));
  connect(weaBus, leaWes.weaBus) annotation (Line(
      points={{-47,98},{-47,-44},{-120,-44},{-120,-176},{-196,-176}},
      color={255,204,51},
      thickness=0.5));
  connect(weaBus, leaNor.weaBus) annotation (Line(
      points={{-47,98},{-47,-44},{-120,-44},{-120,-136},{-196,-136}},
      color={255,204,51},
      thickness=0.5));
  connect(weaBus, leaEas.weaBus) annotation (Line(
      points={{-47,98},{-126,98},{-126,-96},{-198,-96},{-198,-96}},
      color={255,204,51},
      thickness=0.5));
  connect(zeroLoad.internalElectricalPin, internalElectricalPin) annotation (
      Line(
      points={{44,-60},{68,-60},{68,-80},{70,-80},{70,-96}},
      color={0,0,0},
      thickness=1));
  connect(nor.heaPorAir, heatPortCon[1]) annotation (Line(points={{24,-320},{24,
          -76},{-84,-76},{-84,55.8333},{-100,55.8333}}, color={191,0,0}));
  connect(nor.heaPorAir, heatPortRad[1]) annotation (Line(points={{24,-320},{24,
          -76},{-84,-76},{-84,-64.1667},{-100,-64.1667}}, color={191,0,0}));
  connect(wes.heaPorAir, heatPortCon[2]) annotation (Line(points={{-108,-372},{-108,
          -76},{-84,-76},{-84,57.5},{-100,57.5}}, color={191,0,0}));
  connect(wes.heaPorAir, heatPortRad[2]) annotation (Line(points={{-108,-372},{-108,
          -76},{-84,-76},{-84,-62.5},{-100,-62.5}}, color={191,0,0}));
  connect(cor.heaPorAir, heatPortCon[3]) annotation (Line(points={{24,-376},{24,
          -76},{-84,-76},{-84,59.1667},{-100,59.1667}}, color={191,0,0}));
  connect(cor.heaPorAir, heatPortRad[3]) annotation (Line(points={{24,-376},{24,
          -76},{-84,-76},{-84,-60.8333},{-100,-60.8333}}, color={191,0,0}));
  connect(eas.heaPorAir, heatPortCon[4]) annotation (Line(points={{180,-368},{
          180,-274},{24,-274},{24,-76},{-84,-76},{-84,60.8333},{-100,60.8333}},
        color={191,0,0}));
  connect(eas.heaPorAir, heatPortRad[4]) annotation (Line(points={{180,-368},{
          180,-274},{24,-274},{24,-76},{-84,-76},{-84,-59.1667},{-100,-59.1667}},
        color={191,0,0}));
  connect(sou.heaPorAir, heatPortCon[5]) annotation (Line(points={{24,-480},{24,
          -76},{-84,-76},{-84,62.5},{-100,62.5}}, color={191,0,0}));
  connect(sou.heaPorAir, heatPortRad[5]) annotation (Line(points={{24,-480},{24,
          -76},{-84,-76},{-84,-57.5},{-100,-57.5}}, color={191,0,0}));
  connect(att.heaPorAir, heatPortCon[6]) annotation (Line(points={{180,-496},{
          180,-274},{24,-274},{24,-76},{-84,-76},{-84,64.1667},{-100,64.1667}},
        color={191,0,0}));
  connect(att.heaPorAir, heatPortRad[6]) annotation (Line(points={{180,-496},{
          180,-274},{24,-274},{24,-76},{-84,-76},{-84,-55.8333},{-100,-55.8333}},
        color={191,0,0}));
  annotation (Diagram(coordinateSystem(extent={{-100,-240},{100,100}})), Icon(
        coordinateSystem(extent={{-100,-240},{100,100}})));
end SpawnEPlus;
