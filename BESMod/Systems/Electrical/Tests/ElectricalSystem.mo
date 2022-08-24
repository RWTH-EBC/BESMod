within BESMod.Systems.Electrical.Tests;
model ElectricalSystem
  extends Modelica.Icons.Example;
  BESMod.Systems.Electrical.ElectricalSystem
    pVBatterySystemNoTransfer(
    use_elecHeating=false,
    redeclare
      BESMod.Systems.Electrical.RecordsCollection.ElectricalSystemBaseDataDefinition
      electricalSystemParameters(
      nZones=1,
      Q_flow_nominal={0},
      TOda_nominal=261.15,
      TSup_nominal={293.15},
      TZone_nominal={293.15},
      TAmb=293.15,
      AZone={0},
      hZone={0},
      ABui=0,
      hBui=0,
      ARoo=0),
    redeclare Transfer.NoElectricalTransfer transfer,
    redeclare Distribution.BatterySystemSimple distribution(redeclare
        BuildingSystems.Technologies.ElectricalStorages.Data.LithiumIon.LithiumIonTeslaPowerwall1
        batteryParameters),
    redeclare Generation.PVSystemMultiSub generation(
      redeclare model CellTemperature =
          AixLib.Electrical.PVSystem.BaseClasses.CellTemperatureMountingContactToGround,
      redeclare AixLib.DataBase.SolarElectric.SchuecoSPV170SME1 pVParameters,
      lat=weaDat.lat,
      lon=weaDat.lon,
      alt=weaDat.alt,
      timZon=3600,
      ARoof=50),
    nLoadsExtSubSys=1,
    redeclare Control.NoControl control)
    annotation (Placement(transformation(extent={{-40,-34},{52,42}})));

  Modelica.Blocks.Sources.Sine LoadFromResidualBES(
    amplitude=3000,
    f=1/86400,
    offset=3000)
    annotation (Placement(transformation(extent={{-98,24},{-78,44}})));
  BESMod.Utilities.Electrical.RealToElecCon realToElecCon(use_souGen=false)
    annotation (Placement(transformation(extent={{-70,24},{-50,44}})));
  IBPSA.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
        ModelicaServices.ExternalReferences.loadResource(
        "modelica://BESMod/Resources/TRY2015_522361130393_Jahr_City_Potsdam.mos"))
    annotation (Placement(transformation(extent={{-100,68},{-72,96}})));
  BESMod.Utilities.Electrical.ElecConToReal elecConToReal(reverse=true)
    annotation (Placement(transformation(extent={{64,-12},{88,14}})));
  Modelica.Blocks.Interfaces.RealOutput PElecFromGrid "Electrical power"
    annotation (Placement(transformation(extent={{100,-8},{120,12}})));
equation
  connect(LoadFromResidualBES.y, realToElecCon.PEleLoa)
    annotation (Line(points={{-77,34},{-74,34},{-74,38},{-72,38}},
                                                   color={0,0,127}));
  connect(weaDat.weaBus, pVBatterySystemNoTransfer.weaBus) annotation (Line(
      points={{-72,82},{-64,82},{-64,84},{-56,84},{-56,16.2143},{-40,16.2143}},
      color={255,204,51},
      thickness=0.5));

  connect(pVBatterySystemNoTransfer.externalElectricalPin1, elecConToReal.internalElectricalPin)
    annotation (Line(
      points={{52.5412,28.4286},{60,28.4286},{60,6},{58,6},{58,1.26},{64.24,
          1.26}},
      color={0,0,0},
      thickness=1));
  connect(elecConToReal.PElecLoa, PElecFromGrid)
    annotation (Line(points={{90.4,6.2},{96,6.2},{96,2},{110,2}},
                                                             color={0,0,127}));
  connect(realToElecCon.internalElectricalPin, pVBatterySystemNoTransfer.internalElectricalPin[
    1]) annotation (Line(
      points={{-49.8,34.2},{-43.9,34.2},{-43.9,27.8857},{-40,27.8857}},
      color={0,0,0},
      thickness=1));
  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(graphics,
        coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=86400,
      Interval=900,
      __Dymola_Algorithm="Dassl"),
    __Dymola_experimentSetupOutput,
    __Dymola_experimentFlags(
      Advanced(
        EvaluateAlsoTop=true,
        GenerateVariableDependencies=false,
        OutputModelicaCode=false),
      Evaluate=true,
      OutputCPUtime=false,
      OutputFlatModelica=false));
end ElectricalSystem;
