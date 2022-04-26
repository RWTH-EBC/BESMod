within BESMod;
package Components "Package for all additional compontents developted for this project"
  extends Modelica.Icons.Package;

annotation (Documentation(info="<html>
<p>Components used in building energy systems which are not given in an existing model library to the modeling depth required by the simulation.</p>
<p>Most of these components shall not stay in this library but rather</p>
<ul>
<li>be integrated into the corresponding component library. For instance, we modified the heating rod model in the IBPSA. This will be added to the IBPSA in the near future</li>
<li>be replaced by better fitting models. For instance, the ArtificalPumps were used starting this library but are replaced one after another be the movers from IBPSA</li>
<li>be moved to a matching project library. For instance, we simulated an UFH system in one project. Moving the UFH-subsystem and these models into an own project library is more straightforward.</li>
</ul>
<p><br>This is true not only for this package but all packages named &quot;Components&quot;. </p>
</html>"), Icon(graphics={
        Polygon(points={{-72,34},{66,-36},{66,34},{0,-2},{-72,-34},{-72,34}},
            lineColor={0,0,0}),
        Line(points={{0,50},{0,-2}}),
        Rectangle(
          extent={{-20,58},{20,50}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid)}));
end Components;
