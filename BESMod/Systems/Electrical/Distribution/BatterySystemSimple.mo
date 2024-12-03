within BESMod.Systems.Electrical.Distribution;
model BatterySystemSimple "Simple Battery model"
  extends
    BESMod.Systems.Electrical.Distribution.BaseClasses.PartialDistribution;

  parameter Real SOC_start_bat = 0.2 "Initial SOC of battery" annotation(Dialog(tab="Initialization"));
  parameter Integer nBat=1 "Number of batteries";
  Components.FixedInitialBatterySimple batterySimple(
    final batteryData=batteryParameters,
    nBat=nBat,
    final SOC_start=SOC_start_bat)
    annotation (Placement(transformation(extent={{-46,-42},{46,42}})));
  BESMod.Utilities.Electrical.ElecConToReal elecConToReal(reverse=true)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-70,34})));
  BESMod.Utilities.Electrical.RealToElecConSplit realToElecConSplit annotation (
     Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={50,-30})));
  BESMod.Utilities.Electrical.ElecConToReal elecConToReal2[nSubSys](each final
      reverse=true) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={72,24})));

  replaceable parameter BuildingSystems.Technologies.ElectricalStorages.Data.BaseClasses.ElectricBatteryGeneral
    batteryParameters constrainedby
    BuildingSystems.Technologies.ElectricalStorages.Data.BaseClasses.ElectricBatteryGeneral
    annotation (choicesAllMatching=true, Placement(transformation(extent={{-68,-42},{-48,-22}})));

  Modelica.Blocks.Math.Sum sumOfLoads(nin=nSubSys)
    annotation (Placement(transformation(extent={{66,-8},{52,6}})));
equation
  connect(batterySimple.SOC, OutputDistr.SOCBat) annotation (Line(points={{0,
          22.68},{0,40},{100,40},{100,-100},{0,-100},{0,-98}}, color={0,0,127}),
      Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(realToElecConSplit.internalElectricalPin, externalElectricalPin)
    annotation (Line(
      points={{50.2,-40.2},{50.2,-65.1},{50,-65.1},{50,-98}},
      color={0,0,0},
      thickness=1));
  connect(internalElectricalPin, elecConToReal2.internalElectricalPin)
    annotation (Line(
      points={{50,100},{50,66},{72.2,66},{72.2,33.8}},
      color={0,0,0},
      thickness=1));
  connect(elecConToReal2.PElecLoa, sumOfLoads.u)
    annotation (Line(points={{76,12},{76,-1},{67.4,-1}}, color={0,0,127}));
  connect(sumOfLoads.y, batterySimple.PLoad) annotation (Line(points={{51.3,-1},
          {39.65,-1},{39.65,0},{23,0}}, color={0,0,127}));
  connect(internalElectricalPin[2], elecConToReal.internalElectricalPin)
    annotation (Line(
      points={{50,100},{48,100},{48,66},{-69.8,66},{-69.8,43.8}},
      color={0,0,0},
      thickness=1));
  connect(elecConToReal.PElecGen, batterySimple.PCharge)
    annotation (Line(points={{-74,22},{-74,0},{-23,0}}, color={0,0,127}));
  connect(realToElecConSplit.PEle, batterySimple.PGrid) annotation (Line(points=
         {{50,-18},{50,16.8},{24.84,16.8}}, color={0,0,127}));
  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)), Documentation(info="<html>
<p>Simple battery model acting as an electrical distribution system. 
The model uses a simplified battery model with SOC tracking and 
interfaces with other system components through electrical connectors 
that are converted to real signals.</p>

<h4>Important Parameters</h4>
<ul>
  <li><code>SOC_start_bat</code>: Initial state of charge of the battery (default: 0.2)</li>
  <li><code>nBat</code>: Number of batteries in the system</li>
  <li><code>batteryParameters</code>: Replaceable record containing battery specifications, must extend <a href=\"modelica://BuildingSystems.Technologies.ElectricalStorages.Data.BaseClasses.ElectricBatteryGeneral\">BuildingSystems.Technologies.ElectricalStorages.Data.BaseClasses.ElectricBatteryGeneral</a></li>
</ul>
</html>"));
end BatterySystemSimple;
