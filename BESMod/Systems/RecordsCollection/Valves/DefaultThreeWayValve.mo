within BESMod.Systems.RecordsCollection.Valves;
record DefaultThreeWayValve
  extends ThreeWayValve(
    from_dp=true,
    y_start=1,
    valveAutho=0.5,
    init=Modelica.Blocks.Types.Init.InitialOutput,
    order=2,
    riseTime=120,
    use_inputFilter=false,
    tau=10,
    fraK=1,
    l={0.0001,0.0001},
    R=50,
    delta0=0.01,
    deltaM=0.02);
  annotation (Documentation(info="<html>
<p>
Default parameter settings for a three-way valve. 
This model uses flow characteristics based on valve authority and fixed 
parameters for initialization and dynamics.
</p>

<h4>Important Parameters</h4>
<ul>
  <li><code>valveAutho</code> = 0.5: Valve authority</li>
</ul>
</body>
</html>
</html>"));
end DefaultThreeWayValve;
