within BESMod.Systems.RecordsCollection.TemperatureSensors;
record DefaultSensor
  extends TemperatureSensorBaseDefinition(
    TAmb=293.15,
    tauHeaTra=1200,
    transferHeat=false,
    initType=Modelica.Blocks.Types.Init.InitialState,
    tau=1);
end DefaultSensor;
