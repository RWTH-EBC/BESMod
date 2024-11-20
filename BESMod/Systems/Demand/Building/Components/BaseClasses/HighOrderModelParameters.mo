within BESMod.Systems.Demand.Building.Components.BaseClasses;
partial model HighOrderModelParameters
  "Model with parameters for high order model of AixLib"

  extends AixLib.ThermalZones.HighOrder.Rooms.BaseClasses.PartialRoomParams(
      redeclare replaceable parameter
      AixLib.DataBase.Walls.Collections.OFD.BaseDataMultiInnerWalls wallTypes,
    n50=if TIR == 1 or TIR == 2 then 3 else if TIR == 3 then 4 else 6);

  parameter Integer TIR=1 "Thermal Insulation Regulation" annotation (Dialog(
      group="Construction parameters",
      compact=true,
      descriptionLabel=true), choices(
      choice=1 "EnEV_2009",
      choice=2 "EnEV_2002",
      choice=3 "WSchV_1995",
      choice=4 "WSchV_1984",
      radioButtons=true));
  parameter Modelica.Units.SI.CoefficientOfHeatTransfer UValOutDoors=if TIR == 1 then 1.8 else 2.9
    "Thermal transmission coefficient of door";
  parameter Modelica.Units.SI.Emissivity eps_door=0.9
    "Solar emissivity of door material";
  // Dynamics
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Type of energy balance for wall capacities: dynamic (3 initialization options) or steady state" annotation (Dialog(tab="Dynamics"));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
  annotation (Documentation(info="<html>
<p>
This is a partial model containing parameters for high order building models from AixLib. 
It includes parameters for different building thermal insulation regulations (TIR).
</p>

<h4>Important Parameters</h4>
<ul>
<li><code>TIR</code>: Thermal Insulation Regulation level (1=EnEV_2009, 2=EnEV_2002, 3=WSchV_1995, 4=WSchV_1984)</li>
<li><code>n50</code>: Air exchange rate at 50 Pa pressure difference (1/h). Values depend on TIR:
  <ul>
    <li>3.0 1/h for EnEV_2009 and EnEV_2002 </li>
    <li>4.0 1/h for WSchV_1995</li>
    <li>6.0 1/h for WSchV_1984</li>
  </ul>
</li>
<li><code>UValOutDoors</code>: Thermal transmission coefficient of door [W/(m²·K)]
  <ul>
    <li>1.8 W/(m²·K) for EnEV_2009</li>
    <li>2.9 W/(m²·K) for other regulations</li>
  </ul>
</li>
</ul>
</html>"));
end HighOrderModelParameters;
