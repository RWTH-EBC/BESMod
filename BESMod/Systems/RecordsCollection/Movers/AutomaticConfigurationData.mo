within BESMod.Systems.RecordsCollection.Movers;
record AutomaticConfigurationData
  "Automatic configuration for BES Library"
  extends AixLib.Fluid.Movers.Data.Generic(
    final speed_nominal=1,
    final motorCooledByFluid=false,
    final pressure(V_flow={V_flowCurve[i] * m_flow_nominal / rho for i in 1:size(V_flowCurve, 1)},
                   dp={dpCurve[i] * dp_nominal for i in 1:size(dpCurve, 1)}));
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal
    "Nominal mass flow rate";
  parameter Modelica.Units.SI.PressureDifference dp_nominal
    "Nominal pressure difference";
  parameter Modelica.Units.SI.Density rho "Density of fluid in use";
   parameter Real V_flowCurve[:]={0,0.99,1,1.01,1.02}   "Relative V_flow curve to be used";
   parameter Real dpCurve[:]={1.02,1.01,1,0.99,0}     "Relative dp curve to be used";
  annotation (Documentation(info="<html>
<p>
This record extends <a href=\"modelica://AixLib.Fluid.Movers.Data.Generic\">AixLib.Fluid.Movers.Data.Generic</a> 
to automatically configure a pump/fan for the BES Library based on nominal operating points.
</p>

<h4>Important Parameters</h4>
<ul>
<li><code>m_flow_nominal</code>: Nominal mass flow rate [kg/s]</li>
<li><code>dp_nominal</code>: Nominal pressure difference [Pa]</li>
<li><code>rho</code>: Density of fluid in use [kg/m^3]</li>
<li><code>V_flowCurve</code>: Relative volume flow curve points around nominal point [-]</li>
<li><code>dpCurve</code>: Relative pressure difference curve points around nominal point [-]</li>
</ul>
</html>"));
end AutomaticConfigurationData;
