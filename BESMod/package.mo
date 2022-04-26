within ;
package BESMod
  extends Modelica.Icons.Package;

  annotation (
    version="0.2.0",
    uses(
    Modelica(version="3.2.3"),
    SDF(version="0.4.1"),
    IBPSA(version="3.0.0")),
  conversion(from(
    version="0.1.1",
       script="modelica://BESMod/Resources/Scripts/ConvertBESMod_from_0.1.1_to_0.2.0.mos")),
    Icon(graphics={Bitmap(extent={{-100,-106},{100,108}},
                                                      fileName="modelica://BESMod/Resources/img/BESMod_icon.png")}));
end BESMod;
