within BESMod.Systems.Hydraulical.Control.Components.OnOffController;
model AlternativeBivalentOnOffController "Controlls an alternative bivalent heat pump system with storages"
  extends BaseClasses.PartialOnOffController;
  StorageHysteresis storageHysteresis(final bandwidth=hysteresis, final
      pre_y_start=true)
    annotation (Placement(transformation(extent={{-40,22},{0,62}})));
  Modelica.Blocks.Logical.GreaterEqualThreshold greaterEqualT_biv(threshold=
        T_biv) annotation (Placement(transformation(extent={{20,80},{40,100}})));
  parameter Modelica.Units.SI.Temperature T_biv=271.15 "Bivalent temperature";
  Modelica.Blocks.Logical.And greaterEqualT_biv1
    annotation (Placement(transformation(extent={{60,60},{80,80}})));
  Modelica.Blocks.Logical.And greaterEqualT_biv2
    annotation (Placement(transformation(extent={{60,-60},{80,-40}})));
  Modelica.Blocks.Logical.Not greaterEqualT_biv3 annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={50,-10})));
  parameter Real hysteresis=10 "Bandwidth around reference signal";
  Modelica.Blocks.Math.BooleanToReal
                             or3(final realTrue=1, final realFalse=0)
                                 annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={82,-80})));
equation
  connect(T_Set, storageHysteresis.T_set) annotation (Line(points={{0,-118},{
          -56,-118},{-56,58},{-44,58}},             color={0,0,127}));
  connect(T_Top, storageHysteresis.T_top) annotation (Line(points={{-120,60},{
          -74,60},{-74,42},{-44,42}},
                                    color={0,0,127}));
  connect(T_bot, storageHysteresis.T_bot) annotation (Line(points={{-120,-60},{
          -50,-60},{-50,26},{-44,26}},   color={0,0,127}));
  connect(T_oda, greaterEqualT_biv.u)
    annotation (Line(points={{0,120},{0,90},{18,90}}, color={0,0,127}));
  connect(HP_On, greaterEqualT_biv1.y) annotation (Line(points={{110,60},{96,60},
          {96,70},{81,70}}, color={255,0,255}));
  connect(greaterEqualT_biv.y, greaterEqualT_biv1.u1) annotation (Line(points={
          {41,90},{52,90},{52,70},{58,70}}, color={255,0,255}));
  connect(storageHysteresis.y, greaterEqualT_biv1.u2) annotation (Line(points={
          {2,42},{26.85,42},{26.85,62},{58,62}}, color={255,0,255}));
  connect(Auxilliar_Heater_On, greaterEqualT_biv2.y) annotation (Line(points={{
          110,-60},{96,-60},{96,-50},{81,-50}}, color={255,0,255}));
  connect(greaterEqualT_biv.y, greaterEqualT_biv3.u)
    annotation (Line(points={{41,90},{50,90},{50,2}}, color={255,0,255}));
  connect(greaterEqualT_biv3.y, greaterEqualT_biv2.u1)
    annotation (Line(points={{50,-21},{50,-50},{58,-50}}, color={255,0,255}));
  connect(storageHysteresis.y, greaterEqualT_biv2.u2) annotation (Line(points={
          {2,42},{28,42},{28,-58},{58,-58}}, color={255,0,255}));
  connect(Auxilliar_Heater_set, or3.y)
    annotation (Line(points={{110,-80},{88.6,-80}}, color={0,0,127}));
  connect(greaterEqualT_biv2.y, or3.u) annotation (Line(points={{81,-50},{82,
          -50},{82,-70},{74.8,-70},{74.8,-80}}, color={255,0,255}));
end AlternativeBivalentOnOffController;
