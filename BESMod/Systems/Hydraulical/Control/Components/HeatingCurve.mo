within BESMod.Systems.Hydraulical.Control.Components;
model HeatingCurve
  "Defines T_supply of buffer storage tank (in dependency of ambient temperature)"

  parameter Modelica.Units.SI.Temperature TRoomSet=295.15
    "Expected room temperature (22°C)";
  parameter Real GraHeaCurve=1 "Heat curve gradient";
  parameter Modelica.Units.SI.Temperature THeaThres=273.15 + 15
    "Constant heating threshold temperature";
  parameter Modelica.Units.SI.TemperatureDifference dTOffSet_HC=2
    "Additional Offset of heating curve";

  Modelica.Blocks.Interfaces.RealInput TOda
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput TSet
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

equation
  if TOda < THeaThres then
    TSet = GraHeaCurve*(TRoomSet - TOda) + TRoomSet + dTOffSet_HC;
  else
    // No heating required.
    TSet = TRoomSet + dTOffSet_HC;
  end if;
  annotation (Icon(graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
                             Text(
          extent={{-100,230},{100,30}},
          lineColor={0,0,0},
          textString="%name")}));
end HeatingCurve;
