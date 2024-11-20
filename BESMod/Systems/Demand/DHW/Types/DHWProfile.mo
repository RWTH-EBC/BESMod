within BESMod.Systems.Demand.DHW.Types;
type DHWProfile = enumeration(
    S "Profile S",
    M "Profile M",
    L "Profile L",
    DHWCalc "DHWCalc",
    NoDHW "No DHW") "Enum for dhw profile type";
  annotation (Documentation(info="<html>
<p>Enumeration for selecting different domestic hot water (DHW) demand profiles.</p>

<h4>Important Parameters</h4>
<ul>
  <li><b>S</b>: Profile S - Small tapping profile</li>
  <li><b>M</b>: Profile M - Medium tapping profile</li>
  <li><b>L</b>: Profile L - Large tapping profile</li>
  <li><b>DHWCalc</b>: DHWCalc profile</li>
  <li><b>NoDHW</b>: No DHW demand</li>
</ul>
</html>"));
