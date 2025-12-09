import sympy


def calc_resistances(zone_parameters: dict, split_rad_int: dict, split_rad_sol: dict):
    """
    Calculates the coefficients for the algebraic equations of the surface temperatures.
    """
    # inputs
    QTraRad_flow = sympy.symbols('QTraRad_flow')
    q_ig_rad = sympy.symbols('q_ig_rad')
    Q_RadSol = sympy.symbols('Q_RadSol')
    T_preTemWin = sympy.symbols('T_preTemWin')
    # states
    T_Air = sympy.symbols('T_Air')
    T_int = sympy.symbols('T_int')
    T_ext = sympy.symbols('T_ext')
    T_roof = sympy.symbols('T_roof')
    T_floor = sympy.symbols('T_floor')
    # surface temps
    T_int_sur = sympy.symbols('T_int_sur')
    T_ext_sur = sympy.symbols('T_ext_sur')
    T_roof_sur = sympy.symbols('T_roof_sur')
    T_floor_sur = sympy.symbols('T_floor_sur')
    T_win_sur = sympy.symbols('T_win_sur')

    # parameters
    # split factors
    split_rad_int_int, split_rad_sol_int = split_rad_int['int'], split_rad_sol['int']
    split_rad_int_ext, split_rad_sol_ext = split_rad_int['ext'], split_rad_sol['ext']
    split_rad_int_roof, split_rad_sol_roof = split_rad_int['roof'], split_rad_sol['roof']
    split_rad_int_floor, split_rad_sol_floor = split_rad_int['floor'], split_rad_sol['floor']
    split_rad_int_win, split_rad_sol_win = split_rad_int['win'], split_rad_sol['win']

    # thermal transmittance
    # air
    k_int_air = zone_parameters['hConInt'] * zone_parameters['AInttot']
    k_ext_air = zone_parameters['hConExt'] * zone_parameters['AExttot']
    k_roof_air = zone_parameters['hConRoof'] * zone_parameters['ARooftot']
    k_floor_air = zone_parameters['hConFloor'] * zone_parameters['AFloortot']
    k_win_air = zone_parameters['hConWin'] * zone_parameters['AWintot']

    # internal walls
    k_int = 1 / zone_parameters['RInt']
    k_air_int = k_int_air
    k_ext_int = zone_parameters['hRad'] * min(zone_parameters['AInttot'], zone_parameters['AExttot'])
    k_roof_int = zone_parameters['hRad'] * min(zone_parameters['AInttot'], zone_parameters['ARooftot'])
    k_floor_int = zone_parameters['hRad'] * min(zone_parameters['AInttot'], zone_parameters['AFloortot'])
    k_win_int = zone_parameters['hRad'] * min(zone_parameters['AInttot'], zone_parameters['AWintot'])

    # external walls
    k_ext = 1 / zone_parameters['RExt']
    k_air_ext = k_ext_air
    k_int_ext = k_ext_int
    k_roof_ext = zone_parameters['hRad'] * min(zone_parameters['AExttot'], zone_parameters['ARooftot'])
    k_floor_ext = zone_parameters['hRad'] * min(zone_parameters['AExttot'], zone_parameters['AFloortot'])
    k_win_ext = zone_parameters['hRad'] * min(zone_parameters['AExttot'], zone_parameters['AWintot'])
    k_amb_ext = 1 / (1 / ((zone_parameters['hConWallOut'] + zone_parameters['hRadWall']) * zone_parameters['AExttot']) + zone_parameters['RExtRem'])

    # roof
    k_roof = 1 / zone_parameters['RRoof']
    k_air_roof = k_roof_air
    k_int_roof = k_roof_int
    k_ext_roof = k_roof_ext
    k_floor_roof = zone_parameters['hRad'] * min(zone_parameters['AFloortot'], zone_parameters['ARooftot'])
    k_win_roof = zone_parameters['hRad'] * min(zone_parameters['AWintot'], zone_parameters['ARooftot'])
    k_amb_roof = 1 / (
            1 / ((zone_parameters['hConRoofOut'] + zone_parameters['hRadRoof']) * zone_parameters['ARooftot']) + zone_parameters['RRoofRem'])

    # floor
    k_floor = 1 / zone_parameters["RFloor"]
    k_air_floor = k_floor_air
    k_roof_floor = k_floor_roof
    k_ext_floor = k_floor_ext
    k_int_floor = k_floor_int
    k_win_floor = zone_parameters['hRad'] * min(zone_parameters['AWintot'], zone_parameters['AFloortot'])
    k_amb_floor = 1 / zone_parameters['RFloorRem']

    # windows
    k_air_win = k_win_air
    k_int_win = k_win_int
    k_ext_win = k_win_ext
    k_roof_win = k_win_roof
    k_floor_win = k_win_floor
    k_amb_win = 1 / (1 / ((zone_parameters['hConWinOut'] + zone_parameters['hRadWall']) * zone_parameters['AWintot']) + zone_parameters['RWin'])
    k_win_amb = k_amb_win

    # equations
    eq_int = sympy.Eq(
        k_int * (T_int - T_int_sur) +
        k_int_air * (T_Air - T_int_sur) +
        k_int_ext * (T_ext_sur - T_int_sur) +
        k_int_roof * (T_roof_sur - T_int_sur) +
        k_int_floor * (T_floor_sur - T_int_sur) +
        k_int_win * (T_win_sur - T_int_sur) +
        split_rad_int_int * QTraRad_flow +
        split_rad_int_int * q_ig_rad +
        split_rad_sol_int * Q_RadSol, 0)

    eq_ext = sympy.Eq(
        k_ext * (T_ext - T_ext_sur) +
        k_ext_air * (T_Air - T_ext_sur) +
        k_ext_int * (T_int_sur - T_ext_sur) +
        k_ext_roof * (T_roof_sur - T_ext_sur) +
        k_ext_floor * (T_floor_sur - T_ext_sur) +
        k_ext_win * (T_win_sur - T_ext_sur) +
        split_rad_int_ext * QTraRad_flow +
        split_rad_int_ext * q_ig_rad +
        split_rad_sol_ext * Q_RadSol, 0)

    eq_roof = sympy.Eq(
        k_roof * (T_roof - T_roof_sur) +
        k_roof_air * (T_Air - T_roof_sur) +
        k_roof_int * (T_int_sur - T_roof_sur) +
        k_roof_ext * (T_ext_sur - T_roof_sur) +
        k_roof_floor * (T_floor_sur - T_roof_sur) +
        k_roof_win * (T_win_sur - T_roof_sur) +
        split_rad_int_roof * QTraRad_flow +
        split_rad_int_roof * q_ig_rad +
        split_rad_sol_roof * Q_RadSol, 0)

    eq_floor = sympy.Eq(
        k_floor * (T_floor - T_floor_sur) +
        k_floor_air * (T_Air - T_floor_sur) +
        k_floor_int * (T_int_sur - T_floor_sur) +
        k_floor_ext * (T_ext_sur - T_floor_sur) +
        k_floor_roof * (T_roof_sur - T_floor_sur) +
        k_floor_win * (T_win_sur - T_floor_sur) +
        split_rad_int_floor * QTraRad_flow +
        split_rad_int_floor * q_ig_rad +
        split_rad_sol_floor * Q_RadSol, 0)

    eq_win = sympy.Eq(
        k_win_amb * (T_preTemWin - T_win_sur) +
        k_win_air * (T_Air - T_win_sur) +
        k_win_int * (T_int_sur - T_win_sur) +
        k_win_ext * (T_ext_sur - T_win_sur) +
        k_win_roof * (T_roof_sur - T_win_sur) +
        k_win_floor * (T_floor_sur - T_win_sur) +
        split_rad_int_win * QTraRad_flow +
        split_rad_int_win * q_ig_rad +
        split_rad_sol_win * Q_RadSol, 0)

    sol = sympy.solve([eq_int, eq_ext, eq_roof, eq_floor, eq_win],
                      [T_int_sur, T_ext_sur, T_roof_sur, T_floor_sur, T_win_sur])

    # Extract coefficients from the solution
    coefficients = {}

    # Iterate over the equations in the solution
    for var_sur, eq in sol.items():
        # Extract coefficients for each symbolic variable
        coeffs = {}
        for var in [T_Air, T_int, T_ext, T_roof, T_floor, T_preTemWin, QTraRad_flow, q_ig_rad, Q_RadSol]:
            coeffs[str(var)] = float(eq.coeff(var))

        # Store coefficients for the current equation
        coefficients[str(var_sur)] = coeffs

    return coefficients
