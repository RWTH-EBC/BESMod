import os
import sys
import pathlib


class LibraryInstaller:
    """
    Custom dataclass to avoid import issues.

    :param str url:
        Url to repo to install
    :param str commit:
        The commit hash
    :param str mo:
        Default None.
        If the mo to load is not the
        name\\package.mo in the setup-config dicts.
    """

    def __init__(self, url: str, commit: str, mo: str = None):
        self.url: str = url
        self.commit: str = commit
        self.mo: str = mo


required_dependencies_config: dict = {
    "IBPSA": LibraryInstaller(
        url="https://github.com/ibpsa/modelica-ibpsa",
        commit="d5b02ab5aac01c4d07583d73afff6b14c5f58bd2"
    )
}

optional_dependencies_config: dict = {
    "AixLib": LibraryInstaller(
        url="https://github.com/RWTH-EBC/AixLib",
        commit="0cef0cefc199dcb0d642d2b0c6eb0a3438d8a9a6"
    ),
    "Buildings": LibraryInstaller(
        url="https://github.com/lbl-srg/modelica-buildings",
        commit="fba63b60c75bb0285ede2081ae17dbdc9f38d9e7"
    ),
    "BuildingSystems": LibraryInstaller(
        url="https://github.com/UdK-VPT/BuildingSystems",
        commit="64adca47eae19d2744d86aa8d1624cbf7ad6326b"
    )
}


def install_dependencies(
        optional_dependencies: list,
        install_directory: str,
        working_directory: str,
        besmod_directory: pathlib.Path):
    working_directory = pathlib.Path(working_directory)
    install_directory = pathlib.Path(install_directory)

    os.makedirs(working_directory, exist_ok=True)
    os.makedirs(install_directory, exist_ok=True)

    install_libraries = required_dependencies_config.copy()
    for optional_dependency in optional_dependencies:
        if optional_dependency not in optional_dependencies_config:
            raise KeyError(f"Given dependency '{optional_dependency}' is not supported.")
        install_libraries[optional_dependency] = optional_dependencies_config[optional_dependency]

    open_models = []
    for lib, lib_installer in install_libraries.items():
        os.chdir(install_directory)
        lib_dir = install_directory.joinpath(lib)
        os.system(f'git clone "{lib_installer.url}" "{str(lib_dir)}"')
        os.chdir(lib_dir)
        os.system(f"git checkout -b commit_{lib_installer.commit[:8]} {lib_installer.commit} --")
        if lib_installer.mo is None:
            package_mo = f"{lib}//package.mo"
        else:
            package_mo = lib_installer.mo
        open_models.append(f'openModel("{str(lib_dir.joinpath(package_mo))}", changeDirectory=false);')

    besmod_package_mo = besmod_directory.joinpath("BESMod", "package.mo")
    open_models.append(f'openModel("{str(besmod_package_mo)}", changeDirectory=false);')

    open_libs_mos = "\n".join(open_models)
    with open(besmod_directory.joinpath("startup.mos"), "w+") as file:
        file.write(open_libs_mos)
        file.write("\n// Change working directory\n")
        file.write(f'cd("{str(working_directory)}")')


if __name__ == '__main__':
    argv = sys.argv
    filepath = argv[0]
    argv = argv[1:]
    BESMOD_DIR = pathlib.Path(os.getcwd()).joinpath(filepath).parent
    INSTALL_DIR = BESMOD_DIR.joinpath("installed_dependencies")
    WORKING_DIR = BESMOD_DIR.joinpath("working_dir")
    OPTIONAL_DEPENDENCIES = []
    INSTALL_FULL = False
    for _v in argv:
        if _v.startswith("--install_dir="):
            INSTALL_DIR = _v.replace("--install_dir=", "")
        elif _v.startswith("--working_dir="):
            WORKING_DIR = _v.replace("--working_dir=", "")
        elif _v == "full":
            INSTALL_FULL = True
        else:
            OPTIONAL_DEPENDENCIES.append(_v)
    if INSTALL_FULL:
        OPTIONAL_DEPENDENCIES = list(optional_dependencies_config.keys())
    install_dependencies(
        optional_dependencies=OPTIONAL_DEPENDENCIES,
        install_directory=INSTALL_DIR,
        working_directory=WORKING_DIR,
        besmod_directory=BESMOD_DIR
    )
