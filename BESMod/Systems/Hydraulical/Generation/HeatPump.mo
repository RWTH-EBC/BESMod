within BESMod.Systems.Hydraulical.Generation;
model HeatPump "Monovalent heat pump"
  extends BESMod.Systems.Hydraulical.Generation.BaseClasses.PartialHeatPump(
    final QSec_flow_nominal=0,
    final QGenBiv_flow_nominal=Q_flow_design[1]*(TBiv - THeaTresh)/(
        TOda_nominal - THeaTresh),
    THeaTresh=293.15,
    QPriAtTOdaNom_flow_nominal=0,
    genDesTyp=BESMod.Systems.Hydraulical.Generation.Types.GenerationDesign.Monovalent,
    TBiv=TOda_nominal,
    resGen(
      dp_nominal=parHeaPum.dpCon_nominal + resGen.dpFixed_nominal,
      final length=lengthPip,
      final resCoe=resCoe),
    heatPump(dpCon_nominal=0));
  parameter Modelica.Units.SI.Length lengthPip=8 "Length of all pipes"
    annotation (Dialog(tab="Pressure losses"));
  parameter Real resCoe=4*facPerBend
    "Factor to take into account resistance of bends, fittings etc."
    annotation (Dialog(tab="Pressure losses"));
equation
  connect(senTGenOut.port_a, heatPump.port_b1) annotation (Line(points={{60,80},
          {32,80},{32,44},{-30,44},{-30,35}},    color={0,127,255}));
  connect(resGen.port_a, heatPump.port_a1) annotation (Line(points={{60,-10},{28,
          -10},{28,-18},{-30,-18},{-30,0}},color={0,127,255}));
end HeatPump;
