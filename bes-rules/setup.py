import setuptools

setuptools.setup(
    name='bes_rules',
    python_requires=">=3.10,<3.12",  # aisweather currently does not support >=3.12
    version="0.1",
    description='Dissertation package of Fabian Roemer, born Wuellhorst',
    author='Fabian Roemer',
    author_email='fabian.roemer@eonerc.rwth-aachen.de',
    packages=setuptools.find_packages(exclude=['tests', 'tests.*', 'img']),
    install_requires=[]  # Install requirements manually to enable custom versions
)
