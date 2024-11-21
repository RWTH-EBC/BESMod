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
  connect(senTGenOut.port_a, heatPump.port_b1) annotation (Line(points={{60,80},
          {32,80},{32,44},{-30,44},{-30,35}},    color={0,127,255}));
  connect(heatPump.port_a1, pump.port_b) annotation (Line(points={{-30,0},{-30,
          -70},{1.77636e-15,-70}},       color={0,127,255}));
  annotation (Documentation(info="<html>
<h4>Information</h4>
<p>Monovalent heat pump system model. 
This model implements a heat pump as the sole heat generator without any backup/auxiliary heater.</p>

<h4>Model Structure</h4>
<p>This model extends <a href=\"modelica://BESMod.Systems.Hydraulical.Generation.BaseClasses.PartialHeatPump\">BESMod.Systems.Hydraulical.Generation.BaseClasses.PartialHeatPump</a></p>

</html>"));
end HeatPump;
