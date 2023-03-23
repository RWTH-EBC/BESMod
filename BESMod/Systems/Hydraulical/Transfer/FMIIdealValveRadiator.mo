within BESMod.Systems.Hydraulical.Transfer;
model FMIIdealValveRadiator
  extends FMIReplaceableTransfer(
    use_p_ref=true,
    use_p_in=true,
    redeclare replaceable package Medium = IBPSA.Media.Water,
    redeclare Systems.Hydraulical.Transfer.IdealValveRadiator transfer(
      nParallelDem=1,
        dTTra_nominal=fill(10, transfer.nParallelDem),
        f_design=fill(1.2, transfer.nParallelDem),
      Q_flow_nominal={10632.414942943078},
      TOda_nominal(displayUnit="K") = 265.35,
      TDem_nominal(displayUnit="K") = {293.15},
      TAmb(displayUnit="K") = 293.15,
      TTra_nominal(displayUnit="K") = {328.15},
      dpSup_nominal(displayUnit="Pa") = {0.0},
      AZone={185.9548},
      hZone={2.6},
      ABui=0.0,
      hBui=0.0,
        redeclare
          BESMod.Systems.Hydraulical.Transfer.RecordsCollection.RadiatorTransferData
          radParameters,
        redeclare BESMod.Systems.RecordsCollection.Movers.DefaultMover pumpData,
      reaPasThrOpe));
end FMIIdealValveRadiator;
