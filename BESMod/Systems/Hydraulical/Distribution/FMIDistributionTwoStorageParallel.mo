within BESMod.Systems.Hydraulical.Distribution;
model FMIDistributionTwoStorageParallel
  extends FMIReplaceableDistribution(
    use_p_in_Gen=true,
    use_p_in_Bui=true,
    use_p_in_DHW=true,
    allowFlowReversal=false,
    redeclare replaceable package MediumGen = IBPSA.Media.Water,
    redeclare replaceable package MediumDHW = IBPSA.Media.Water,
    redeclare replaceable package Medium = IBPSA.Media.Water,
    redeclare Systems.Hydraulical.Distribution.DistributionTwoStorageParallel
        distribution(
      energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
      Q_flow_nominal={12758.897931531694},
      TOda_nominal(displayUnit="K") = 265.35,
      TDem_nominal(displayUnit="K") = {328.15},
      TAmb(displayUnit="K") = 293.15,
      mDHW_flow_nominal=0.1,
      QDHW_flow_nominal=16736.0,
      TDHW_nominal(displayUnit="K") = 323.15,
      VDHWDay=0.123417,
      TDHWCold_nominal(displayUnit="K") = 283.15,
      designType=BESMod.Systems.Hydraulical.Distribution.Types.DHWDesignType.FullStorage,
      tCrit(displayUnit="s") = 3600.0,
      QCrit=2.24,
      mSup_flow_nominal={0.3243419773756343},
      mDem_flow_nominal={0.25412081603592446},
      redeclare
          BESMod.Systems.Hydraulical.Distribution.RecordsCollection.SimpleStorage.DefaultStorage
          bufParameters(dTLoadingHC1=0),
        redeclare
          BESMod.Systems.Hydraulical.Distribution.RecordsCollection.SimpleStorage.DefaultStorage
          dhwParameters(dTLoadingHC1=10),
        redeclare BESMod.Systems.RecordsCollection.Valves.DefaultThreeWayValve
          threeWayValveParameters));
end FMIDistributionTwoStorageParallel;
