import pandas as pd
from bes_rules import DATA_PATH


def load_vitocal250_COPs(sheet_name):
    df = pd.read_excel(DATA_PATH.joinpath("vitocal250.xlsx"), index_col=0, sheet_name=sheet_name)
    df = df.transpose()
    df.columns.name = "TSupply"
    df.index.name = "TOda"
    return df
