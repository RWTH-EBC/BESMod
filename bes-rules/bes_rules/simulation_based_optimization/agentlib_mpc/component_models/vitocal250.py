from agentlib_mpc.models.casadi_model import CasadiModel


def vitocal250_with_ideal_heater(
        casadi_model: CasadiModel,
        bes_parameters: dict,
        THeaPumSou: float,
        THeaPumSup: float,
        THeaPumIn: float,
        mHeaPum_flow: float
):
    # assumption stationary energy balance
    QHeaPum_flow_max = (3189231.4110641507 +
                        -32220.980830563 * THeaPumSou +
                        -1685.3455766577608 * THeaPumSup +
                        +10.644665614582552 * THeaPumSou * THeaPumSup +
                        +109.27161006239132 * THeaPumSou ** 2 +
                        -0.016922003609194197 * THeaPumSou ** 2 * THeaPumSup +
                        -0.12370531548537612 * THeaPumSou ** 3) * casadi_model.scalingFactor
    # one hydraulic circle (EB)
    QEleHea_flow = bes_parameters["hydraulic.generation.QSec_flow_nominal"] * casadi_model.yEleHeaSet
    QHeaPum_flow = mHeaPum_flow * casadi_model.cp_water * (THeaPumSup - THeaPumIn) - QEleHea_flow

    COP = (965.902231300392 +
           - 9.533246340114223 * THeaPumSou +
           - 1.029123761692837 * THeaPumSup +
           + 0.008767379505684366 * THeaPumSou * THeaPumSup +
           + 0.029481697344765898 * THeaPumSou ** 2 +
           - 1.899325852627404e-05 * THeaPumSou ** 2 * THeaPumSup +
           - 2.6599338912753304e-05 * THeaPumSou ** 3)
    PEleHeaPum = QHeaPum_flow / COP
    PEleEleHea = QEleHea_flow / bes_parameters["hydraulic.generation.parEleHea.eta"]
    return QHeaPum_flow_max, QHeaPum_flow, PEleHeaPum, PEleEleHea
