  annotation (Documentation(info="<html>
<p>Type for pressure drop per length with unit Pascal per meter (Pa/m).</p>
</html>"));
within BESMod.Systems.Hydraulical.Transfer.Types;
type PressureDropPerLength = Real (
    final quantity="Modelica.SIunits.Pressure/Modelica.SIunits.Length",
    final unit="Pa/m") "Pressure drop per length";
