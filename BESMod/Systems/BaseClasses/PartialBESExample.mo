within BESMod.Systems.BaseClasses;
partial model PartialBESExample "Partial example model"

<<<<<<< HEAD
  BESMod.Systems.RecordsCollection.ExampleSystemParameters systemParameters
    "Parameters relevant for the whole energy system"                                                                         annotation (Placement(transformation(extent={{76,-96},{96,-76}})));
=======
  BESMod.Systems.RecordsCollection.ExampleSystemParameters systemParameters "Parameters relevant for the whole energy system" annotation (Placement(transformation(extent={{80,-100},
            {100,-80}})));
>>>>>>> main
  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(graphics,
        coordinateSystem(preserveAspectRatio=false)),experiment(StopTime=86400, __Dymola_Algorithm="Dassl"));
end PartialBESExample;
