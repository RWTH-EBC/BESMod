within BESMod.UsersGuide;
package ContrainingClauseTutorial

  partial model PartialModule

    parameter Real topDownParameter "A top-down parameter"
      annotation (Dialog(group="Top-Down"));
    parameter Real bottomUpParameter "A bottom-up parameter"
      annotation (Dialog(group="Bottom-Up"));

  end PartialModule;

  model MyOwnModule
     extends PartialModule(bottomUpParameter=5);



  end MyOwnModule;
  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(graphics,
        coordinateSystem(preserveAspectRatio=false)));
end ContrainingClauseTutorial;
