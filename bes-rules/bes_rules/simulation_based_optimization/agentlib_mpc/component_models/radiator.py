import matplotlib.pyplot as plt
import numpy as np

from ebcpy import TimeSeriesData
from agentlib_mpc.models.casadi_model import CasadiModel
import casadi as ca

from bes_rules import STARTUP_BESMOD_MOS
from bes_rules.utils.function_fit import fit_linear_regression


def radiator_no_exponent_outlet_temperature(
        casadi_model: CasadiModel,
        TTraSup: float,
        mTra_flow: float,
        T_Air
):
    # assumption stationary energy balance
    # no delay by volume elements/thermal inertia
    # sim: simple radiator model (EN442-2), no delay between buffer storage and heater
    # from energy balance and heat transfer
    return T_Air + (TTraSup - T_Air) * ca.exp(-casadi_model.UA_heater / (mTra_flow * casadi_model.cp_water))


def radiator_Q_flow_given_exponent_outlet_temperature(
        casadi_model: CasadiModel,
        TTraSup: float,
        mTra_flow: float,
        Q_flow: float,
        T_Air
):
    n = casadi_model.n_heater_exp
    return T_Air + (TTraSup - T_Air) * ca.exp(
        - casadi_model.UA_heater ** (1 / n) * Q_flow ** (1 - 1 / n) /
        (mTra_flow * casadi_model.cp_water)
    )


def create_regression_for_opening():
    """
    Simulate BESMod.Examples.GasBoilerBuildingOnly for e.g. 180 days first
    to generate data.

    Ideas:
    - Q_flow and TSup is given in optimization
    - Using the opening from simulation is not accurate, as TSup may be higher than the one in the simulation
    - if opening is fixed, TRet follows, but then hot water is fed into lower storage layer
    - if opening and TRet is free, various solutions exist --> opening must be a control variable.
    """
    y = "outputs.hydraulic.tra.opening[1]"
    Q_flow = "outputs.building.eneBal[1].traGain.value"
    TSup = "outputs.hydraulic.tra.TSup[1]"
    TRet = "outputs.hydraulic.tra.TRet[1]"
    TRoom = "outputs.building.TZone[1]"
    tsd = TimeSeriesData(STARTUP_BESMOD_MOS.parent.joinpath("working_dir", "GasBoilerBuildingOnly.mat"),
                         variable_names=[Q_flow, TSup, TRet, TRoom, y]).to_df().loc[86400 * 2:]

    delta_T_mean = (tsd.loc[:, TSup] + tsd.loc[:, TRet]) / 2 - tsd.loc[:, TRoom]
    dT_A = tsd.loc[:, TSup] - tsd.loc[:, TRoom]
    dT_B = tsd.loc[:, TRet] - tsd.loc[:, TRoom]
    delta_T_log = (dT_A - dT_B) / np.log(dT_A / dT_B)
    mask_nan = np.isnan(delta_T_log)
    plt.figure()
    plt.scatter(tsd.loc[:, Q_flow], tsd.loc[:, y])
    plt.xlabel("Q_flow")
    plt.ylabel("opening")
    plt.figure()
    plt.scatter(tsd.loc[:, Q_flow], tsd.loc[:, TSup])
    plt.xlabel("Q_flow")
    plt.ylabel("delta_T_log")
    # Theory is Q = opening * m_flow_nominal * cp * dT_log
    # So Q / dT_log should lead to linear regression
    nHeaTra = 1.3
    fit_linear_regression(
        variables=[tsd.loc[~mask_nan, Q_flow] / (delta_T_log.loc[~mask_nan] ** nHeaTra)],
        y=tsd.loc[~mask_nan, y]
    )


def understand_return_temperature_equation():
    """
    Simulate BESMod.Examples.GasBoilerBuildingOnly for e.g. 30 days
    with protected outputs to generate data and set n=1.001
    """
    y = "outputs.hydraulic.tra.opening[1]"
    Q_flow = "outputs.building.eneBal[1].traGain.value"
    TSup = "outputs.hydraulic.tra.TSup[1]"
    TRet = "outputs.hydraulic.tra.TRet[1]"
    TRet = "hydraulic.transfer.rad[1].vol[5].T"
    TRoom = "outputs.building.TZone[1]"
    UA = "hydraulic.transfer.rad[1].UAEle"
    m_flow_nominal = "hydraulic.transfer.m_flow_nominal[1]"
    m_flow = "hydraulic.transfer.portTra_in[1].m_flow"
    variable_names = [Q_flow, TSup, TRet, TRoom, y, UA, m_flow_nominal, m_flow]
    tsd = TimeSeriesData(
        STARTUP_BESMOD_MOS.parent.joinpath("working_dir", "GasBoilerBuildingOnly.mat"),
        variable_names=variable_names
    ).to_df().loc[86400 * 2:]

    y = tsd.loc[:, y].values
    Q_flow = tsd.loc[:, Q_flow].values
    TSup = tsd.loc[:, TSup].values
    TRet = tsd.loc[:, TRet].values
    TRoom = tsd.loc[:, TRoom].values
    UA = tsd.loc[:, UA].values * 5
    m_flow = tsd.loc[:, m_flow].values
    # m_flow = tsd.loc[:, m_flow_nominal].values * y
    cp_water = 4184
    TTraRet_equation = TRoom + (TSup - TRoom) * np.exp(- UA / (m_flow * cp_water))
    TTraRet_chen = get_T_return_chen_and_underwood(
        TAir=TRoom, TSup=TSup, UA_Nom=UA, nHea=1.001, Q_flow=Q_flow
    )
    QTra_flow_equation = m_flow * cp_water * (TSup - TTraRet_equation)
    QTra_flow_chen = m_flow * cp_water * (TSup - TTraRet_chen)

    UA_equ = m_flow * cp_water * np.log(
        (TSup - TRoom) /
        (TRet - TRoom)
    )
    fig, ax = plt.subplots(4, 1, sharex=True)
    ax[0].plot(tsd.index, TSup, label="Supply")
    ax[0].plot(tsd.index, TRet, label="Ret-Real")
    ax[0].plot(tsd.index, TTraRet_equation, label="Ret-Equ")
    ax[0].plot(tsd.index, TTraRet_chen, label="Ret-chen", linestyle="--")
    ax[0].set_ylabel("T")
    ax[1].plot(tsd.index, y)
    ax[1].set_ylabel("opening")
    ax[2].plot(tsd.index, Q_flow, label="Q-Real")
    ax[2].plot(tsd.index, QTra_flow_equation, label="Q-Equ")
    ax[2].plot(tsd.index, QTra_flow_chen, label="Q-chen", linestyle="--")
    ax[2].legend()
    ax[2].set_ylabel("Q_flow")
    ax[3].plot(tsd.index, UA_equ, label="Equ")
    ax[3].plot(tsd.index, UA, label="Real")
    ax[3].legend()
    ax[3].set_ylabel("UA")
    ax[-1].set_xlabel("Time")
    ax[0].legend()
    plt.show()


def get_T_return_chen_and_underwood(
        TAir: float,
        nHea: float,
        TSup: float,
        Q_flow: float,
        UA_Nom: float
):
    """
    Based on: https://www.sciencedirect.com/science/article/pii/0009250987801288
    """
    n_chen = 0.3275
    dTSup = (TSup - TAir)
    dTRet = (2 * (Q_flow / UA_Nom) ** (n_chen / nHea) - dTSup ** n_chen) ** (1 / n_chen)
    return dTRet + TAir

def get_mass_flow_psi(
    Q_dot: float,
    T_supply: float,
    T_supply_design: float,
    T_return_design: float,
    T_room: int,
    radiator_properties,
    rad_area: str,
    num_rad: int,
    general_properties:dict,
    des_massflow: float,
    Q_dot_design: float
):
    """
    Function to calculate the return temperature and mass flow rate for a given heat demand and supply temperature.
    Args:
        Q_dot: heat demand in W
        T_supply: supply temperature in °C
        T_room: room temperature in °C
        radiator_properties: properties of the radiator
        rad_area: area of the radiator in mm
        num_rad: number of radiators
    Returns:
        T_ret: return temperature in °C
        mass_flow_rate: mass flow rate in kg/s
    """

    # Extract dimensions
    width = int(rad_area.split("x")[0])  # in mm
    height = int(rad_area.split("x")[1])  # in mm

    # Radiator coefficients
    n = radiator_properties[f"n_{height}"][0]
    KA = (radiator_properties[f"Km_{height}"][0] * width / 1000)  # convert width to meters

    # Specific heat capacity (in J/kg·K)
    cp = next(item["value"] * 1000 for item in general_properties if item["name"] == "c_p_water")

    # Check if Q_dot is positive and temperatures are valid
    if Q_dot <= 0:
        raise ValueError("Heat demand Q_dot must be positive.")

    if T_supply <= T_room:
        raise ValueError("Supply temperature must be greater than room temperature.")

    # Define function for root-finding
    def residual(T_ret):
        if T_ret <= T_room or T_ret >= T_supply:
            return np.inf  # Return large value for invalid T_ret

        try:
            # Calculate logarithmic mean temperature difference
            delta_T_log = (T_supply - T_ret) / np.log((T_supply - T_room) / (T_ret - T_room))

            # The equation to solve: Km * A * delta_T_log = Q_dot
            return KA * delta_T_log - Q_dot/ num_rad  # divide by num_rad to get per radiator
        except (ZeroDivisionError, ValueError):
            return np.inf  # Return large value for invalid calculations

    # Find appropriate bracket by testing values
    # Start with a more conservative bracket
    T_ret_min = T_room + 1.0  # Minimum return temperature
    T_ret_max = T_supply - 1.0  # Maximum return temperature

    # Check if the bracket is valid
    if T_ret_max <= T_ret_min:
        # If temperature difference is too small, use a smaller margin
        T_ret_min = T_room + 0.1
        T_ret_max = T_supply - 0.1

        if T_ret_max <= T_ret_min:
            raise ValueError(f"Temperature difference too small: T_supply={T_supply}, T_room={T_room}")

    # Test the residual at the bounds
    res_min = residual(T_ret_min)
    res_max = residual(T_ret_max)

    # If residuals have the same sign, try to find a better bracket
    if res_min * res_max > 0:
        # Try to find a bracket by sampling points
        T_test_points = np.linspace(T_ret_min, T_ret_max, 20)
        found_bracket = False

        for i in range(len(T_test_points) - 1):
            res_a = residual(T_test_points[i])
            res_b = residual(T_test_points[i + 1])

            if res_a * res_b < 0 and np.isfinite(res_a) and np.isfinite(res_b):
                T_ret_min = T_test_points[i]
                T_ret_max = T_test_points[i + 1]
                found_bracket = True
                break

        if not found_bracket:
            raise ValueError(f"Could not find valid bracket for root finding. Q_dot={Q_dot}, T_supply={T_supply}, T_room={T_room}")

    # Root finding within the found bracket
    try:
        result = root_scalar(
            residual,
            bracket=[T_ret_min, T_ret_max],
            method='brentq'
        )
    except ValueError as e:
        raise ValueError(f"Root finding failed: {e}. Q_dot={Q_dot}, T_supply={T_supply}, T_room={T_room}")

    if not result.converged:
        raise ValueError("Root-finding for T_return did not converge.")

    T_ret = result.root
    delta_T = T_supply - T_ret

    if delta_T <= 0:
        raise ValueError("Invalid temperature difference: T_supply must be > T_return.")

    mass_flow_rate = Q_dot / (cp * delta_T)

    if mass_flow_rate < 0:
        raise ValueError("Invalid mass flow rate: it cannot be negative.")

    if mass_flow_rate > des_massflow:
        raise ValueError("Invalid mass flow rate: it cannot be greater than the design value.")

    return mass_flow_rate, T_ret



from scipy import optimize
import numpy as np
import matplotlib.pyplot as plt
from matplotlib.colors import LinearSegmentedColormap
from mpl_toolkits.axes_grid1 import make_axes_locatable

def solve_radiator_equations(T_Air, TTraSup, n, Q_flow, cp_water, UA_heater, mTra_flow_nominal, tol=1e-6):
    """
    Solves the radiator equation system for TRet and mTra_flow.

    # Known inputs: T_Air, TTraSup, n, Q_flow, cp_water, UA_Heater
    TRet = T_Air + (TTraSup - T_Air) * np.exp(
            - UA_heater ** (1 / n) * Q_flow ** (1 - 1 / n) /
            (mTra_flow * cp_water)
        )
    mTra_flow = Q_flow / cp_water / (TTraSup - TRet)

    Parameters:
    -----------
    T_Air : float
        Air temperature [°C]
    TTraSup : float
        Supply temperature [°C], must be > T_Air
    n : float
        Radiator exponent
    Q_flow : float
        Heat flow [W], must be > 0
    cp_water : float
        Specific heat capacity of water [J/(kg·K)]
    UA_heater : float
        Heat transfer coefficient × area [W/K]
    tol : float, optional
        Tolerance for convergence

    Returns:
    --------
    TRet : float
        Return temperature [°C]
    mTra_flow : float
        Mass flow rate [kg/s]
    """
    # Validate inputs
    if Q_flow <= 0:
        raise ValueError("Q_flow must be greater than 0")

    if T_Air >= TTraSup:
        raise ValueError("TTraSup must be greater than T_Air")

    def equation_to_solve(TRet_value):
        # Calculate mTra_flow from the second equation
        valve = Q_flow / cp_water / (TTraSup - TRet_value) / mTra_flow_nominal
        mTra_flow_value = valve * mTra_flow_nominal
        # Calculate expected TRet using the first equation
        TRet_calculated = T_Air + (TTraSup - T_Air) * np.exp(
            -UA_heater ** (1 / n) * Q_flow ** (1 - 1 / n) / (mTra_flow_value * cp_water)
        )

        return TRet_value - TRet_calculated

    # Define bounds for TRet (must be between T_Air and TTraSup)
    # Add a small margin to avoid numerical issues at the boundaries
    lower_bound = T_Air + tol
    upper_bound = TTraSup - tol
    # Evaluate function at boundaries
    f_lower = equation_to_solve(lower_bound)
    f_upper = equation_to_solve(upper_bound)
    try:
        # Use scipy's root-finding algorithm to solve the equation
        TRet = optimize.brentq(equation_to_solve, lower_bound, upper_bound, rtol=tol)

        # Calculate mTra_flow from the second equation
        mTra_flow = Q_flow / cp_water / (TTraSup - TRet)

        return TRet, mTra_flow / mTra_flow_nominal, mTra_flow

    except (ValueError, RuntimeError) as e:
        raise ValueError(f"Failed to find a valid solution between {lower_bound} and {upper_bound}: {e}")


def plot_radiator_performance(TOda_nominal=-12 + 273.15, T_max=291.15,
                              n_temp_points=50, n_load_points=50):
    """
    Creates a plot showing TRet and mTra_flow as a function of outdoor temperature and load fraction.

    Parameters:
    -----------
    solve_function : function
        The function to solve the radiator equations
    TOda_nominal : float
        Minimum outdoor temperature [K]
    T_max : float
        Maximum outdoor temperature [K]
    n_temp_points : int
        Number of outdoor temperature points
    n_load_points : int
        Number of load fraction points

    Returns:
    --------
    fig : matplotlib.figure.Figure
        The created figure
    """

    Q_nom = 10000
    dT_nom = 15
    T_supply_nom = 75 + 273.15

    # Fixed parameters
    T_Air = 293.15  # Indoor air temperature [K]
    n = 1.24  # Radiator exponent
    cp_water = 4184  # Specific heat capacity of water [J/(kg·K)]
    dT_log_nom = dT_nom / np.log((T_supply_nom - T_Air) / (T_supply_nom - dT_nom - T_Air))
    UA_heater = Q_nom / (dT_log_nom ** 1.24)  # Heat transfer coefficient × area [W/K]
    mTra_flow_nominal = Q_nom / cp_water / dT_nom

    # Create temperature and load fraction arrays
    T_outdoor = np.linspace(TOda_nominal, T_max, n_temp_points)
    load_fractions = np.linspace(0.01, 1.0,
                                 n_load_points)  # Starting from small non-zero value to avoid division by zero

    # Initialize arrays to store results
    TRet_results = np.zeros((n_temp_points, n_load_points))
    valve_results = np.zeros((n_temp_points, n_load_points))
    mTra_flow_results = np.zeros((n_temp_points, n_load_points))

    # Define supply temperature as a function of outdoor temperature
    # Linear interpolation between maximum supply temp at min outdoor temp
    # and minimum supply temp at max outdoor temp
    min_supply_temp = 303.15  # 30°C at warmest outdoor temperature

    def get_TTraSup(T_out):
        return T_supply_nom + (min_supply_temp - T_supply_nom) * (T_out - TOda_nominal) / (T_Air - TOda_nominal)

    # Define maximum heat flow as a function of outdoor temperature
    # Linear decrease with increasing outdoor temperature
    max_Q_flow_min_temp = 10000  # Maximum heat flow at minimum outdoor temperature [W]

    def get_max_Q_flow(T_out):
        return max_Q_flow_min_temp - max_Q_flow_min_temp * (T_out - TOda_nominal) / (T_Air - TOda_nominal)

    # Calculate TRet, valve opening, and mTra_flow for each combination of outdoor temperature and load fraction
    for i, T_out in enumerate(T_outdoor):
        TTraSup = get_TTraSup(T_out)
        max_Q_flow = get_max_Q_flow(T_out)

        for j, fraction in enumerate(load_fractions):
            Q_flow = fraction * max_Q_flow

            try:
                TRet, valve, mTra_flow = solve_radiator_equations(
                    T_Air=T_Air,
                    TTraSup=TTraSup,
                    n=n,
                    Q_flow=Q_flow,
                    cp_water=cp_water,
                    UA_heater=UA_heater,
                    mTra_flow_nominal=mTra_flow_nominal,
                )
                TRet_results[i, j] = TRet
                valve_results[i, j] = valve
                mTra_flow_results[i, j] = mTra_flow
            except Exception as e:
                print(f"Error at T_out={T_out - 273.15}°C, load={fraction}: {e}")
                TRet_results[i, j] = np.nan
                valve_results[i, j] = np.nan
                mTra_flow_results[i, j] = np.nan
    # Create figure with three subplots
    fig, axes = plt.subplots(1, 3, figsize=(20, 8), sharey=True)

    # Set up meshgrid for plotting
    X, Y = np.meshgrid(T_outdoor - 273.15, load_fractions)  # Convert to Celsius for display

    # Custom colormap
    custom_cmap = plt.cm.get_cmap('coolwarm')

    # Plot Return Temperature
    im1 = axes[0].pcolormesh(X, Y, TRet_results.T - 273.15, cmap=custom_cmap)
    axes[0].set_title('Return Temperature [°C]')
    axes[0].set_xlabel('Outdoor Temperature [°C]')
    axes[0].set_ylabel('Load Fraction')
    divider = make_axes_locatable(axes[0])
    cax1 = divider.append_axes("right", size="5%", pad=0.1)
    plt.colorbar(im1, cax=cax1)

    # Plot Valve Opening
    im2 = axes[1].pcolormesh(X, Y, valve_results.T, cmap='viridis')
    axes[1].set_title('Valve Opening [0-1]')
    axes[1].set_xlabel('Outdoor Temperature [°C]')
    divider = make_axes_locatable(axes[1])
    cax2 = divider.append_axes("right", size="5%", pad=0.1)
    plt.colorbar(im2, cax=cax2)

    # Plot Mass Flow Rate
    im3 = axes[2].pcolormesh(X, Y, mTra_flow_results.T * 1000, cmap='plasma')  # Convert to g/s for display
    axes[2].set_title('Mass Flow Rate [g/s]')
    axes[2].set_xlabel('Outdoor Temperature [°C]')
    divider = make_axes_locatable(axes[2])
    cax3 = divider.append_axes("right", size="5%", pad=0.1)
    plt.colorbar(im3, cax=cax3)

    # Add contour lines to all plots
    CS1 = axes[0].contour(X, Y, TRet_results.T - 273.15, levels=10, colors='k', alpha=0.5, linewidths=0.8)
    axes[0].clabel(CS1, inline=True, fontsize=8, fmt='%.1f')

    CS2 = axes[1].contour(X, Y, valve_results.T, levels=10, colors='k', alpha=0.5, linewidths=0.8)
    axes[1].clabel(CS2, inline=True, fontsize=8, fmt='%.2f')

    CS3 = axes[2].contour(X, Y, mTra_flow_results.T * 1000, levels=10, colors='k', alpha=0.5, linewidths=0.8)
    axes[2].clabel(CS3, inline=True, fontsize=8, fmt='%.1f')

    plt.tight_layout()
    plt.show()


if __name__ == '__main__':
    plot_radiator_performance()

