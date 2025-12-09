import setuptools

import pathlib

with open(pathlib.Path(__file__).parent.joinpath("requirements.txt"), "r") as file:
    INSTALL_REQUIRES = [l.replace("\n", "") for l in file.readlines()]

setuptools.setup(
    name='bes_rules',
    version="0.1",
    description='Dissertation package of Fabian Roemer, born Wuellhorst',
    author='Fabian Roemer',
    author_email='fabian.roemer@eonerc.rwth-aachen.de',
    packages=setuptools.find_packages(exclude=['tests', 'tests.*', 'img']),
    install_requires=INSTALL_REQUIRES
)
