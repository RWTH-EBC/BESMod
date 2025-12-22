# Installation

Clone this repository.
To install, change directory (cd) into the cloned folder. Then run
```
pip install -r requirements.txt
pip install -e .
```

The -e option for editable mode is necessary to correctly load all the paths.

## Paths

We use pathlib and globally defined PATH variables to make transitioning between devices easier. 
To use this, you have to specify a file `pc_specific_settings.json` (not commited to git).
Most notably, if `DATA_PATH` and `STARTUP_BESMOD_MOS` are not defined, the paths from this repo will
be used - if they exist. 
Note that the `DATA_PATH` only has dummy, single weather files and further scenario assumptions.

```json
{
  "RESULTS_FOLDER": "D:\\01_Results",
  "STARTUP_BESMOD_MOS": "D:\\BESMod\\startup.mos",
  "N_CPU": 12,
  "DATA_PATH": "D:\\custom_data_path"
}
```