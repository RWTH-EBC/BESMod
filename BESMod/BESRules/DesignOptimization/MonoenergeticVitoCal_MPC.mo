within BESMod.BESRules.DesignOptimization;
model MonoenergeticVitoCal_MPC
  extends MonoenergeticVitoCal(
    hydraulic(control(
        supCtrlTypTheVal=BESMod.Utilities.SupervisoryControl.Types.SupervisoryControlType.External,
        pumGenAlwOn=true,
        supCtrHeaCurTyp=BESMod.Utilities.SupervisoryControl.Types.SupervisoryControlType.External,
        supCtrDHWTyp=BESMod.Utilities.SupervisoryControl.Types.SupervisoryControlType.External,
        buiAndDHWCtr(supCtrHeaCur(actExt(final y=actExtBufCtrl), uExt(final y=
                  TBufSet)), supCtrDHW(uExt(final y=TDHWSet), actExt(final y=
                  actExtDHWCtrl))),
        supCtrlTheVal(uExt(y=yValSet), actExt(y=actExtVal)))));
  extends BESMod.BESRules.BaseClasses.MPC_API;

end MonoenergeticVitoCal_MPC;
