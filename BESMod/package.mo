within ;
package BESMod
  extends Modelica.Icons.Package;

  annotation (
    version="0.7.0",
    uses(
    Modelica(version="4.0.0"),
    SDF(version="0.4.2"),
      IBPSA(version="4.0.0"),
      AixLib(version="3.0.0")),
   conversion(
 from(
  version="0.6.0",
  script="modelica://BESMod/Resources/Scripts/ConvertBESMod_from_0.6.0_to_0.7.0.mos",
  to="0.7.0")),
    Icon(graphics={Bitmap(extent={{-100,-100},{100,100}},
   fileName="modelica://BESMod/Resources/Images/BESMod_icon.png")}));
end BESMod;
