within BESMod.Examples.BAUSimStudy;
record BESParameters
  extends Systems.RecordsCollection.SystemParametersBaseDataDefinition(
    final use_dhw=true,
    final use_demand=true,
    final use_hydraulic=true,
    final V_dhw_day=if use_dhwCalc then V_dhwCalc_day else DHWProfile.V_dhw_day,
    final use_dhwCalc=false,
    redeclare final
      BESMod.Systems.Demand.DHW.RecordsCollection.ProfileM
      DHWProfile,
    final intGains_gain=1,
    final fileNameIntGains=Modelica.Utilities.Files.loadResource("modelica://BESMod/Resources/InternalGains.txt"),
    final filNamWea=Modelica.Utilities.Files.loadResource("modelica://BESMod/Resources/TRY2015_522361130393_Jahr_City_Potsdam.mos"),
    final TAmbVen=min(TSetZone_nominal),
    final TAmbHyd=min(TSetZone_nominal),
    final TDHWWaterCold=283.15,
    final TSetDHW=328.15,
    final TVenSup_nominal=TSetZone_nominal,
    final TSetZone_nominal=fill(293.15, nZones),
    final QDHW_flow_nomial=DHWProfile.m_flow_nominal*4184*(TSetDHW - TDHWWaterCold),
    final nZones=1,
    final use_ventilation=false);

end BESParameters;
