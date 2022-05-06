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
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
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
end RecordsCollection;
