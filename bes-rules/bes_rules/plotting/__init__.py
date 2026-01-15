"""Some basic plotting utilities"""
from bes_rules.plotting.utils import get_figure_size, load_plot_config, save, create_plots

class EBCColors:
    dark_red = [172 / 255, 43 / 255, 28 / 255]
    red = [221 / 255, 64 / 255, 45 / 255]
    light_red = [235 / 255, 140 / 255, 129 / 255]
    green = [112 / 255, 173 / 255, 71 / 255]
    light_grey = [217 / 255, 217 / 255, 217 / 255]
    grey = [157 / 255, 158 / 255, 160 / 255]
    dark_grey = [78 / 255, 79 / 255, 80 / 255]
    light_blue = [157 / 255, 195 / 255, 230 / 255]
    blue = [0 / 255, 84 / 255, 159 / 255]
    ebc_palette_sort_1 = [
        dark_red,
        red,
        light_red,
        dark_grey,
        grey,
        light_grey,
        blue,
        light_blue,
        green,
    ]
    ebc_palette_sort_2 = [
        blue,
        red,
        grey,
        green,
        dark_red,
        dark_grey,
        light_red,
        light_blue,
        light_grey,
    ]

