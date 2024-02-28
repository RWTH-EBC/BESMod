within BESMod.Systems.Electrical;
model DirectGridConnectionSystem
  "Direct grid connection only, no generation or transfer"
  extends BaseClasses.PartialElectricalSystem(
    redeclare final BESMod.Systems.Electrical.Generation.NoGeneration
      generation,
    redeclare final BESMod.Systems.Electrical.Control.NoControl control,
    redeclare final BESMod.Systems.Electrical.Transfer.NoElectricalTransfer
      transfer,
    redeclare final BESMod.Systems.Electrical.Distribution.DirectlyToGrid
      distribution);
end DirectGridConnectionSystem;
