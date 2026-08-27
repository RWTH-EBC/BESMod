within BESMod.Systems.Hydraulical.RecordsCollection;
record CopperPipeVariableSize
  "Record for a copper pipe with a variable size"
  extends AixLib.DataBase.Pipes.PipeBaseDataDefinition(
    d_o=d_i + 2*1e-3,
    d=8900,
    lambda=393,
    c=390);
  annotation (Documentation(info="<html>
<p>
  The parameter <code>d_i</code> is calculated automatically based on mass 
  flow rate and a given flow velocity. The pipe assume a 
  default pipe thickness of 1 mm.
</p>
</html>"));
end CopperPipeVariableSize;
