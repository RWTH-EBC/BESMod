within BESMod.Utilities.TimeConstantEstimation.UnderfloorHeating;
model ConstantSupply
  extends Partial(hydraulic(control(redeclare
          BESMod.Systems.Hydraulical.Control.Components.BuildingSupplyTemperatureSetpoints.Constant
          supTSet(TConSup=TConSup))));
  extends Modelica.Icons.Example;
  parameter Modelica.Units.SI.Temperature TConSup=45
    "Constant supply temperature" annotation (Evaluate=false);
end ConstantSupply;
