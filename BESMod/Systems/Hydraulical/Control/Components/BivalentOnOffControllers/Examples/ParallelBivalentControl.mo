within BESMod.Systems.Hydraulical.Control.Components.BivalentOnOffControllers.Examples;
model ParallelBivalentControl
  extends PartialOnOffController(dTHys=onOffController.Hysteresis, redeclare
      BESMod.Systems.Hydraulical.Control.Components.BivalentOnOffControllers.PartParallelBivalent
      onOffController(
      dTHys=10,
      TCutOff=263.15,
      TBiv=270.15,
      TOda_nominal=258.15,
      TRoom=293.15,
      QDem_flow_nominal=12000,
      QHP_flow_cutOff=3000,
      secGenOn(start=false),
      ySecGenSet(start=0)));

  extends Modelica.Icons.Example;
end ParallelBivalentControl;
