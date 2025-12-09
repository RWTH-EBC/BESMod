import datetime
import pathlib

import matplotlib.pyplot as plt
import matplotlib.patches as patches
import numpy as np
from matplotlib.patches import FancyArrowPatch
from matplotlib.patches import ConnectionPatch
import matplotlib.animation as animation
from ebcpy import load_time_series_data


def plot_storage_model(layers=8, storage_height=6, storage_width=2,
                       bottom_left_flow=0.5, top_right_flow=-0.3, top_left_flow=0.2, bottom_right_flow=-0.4,
                       bottom_left_temp=80, top_right_temp=60, top_left_temp=90, bottom_right_temp=40,
                       layer_temps=None, internal_flow_direction='up',
                       timestamp=None,
                       temp_min=None, temp_max=None):
    """
    Plot 1D storage model with temperatures and flow visualization

    Parameters:
    - layers: number of storage layers
    - storage_height: height of storage tank
    - storage_width: width of storage tank
    - left_flow, right_flow, top_flow, bottom_flow: mass flow rates (+ = into storage)
    - left_temp, right_temp, top_temp, bottom_temp: temperatures at ports
    - layer_temps: list of temperatures for each layer (if None, generates gradient)
    - internal_flow_direction: 'up' or 'down'
    """

    ax = plt.gca()

    # Fixed positions for consistent layout
    storage_x = storage_width * 3  # Center x position
    storage_y = storage_height * 0.1  # Bottom y position
    port_length = 0.5 * storage_width

    # Generate layer temperatures if not provided
    if layer_temps is None:
        layer_temps = np.linspace(90, 30, layers)  # Hot at top, cold at bottom

    # Draw storage tank (black box mantle)
    storage_rect = patches.Rectangle((storage_x - storage_width / 2, storage_y),
                                     storage_width, storage_height,
                                     linewidth=3, edgecolor='black',
                                     facecolor='lightgray', alpha=0.3)
    ax.add_patch(storage_rect)

    # Draw storage layers with temperature colors
    layer_height = storage_height / layers
    colormap = plt.cm.coolwarm
    if temp_min is None:
        temp_min = min(layer_temps.min(), bottom_right_temp, bottom_left_temp, top_right_temp, top_left_temp)
    if temp_max is None:
        temp_max = max(layer_temps.max(), bottom_right_temp, bottom_left_temp, top_right_temp, top_left_temp)

    for i in range(layers):
        y_pos = storage_y + i * layer_height
        temp = layer_temps[i]
        color_val = (temp - temp_min) / (temp_max - temp_min)
        color = colormap(color_val)

        layer_rect = patches.Rectangle((storage_x - storage_width / 2, y_pos + 0.01),
                                       storage_width, layer_height - 0.01,
                                       facecolor=color, alpha=0.7)
        ax.add_patch(layer_rect)
        #
        # # Add temperature text
        # ax.text(storage_x, y_pos + layer_height / 2, f'{temp:.1f}°C',
        #         ha='center', va='center')

    # Port positions
    bottom_port_y = storage_y
    top_port_y = storage_y + storage_height
    left_port_x = storage_x - storage_width / 2
    right_port_x = storage_x + storage_width / 2

    # Draw ports and flow arrows with temperatures
    def draw_port_flow(x_start, y_start, x_end, y_end, flow_rate, temp, label_pos, port_name):
        color_val = (temp - temp_min) / (temp_max - temp_min)
        arrow_color = colormap(color_val)

        if flow_rate > 0:  # Flow into storage
            arrow = FancyArrowPatch((x_start, y_start), (x_end, y_end),
                                    arrowstyle='->', mutation_scale=20,
                                    color=arrow_color, linewidth=3)
            temp_x, temp_y = x_start, y_start
        else:  # Flow out of storage
            arrow = FancyArrowPatch((x_end, y_end), (x_start, y_start),
                                    arrowstyle='->', mutation_scale=20,
                                    color=arrow_color, linewidth=3)
            temp_x, temp_y = x_start, y_start

        ax.add_patch(arrow)

        # Add temperature label
        ax.text(temp_x + label_pos[0], temp_y + label_pos[1],
                f'{temp:.1f}°C\n({flow_rate:+.1f} kg/s)',
                ha='center', va='center',
                bbox=dict(boxstyle='round,pad=0.3', facecolor='white', alpha=0.8))

        # Add port name
        ax.text(temp_x + label_pos[0], temp_y + label_pos[1] - storage_height * 0.15, port_name,
                ha='center', va='center')

    # Left bottom port
    draw_port_flow(left_port_x - port_length, bottom_port_y,
                   left_port_x, bottom_port_y,
                   bottom_left_flow, bottom_left_temp, (-port_length * 0.5, 0), 'Generation return')

    # Top Right port
    draw_port_flow(right_port_x + port_length, top_port_y,
                   right_port_x, top_port_y,
                   top_right_flow, top_right_temp, (port_length * 0.5, 0), 'Transfer supply')

    # Top left port
    draw_port_flow(left_port_x - port_length, top_port_y,
                   left_port_x, top_port_y,
                   top_left_flow, top_left_temp, (-port_length * 0.5, 0), 'Generation supply')

    # Bottom right port
    draw_port_flow(right_port_x + port_length, bottom_port_y,
                   right_port_x, bottom_port_y,
                   bottom_right_flow, bottom_right_temp, (port_length * 0.5, 0), 'Transfer return')

    # Internal flow direction arrow
    arrow_start_y = storage_y + storage_height * 0.2
    arrow_end_y = storage_y + storage_height * 0.8

    if internal_flow_direction == 'up':
        internal_arrow = FancyArrowPatch((storage_x + 0.3, arrow_start_y),
                                         (storage_x + 0.3, arrow_end_y),
                                         arrowstyle='->', mutation_scale=25,
                                         color='green', linewidth=4, alpha=1)
        flow_text = 'Internal Flow: UP'
    else:
        internal_arrow = FancyArrowPatch((storage_x + 0.3, arrow_end_y),
                                         (storage_x + 0.3, arrow_start_y),
                                         arrowstyle='->', mutation_scale=25,
                                         color='orange', linewidth=4, alpha=1)
        flow_text = 'Internal Flow: DOWN'

    ax.add_patch(internal_arrow)
    # ax.text(storage_x + 1.2, storage_y + storage_height / 2, flow_text,
    #         rotation=90, ha='center', va='center')

    # Dimension labels
    # Width label
    ax.annotate('', xy=(storage_x - storage_width / 2, storage_y - storage_height * 0.15),
                xytext=(storage_x + storage_width / 2, storage_y - storage_height * 0.15),
                arrowprops=dict(arrowstyle='<->', color='black'))
    ax.text(storage_x, storage_y - 0.1 * storage_height, f'Width: {storage_width:.1f} m',
            ha='center', va='center')

    # Height label
    ax.annotate('', xy=(storage_x - storage_width * 0.8, storage_y),
                xytext=(storage_x - storage_width * 0.8, storage_y + storage_height),
                arrowprops=dict(arrowstyle='<->', color='black'))
    ax.text(storage_x - storage_width, storage_y + storage_height / 2,
            f'Height: {storage_height:.1f} m',
            rotation=90, ha='center', va='center')

    # Add colorbar for temperature scale
    sm = plt.cm.ScalarMappable(cmap=colormap, norm=plt.Normalize(vmin=temp_min, vmax=temp_max))
    sm.set_array([])
    cbar = plt.colorbar(sm, ax=ax, shrink=0.6, aspect=20)
    cbar.set_label('Temperature / °C', rotation=270, labelpad=20)

    # Set plot properties
    ax.set_xlim(storage_x - storage_width * 2, storage_x + storage_width * 2)
    ax.set_ylim(storage_y - storage_height * 0.5, storage_y + storage_height * 1.5)
    ax.set_xlabel('Position / m')
    ax.set_ylabel('Position / m')
    ax.set_title(f'1D Storage at {timestamp.strftime("%m-%d %H:%M:%S")}')

    plt.tight_layout()
    return ax


def map_besmod_to_plot_function(
        mat_file: pathlib.Path,
        save_path: pathlib.Path,
        use_animation=True,
        aixlib_buffer_storage_path: str = "hydraulic.distribution.stoBuf",
        start=7 * 86400,
        end=10 * 86400,
        scale_colors=True
):
    m_flow_top_left = f"{aixlib_buffer_storage_path}.fluidportTop1.m_flow"
    m_flow_top_right = f"{aixlib_buffer_storage_path}.fluidportTop2.m_flow"
    m_flow_bot_left = f"{aixlib_buffer_storage_path}.fluidportBottom1.m_flow"
    m_flow_bot_right = f"{aixlib_buffer_storage_path}.fluidportBottom2.m_flow"
    h_outflow_top_left = f"{aixlib_buffer_storage_path}.fluidportTop1.h_outflow"
    h_outflow_top_right = f"{aixlib_buffer_storage_path}.fluidportTop2.h_outflow"
    h_outflow_bot_left = f"{aixlib_buffer_storage_path}.fluidportBottom1.h_outflow"
    h_outflow_bot_right = f"{aixlib_buffer_storage_path}.fluidportBottom2.h_outflow"

    h = f"{aixlib_buffer_storage_path}.data.hTank"
    d = f"{aixlib_buffer_storage_path}.data.dTank"
    n_layers = f"{aixlib_buffer_storage_path}.n"
    tsd = load_time_series_data(
        mat_file,
        variable_names=[
            f"{aixlib_buffer_storage_path}.layer[*].T",
            m_flow_top_left, h_outflow_top_left,
            m_flow_top_right, h_outflow_top_right,
            m_flow_bot_left, h_outflow_bot_left,
            m_flow_bot_right, h_outflow_bot_right,
            h, d, n_layers
        ]
    ).loc[start:end]
    tsd_c = tsd.tsd.to_datetime_index(origin=datetime.datetime(2015, 1, 1), inplace=False)
    tsd.loc[:, "timestamp"] = tsd_c.index
    # Prepare your data for all frames
    frames_data = []
    layers = int(tsd.iloc[-1][n_layers])

    if scale_colors:
        temp_min = None
        temp_max = None
    else:
        temp_min = tsd.loc[:, f"{aixlib_buffer_storage_path}.layer[1].T"].min() - 273.15
        temp_max = tsd.loc[:, f"{aixlib_buffer_storage_path}.layer[{layers}].T"].max() - 273.15

    for idx in tsd.index:
        m_flow_top = tsd.loc[idx, m_flow_top_left] + tsd.loc[idx, m_flow_top_right]
        m_flow_bottom = tsd.loc[idx, m_flow_bot_left] + tsd.loc[idx, m_flow_bot_right]

        def _get_T(h, m_flow, layer_T):
            # Get T from h_outflow based on constant cp
            if m_flow >= 0:
                return h / 4184  # in °C
            return layer_T  # leaves as mixed if m_flow < 0


        layer_temps = np.array([tsd.loc[idx, f"{aixlib_buffer_storage_path}.layer[{n}].T"] - 273.15
                                for n in range(1, layers + 1)])

        bottom_left_temp = _get_T(tsd.loc[idx, h_outflow_bot_left], tsd.loc[idx, m_flow_bot_left], layer_temps[0])
        top_right_temp = _get_T(tsd.loc[idx, h_outflow_top_right], tsd.loc[idx, m_flow_top_right], layer_temps[-1])
        top_left_temp = _get_T(tsd.loc[idx, h_outflow_top_left], tsd.loc[idx, m_flow_top_left], layer_temps[-1])
        bottom_right_temp = _get_T(tsd.loc[idx, h_outflow_bot_right], tsd.loc[idx, m_flow_bot_right], layer_temps[0])

        frames_data.append(dict(
            layers=layers,
            storage_height=tsd.loc[idx, h],
            storage_width=tsd.loc[idx, d],
            bottom_left_flow=tsd.loc[idx, m_flow_bot_left],
            top_right_flow=tsd.loc[idx, m_flow_top_right],
            top_left_flow=tsd.loc[idx, m_flow_top_left],
            bottom_right_flow=tsd.loc[idx, m_flow_bot_right],
            bottom_left_temp=bottom_left_temp,
            top_right_temp=top_right_temp,
            top_left_temp=top_left_temp,
            bottom_right_temp=bottom_right_temp,
            layer_temps=layer_temps,
            internal_flow_direction='up' if m_flow_top < m_flow_bottom else "down",
            timestamp=tsd.loc[idx, "timestamp"],
            temp_min=temp_min,
            temp_max=temp_max
        ))

    if use_animation:
        # Create animation
        fig = plt.figure(figsize=(12, 8))

        def animate(frame):
            plt.clf()  # Clear the figure
            plot_storage_model(**frames_data[frame])

        ani = animation.FuncAnimation(fig, animate, frames=len(frames_data),
                                      interval=100, repeat=True)
        ani.save(save_path.with_suffix('.gif'), writer='pillow', fps=10)
    else:
        for data in frames_data:
            plot_storage_model(**data)
            plt.show()


# Example usage
if __name__ == "__main__":
    from bes_rules import RESULTS_FOLDER
    INPUT_CONFIG = "TRY2015_541817120824_Jahr_B1918_standard_o0w2r1g0_SingleDwelling_M_0K-Per-IntGai"
    INPUT_CONFIG = "TRY2045_474856110632_Somm_B2001_standard_o2w2r2g2_SingleDwelling_M_0K-Per-IntGai"

    BASE = RESULTS_FOLDER.joinpath("UseCase_TBivAndV", "influence_heat_transfer_januar", "DesignOptimizationResults")
    for M in [
        "HeatTransferOnlyConduction",
        "HeatTransferLambdaEffSmooth",
        "HeatTransferBuoyancyWetter",
    ]:
        for N in ["_NLayer", ""]:
            for STO in [0, 3]:
                for SCALE in [False, True]:
                    map_besmod_to_plot_function(
                        mat_file=BASE.joinpath(f"{INPUT_CONFIG}_{M}{N}", f"iterate_{STO}.mat"),
                        use_animation=True,
                        save_path=BASE.parent.joinpath(f"{M}{N}{'5' if STO == 0 else '32'}{SCALE}"),
                        scale_colors=SCALE,
                        start=7*86400,
                        end=14*86400
                    )
