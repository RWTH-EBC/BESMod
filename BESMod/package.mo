within ;
package BESMod
  extends Modelica.Icons.Package;

  annotation (
    version="0.6.0",
    uses(
    Modelica(version="4.0.0"),
    SDF(version="0.4.2"),
      IBPSA(version="4.0.0"),
      AixLib(version="2.1.1")),
   conversion(
 from(
  version="0.2.2",
     script="modelica://BESMod/Resources/Scripts/ConvertBESMod_from_0.2.2_to_0.3.0.mos",
     to="0.3.0"),
 from(
  version="0.3.1",
  script="modelica://BESMod/Resources/Scripts/ConvertBESMod_from_0.3.1_to_0.3.2.mos",
     to="0.3.2")),
    Icon(graphics={Bitmap(extent={{-100,-100},{100,100}},
   fileName="modelica://BESMod/Resources/Images/BESMod_icon.png")}));
end BESMod;
