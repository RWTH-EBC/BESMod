within BESMod.Systems.Hydraulical.Control.Components;
model HeatingCurve
  "Defines supply temperature to building in dependency of ambient temperature"

  parameter Modelica.Units.SI.Temperature TSup_nominal
    "Nominal supply temperature";
  parameter Modelica.Units.SI.Temperature TRet_nominal
    "Nominal supply temperature";
  parameter Modelica.Units.SI.Temperature TOda_nominal
    "Nominal outdoor air temperature";
  parameter Real nHeaTra "Exponent of heat transfer system";

  Modelica.Blocks.Interfaces.RealInput TOda
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput TSet
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

  Modelica.Blocks.Interfaces.RealInput TZoneSet "Zone / room set temperature"
                                                annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,120})));
protected
  parameter Modelica.Units.SI.Temperature TSupMea_nominal=
    (TSup_nominal + TRet_nominal) / 2 "Nominal mean temperature";
  Real derQRel = - 1 / (TZoneSet - TOda_nominal);

equation
  if TOda < TZoneSet then
    TSet = TSup_nominal + (derQRel * (TSupMea_nominal - TZoneSet) * 1 / nHeaTra +
            (TSup_nominal - TRet_nominal) / 2 * derQRel)
      * (TOda - TOda_nominal);
  else
    // No heating required.
    TSet = TZoneSet;
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
