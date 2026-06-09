within BESMod.Examples.UFHSystems;
model TestNomialConstantSupply
  extends Utilities.TimeConstantEstimation.UnderfloorHeating.Partial(
    TOda_start=systemParameters.TOda_nominal,
    dTStepOda=0,
    dTStepSet=0,
    redeclare BESMod.Examples.UFHSystems.Haus43a_kfw40_iwu building(
        zoneParam={BESMod.Examples.UFHSystems.Haus43a_kfw40_iwu_DataBase.Haus43a_kfw40_iwu_SingleDwelling(
        useConstantACHrate=true,
          baseACH=0.5,
          AFloor=0)}),
    hydraulic(
    redeclare
        BESMod.Systems.Hydraulical.Transfer.UFHTransferSystemPressureBasedNormBased
        transfer(redeclare
          BESMod.Systems.Hydraulical.Transfer.RecordsCollection.DefaultUFHData_NormBased
          UFHParameters, dis=5), control(redeclare
          BESMod.Systems.Hydraulical.Control.Components.ThermostaticValveController.ConstantOpening
          valCtrl, redeclare
          BESMod.Systems.Hydraulical.Control.Components.BuildingSupplyTemperatureSetpoints.Constant
          supTSet(TConSup=TConSup))),
    weaDat(
      TDryBulSou=IBPSA.BoundaryConditions.Types.DataSource.Input,
      TDryBul=systemParameters.TOda_nominal,
      TBlaSkySou=IBPSA.BoundaryConditions.Types.DataSource.Parameter,
      winSpeSou=IBPSA.BoundaryConditions.Types.DataSource.Parameter));
  extends Modelica.Icons.Example;
  parameter Modelica.Units.SI.Temperature TConSup=35
    "Constant supply temperature" annotation (Evaluate=false);
end TestNomialConstantSupply;
