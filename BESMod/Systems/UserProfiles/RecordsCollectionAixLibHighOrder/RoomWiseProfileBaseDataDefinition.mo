within BESMod.Systems.UserProfiles.RecordsCollectionAixLibHighOrder;
record RoomWiseProfileBaseDataDefinition "Base record for one-value time-series profiles"
  parameter Real[:, 11] Profile "First column time";
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html><h4>
  <span style=\"color:#008000\">Overview</span>
</h4>
<p>
  Profiles are to be understood as room wise useage profiles for the AixLib SFH HOM.
 <p>Columes</p>
<p>1	Time</p>
<p>2	Livingroom</p>
<p>3	Hobby</p>
<p>4	Corridor_gf</p>
<p>5 	WC_Storage</p>
<p>6	Kitchen</p>
<p>7	Bedroom</p>
<p>8	Children1</p>
<p>9	Corridor_upp</p>
<p>10	Bath</p>
<p>11	Children2</p>
</p>
<h4>
  <span style=\"color:#008000\">Concept</span>
</h4>
<p>
  For example:
</p>
<ul>
  <li>Ventilation schedules
  </li>
  <li>Schedules for set room temperature
  </li>
</ul>
<h4>
  <span style=\"color:#008000\">References</span>
</h4>
<p>
  Base data definition for record to be used in model <a href=
  \"Modelica.Blocks.Sources.CombiTimeTable\">Modelica.Blocks.Sources.CombiTimeTable</a>
</p>
<ul>
  </li>
  <li>
    <i>August 6, 2026&#160;</i> by Hendrik van der Stok:<br/>
    Implemented.
  </li>
</ul>
</html>"));
end RoomWiseProfileBaseDataDefinition;
