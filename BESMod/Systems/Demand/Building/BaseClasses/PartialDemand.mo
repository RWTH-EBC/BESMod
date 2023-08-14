within BESMod.Systems.Demand.Building.BaseClasses;
partial model PartialDemand "Partial demand model for HPS"
  extends BESMod.Utilities.Icons.BuildingIcon;
  parameter Boolean use_openModelica=false
    "=true to disable features which 
    are not available in open modelica" annotation(Dialog(tab="Advanced"));
  parameter Integer nZones(min=1) "Number of zones /rooms";
  parameter Modelica.Units.SI.Temperature TSetZone_nominal[nZones]=fill(293.15,
      nZones) "Nominal room set temerature"
    annotation (Dialog(group="Temperature demand"));
  parameter Modelica.Units.SI.Area AZone[nZones] "Area of zones/rooms"
    annotation (Dialog(group="Geometry"));
  parameter Modelica.Units.SI.Height hZone[nZones] "Height of zones"
    annotation (Dialog(group="Geometry"));
  parameter Modelica.Units.SI.Area ABui "Ground area of building"
    annotation (Dialog(group="Geometry"));
  parameter Modelica.Units.SI.Height hBui "Height of building"
    annotation (Dialog(group="Geometry"));
  parameter Modelica.Units.SI.Area ARoo "Roof area of building"
    annotation (Dialog(group="Geometry"));
  parameter Boolean use_hydraulic=true "=false to disable hydraulic supply";
  parameter Boolean use_ventilation=true "=false to disable ventilation supply";
  parameter Modelica.Units.SI.Temperature TOda_nominal "Nominal outdoor air temperature"
   annotation(Dialog(group="Design - Top Down: Parameters are given by the parent system"));

  replaceable package MediumZone = IBPSA.Media.Air constrainedby
    Modelica.Media.Interfaces.PartialMedium annotation (choices(
        choice(redeclare package Medium = IBPSA.Media.Air "Moist air"),
        choice(redeclare package Medium = IBPSA.Media.Water "Water"),
        choice(redeclare package Medium =
            IBPSA.Media.Antifreeze.PropyleneGlycolWater (
              property_T=293.15,
              X_a=0.40)
              "Propylene glycol water, 40% mass fraction")));
  BESMod.Systems.Interfaces.UseProBus useProBus annotation (
      Placement(transformation(extent={{24,82},{78,120}}), iconTransformation(
          extent={{44,88},{66,112}})));

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPortCon[nZones]
    "Heat port for convective heat transfer with room air temperature"
    annotation (Placement(transformation(extent={{-110,50},{-90,70}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPortRad[nZones]
    "Heat port for radiative heat transfer with room radiation temperature"
    annotation (Placement(transformation(extent={{-110,-70},{-90,-50}})));
  BESMod.Systems.Interfaces.DemandOutputs outBusDem if not use_openModelica
    annotation (Placement(transformation(extent={{88,-12},{108,8}})));
  Modelica.Fluid.Interfaces.FluidPort_a portVent_in[nZones](
      redeclare final package Medium = MediumZone)
                           if use_ventilation
    "Inlet for the demand of ventilation"
    annotation (Placement(transformation(extent={{90,28},{110,48}}),
        iconTransformation(extent={{90,28},{110,48}})));
  Modelica.Fluid.Interfaces.FluidPort_b portVent_out[nZones](
      redeclare final package Medium = MediumZone)
                           if use_ventilation
    "Outlet of the demand of Ventilation"
    annotation (Placement(transformation(extent={{90,-50},{110,-30}}),
        iconTransformation(extent={{90,-50},{110,-30}})));

  IBPSA.BoundaryConditions.WeatherData.Bus
      weaBus "Weather data bus" annotation (Placement(transformation(extent={{-68,76},
            {-26,120}}),         iconTransformation(extent={{-68,92},{-48,112}})));
  BESMod.Systems.Interfaces.BuiMeaBus buiMeaBus annotation (
      Placement(transformation(extent={{-20,78},{20,120}}), iconTransformation(
          extent={{-20,78},{20,120}})));
  Electrical.Interfaces.InternalElectricalPinOut internalElectricalPin
    annotation (Placement(transformation(extent={{60,-106},{80,-86}})));
  parameter Modelica.Units.SI.Density rho=MediumZone.density(sta_nominal)
    "Density of medium / fluid in heat distribution system"
    annotation (Dialog(tab="Assumptions", group="General"));
  parameter Modelica.Units.SI.SpecificHeatCapacity cp=
      MediumZone.specificHeatCapacityCp(sta_nominal)
    "Specific heat capacaity of medium / fluid in heat distribution system"
    annotation (Dialog(tab="Assumptions", group="General"));

protected
  parameter MediumZone.ThermodynamicState sta_nominal=MediumZone.setState_pTX(
      T=MediumZone.T_default, p=MediumZone.p_default, X=MediumZone.X_default) "Nominal / default state of medium";
  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(graphics,
        coordinateSystem(preserveAspectRatio=false)));
end PartialDemand;
