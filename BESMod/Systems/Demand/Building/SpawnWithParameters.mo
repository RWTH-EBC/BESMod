within BESMod.Systems.Demand.Building;
model SpawnWithParameters
  extends SpawnEPlus(
    VRooCor=456.455,
    VRooSou=346.022,
    VRooNor=346.022,
    VRooEas=205.265,
    VRooWes=205.265,
    AFloCor=cor.AFlo,
    AFloSou=sou.AFlo,
    AFloNor=nor.AFlo,
    AFloEas=eas.AFlo,
    AFloWes=wes.AFlo,
    opeWesCor(
      wOpe=4),
    opeSouCor(
      wOpe=9),
    opeNorCor(
      wOpe=9),
    opeEasCor(
      wOpe=4),
    leaWes(
      s=18.46/27.69),
    leaSou(
      s=27.69/18.46),
    leaNor(
      s=27.69/18.46),
    leaEas(
      s=18.46/27.69));
equation
  connect(portVent_in[1], nor.ports[4]) annotation (Line(points={{100,33.8333},
          {64,33.8333},{64,-80},{25.5,-80},{25.5,-339.1}},
                                                      color={0,127,255}));
  connect(portVent_out[1], nor.ports[1]) annotation (Line(points={{100,-44.1667},
          {64,-44.1667},{64,-80},{22.5,-80},{22.5,-339.1}},
                                                        color={0,127,255}));
  connect(portVent_in[2], wes.ports[4]) annotation (Line(points={{100,35.5},{64,
          35.5},{64,-80},{24,-80},{24,-274},{-106.5,-274},{-106.5,-391.1}},
                                                                        color={0,
          127,255}));
  connect(portVent_out[2], wes.ports[1]) annotation (Line(points={{100,-42.5},{
          64,-42.5},{64,-80},{24,-80},{24,-274},{-109.5,-274},{-109.5,-391.1}},
                                                                         color={
          0,127,255}));
  connect(portVent_in[3], cor.ports[10]) annotation (Line(points={{100,37.1667},
          {64,37.1667},{64,-80},{25.8,-80},{25.8,-395.1}},
                                                       color={0,127,255}));
  connect(portVent_out[3], cor.ports[1]) annotation (Line(points={{100,-40.8333},
          {100,-395.1},{22.2,-395.1}},
                                     color={0,127,255}));
  connect(portVent_in[4], eas.ports[4]) annotation (Line(points={{100,38.8333},
          {98,38.8333},{98,32},{64,32},{64,-80},{24,-80},{24,-272},{181.5,-272},
          {181.5,-387.1}},
                    color={0,127,255}));
  connect(portVent_out[4], eas.ports[1]) annotation (Line(points={{100,-39.1667},
          {98,-39.1667},{98,-44},{100,-44},{100,-272},{178.5,-272},{178.5,
          -387.1}},
        color={0,127,255}));
  connect(portVent_in[5], sou.ports[4]) annotation (Line(points={{100,40.5},{98,
          40.5},{98,32},{64,32},{64,-80},{25.5,-80},{25.5,-499.1}},
                                                                color={0,127,255}));
  connect(portVent_out[5], sou.ports[1]) annotation (Line(points={{100,-37.5},{
          98,-37.5},{98,-44},{64,-44},{64,-80},{22.5,-80},{22.5,-499.1}},
                                                                   color={0,127,
          255}));
  connect(portVent_in[6], att.ports[1]) annotation (Line(points={{100,42.1667},
          {98,42.1667},{98,32},{64,32},{64,-80},{179,-80},{179,-515.1}},
                                                                color={0,127,255}));
  connect(portVent_out[6], att.ports[2]) annotation (Line(points={{100,-35.8333},
          {98,-35.8333},{98,-44},{64,-44},{64,-80},{181,-80},{181,-515.1}},
                                                                   color={0,127,
          255}));
end SpawnWithParameters;
