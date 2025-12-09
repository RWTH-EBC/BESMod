import logging
import pathlib
from typing import Optional, TYPE_CHECKING

from pydantic import field_validator

from ebcpy.preprocessing import convert_index_to_datetime_index
import datetime

from bes_rules.utils.modelica import load_modelica_file_modifier
from bes_rules.configs.inputs.base import BaseInputConfig
from bes_rules import DATA_PATH

if TYPE_CHECKING:
    from bes_rules.configs import InputConfig


class WeatherConfig(BaseInputConfig):
    dat_file: pathlib.Path
    TOda_nominal: float = None
    mos_path: Optional[pathlib.Path] = None

    @field_validator("TOda_nominal")
    @classmethod
    def check_unit(cls, TOda_nominal):
        """Convert to K if < 100"""
        if TOda_nominal is None:
            return TOda_nominal
        if TOda_nominal > 100:
            return TOda_nominal
        return TOda_nominal + 273.15

    @field_validator("dat_file")
    @classmethod
    def ensure_path(cls, _path):
        if isinstance(_path, pathlib.Path):
            return _path
        return pathlib.Path(_path)

    @field_validator("mos_path")
    @classmethod
    def ensure_optional_path(cls, _path):
        if isinstance(_path, pathlib.Path):
            return _path
        if _path is None:
            return None
        return pathlib.Path(_path)

    def get_modelica_modifier(self, input_config: "InputConfig"):
        return f'systemParameters(\n' \
               f'    filNamWea={load_modelica_file_modifier(self.mos_path)},\n' \
               f'    TOda_nominal={self.TOda_nominal})'

    def get_name(self, location_name=False, pretty_print: bool = False):
        if location_name:
            return str(self.dat_file.parents[1].stem).replace(" ", "_") + self.dat_file.stem.split("_")[-1]
        if pretty_print:
            year, _, _typ = self.dat_file.stem.split("_")
            _typ = {"Jahr": "average", "Somm": "warm", "Wint": "cold"}[_typ]
            return f"{self.dat_file.parents[1].stem}-{year}-{_typ}"
        return self.dat_file.stem.replace('.', '_')

    def get_hourly_weather_data(self):
        first_day_of_year = datetime.datetime(2015, 1, 1, 0, 0)
        if self.dat_file_new_pc.suffix == ".epw":
            from aixweather.project_class import ProjectClassEPW
            try_project = ProjectClassEPW(path=str(self.dat_file_new_pc))
            try_project.import_data()
            try_project.data_2_core_data()
            return convert_index_to_datetime_index(try_project.core_data, origin=first_day_of_year)
        try:
            from aixweather.imports.TRY import load_try_from_file
            df = load_try_from_file(path=str(self.dat_file_new_pc))
        except ValueError as err:
            logging.critical("ValueError during try reading. Only supposed to happen with 2010 data: %s", err)
            # Old case of 2010 data.
            import io
            import pandas as pd
            with open(self.dat_file_new_pc, "r") as file:
                data_lines = file.readlines()[36:]
            data_lines.remove("***\n")  # Remove line "***"
            output = io.StringIO()
            output.writelines(data_lines)
            output.seek(0)
            df = pd.read_csv(output, sep='\s+', header=0)
        df.index *= 3600
        return convert_index_to_datetime_index(df, origin=first_day_of_year)

    @property
    def dat_file_new_pc(self):
        if len(self.dat_file.parents) >= 4 and self.dat_file.parents[4].name == "bes-rules":
            dat_file_new_pc = DATA_PATH.joinpath(self.dat_file.relative_to(self.dat_file.parents[3]))
        else:
            dat_file_new_pc = self.dat_file
        return dat_file_new_pc
