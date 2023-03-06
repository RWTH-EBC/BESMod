within BESMod;
package FMI
  "Contains FMI export containers for the modules, so they can be exported as an FMU"
  extends Modelica.Icons.Package;

  package Hydraulic "FMI export containers for all hydraulic systems"
    extends Utilities.Icons.SystemIcon;
  end Hydraulic;

  package BaseClasses "Package for partial models used by FMI"
    extends Modelica.Icons.BasesPackage;
  end BaseClasses;
  annotation (Icon(graphics={
        Rectangle(
          lineColor={200,200,200},
          fillColor={248,248,248},
          fillPattern=FillPattern.HorizontalCylinder,
          extent={{-100,-100},{100,100}},
          radius=25.0),
                 Bitmap(extent={{-88,-86},{86,88}}, fileName=
            "modelica://IBPSA/Resources/Images/Fluid/FMI/FMI_icon.png")}));
end FMI;
