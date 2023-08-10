within BESMod.Systems.Hydraulical.Control.BaseClasses;
partial model PartialHybridHeatPumpSystemController
  "Partial model with replaceable blocks for rule based control of HPS using Boiler"
  extends
    BESMod.Systems.Hydraulical.Control.BaseClasses.PartialHeatPumpSystemController;

  Components.BoilerInHybridSystem boilerInHybridSystem
    annotation (Placement(transformation(extent={{-30,-20},{-12,0}})));
equation
  connect(boilerInHybridSystem.secGen, buiAndDHWCtr.secGen) annotation (Line(
        points={{-31.8,-6},{-110,-6},{-110,37.5},{-118,37.5}}, color={255,0,255}));
end PartialHybridHeatPumpSystemController;
