![E.ON EBC RWTH Aachen University](./BESMod/Resources/Images/EBC_Logo.png)

# BESMod

This library contains **Mod**ules for the domain-coupled simulation of **B**uilding **E**nergy **S**ystems .
It was presented at the American Modelica Conference 2022. Check out the proceedings here: https://2022.american.conference.modelica.org/documents/NA_Modelica_2022_Proceedings.pdf

Moreover, `BESMod` won the best paper award.

# Installation

## Clone repository

To clone the repository for the first time run:

```
git clone https://github.com/RWTH-EBC/BESMod.git
```

## Install dependencies

To install all dependencies, you need python installed (>= 3.7). 
If you don't have python or don't want to install it, just clone the required libraries manually. 
You can extract the relevant information from the `dependencies.cfg` script.

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

### Updating dependencies

If you have BESMod already installed, run  

```
python install_dependencies.py full --update
```
to update the existing repos and avoid a second download.

# How to contribute to the development of BESMod

You are invited to contribute to the development of **BESMod**.
Issues can be reported using this site's [Issues section](https://github.com/RWTH-EBC/BESMod/issues).
Furthermore, you are welcome to contribute via [Pull Requests](https://github.com/RWTH-EBC/BESMod/pulls).

# How to cite BESMod

URL to proceedings: https://2022.american.conference.modelica.org/documents/NA_Modelica_2022_Proceedings.pdf
DOI:  10.3384/ECP211869

```
@inproceedings{wuellhorst2022besmod,
  title = {{BESMod} - {A} {Modelica} {Library} providing {Building} {Energy} {System} {Modules}},
  author = {W{\"u}llhorst, Fabian and Maier, Laura and Jansen, David and K{\"u}hn, Larissa and Hering, Dominik and M{\"u}ller, Dirk}},
  year = {2022},
  booktitle={Proceedings of the American Modelica Conference 2022, Dallas, Texas, USA, October 26-28},
  pages={9--18},
  year={2022},
  doi={10.3384/ecp21186}
}
```

# License

The **BESMod** Library is released by RWTH Aachen University, E.ON Energy Research Center, Institute for Energy Efficient Buildings and Indoor Climate and is available under a 3-clause BSD-license.
See [BESMod Library license](License).

# Acknowledgements

We gratefully acknowledge the financial support by the Federal Ministry for Economic Affairs and Climate Action (BMWK), promotional reference 03ET1495A.

<img src="./BESMod/Resources/Images/BMWK_logo.png" alt="BMWK" width="200"/>

This work emerged from the IBPSA Project 1, an international project conducted under the umbrella of the International Building Performance Simulation Association (IBPSA). Project 1 will develop and demonstrate a BIM/GIS and Modelica Framework for building and community energy system design and operation.

![IBPSA](./BESMod/Resources/Images/IBPSA-logo-text.png)
