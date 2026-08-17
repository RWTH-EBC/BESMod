within BESMod.Systems.UserProfiles.RecordsCollectionAixLibHighOrder.SetTemperatures;
record ConstRoomNom "DIN 12831 norm based const temperatrues"
  extends BESMod.Systems.UserProfiles.RecordsCollectionAixLibHighOrder.RoomWiseProfileBaseDataDefinition(Profile=[0,
        293.15,293.15,293.15,293.15,293.15,293.15,293.15,293.15,297.15,293.15;
        86400,293.15,293.15,293.15,293.15,293.15,293.15,293.15,293.15,297.15,
        293.15]);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end ConstRoomNom;
