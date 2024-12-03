within BESMod.Tutorial;
package RecordsCollection
  extends Modelica.Icons.RecordsPackage;
  partial record MyComponentBaseDataDefinition "Parameters used for a sine-wave"
    extends Modelica.Icons.Record;
    parameter Real amplitude "Amplitude of sine wave";
    parameter Modelica.Units.SI.Frequency f "Frequency of sine wave";
    parameter Modelica.Units.SI.Angle phase "Phase of sine wave";
    parameter Real offset "Offset of output signal y";
    parameter Modelica.Units.SI.Time startTime
      "Output y = offset for time < startTime";
    annotation (Icon(graphics,
                     coordinateSystem(preserveAspectRatio=false)), Diagram(graphics,
          coordinateSystem(preserveAspectRatio=false)));
  end MyComponentBaseDataDefinition;

  record DefaultSineWave "Default sine-wave with 1 Hz"
    extends MyComponentBaseDataDefinition(
      startTime=0,
      offset=0,
      phase=0,
      f=1);
  end DefaultSineWave;

  record PhaseShift90 "Sine-wave with 1 Hz and 90 ° shift"
    extends MyComponentBaseDataDefinition(
      startTime=0,
      offset=0,
      phase=1.5707963267949,
      f=1);
  end PhaseShift90;
  annotation (Documentation(info="<html>
<h4>Information</h4>
<p>
This package contains record definitions for sine wave parameterization used in the 
<a href=\"modelica://BESMod.Tutorial\">BESMod.Tutorial</a> package.
</p>

<p>
The base record <code>MyComponentBaseDataDefinition</code> defines the fundamental parameters needed
to describe a sine wave signal. Two predefined parameter sets are available:
</p>

<ul>
<li><code>DefaultSineWave</code>: Standard 1 Hz sine wave without phase shift or offset</li>
<li><code>PhaseShift90</code>: 1 Hz sine wave with 90� phase shift</li>
</ul>
</html>"));
end RecordsCollection;
