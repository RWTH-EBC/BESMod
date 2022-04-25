# BESMod

This library contains models for building energy systems simulations using a modular subsystem approach.
It is submitted to the American Modelica Conference 2022. 
Currently, the review process is not finished.

# Installation

To install all dependencies, you need python installed (>= 3.7). 
If you don't have python or don't want to install it, just clone the required libraries manually. 
You can extract the relevant information from the `install_dependencies.py` script.

Using the script, it's just:

```python
python install_dependencies.py full
```
to install all dependencies or specify the list of optional dependencies you want to use:
```python
python install_dependencies.py AixLib Buildings
```
To change the default directories of installation and working directory, you have the following options:
```
--install_dir=/path_to_a_install_dir
--working_dir=/path_to_a_working_dir
```
Example:
```python
python install_dependencies.py AixLib Buildings --install_dir=D:\BESMod_install --working_dir=D:\BESMod_cwd
```
After installing all libraries, a script `startup.mos` will be created in your BESMod repo.
Execute this script to load all dependencies and start modelling.
