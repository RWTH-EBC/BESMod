within BESMod.Systems.Electrical.Generation.Tests;
model TestNoGeneration
  extends PartialTest(redeclare
      BESMod.Systems.Electrical.Generation.NoGeneration generation);
  extends Modelica.Icons.Example;


  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(graphics,
        coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=86400,
      Interval=900,
      __Dymola_Algorithm="Dassl"), Documentation(info="<html>

<h4>Information</h4>
<p>Test model 
using the <a href=\"modelica://BESMod.Systems.Electrical.Generation.NoGeneration\">BESMod.Systems.Electrical.Generation.NoGeneration</a> model. 
This model represents the case where no electrical generation system is present.</p>

</html>"));
end TestNoGeneration;
