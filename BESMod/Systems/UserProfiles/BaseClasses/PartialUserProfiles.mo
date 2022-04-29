within BESMod.Systems.UserProfiles.BaseClasses;
partial model PartialUserProfiles
  "Partial model for replaceable user profiles"

  replaceable parameter
    BESMod.Systems.RecordsCollection.SystemParametersBaseDataDefinition
    systemParameters constrainedby
    BESMod.Systems.RecordsCollection.SystemParametersBaseDataDefinition
    "Parameters relevant for the whole energy system" annotation (
      choicesAllMatching=true, Placement(transformation(extent={{86,-118},{
            118,-82}})));
  BESMod.Systems.Interfaces.UseProBus useProBus annotation (
      Placement(transformation(extent={{80,-34},{150,32}}), iconTransformation(
          extent={{80,-34},{150,32}})));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-120,
            -120},{120,120}}),
                         graphics={
        Text(
          extent={{-196,136},{190,24}},
          lineColor={0,0,0},
          textString="%name%
"),     Polygon(points={{-118,-96},{-118,-96}}, lineColor={28,108,200}),
        Bitmap(extent={{-96,-96},{90,92}}, fileName="modelica://BESMod/Resources/Images/Users.png")}),
      Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,-120},
            {120,120}})));
end PartialUserProfiles;
