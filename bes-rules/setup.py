import setuptools

setuptools.setup(
    name='bes_rules',
    version="0.1",
    description='Dissertation package of Fabian Roemer, born Wuellhorst',
    author='Fabian Roemer',
    author_email='fabian.roemer@eonerc.rwth-aachen.de',
    packages=setuptools.find_packages(exclude=['tests', 'tests.*', 'img']),
    install_requires=[]  # Install requirements manually to enable custom versions
)
