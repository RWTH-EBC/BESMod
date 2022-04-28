within BESMod.Systems.Hydraulical.Control.Components.OnOffController;
model ParallelBivalentControl
  "Parallel bivalent control"
  extends
    BESMod.Systems.Hydraulical.Control.Components.OnOffController.BaseClasses.PartialOnOffController;

  parameter Modelica.Units.SI.TemperatureDifference Hysteresis=10;
  parameter Modelica.Units.SI.Temperature TCutOff "Cut-off temperature";
  parameter Modelica.Units.SI.Temperature TBiv "Bivalence temperature";
  parameter Modelica.Units.SI.Temperature TOda_nominal "Nominal temperature ";
  parameter Modelica.Units.SI.Temperature TRoom "Room set temperature";
  parameter Modelica.Units.SI.HeatFlowRate QDem_flow_nominal;
  parameter Modelica.Units.SI.HeatFlowRate QHP_flow_cutOff;

  BESMod.Systems.Hydraulical.Control.Components.OnOffController.StorageHysteresis
    storageHysteresis(final bandwidth=Hysteresis, final pre_y_start=true)
    annotation (Placement(transformation(extent={{-58,18},{-18,58}})));

  Modelica.Blocks.Logical.GreaterEqualThreshold greaterEqualT_biv(threshold=
        TCutOff)
               annotation (Placement(transformation(extent={{12,54},{36,78}})));
  Modelica.Blocks.Logical.And and1
    annotation (Placement(transformation(extent={{60,46},{80,66}})));

protected
  parameter Real phiBiv = (TRoom - TBiv)/(TRoom - TOda_nominal) "Part load at bivalence temperature";
  parameter Real partLoadHeaPumAtCutOff(min=0, max=1)=QHP_flow_cutOff/QDem_flow_nominal "Percentage of nominal heat demand supplied by heat pump at cut-off temperature";

  Real partLoadAuxHea = min(1, (TRoom - T_oda) / (TRoom - TOda_nominal));

equation

  if T_oda < TCutOff then
    // Only auxilliar device is active
    Auxilliar_Heater_On = storageHysteresis.y;
    Auxilliar_Heater_set = partLoadAuxHea;
  elseif T_oda < TBiv then
    // Both devices are active
    Auxilliar_Heater_On = storageHysteresis.y;
    Auxilliar_Heater_set = max(0, partLoadAuxHea - (partLoadHeaPumAtCutOff  + (phiBiv - partLoadHeaPumAtCutOff)* (T_oda - TCutOff) / (TBiv - TCutOff)));
  else
    // Only heat pump is active
    Auxilliar_Heater_On = false;
    Auxilliar_Heater_set = 0;
  end if;

  connect(T_Top, storageHysteresis.T_top) annotation (Line(points={{-120,60},{-86,
          60},{-86,38},{-62,38}}, color={0,0,127}));
  connect(T_Set, storageHysteresis.T_set) annotation (Line(points={{0,-118},{0,
          -20},{-80,-20},{-80,54},{-62,54}},
                                        color={0,0,127}));
  connect(T_Top, storageHysteresis.T_bot) annotation (Line(points={{-120,60},{
          -92,60},{-92,22},{-62,22}}, color={0,0,127}));
  connect(greaterEqualT_biv.y, and1.u1) annotation (Line(points={{37.2,66},{42,66},
          {42,56},{58,56}}, color={255,0,255}));
  connect(storageHysteresis.y, and1.u2) annotation (Line(points={{-16,38},{42,38},
          {42,48},{58,48}}, color={255,0,255}));
  connect(and1.y, HP_On) annotation (Line(points={{81,56},{92,56},{92,60},{110,60}},
        color={255,0,255}));
  connect(T_oda, greaterEqualT_biv.u)
    annotation (Line(points={{0,120},{0,66},{9.6,66}}, color={0,0,127}));
  annotation (Icon(graphics={     Polygon(
            points={{-65,89},{-73,67},{-57,67},{-65,89}},
            lineColor={192,192,192},
            fillColor={192,192,192},
            fillPattern=FillPattern.Solid),Line(points={{-65,67},{-65,-81}},
          color={192,192,192}),Line(points={{-90,-70},{82,-70}}, color={192,
          192,192}),Polygon(
            points={{90,-70},{68,-62},{68,-78},{90,-70}},
            lineColor={192,192,192},
            fillColor={192,192,192},
            fillPattern=FillPattern.Solid),
                            Text(
            extent={{-65,93},{-12,75}},
            lineColor={160,160,164},
            textString="y"),Line(
            points={{-80,-70},{30,-70}},
            thickness=0.5),Line(
            points={{-50,10},{80,10}},
            thickness=0.5),Line(
            points={{-50,10},{-50,-70}},
            thickness=0.5),Line(
            points={{30,10},{30,-70}},
            thickness=0.5),Line(
            points={{-10,-65},{0,-70},{-10,-75}},
            thickness=0.5),Line(
            points={{-10,15},{-20,10},{-10,5}},
            thickness=0.5),Line(
            points={{-55,-20},{-50,-30},{-44,-20}},
            thickness=0.5),Line(
            points={{25,-30},{30,-19},{35,-30}},
            thickness=0.5),Text(
            extent={{-99,2},{-70,18}},
            lineColor={160,160,164},
            textString="true"),Text(
            extent={{-98,-87},{-66,-73}},
            lineColor={160,160,164},
            textString="false"),Text(
            extent={{19,-87},{44,-70}},
            lineColor={0,0,0},
            textString="uHigh"),Text(
            extent={{-63,-88},{-38,-71}},
            lineColor={0,0,0},
            textString="uLow"),Line(points={{-69,10},{-60,10}}, color={160,
          160,164})}), Diagram(graphics={Rectangle(
          extent={{100,-40},{20,-100}},
          lineColor={28,108,200},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid), Text(
          extent={{20,-50},{94,-84}},
          lineColor={28,108,200},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="Internal
(see equations)")}));
end ParallelBivalentControl;
