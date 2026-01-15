within BESMod.Systems.Hydraulical.Control.Components.BuildingSupplyTemperatureSetpoints.BaseClasses.Functions;
partial function PartialHeatingCurve "Partial function to define interfacesHeating curve based on Lämmle et al."
  input Modelica.Units.SI.Temperature TOda "Outdoor air temperature";
  input Modelica.Units.SI.Temperature THeaThr "Heating threshold temperature";
  input Modelica.Units.SI.Temperature TRoom "Room temperature";
  input Modelica.Units.SI.Temperature TSup_nominal "Nominal supply temperature";
  input Modelica.Units.SI.Temperature TRet_nominal "Nominal return temperature";
  input Modelica.Units.SI.Temperature TOda_nominal "Nominal outdoor air temperature";
  input Real nHeaTra "Heat transfer exponent";
  output Modelica.Units.SI.Temperature TSup "Supply temperature";

  annotation (Documentation(info="<html>
<p>The functions in this package are based on the equations provided in https://www.sciencedirect.com/science/article/pii/S0360544221032011?via&percnt;3Dihub</p>
</html>"));
end PartialHeatingCurve;
