within BESMod.Systems.Hydraulical.Generation;
model HeatPump "Monovalent heat pump"
  extends BESMod.Systems.Hydraulical.Generation.BaseClasses.PartialHeatPump(
    final QSec_flow_nominal=0,
    final QGenBiv_flow_nominal=Q_flow_design[1]*(TBiv - THeaTresh)/(
        TOda_nominal - THeaTresh),
    THeaTresh=293.15,
    QPriAtTOdaNom_flow_nominal=0,
    genDesTyp=BESMod.Systems.Hydraulical.Generation.Types.GenerationDesign.Monovalent,
    TBiv=TOda_nominal);

equation
  connect(senTGenOut.port_a, heatPump.port_b1) annotation (Line(points={{60,80},{
          32,80},{32,44},{-30.5,44},{-30.5,37}}, color={0,127,255}));
  connect(heatPump.port_a1, portGen_in[1])  annotation (Line(points={{-30.5,-7},
          {-30.5,-2},{100,-2}},          color={0,127,255}));
end HeatPump;
