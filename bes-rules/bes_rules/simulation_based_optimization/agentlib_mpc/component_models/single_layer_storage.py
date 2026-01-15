from agentlib_mpc.models.casadi_model import CasadiModel


def storage_in_serial_connection(casadi_model: CasadiModel, bes_parameters: dict, mSto_flow: float):
    # no layers
    # assumption: buffer storage is only a inertia and no hydraulic switch => mdot_hp = mTra_flow
    TBufAmb = bes_parameters["hydraulic.distribution.parStoBuf.TAmb"]
    TBuf_nominal = bes_parameters["hydraulic.distribution.parStoBuf.T_m"]
    QBuf_loss_flow = bes_parameters["hydraulic.distribution.parStoBuf.QLoss_flow"]
    dTBuf_nominal = TBuf_nominal - TBufAmb
    UABuf = QBuf_loss_flow / dTBuf_nominal
    VBuf = bes_parameters["hydraulic.distribution.parStoBuf.V"]
    Q_storage_loss = UABuf * (casadi_model.TBufSet - TBufAmb)
    casadi_model.TBuf.ode = (1 / (VBuf * casadi_model.rho_water * casadi_model.cp_water)) * (
            Q_storage_loss + mSto_flow * casadi_model.cp_water * (casadi_model.TBufSet - casadi_model.TBuf)
    )
    return Q_storage_loss
