within BESMod.Systems.Demand.Building.Components.TEASERBuildingSingleZone;
model ConvertRoomsInputsDelayLoss2nR
  extends PartialConvertRoomInputs;

  parameter Real totalHvaluesRoom[nRooms] = fill(Modelica.Constants.inf, nRooms);
  parameter Real useLossRatio = 1;
  parameter Real delayFac = 1;

  final parameter Real A[nRooms,nOrientations] = transpose(FacATransparentPerRoom);

  //Real limitFactor[nRooms];
  Real limit[nRooms];
  Modelica.Blocks.Math.MatrixGain OrisToRooms(K=A)
    annotation (Placement(transformation(extent={{-80,-46},{-68,-34}})));
  Modelica.Blocks.Nonlinear.VariableLimiter variableLimiter[nRooms]
    annotation (Placement(transformation(extent={{-30,-70},{-10,-50}})));
  Modelica.Blocks.Sources.Constant const[nRooms](each k=0)
    annotation (Placement(transformation(extent={{-58,-80},{-48,-70}})));
  Modelica.Blocks.Math.Add dT[nRooms](each k1=-1)
    annotation (Placement(transformation(extent={{-44,50},{-24,70}})));
  Modelica.Blocks.Routing.Replicator replicator(nout=nRooms)
    annotation (Placement(transformation(extent={{-76,70},{-56,90}})));
  Modelica.Blocks.Math.Sum sumSol(each nin=nRooms)
    annotation (Placement(transformation(extent={{-54,-46},{-42,-34}})));
  Modelica.Blocks.Math.Sum sumInt(each nin=nRooms)
    annotation (Placement(transformation(extent={{-58,-100},{-46,-88}})));
  Modelica.Blocks.Math.Sum sumIntMax(each nin=nRooms)
    annotation (Placement(transformation(extent={{66,-86},{76,-76}})));
  Modelica.Blocks.Math.Add delayedGains[nRooms](each k1=-1)
                                                       annotation (Placement(
        transformation(
        extent={{-7,7},{7,-7}},
        rotation=90,
        origin={-17,-25})));
  Modelica.Blocks.Sources.RealExpression realExpression[nRooms](y=OrisToRooms.y ./
        max2.y)
    annotation (Placement(transformation(extent={{-12,-90},{8,-70}})));
  Modelica.Blocks.Math.Product product1[nRooms]
    annotation (Placement(transformation(extent={{38,-60},{52,-46}})));
  Modelica.Blocks.Math.Product product2[nRooms]
    annotation (Placement(transformation(extent={{46,-88},{60,-74}})));
  Modelica.Blocks.Math.Add add[nRooms](each k1=-1)
    annotation (Placement(transformation(extent={{22,-94},{36,-80}})));
  Modelica.Blocks.Sources.Constant const2[nRooms](each k=1)
    annotation (Placement(transformation(extent={{-10,-100},{2,-88}})));
  Modelica.Blocks.Math.Sum sumSolMax(each nin=nRooms)
    annotation (Placement(transformation(extent={{62,-58},{74,-46}})));
  Modelica.Blocks.Sources.RealExpression totSolToOri[nOrientations](y={
        solOrientationGain[i]/max(sum(solOrientationGain), Modelica.Constants.eps)
        for i in 1:nOrientations})
    annotation (Placement(transformation(extent={{56,-32},{76,-12}})));
  Modelica.Blocks.Math.Product product3[nOrientations]
    annotation (Placement(transformation(extent={{80,-44},{90,-34}})));
  Modelica.Blocks.Sources.RealExpression realExpression1[nRooms](y=limit)
    annotation (Placement(transformation(extent={{-74,14},{-54,34}})));
  Modelica.Blocks.Continuous.Integrator integrator[nRooms]
    annotation (Placement(transformation(extent={{6,22},{26,42}})));
  Modelica.Blocks.Math.Add add1[nRooms]
    annotation (Placement(transformation(extent={{-60,-66},{-48,-54}})));
  Modelica.Blocks.Math.Sum sum1(nin=nRooms) annotation (Placement(
        transformation(
        extent={{7,-7},{-7,7}},
        rotation=90,
        origin={83,-3})));
  Modelica.Blocks.Math.Gain useRate[nRooms](k={useLossRatio*10^(-5*(1 -
        delayFac)) for i in 1:nRooms})
    annotation (Placement(transformation(extent={{44,8},{64,28}})));
  Modelica.Blocks.Math.Gain lossRate[nRooms](k={(1 - useLossRatio)*10^(-5*(1 -
        delayFac)) for i in 1:nRooms})
    annotation (Placement(transformation(extent={{44,36},{64,56}})));
  Modelica.Blocks.Math.Add3 add3_1[nRooms](
    each k1=-1,
    each k2=+1,
    each k3=-1)
    annotation (Placement(transformation(extent={{-20,26},{-8,38}})));
  Modelica.Blocks.Math.Add add2
    annotation (Placement(transformation(extent={{82,-70},{94,-58}})));
  Modelica.Blocks.Math.Max max2[nRooms] annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={30,-26})));
  Modelica.Blocks.Sources.Constant const3[nRooms](each k=Modelica.Constants.eps)
    annotation (Placement(transformation(extent={{2,-18},{12,-8}})));
equation

  // compute smooth gain limit for each room
  for r in 1:nRooms loop
    //limitFactor[r] = 1 / (1 + exp(-dT_slope * (dT[r].y - dT_switch)));

    // final solar gain limit (kW or W)
    //limit[r] = (1 - limitFactor[r]) * OrisToRooms.y[r] + limitFactor[r] * dT[r].y * totalHvaluesRoom[r];
    limit[r] = noEvent(max(abs(dT[r].y),1)) * totalHvaluesRoom[r];
  end for;

  connect(solOrientationGain, OrisToRooms.u)
    annotation (Line(points={{-106,-40},{-81.2,-40}}, color={0,0,127}));
  connect(const.y, variableLimiter.limit2) annotation (Line(points={{-47.5,-75},
          {-40,-75},{-40,-68},{-32,-68}}, color={0,0,127}));
  connect(TDryBul, replicator.u)
    annotation (Line(points={{-106,80},{-78,80}}, color={0,0,127}));
  connect(replicator.y, dT.u1) annotation (Line(points={{-55,80},{-48,80},{-48,72},
          {-52,72},{-52,66},{-46,66}}, color={0,0,127}));
  connect(TRoomSet, dT.u2) annotation (Line(points={{-106,40},{-52,40},{-52,54},
          {-46,54}}, color={0,0,127}));
  connect(intGains, sumInt.u) annotation (Line(points={{-106,-80},{-66,-80},{-66,
          -94},{-59.2,-94}}, color={0,0,127}));
  connect(OrisToRooms.y, sumSol.u)
    annotation (Line(points={{-67.4,-40},{-55.2,-40}}, color={0,0,127}));
  connect(variableLimiter.y, delayedGains.u1) annotation (Line(points={{-9,-60},
          {-6,-60},{-6,-38},{-12.8,-38},{-12.8,-33.4}},
                                            color={0,0,127}));
  connect(const2.y, add.u2) annotation (Line(points={{2.6,-94},{2.6,-91.2},{20.6,
          -91.2}}, color={0,0,127}));
  connect(realExpression.y, add.u1) annotation (Line(points={{9,-80},{9,-82.8},{
          20.6,-82.8}}, color={0,0,127}));
  connect(realExpression.y, product1.u2) annotation (Line(points={{9,-80},{14,-80},
          {14,-57.2},{36.6,-57.2}}, color={0,0,127}));
  connect(variableLimiter.y, product1.u1) annotation (Line(points={{-9,-60},{-6,
          -60},{-6,-48.8},{36.6,-48.8}}, color={0,0,127}));
  connect(add.y, product2.u2) annotation (Line(points={{36.7,-87},{40.65,-87},{40.65,
          -85.2},{44.6,-85.2}}, color={0,0,127}));
  connect(variableLimiter.y, product2.u1) annotation (Line(points={{-9,-60},{-6,
          -60},{-6,-48},{30,-48},{30,-68},{44.6,-68},{44.6,-76.8}}, color={0,0,127}));
  connect(product2.y, sumIntMax.u) annotation (Line(points={{60.7,-81},{65,-81}},
                                   color={0,0,127}));
  connect(product1.y, sumSolMax.u) annotation (Line(points={{52.7,-53},{56.75,-53},
          {56.75,-52},{60.8,-52}}, color={0,0,127}));
  connect(totSolToOri.y, product3.u1)
    annotation (Line(points={{77,-22},{79,-22},{79,-36}}, color={0,0,127}));
  for i in 1:nOrientations loop
    connect(sumSolMax.y, product3[i].u2);
  end for;
  connect(product3.y, solGain) annotation (Line(points={{90.5,-39},{90.5,-36},{94,
          -36},{94,-47},{115,-47}}, color={0,0,127}));
  connect(realExpression1.y, variableLimiter.limit1) annotation (Line(points={{-53,
          24},{-46,24},{-46,-30},{-38,-30},{-38,-32},{-32,-32},{-32,-52}},
        color={0,0,127}));
  connect(OrisToRooms.y, add1.u1) annotation (Line(points={{-67.4,-40},{-67.4,-56.4},
          {-61.2,-56.4}}, color={0,0,127}));
  connect(intGains, add1.u2) annotation (Line(points={{-106,-80},{-66,-80},{-66,
          -63.6},{-61.2,-63.6}}, color={0,0,127}));
  connect(add1.y, variableLimiter.u)
    annotation (Line(points={{-47.4,-60},{-32,-60}}, color={0,0,127}));
  connect(add1.y, delayedGains.u2) annotation (Line(points={{-47.4,-60},{-38,-60},
          {-38,-44},{-21.2,-44},{-21.2,-33.4}}, color={0,0,127}));
  connect(integrator.y, lossRate.u) annotation (Line(points={{27,32},{36,32},{36,
          46},{42,46}}, color={0,0,127}));
  connect(integrator.y, useRate.u) annotation (Line(points={{27,32},{36,32},{36,
          18},{42,18}}, color={0,0,127}));
  connect(add3_1.y, integrator.u)
    annotation (Line(points={{-7.4,32},{4,32}}, color={0,0,127}));
  connect(intGain[1], add2.y) annotation (Line(points={{113,-81},{110,-81},{110,
          -64},{94.6,-64}}, color={0,0,127}));
  connect(sumIntMax.y, add2.u2) annotation (Line(points={{76.5,-81},{76.5,-76},{
          80.8,-76},{80.8,-67.6}}, color={0,0,127}));
  connect(add1.y, max2.u2) annotation (Line(points={{-47.4,-60},{-38,-60},{-38,-44},
          {14,-44},{14,-29.6},{22.8,-29.6}}, color={0,0,127}));
  connect(const3.y, max2.u1) annotation (Line(points={{12.5,-13},{16,-13},{16,-22.4},
          {22.8,-22.4}}, color={0,0,127}));
  connect(useRate.y, add3_1.u3) annotation (Line(points={{65,18},{70,18},{70,4},
          {-6,4},{-6,6},{-21.2,6},{-21.2,27.2}}, color={0,0,127}));
  connect(lossRate.y, add3_1.u1) annotation (Line(points={{65,46},{70,46},{70,60},
          {-16,60},{-16,42},{-21.2,42},{-21.2,36.8}}, color={0,0,127}));
  connect(useRate.y, sum1.u) annotation (Line(points={{65,18},{70,18},{70,12},{83,
          12},{83,5.4}}, color={0,0,127}));
  connect(sum1.y, add2.u1) annotation (Line(points={{83,-10.7},{82,-10.7},{82,-30},
          {92,-30},{92,-54},{80.8,-54},{80.8,-60.4}}, color={0,0,127}));
  connect(delayedGains.y, add3_1.u2) annotation (Line(points={{-17,-17.3},{-17,4},
          {-26,4},{-26,32},{-21.2,32}}, color={0,0,127}));
end ConvertRoomsInputsDelayLoss2nR;
