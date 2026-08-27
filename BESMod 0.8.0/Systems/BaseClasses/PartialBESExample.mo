within BESMod.Systems.BaseClasses;
partial model PartialBESExample "Partial example model"

  parameter BESMod.Systems.RecordsCollection.ExampleSystemParameters systemParameters
    "Parameters relevant for the whole energy system" annotation (Placement(transformation(extent={{80,-100},
            {100,-80}})));
  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(graphics,
        coordinateSystem(preserveAspectRatio=false)),experiment(StopTime=86400, __Dymola_Algorithm="Dassl"));
end PartialBESExample;
