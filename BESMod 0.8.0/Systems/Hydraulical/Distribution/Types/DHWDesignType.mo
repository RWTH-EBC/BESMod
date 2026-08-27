within BESMod.Systems.Hydraulical.Distribution.Types;
type DHWDesignType = enumeration(
    NoStorage "No Storage",
    PartStorage "Part Storage",
    FullStorage "Full Storage") "Option of how to account DHW in design according to EN 15450"
  annotation (Documentation(info="<html>
<p>Check EN 15450 for information on the design of DHW storages. Currently, only part storage and no storage are implemented. Full storage is not considered yet. If you want to use it, please raise an issue.</p>
</html>"));
