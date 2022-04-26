within BESMod.Systems.BaseClasses;
partial model PartialBESExample "Partial example model"
  extends Modelica.Icons.Example;

  BESMod.Systems.RecordsCollection.ExampleSystemParameters systemParameters "Parameters relevant for the whole energy system" annotation (Placement(transformation(extent={{76,-96},{96,-76}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),experiment(StopTime=86400, __Dymola_Algorithm="Dassl"));
end PartialBESExample;
