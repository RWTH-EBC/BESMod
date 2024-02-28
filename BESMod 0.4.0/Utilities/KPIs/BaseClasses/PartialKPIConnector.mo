within BESMod.Utilities.KPIs.BaseClasses;
partial expandable connector PartialKPIConnector "Partial emtpy KPI connector for icon"

  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}, initialScale=0.2),
        graphics={Polygon(
          points={{-100,100},{-100,-100},{102,0},{-100,100}},
          lineColor={135,135,135},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid), Text(
          extent={{-98,-100},{98,-140}},
          textColor={135,135,135},
          textString="KPIs")}),
    Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        initialScale=0.2)),
    Documentation(info="<html>
This icon is designed for a <strong>control bus</strong> connector.
</html>"));
end PartialKPIConnector;
