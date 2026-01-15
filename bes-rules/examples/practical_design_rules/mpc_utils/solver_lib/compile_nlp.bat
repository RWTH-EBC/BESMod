set source_file=%1
set target_file=%2

ECHO "You need to set up the paths for your system! Comment this line when done."

:: setup your command line for visual studio compilers
:: put the path to your visual studio vcvarsall.bat file here, example path below
call "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvarsall.bat" x64


"cl" "/LD" %source_file%