within BESMod.Systems.Demand.Building.Components.BaseClasses;
partial model PartialAixLibHighOrder
    extends BESMod.Utilities.Icons.BuildingIcon;
    extends
    BESMod.Systems.Demand.Building.Components.BaseClasses.HighOrderModelParameters;

  parameter Integer nZones(min=1) "Number of zones /rooms";
  parameter Boolean use_ventilation=true "=false to disable ventilation supply";

  replaceable package MediumZone = IBPSA.Media.Air constrainedby
    Modelica.Media.Interfaces.PartialMedium annotation (choices(
        choice(redeclare package Medium = IBPSA.Media.Air "Moist air"),
        choice(redeclare package Medium = IBPSA.Media.Water "Water"),
        choice(redeclare package Medium =
            IBPSA.Media.Antifreeze.PropyleneGlycolWater (
              property_T=293.15,
              X_a=0.40)
              "Propylene glycol water, 40% mass fraction")));

  AixLib.Utilities.Interfaces.ConvRadComb heatingToRooms1[nZones]
    annotation (Placement(transformation(extent={{-108,-10},{-88,10}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a groundTemp
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));
  Modelica.Fluid.Interfaces.FluidPort_a portVent_in[nZones](redeclare final
      package Medium = MediumZone)
                           if use_ventilation
    "Inlet for the demand of ventilation"
    annotation (Placement(transformation(extent={{90,-76},{110,-56}}),
        iconTransformation(extent={{90,-74},{110,-54}})));
  Modelica.Fluid.Interfaces.FluidPort_b portVent_out[nZones](redeclare final
      package Medium = MediumZone)
                           if use_ventilation
    "Outlet of the demand of Ventilation"
    annotation (Placement(transformation(extent={{90,-102},{110,-82}}),
        iconTransformation(extent={{90,-98},{110,-78}})));
  AixLib.Utilities.Interfaces.SolarRad_in West
    annotation (Placement(transformation(extent={{118,-48},{98,-28}})));
  AixLib.Utilities.Interfaces.SolarRad_in South
    annotation (Placement(transformation(extent={{118,-22},{98,-2}})));
  AixLib.Utilities.Interfaces.SolarRad_in East
    annotation (Placement(transformation(extent={{118,4},{98,24}})));
  AixLib.Utilities.Interfaces.SolarRad_in North
    annotation (Placement(transformation(extent={{118,30},{98,50}})));
  AixLib.Utilities.Interfaces.SolarRad_in SolarRadiationPort_RoofS
    annotation (Placement(transformation(extent={{118,54},{98,74}})));
  AixLib.Utilities.Interfaces.SolarRad_in SolarRadiationPort_RoofN
    annotation (Placement(transformation(extent={{118,80},{98,100}})));
  Modelica.Blocks.Interfaces.RealInput WindSpeedPort
    annotation (Placement(transformation(extent={{-126,42},{-86,82}})));
  Modelica.Blocks.Interfaces.RealInput AirExchangePort[nZones]
    annotation (Placement(transformation(extent={{-126,14},{-86,54}})));
  Modelica.Blocks.Interfaces.RealOutput TZoneMea[nZones](each final unit="K", each final displayUnit="degC") annotation (Placement(
        transformation(extent={{-86,-76},{-132,-30}}), iconTransformation(
          extent={{-84,-70},{-124,-30}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temperatureSensor[
    nZones] annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
equation
  connect(temperatureSensor.port, heatingToRooms1.conv)
    annotation (Line(points={{-80,0},{-88,0},{-88,0.05},{-97.95,0.05}},
                                               color={191,0,0}));
  connect(temperatureSensor.T, TZoneMea) annotation (Line(points={{-59,0},{-56,0},
          {-56,-53},{-109,-53}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialAixLibHighOrder;
