import os
import sys
import pathlib
import json


class LibraryInstaller:
    """
    Custom dataclass to avoid import issues.

    :param str url:
        Url to repo to install
    :param str commit:
        The commit hash
    :param str default_branch:
        Default branch. Used to update installed
        dependencies
    :param str mo:
        Default None.
        If the mo to load is not the
        name\\package.mo in the setup-config dicts.
    """

    def __init__(self, url: str, commit: str, default_branch: str, mo: str = None):
        self.url: str = url
        self.commit: str = commit
        self.mo: str = mo
        self.default_branch: str = default_branch


required_dependencies_config: dict = {}
optional_dependencies_config: dict = {}

with open("dependencies.json", "r") as file:
    data = json.load(file)
    for key, value in data["required"].items():
        required_dependencies_config[key] = LibraryInstaller(**value)
    for key, value in data["optional"].items():
        optional_dependencies_config[key] = LibraryInstaller(**value)


def install_dependencies(
        optional_dependencies: list,
        install_directory: str,
        working_directory: str,
        besmod_directory: pathlib.Path,
        update: bool
):
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
        if update:
            os.chdir(lib_dir)
            os.system(f'git checkout "{lib_installer.default_branch}"')
            os.system('git pull')
            # Try to create new branch
            ret = os.system(f"git checkout -b commit_{lib_installer.commit[:8]} {lib_installer.commit} --")
            if ret != 0:
                os.system(f"git checkout commit_{lib_installer.commit[:8]}")
        else:
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
        file.write(f'cd("{str(working_directory)}");')


if __name__ == '__main__':
    argv = sys.argv
    filepath = argv[0]
    argv = argv[1:]
    BESMOD_DIR = pathlib.Path(os.getcwd()).joinpath(filepath).parent
    INSTALL_DIR = BESMOD_DIR.joinpath("installed_dependencies")
    WORKING_DIR = BESMOD_DIR.joinpath("working_dir")
    OPTIONAL_DEPENDENCIES = []
    INSTALL_FULL = False
    UPDATE = False
    for _v in argv:
        if _v.startswith("--install_dir="):
            INSTALL_DIR = _v.replace("--install_dir=", "")
        elif _v.startswith("--working_dir="):
            WORKING_DIR = _v.replace("--working_dir=", "")
        elif _v == "full":
            INSTALL_FULL = True
        elif _v == "--update":
            UPDATE = True
        else:
            OPTIONAL_DEPENDENCIES.append(_v)
    if INSTALL_FULL:
        OPTIONAL_DEPENDENCIES = list(optional_dependencies_config.keys())
    install_dependencies(
        optional_dependencies=OPTIONAL_DEPENDENCIES,
        install_directory=INSTALL_DIR,
        working_directory=WORKING_DIR,
        besmod_directory=BESMOD_DIR,
        update=UPDATE
    )
