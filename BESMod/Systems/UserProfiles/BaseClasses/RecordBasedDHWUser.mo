within BESMod.Systems.UserProfiles.BaseClasses;
partial model RecordBasedDHWUser "Model for DHW-records and nominal, constant set-point temperature as a user"
  extends PartialUserProfiles(VolDHWDay=if use_dhwCalc then V_dhwCalc_day else
        DHWProfile.V_dhw_day, mDHW_flow_nominal=DHWProfile.m_flow_nominal);

  replaceable parameter Systems.Demand.DHW.RecordsCollection.PartialDHWTap
    DHWProfile annotation (choicesAllMatching=true, Dialog(
      group="DHW",
      enable=not use_dhwCalc and use_dhw));

  parameter Boolean use_dhwCalc=false "=true to use the tables in DHWCalc. Will slow down the simulation, but represents DHW tapping more in a more realistic way."     annotation (Dialog(group="DHW",  enable=use_dhw));
  parameter String tableName="DHWCalc" "Table name on file for DHWCalc"
    annotation (Dialog(group="DHW",  enable=use_dhwCalc and use_dhw));
  parameter String fileName=Modelica.Utilities.Files.loadResource(
      "modelica://BESMod/Resources/DHWCalc.txt")
    "File where matrix is stored for DHWCalc"
    annotation (Dialog(group="DHW",  enable=use_dhwCalc and use_dhw));
  parameter Modelica.Units.SI.Volume V_dhwCalc_day=0
    "Average daily tapping volume in DHWCalc table" annotation (Dialog(
      group="DHW",
      enable=use_dhwCalc));
  Modelica.Blocks.Sources.CombiTimeTable combiTimeTableDHWInput(
    final tableOnFile=use_dhwCalc,
    final table=DHWProfile.table,
    final tableName=tableName,
    final fileName=fileName,
    final columns=2:5,
    final smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    final extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic)
    "Read the input data from the given file. " annotation (Placement(visible=true,
        transformation(
        extent={{-14,-14},{14,14}},
        rotation=0,
        origin={46,86})));
  Modelica.Blocks.Sources.Constant const[nZones](k=
        TSetZone_nominal)                  "Profiles for internal gains"
    annotation (Placement(transformation(
        extent={{23,23},{-23,-23}},
        rotation=180,
        origin={-73,-57})));
equation
  connect(combiTimeTableDHWInput.y[4], useProBus.TDHWDemand) annotation (Line(
        points={{61.4,86},{115,86},{115,-1}},  color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(combiTimeTableDHWInput.y[2], useProBus.mDHWDemand_flow) annotation (
      Line(points={{61.4,86},{115,86},{115,-1}},                    color={0,0,
          127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(const.y, useProBus.TZoneSet) annotation (Line(points={{-47.7,-57},{115,
          -57},{115,-1}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(graphics,
        coordinateSystem(preserveAspectRatio=false)));
end RecordBasedDHWUser;
