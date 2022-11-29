REM run as Administrator
@echo off

cd /d %~dp0
set CURRENT_DIRECTORY=%~dp0
set CURRENT_DIRECTORY_LINUX=%CURRENT_DIRECTORY:\=/%

set DOWNLOADS_DIR=%USERPROFILE%\Downloads
set DOWNLOADS_DIR_LINUX=%DOWNLOADS_DIR:\=/%

@REM this is needed for bootstrapping emsdk
set PYTHON_DIR=%DOWNLOADS_DIR%\python-3.7.9-amd64-portable

@REM git clone --recursive https://github.com/emscripten-core/emsdk.git && cd emsdk && git checkout 3.1.25
SET EMSDK=%DOWNLOADS_DIR%\emsdk
SET EMSDK_NODE=%EMSDK%\node\14.18.2_64bit\bin\node.exe
SET EMSDK_PYTHON=%EMSDK%\python\3.9.2-nuget_64bit\python.exe
SET JAVA_HOME=%EMSDK%\java\8.152_64bit

@REM mingw64 is still needed for searching standard library headers
SET PATH=^
%DOWNLOADS_DIR%\PortableGit\bin;^
%DOWNLOADS_DIR%\x86_64-8.1.0-release-posix-seh-rt_v6-rev0;^
%DOWNLOADS_DIR%\x86_64-8.1.0-release-posix-seh-rt_v6-rev0\bin;^
%DOWNLOADS_DIR%\cmake-3.22.2-windows-x86_64\bin;^
%PYTHON_DIR%;^
%PYTHON_DIR%Scripts;^
%EMSDK%;^
%EMSDK%\upstream\emscripten;^
%EMSDK%\node\14.18.2_64bit\bin;

@REM -DCMAKE_TOOLCHAIN_FILE="%current_directory_linux%../emsdk/upstream/emscripten/cmake/Modules/Platform/Emscripten.cmake" ^
@REM -DEMSCRIPTEN_ROOT="%current_directory_linux%../emsdk/upstream/emscripten" ^

cd /d %EMSDK% &&^
dir
.\emsdk install latest &&^
.\emsdk activate latest &&^
cd /d %CURRENT_DIRECTORY% &&^
cmake.exe -G"MinGW Makefiles" ^
-DCMAKE_TOOLCHAIN_FILE="%DOWNLOADS_DIR_LINUX%/emsdk/upstream/emscripten/cmake/Modules/Platform/Emscripten.cmake" ^
-DCMAKE_BUILD_TYPE=Release ^
-DBUILD_PROGRAMS=OFF ^
-DBUILD_EXAMPLES=OFF ^
-DBUILD_TESTING=OFF ^
-DWITH_FORTIFY_SOURCE=OFF ^
-DWITH_STACK_PROTECTOR=OFF ^
-DBUILD_DOCS=OFF ^
-DINSTALL_MANPAGES=OFF ^
-DINSTALL_PKGCONFIG_MODULES=ON ^
-DINSTALL_CMAKE_CONFIG_MODULE=ON ^
-DWITH_OGG=OFF ^
-DCMAKE_INSTALL_PREFIX="cmake-build/flac-emscripten" -B./cmake-build ^
-B./cmake-build &&^
cd cmake-build &&^
cmake --build . &&^
cmake --install . &&^
echo "Successful build"
pause
@REM -DEMSCRIPTEN_ROOT="%DOWNLOADS_DIR_LINUX%/PortableGit/emsdk/upstream/emscripten" ^
@REM -DBUILD_SHARED_LIBS=OFF ^
@REM -DBUILD_CXXLIBS=ON ^
