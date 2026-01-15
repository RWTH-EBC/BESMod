import numpy as np
from agentlib_mpc.models.casadi_model import CasadiModel, CasadiState


def storage_n_layer(
        casadi_model: CasadiModel,
        bes_parameters: dict,
        mGen_flow: float,
        mTra_flow: float,
        TTraRet: float,
        TGenSup: float
):
    # Get important parameters for model
    nLayer = casadi_model.config.nLayer
    VBuf = bes_parameters["hydraulic.distribution.parStoBuf.V"]
    TBufAmb = bes_parameters["hydraulic.distribution.parStoBuf.TAmb"]

    # model equations
    m_cp_layer = VBuf / nLayer * casadi_model.rho_water * casadi_model.cp_water
    m_flow_cp_gen = mGen_flow * casadi_model.cp_water
    m_flow_cp_tra = mTra_flow * casadi_model.cp_water
    delta_m_flow_cp = (mGen_flow - mTra_flow) * casadi_model.cp_water

    try:
        if "hydraulic.distribution.stoBuf.G_middle" in bes_parameters:
            G_mid_layer = bes_parameters["hydraulic.distribution.stoBuf.G_middle"] / nLayer
            G_top_bot_layer = G_mid_layer + bes_parameters["hydraulic.distribution.stoBuf.G_top_bottom"]
        else:
            h = bes_parameters["hydraulic.distribution.parStoBuf.h"]
            d = bes_parameters["hydraulic.distribution.parStoBuf.d"]
            hConIn = bes_parameters["hydraulic.distribution.parStoBuf.hConIn"]
            hConOut = bes_parameters["hydraulic.distribution.parStoBuf.hConOut"]
            sIns = bes_parameters["hydraulic.distribution.parStoBuf.sIns"]
            lambdaIns = bes_parameters["hydraulic.distribution.parStoBuf.lambda_ins"]
            G_mid_layer = (
                    (2 * np.pi * h) /
                    (
                            1 / (hConIn * d / 2) +
                            (1 / lambdaIns) *
                            np.log((d / 2 + sIns) / (d / 2)) +
                            (1 / (hConOut * (d / 2 + sIns)))
                    )
            ) / nLayer
            G_top_bot_layer = G_mid_layer + (d / 2) ** 2 * np.pi * lambdaIns / sIns
    except KeyError as err:
        raise KeyError(
            "This MPC model only support StorageSimple and StorageDetailed from AixLib, "
            "but the model parameters do not include the required keys for any of the two."
        ) from err

    def get_T(_casadi_model, _n):
        state = _casadi_model.get(f"T_TES_{_n}")
        if not isinstance(state, CasadiState):
            raise TypeError(f"State for layer {_n} is not a CasadiState but rather {type(state)}")
        return state

    Q_storage_loss = 0

    for n in range(1, nLayer + 1):
        if n == nLayer:
            # TOP LAYER
            Q_storage_loss_n = G_top_bot_layer * (casadi_model.get_T_layer(n) - TBufAmb)
            # Note: This is the same as:
            #   + m_flow_cp_gen * TGenSup - (m_flow_cp_gen - m_flow_cp_tra) * T_n - m_flow_cp_tra * T_n
            #  = m_flow_cp_gen * (TGenSup - T_n)
            casadi_model.get_T_layer(n).ode = (1 / m_cp_layer) * (
                    m_flow_cp_gen * (TGenSup - casadi_model.get_T_layer(n))
                    - Q_storage_loss_n
            )
        elif n == 1:
            # BOTTOM LAYER
            Q_storage_loss_n = G_top_bot_layer * (casadi_model.get_T_layer(n) - TBufAmb)
            casadi_model.get_T_layer(n).ode = (1 / m_cp_layer) * (
                    m_flow_cp_tra * TTraRet
                    + delta_m_flow_cp * casadi_model.get_T_layer(n + 1)
                    - m_flow_cp_gen * casadi_model.get_T_layer(n)
                    - Q_storage_loss_n
            )
        else:
            # MID LAYER
            Q_storage_loss_n = G_mid_layer * (casadi_model.get_T_layer(n) - TBufAmb)
            casadi_model.get_T_layer(n).ode = (1 / m_cp_layer) * (
                    delta_m_flow_cp * (casadi_model.get_T_layer(n + 1) - casadi_model.get_T_layer(n))
                    - Q_storage_loss_n
            )
        Q_storage_loss += Q_storage_loss_n
    return Q_storage_loss
