within BESMod.Utilities.KPIs.BaseClasses;
partial model KPIIcon "Icon for KPI calculators"

  annotation (Icon(graphics={
          Rectangle(
          extent={{-100,100},{102,-100}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid), Text(
          extent={{-98,-100},{100,-160}},
          lineColor={0,0,0},
          textString="%name")}), Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),
    Documentation(info="<html>
<p>Icon for KPI calculation</p>
</html>"));
end KPIIcon;
