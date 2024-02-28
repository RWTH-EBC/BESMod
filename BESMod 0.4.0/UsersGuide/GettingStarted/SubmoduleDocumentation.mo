within BESMod.UsersGuide.GettingStarted;
model SubmoduleDocumentation "Building a submodule"

  annotation(Documentation(info="<html>
<p>If you want to introduce your own new subsystem / module to the list of available modules, this short guide will help you.</p>
<p>1. Find the matching Partial model. For instance, if you want to introduce a new generation module in the hydraulic subsystem, use BESMod.Systems.Hydraulical.Generation.BaseClasses.PartialGeneration</p>
<p>2. Drag-and-drop the components for your module into the system</p>
<p>3. If no record for the component exists, create a new partial record under RecordsCollections.</p>
<p>4. Link the component records to the bottom-up and top-down parameters. For instance, if the record specifies a pressure drop, set dp_nominal to the records value.</p>
<p>5. Use the top-down parameters to link the design of the components to the systems design. This is not mandatory. However, skipping this step will increase the manual parameterization effort.</p>
<p>6. Move all created parameters to the fitting section (Top-Down, Bottom-Up, Component Choices, Component Recrods)</p>
<p><br><h4>Creating replaceable component choices</h4></p>
<p>1. Either in graphics or text view, declare the component as replaceable</p>
<p>2. Add a contraining clause. Inhere, set avaiable parameters (possibly final) according to the example </p>
<p>3. In the annotation, specify the Dialogs group to &quot;Component choices&quot;</p>
</html>"));
end SubmoduleDocumentation;
