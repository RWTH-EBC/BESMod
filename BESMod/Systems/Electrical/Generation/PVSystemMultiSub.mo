within BESMod.Systems.Electrical.Generation;
model PVSystemMultiSub
  "PV system with subsystems of different orientation and module type"
  extends
    BESMod.Systems.Electrical.Generation.BaseClasses.PartialGeneration(
      numGenUnits=1);

  AixLib.Electrical.PVSystem.PVSystem pVSystem[numGenUnits](
    final data=pVParameters,
    redeclare final model IVCharacteristics =
        AixLib.Electrical.PVSystem.BaseClasses.IVCharacteristics5pAnalytical,
    redeclare model CellTemperature = CellTemperature,
    final n_mod=n_mod,
    final til=til,
    final azi=azi,
    final lat=lat,
    final lon=lon,
    final alt=alt,
    final timZon=timZon,
    final groRef=0.2,
    final use_ParametersGlaz=false)
    annotation (Placement(transformation(extent={{-32,-30},{26,28}})));
  Modelica.Blocks.Math.Sum sumOfPower(nin=numGenUnits)
                                      "Sums up DC Output power" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={50,20})));
  replaceable model CellTemperature =
      AixLib.Electrical.PVSystem.BaseClasses.PartialCellTemperature annotation (
     __Dymola_choicesAllMatching=true);
  Utilities.Electrical.RealToElecCon realToElecCon(use_souLoa=false)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={50,58})));
  replaceable parameter AixLib.DataBase.SolarElectric.PVBaseDataDefinition pVParameters[numGenUnits]
  constrainedby AixLib.DataBase.SolarElectric.PVBaseDataDefinition
    annotation(choicesAllMatching=true,Placement(transformation(extent={{-80,-40},{-60,-20}})));
  parameter Modelica.SIunits.Angle lat "Location's Latitude"
  annotation(Dialog(group="Design - Top Down: Parameters are given by the parent system"));
  parameter Modelica.SIunits.Angle lon "Location's Longitude"
  annotation(Dialog(group="Design - Top Down: Parameters are given by the parent system"));
  parameter Real alt "Site altitude in Meters, default= 1"
  annotation(Dialog(group="Design - Top Down: Parameters are given by the parent system"));
  parameter Modelica.SIunits.Time timZon
    "Time zone. Should be equal with timZon in ReaderTMY3, if PVSystem and ReaderTMY3 are used together."
    annotation(Dialog(group="Design - Top Down: Parameters are given by the parent system"));
  parameter Real n_mod[numGenUnits]={f_design[i]*ARoof/pVParameters[i].A_mod for i in 1:numGenUnits} "Number of connected PV modules";
  parameter Modelica.SIunits.Angle til[numGenUnits]=fill(20*180/Modelica.Constants.pi,numGenUnits) "Surface's tilt angle (0:flat)";
  parameter Modelica.SIunits.Angle azi[numGenUnits]=fill(0,numGenUnits)  "Surface's azimut angle (0:South)";
  parameter Modelica.SIunits.Area ARoof(min=0) "Roof area of building" annotation(Dialog(group="Design - Top Down: Parameters are given by the parent system"));

equation
  for i in 1:numGenUnits loop
    connect(pVSystem[i].weaBus, weaBus);
  end for;
  connect(sumOfPower.y, realToElecCon.PEleGen)
    annotation (Line(points={{50,31},{54,31},{54,46}}, color={0,0,127}));
  connect(realToElecCon.internalElectricalPin, internalElectricalPin)
    annotation (Line(
      points={{49.8,68.2},{49.8,82.1},{50,82.1},{50,98}},
      color={0,0,0},
      thickness=1));
  connect(pVSystem.DCOutputPower, sumOfPower.u)
    annotation (Line(points={{28.9,-1},{50,-1},{50,8}}, color={0,0,127}));
   annotation(Dialog(group="Design - Bottom Up: Parameters are defined by the subsystem"),
              Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PVSystemMultiSub;
