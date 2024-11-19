within BESMod.Systems.Electrical.Generation;
model PVSystemMultiSub
  "PV system with subsystems of different orientation and module type"
  extends BESMod.Systems.Electrical.Generation.BaseClasses.PartialGeneration(
      numGenUnits=if useTwoRoo then 2 else 1);

  parameter Modelica.Units.SI.Area ARooSid = ARoo / 2
    "Roof area of one side of the whole roof";

  parameter Boolean useTwoRoo = true
    "=true to use both roof-sides, e.g. north and south or east and west";
  parameter Modelica.Units.SI.Angle tilAllMod=0.34906585039887
    "Surface's tilt angle of all modules (0:flat)";
  parameter Modelica.Units.SI.Angle aziMaiRoo=0
    "Main roof areas surface's azimut angle (0:South)";

  replaceable model CellTemperature =
      AixLib.Electrical.PVSystem.BaseClasses.PartialCellTemperature annotation (
     __Dymola_choicesAllMatching=true, Documentation(info="<html>
<p>Calculates the cell temperature of the PV module based on winVel, T_a, eta and radTil.</p>
</html>"));
  replaceable parameter AixLib.DataBase.SolarElectric.PVBaseDataDefinition pVParameters[numGenUnits]
  constrainedby AixLib.DataBase.SolarElectric.PVBaseDataDefinition
    annotation(choicesAllMatching=true,Placement(transformation(extent={{-82,-40},
            {-62,-20}})));
  parameter Modelica.Units.SI.Angle lat "Location's Latitude";
  parameter Modelica.Units.SI.Angle lon "Location's Longitude";
  parameter Real alt "Site altitude in Meters, default= 1";
  parameter Modelica.Units.SI.Time timZon
    "Time zone. Should be equal with timZon in ReaderTMY3, if PVSystem and ReaderTMY3 are used together.";
  parameter Real numMod[numGenUnits]={(f_design[i]*ARooSid/pVParameters[i].A_mod)
      for i in 1:numGenUnits} "Number of connected PV modules";
  parameter Modelica.Units.SI.Angle til[numGenUnits]=fill(tilAllMod,numGenUnits)
    "Surface's tilt angle (0:flat)";
  parameter Modelica.Units.SI.Angle azi[numGenUnits]={aziMaiRoo + (i-1) * Modelica.Constants.pi for i in 1:numGenUnits}
    "Surface's azimut angle (0:South)";
  parameter Modelica.Units.SI.Power PEleMaxPowPoi[numGenUnits](each displayUnit="kW")={numMod[i]*
      pVParameters[i].P_mp0 for i in 1:numGenUnits}
    "MPP Power of the PV System [kWp]";
  AixLib.Electrical.PVSystem.PVSystem pVSystem[numGenUnits](
    final data=pVParameters,
    redeclare final model IVCharacteristics =
        AixLib.Electrical.PVSystem.BaseClasses.IVCharacteristics5pAnalytical,
    redeclare model CellTemperature = CellTemperature,
    final n_mod=numMod,
    final til=til,
    final azi=azi,
    each final lat=lat,
    each final lon=lon,
    each final alt=alt,
    each final timZon=timZon,
    each final groRef=0.2,
    each final use_ParametersGlaz=false)
    annotation (Placement(transformation(extent={{-32,-30},{26,28}})));
  Modelica.Blocks.Math.Sum sumOfPower(nin=numGenUnits,
    y(unit="W"),
    u(each unit="W"))                 "Sums up DC Output power" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={50,20})));

  BESMod.Utilities.Electrical.RealToElecCon realToElecCon(use_souLoa=false)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={50,58})));

  BESMod.Utilities.KPIs.EnergyKPICalculator intKPICalPElePV(use_inpCon=true)
    annotation (Placement(transformation(extent={{60,-60},{80,-40}})));
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
  connect(sumOfPower.y, intKPICalPElePV.u) annotation (Line(points={{50,31},{50,
          38},{68,38},{68,-34},{46,-34},{46,-50},{58.2,-50}}, color={0,0,127}));
  connect(intKPICalPElePV.KPI, outBusGen.PElePV) annotation (Line(points={{82.2,
          -50},{96,-50},{96,-99},{1.77636e-15,-99}}, color={135,135,135}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
   annotation(Dialog(group="Design - Bottom Up: Parameters are defined by the subsystem"),
              Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PVSystemMultiSub;
