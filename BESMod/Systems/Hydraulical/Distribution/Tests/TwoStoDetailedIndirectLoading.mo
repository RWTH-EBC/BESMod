within BESMod.Systems.Hydraulical.Distribution.Tests;
model TwoStoDetailedIndirectLoading
  extends BaseClasses.PartialTest(
                      redeclare
      BESMod.Systems.Hydraulical.Distribution.TwoStoDetailedIndirectLoading
      distribution(
      redeclare
        BESMod.Systems.RecordsCollection.TemperatureSensors.DefaultSensor
        parTemSen,
      redeclare
        BESMod.Systems.RecordsCollection.Valves.DefaultThreeWayValve
        parThrWayVal,
      redeclare
        BESMod.Systems.Hydraulical.Distribution.RecordsCollection.BufferStorage.DefaultDetailedStorage
        parStoBuf,
      redeclare
        BESMod.Systems.Hydraulical.Distribution.RecordsCollection.BufferStorage.DefaultDetailedStorage
        parStoDHW,
      redeclare
        BESMod.Systems.Hydraulical.Generation.RecordsCollection.ElectricHeater.DefaultElectricHeater
        parEleHeaAftBuf,
      dTLoaHCBuf=10,
      QHeaAftBuf_flow_nominal=0));
  extends Modelica.Icons.Example;

equation
  connect(pulse.y, sigBusDistr.uThrWayVal) annotation (Line(points={{-59,80},{
          -44,80},{-44,79},{0,79}},   color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(booleanConstant.y, sigBusDistr.pumGenOn) annotation (Line(points={{-59,
          50},{0,50},{0,79}}, color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
annotation (experiment(StopTime=3600, Tolerance=1e-06, Interval=100),
     __Dymola_Commands(file="modelica://BESMod/Resources/Scripts/Dymola/Systems/Hydraulical/Distribution/Tests/TwoStoDetailedIndirectLoading.mos"
          "Simulate and plot"),
    Documentation(info="<html>
<p>
  Test for 
  <a href=\"modelica://BESMod.Systems.Hydraulical.Distribution.TwoStoDetailedIndirectLoading\">BESMod.Systems.Hydraulical.Distribution.TwoStoDetailedIndirectLoading</a>.
</p>
<p>
The tests show how all mass flow rates always are met even though 
the three way valve is switching. Furthermore, the building supply tempereature 
decreases over time as the storage gets colder due to switching to DHW mode.
Only at the start, the indirect loading nominal temperature difference of 10 K leads
to increasing temperatures in dynamic operation. 
</p>  
</html>"));
end TwoStoDetailedIndirectLoading;
