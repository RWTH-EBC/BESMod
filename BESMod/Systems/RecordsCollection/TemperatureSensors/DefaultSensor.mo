within BESMod.Systems.RecordsCollection.TemperatureSensors;
record DefaultSensor
  extends TemperatureSensorBaseDefinition(
    TAmb=293.15,
    tauHeaTra=1200,
    transferHeat=false,
    initType=Modelica.Blocks.Types.Init.InitialState,
    tau=1);
  annotation (Documentation(info="<html>
<h4>Information</h4>
<p>Default temperature sensor record.
</p>

<h4>Important Parameters</h4>
<ul>
  <li>TAmb = 293.15 K: Ambient temperature</li>
  <li>tauHeaTra = 1200 s: Time constant for heat transfer</li>
  <li>transferHeat = false: Heat transfer disabled</li>
  <li>initType = InitialState: Initial state configuration type</li>
  <li>tau = 1 s: Time constant of the sensor</li>
</ul>
</html>"));
end DefaultSensor;
