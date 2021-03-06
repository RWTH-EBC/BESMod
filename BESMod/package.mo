within ;
package BESMod
  extends Modelica.Icons.Package;

  annotation (
    version="0.2.0",
    uses(
    SDF(version="0.4.1"),
    BuildingSystems(version="2.0.0-beta"),
    Modelica(version="4.0.0"),
    IBPSA(version="3.0.0"),
    AixLib(version="1.2.0"),
    ModelicaServices(version="4.0.0")),
  conversion(from(
    version="0.1.1",
       script="modelica://BESMod/Resources/Scripts/ConvertBESMod_from_0.1.1_to_0.2.0.mos")),
    Icon(graphics={Bitmap(extent={{-100,-100},{100,100}},
                                                      fileName="modelica://BESMod/Resources/Images/BESMod_icon.png")}));
end BESMod;
