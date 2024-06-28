within BESMod.Examples.TEASERHeatLoadCalculation;
model Example "Simple example"
  extends PartialCalculation(building(redeclare
        BESMod.Examples.BAUSimStudy.Buildings.Case_2_retrofit oneZoneParam(
          heaLoadFacOut=200, heaLoadFacGrd=100)), userProfiles(dTSetBack=3));
  extends Modelica.Icons.Example;
  annotation (
    experiment(stopTime=172800
     Interval=600
     Tolerance=1e-06));
end Example;
