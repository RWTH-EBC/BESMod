within BESMod.Systems.Hydraulical.Control.Components.OnOffController.Examples;
model ParallelBivalentControl
  extends PartialOnOffController(dTHys=onOffController.Hysteresis, redeclare
      BESMod.Systems.Hydraulical.Control.Components.OnOffController.ParallelBivalentControl
      onOffController(
      Auxilliar_Heater_On(start=false),
      Auxilliar_Heater_set(start=0),
      Hysteresis=10,
      TCutOff=263.15,
      TBiv=270.15,
      TOda_nominal=258.15,
      TRoom=293.15,
      QDem_flow_nominal=12000,
      QHP_flow_cutOff=3000));

  extends Modelica.Icons.Example;
end ParallelBivalentControl;
