within BESMod.Systems.Demand.Building.Components;
model RadOnTiltedSurf_LiuWeaBus
  "Calculates solar radiation on tilted surfaces according to Liu with weaBus"
  import Modelica.Units.Conversions.from_deg;
  parameter Integer WeatherFormat = 1 "Format weather file" annotation (Dialog(group=
        "Properties of Weather Data",                                                                              compact = true, descriptionLabel = true), choices(choice = 1 "TRY", choice= 2 "TMY", radioButtons = true));

  parameter Real GroundReflection=0.2 "ground reflection coefficient"
    annotation (Dialog(group="Ground reflection"));

  parameter Modelica.Units.NonSI.Angle_deg Azimut=13.400
    "azimut of tilted surface, e.g. 0=south, 90=west, 180=north, -90=east"
    annotation (Dialog(group="Surface Properties"));
  parameter Modelica.Units.NonSI.Angle_deg Tilt=90
    "tilt of surface, e.g. 0=horizontal surface, 90=vertical surface"
    annotation (Dialog(group="Surface Properties"));

    Modelica.Blocks.Interfaces.RealInput InHourAngleSun
    annotation (Placement(transformation(
          extent={{-16,-16},{16,16}},
          origin={-98,0}),
          iconTransformation(
          extent={{9,-9},{-9,9}},
          rotation=180,
          origin={-79,-41})));
    Modelica.Blocks.Interfaces.RealInput InDeclinationSun
    annotation (Placement(transformation(
          extent={{-16,-16},{16,16}},
          origin={-98,-40}),
          iconTransformation(
          extent={{9,-9},{-9,9}},
          rotation=180,
          origin={-79,-61})));
  AixLib.Utilities.Interfaces.SolarRad_out OutTotalRadTilted
    annotation (Placement(transformation(extent={{80,30},{100,50}})));
    Modelica.Blocks.Interfaces.RealInput InDayAngleSun
    annotation (Placement(transformation(
          extent={{-16,-16},{16,16}},
          origin={-98,34}),
          iconTransformation(
          extent={{9,-9},{-9,9}},
          rotation=180,
          origin={-79,-21})));



  Real InBeamRadHor "beam irradiance on the horizontal surface";
  Real InDiffRadHor "diffuse irradiance on the horizontal surface";

  Real cos_theta;
  Real cos_theta_help;
  Real cos_theta_z;
  Real cos_theta_z_help;
  Real R;
  Real R_help;
  Real term;

  IBPSA.BoundaryConditions.WeatherData.Bus
      weaBus "Weather data bus" annotation (Placement(transformation(extent={{-112,68},
            {-70,112}}),         iconTransformation(extent={{-68,92},{-48,112}})));
  Modelica.Blocks.Routing.RealPassThrough reaPasThrLat
    "Latitude from bus in rad"
    annotation (Placement(transformation(extent={{-60,80},{-40,100}})));
  Modelica.Blocks.Routing.RealPassThrough reaPasThrsolarInput2
    "Latitude from bus in rad"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  Modelica.Blocks.Math.Add addSolarInput1(k1=+1, k2=-1)
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
equation
  // calculation of cos_theta_z [Duffie/Beckman, p.15], cos_theta_z is manually cut at 0 (no neg. values)
  cos_theta_z_help =sin(from_deg(InDeclinationSun))*sin(reaPasThrLat.y)
     + cos(from_deg(InDeclinationSun))*cos(reaPasThrLat.y)*cos(
    from_deg(InHourAngleSun));
  cos_theta_z = (cos_theta_z_help + abs(cos_theta_z_help))/2;

  // calculation of cos_theta [Duffie/Beckman, p.15], cos_theta is manually cut at 0 (no neg. values)
  term = cos(from_deg(InDeclinationSun))*sin(from_deg(Tilt))*sin(from_deg(
    Azimut))*sin(from_deg(InHourAngleSun));
  cos_theta_help =sin(from_deg(InDeclinationSun))*sin(reaPasThrLat.y)*
    cos(from_deg(Tilt)) - sin(from_deg(InDeclinationSun))*cos(reaPasThrLat.y)*
    sin(from_deg(Tilt))*cos(from_deg(Azimut)) + cos(from_deg(
    InDeclinationSun))*cos(reaPasThrLat.y)*cos(from_deg(Tilt))*cos(
    from_deg(InHourAngleSun)) + cos(from_deg(InDeclinationSun))*sin(
    reaPasThrLat.y)*sin(from_deg(Tilt))*cos(from_deg(Azimut))*cos(from_deg(
    InHourAngleSun)) + term;
  cos_theta = (cos_theta_help + abs(cos_theta_help))/2;

  // calculation of R factor [Duffie/Beckman, p.25], due to numerical problems (cos_theta_z in denominator)
  // R is manually set to 0 for theta_z >= 80 deg (-> 90 deg means sunset)
  if noEvent(cos_theta_z <= 0.17365) then
    R_help = cos_theta_z*cos_theta;

  else
    R_help = cos_theta/cos_theta_z;

  end if;

  R = R_help;

  // conversion of direct and diffuse horizontal radiation
  if WeatherFormat == 1 then // TRY
    InBeamRadHor = addSolarInput1.y;
    InDiffRadHor = reaPasThrsolarInput2.y;
  else  // WeatherFormat == 2 , TMY then
    InBeamRadHor = addSolarInput1.y * cos_theta_z;
    InDiffRadHor = max(reaPasThrsolarInput2.y-InBeamRadHor, 0);
  end if;

  // calculation of total radiation on tilted surface according to model of Liu and Jordan
  // according to [Dissertation Nytsch-Geusen, p.98]
  OutTotalRadTilted.I = max(0, R*InBeamRadHor + 0.5*(1 + cos(from_deg(
    Tilt)))*InDiffRadHor + GroundReflection*(InBeamRadHor + InDiffRadHor)
    *((1 - cos(from_deg(Tilt)))/2));

  // Setting the outputs of direct. diffuse and ground reflection radiation on tilted surface and the angle of incidence
  OutTotalRadTilted.I_dir = R*InBeamRadHor;
  OutTotalRadTilted.I_diff = 0.5*(1 + cos(from_deg(Tilt)))*InDiffRadHor;
  OutTotalRadTilted.I_gr = GroundReflection*(InBeamRadHor + InDiffRadHor)*((1 - cos(from_deg(Tilt)))/2);

  OutTotalRadTilted.AOI = Modelica.Math.acos(cos_theta); // in rad

  connect(reaPasThrLat.u, weaBus.lat) annotation (Line(points={{-62,90},{-91,90}},
                                       color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(weaBus.HDifHor, addSolarInput1.u2) annotation (Line(
      points={{-91,90},{-91,64},{-78,64},{-78,44},{-62,44}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(weaBus.HGloHor, addSolarInput1.u1) annotation (Line(
      points={{-91,90},{-91,60},{-70,60},{-70,56},{-62,56}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(reaPasThrsolarInput2.u, weaBus.HDifHor) annotation (Line(points={{-62,
          10},{-78,10},{-78,64},{-91,64},{-91,90}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
          {100,100}}), graphics={
      Rectangle(
        extent={{-80,60},{80,-100}},
        lineColor={0,0,0},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Rectangle(
        extent={{-80,60},{80,-100}},
        lineColor={0,0,0},
         pattern=LinePattern.None,
        fillPattern=FillPattern.HorizontalCylinder,
        fillColor={170,213,255}),
      Ellipse(
        extent={{14,36},{66,-16}},
        lineColor={0,0,255},
         pattern=LinePattern.None,
        fillColor={255,225,0},
        fillPattern=FillPattern.Solid),
      Rectangle(
        extent={{-80,-40},{80,-100}},
        lineColor={0,0,0},
         pattern=LinePattern.None,
        fillPattern=FillPattern.HorizontalCylinder,
        fillColor={0,127,0}),
      Rectangle(
        extent={{-80,-72},{80,-100}},
        lineColor={0,0,255},
         pattern=LinePattern.None,
        fillColor={0,127,0},
        fillPattern=FillPattern.Solid),
      Polygon(
        points={{-60,-64},{-22,-76},{-22,-32},{-60,-24},{-60,-64}},
        lineColor={0,0,0},
        fillPattern=FillPattern.VerticalCylinder,
        fillColor={226,226,226}),
      Polygon(
        points={{-60,-64},{-80,-72},{-80,-100},{-60,-100},{-22,-76},{-60,
            -64}},
        lineColor={0,0,0},
         pattern=LinePattern.None,
        fillPattern=FillPattern.VerticalCylinder,
        fillColor={0,77,0}),
      Text(
        extent={{-100,100},{100,60}},
        lineColor={0,0,255},
        textString="%name")}),
Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}})),
    Documentation(info="<html><h4>
  <span style=\"color:#008000\">Overview</span>
</h4>
<p>
  The <b>RadOnTiltedSurf</b> model calculates the total radiance on a
  tilted surface.
</p>
<h4>
  <span style=\"color:#008000\">Concept</span>
</h4>
<p>
  The <b>RadOnTiltedSurf</b> model uses output data of the <b><a href=
  \"AixLib.Building.Components.Weather.BaseClasses.Sun\">Sun</a></b>
  model and weather data (beam and diffuse radiance on a horizontal
  surface for TRY format, or beam normal and global horizontal for TMY
  format) to compute total radiance on a tilted surface. It needs
  information on the tilt angle and the azimut angle of the surface,
  the latitude of the location and the ground reflection coefficient.
</p>
<p>
  The input InDayAngleSun is not explicitly used in the model, but it
  is part of the partial model and it doesn't interfere with the
  calculations.
</p>
<h4>
  <span style=\"color:#008000\">Example Results</span>
</h4>
<p>
  The model is checked within the <a href=
  \"AixLib.Building.Examples.Weather.WeatherModels\">weather</a> example
  as part of the <a href=
  \"AixLib.Building.Components.Weather.Weather\">weather</a> model.
</p>
</html>",
    revisions="<html><ul>
  <li>
    <i>March 23, 2015&#160;</i> by Ana Constantin:<br/>
    Adapted solar inputs so it cand work with both TRY and TMY weather
    format
  </li>
  <li>
    <i>May 02, 2013&#160;</i> by Ole Odendahl:<br/>
    Formatted documentation appropriately
  </li>
  <li>
    <i>March 14, 2005&#160;</i> by Timo Haase:<br/>
    Implemented.
  </li>
</ul>
</html>"));
end RadOnTiltedSurf_LiuWeaBus;
