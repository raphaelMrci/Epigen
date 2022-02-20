@echo off

set VERSION=w0.1

set TMPDIR=C:\temp\Epigen
SET CURPATH=%~dp0

set GREEN=[32m
set RED=[31m
set YELL=[33m
set BLUE=[34m
set MAGENTA=[35m
set CYAN=[36m
set WHITE=[37m
set NC=[0m

set "print_help="
set "csfml_project="
set "ignore_lib="
set "print_version="
set "set_lib="
set "do_update="
set "python_project="
set "UP_NAME="
set "LO_NAME="
set "STATIC_NAME="

if exist C:\temp\Epigen rd /s /q "C:\temp\Epigen"

:: I've just tried to do a switch case, but Batch doesn't have switch nor elseif... Sorry...
:get_options
if "%1"=="" goto Continue
    if "%1"=="-h" (set "print_help=y") else (
        if "%1"=="--help" (set "print_help=y") else (
            if "%1"=="-g" (set "csfml_project=y") else (
                if "%1"=="--csfml" (set "csfml_project=y") else (
                    if "%1"=="-il" (set "ignore_lib=y") else (
                        if "%1"=="--ignore-lib" (set "ignore_lib=y") else (
                            if "%1"=="-v" (set "print_version=y") else (
                                if "%1"=="--version" (set "print_version=y") else (
                                    if "%1"=="-l" (goto save_lib) else (
                                        if "%1"=="-u" (set "do_update=y") else (
                                            if "%1"=="--update" (set "do_update=y") else (
                                                if "%1"=="-p" (set "python_project=y") else (
                                                    if "%1"=="--python" (set "python_project=y") else (
                                                        set STATIC_NAME="%1"
                                                   )
                                               )
                                           )
                                       )
                                   )
                               )
                           )
                       )
                   )
               )
           )
       )
   )
shift
goto get_options

:save_lib
    shift
    if "%1"=="" (
        echo "Error: Lib path can't be empty."
        exit 84
    )
    echo %1 > %userprofile%\.you_lib
    echo "Lib successfully registered at '%1'"
    exit 0

:Continue

if "%csfml_project%"=="y" if "%python_project%"=="y" (
    echo %RED%Multiple projects types defined. You can't specify more than 1 project type.%NC%
    exit 84
)

if "%print_version%"=="y" (
    echo Current version: %GREEN%%VERSION%%NC%
    exit 0
)

if "%print_help%"=="y" (
    echo Epigen %GREEN%%VERSION%%NC%
    echo.
    echo Epitech project generator developed by Raphael MERCIE - EPITECH Toulouse 2026
    echo Generate Epitech project templates easily
    echo.
    echo USAGE:
    echo     epigen NAME [OPTIONS]
    echo.
    echo DESCRIPTION:
    echo     NAME    name for binary delivery file.
    echo.
    echo OPTIONS:
    echo     -h, --help          print help
    echo     -g, --csfml         create a csfml project ^(TODO^)
    echo     -p, --python        create a python project ^(TODO^)
    echo     -il, --ignore-lib   ignore lib include
    echo     -v, --version       show current version
    echo     -l [4mLIB PATH[0m         define your lib path ^(specify full path^)
    echo     -u, --update        update Epigen
    echo.
    exit 0
)

if "%STATIC_NAME%"=="" set /p STATIC_NAME="Project name: "

set UP_NAME=%STATIC_NAME%
CALL :UpCase UP_NAME
set LO_NAME=%STATIC_NAME%
CALL :LoCase LO_NAME

mkdir %TMPDIR%\src
mkdir %TMPDIR%\tests
mkdir %TMPDIR%\inc
mkdir %TMPDIR%\lib


goto define_project

:add_gitignore
    echo %LO_NAME% > %TMPDIR%\.gitignore
    type "%CURPATH%\gitignore_template" >> %TMPDIR%\.gitignore
    goto:EOF

:UpCase
    FOR %%i IN ("a=A" "b=B" "c=C" "d=D" "e=E" "f=F" "g=G" "h=H" "i=I" "j=J" "k=K" "l=L" "m=M" "n=N" "o=O" "p=P" "q=Q" "r=R" "s=S" "t=T" "u=U" "v=V" "w=W" "x=X" "y=Y" "z=Z") DO CALL SET "%1=%%%1:%%~i%%"
    GOTO:EOF

:LoCase
    FOR %%i IN ("A=a" "B=b" "C=c" "D=d" "E=e" "F=f" "G=g" "H=h" "I=i" "J=j" "K=k" "L=l" "M=m" "N=n" "O=o" "P=p" "Q=q" "R=r" "S=s" "T=t" "U=u" "V=v" "W=w" "X=x" "Y=y" "Z=z") DO CALL SET "%1=%%%1:%%~i%%"
    GOTO:EOF

:makefile_header
    echo ##> %TMPDIR%/Makefile
    echo ## EPITECH PROJECT, 2022>> %TMPDIR%/Makefile
    echo ## %STATIC_NAME%>> %TMPDIR%/Makefile
    echo ## File description:>> %TMPDIR%/Makefile
    echo ## Makefile>> %TMPDIR%/Makefile
    echo ##>> %TMPDIR%/Makefile
    echo. >> %TMPDIR%/Makefile
    echo NAME    =   %LO_NAME%>> %TMPDIR%/Makefile
    echo. >> %TMPDIR%/Makefile
    goto:EOF

:header_file
    echo /*> %TMPDIR%/src/%LO_NAME%.h
    echo ** EPITECH PROJECT, 2022>> %TMPDIR%/src/%LO_NAME%.h
    echo ** %STATIC_NAME%>> %TMPDIR%/src/%LO_NAME%.h
    echo ** File description:>> %TMPDIR%/src/%LO_NAME%.h
    echo ** %STATIC_NAME% header file>> %TMPDIR%/src/%LO_NAME%.h
    echo */>> %TMPDIR%/src/%LO_NAME%.h
    echo. >> %TMPDIR%/src/%LO_NAME%.h
    echo #ifndef %UP_NAME%_H_>> %TMPDIR%/src/%LO_NAME%.h
    echo     #define %UP_NAME%_H_>> %TMPDIR%/src/%LO_NAME%.h
    goto:EOF

:close_header_file
    echo #endif /*   !%UP_NAME%_H_   */>> %TMPDIR%/src/%LO_NAME%.h
    goto:EOF

:main_file
    echo /*> %TMPDIR%/src/%LO_NAME%.c
    echo ** EPITECH PROJECT, 2022>> %TMPDIR%/src/%LO_NAME%.c
    echo ** %STATIC_NAME%>> %TMPDIR%/src/%LO_NAME%.c
    echo ** File description:>> %TMPDIR%/src/%LO_NAME%.c
    echo ** %STATIC_NAME% main file>> %TMPDIR%/src/%LO_NAME%.c
    echo */>> %TMPDIR%/src/%LO_NAME%.c
    echo. >> %TMPDIR%/src/%LO_NAME%.c
    echo #include "%LO_NAME%.h">> %TMPDIR%/src/%LO_NAME%.c
    echo. >> %TMPDIR%/src/%LO_NAME%.c
    echo int main^(int ac, char **av^) {>> %TMPDIR%/src/%LO_NAME%.c
    echo     return ^(0^);>> %TMPDIR%/src/%LO_NAME%.c
    echo }>> %TMPDIR%/src/%LO_NAME%.c
    goto:EOF

:import_lib
    if "%ignore_lib%"=="" (
        if exist %userprofile%\.you_lib (
            FOR /F "tokens=* USEBACKQ" %%F IN (type %userprofile%\.you_lib) DO (
                SET var=%%F
            )
            mkdir %TMPDIR%/lib/my
            @robocopy %var% %TMPDIR%/lib/my /E
            echo. >> %TMPDIR%/src/%LO_NAME%.h
            echo     #include "my.h">> %TMPDIR%/src/%LO_NAME%.h
        ) else (
            echo %YELL%Warning: No lib path was configured. If you want to include your lib, you must use 'epigen -l lib_path'. Try with -h for help.
            echo Use '-il' or '--ignore-lib' to ignore lib import.%NC%
            set ignore_lib=y
        )
    )
    goto:EOF

:generate_csfml
    call :add_gitignore
    call :header_file
    call :import_lib
    echo     #include ^<SFML/Graphics.h^>>> %TMPDIR%/src/%LO_NAME%.h
    echo     #include ^<SFML/System.h^>>> %TMPDIR%/src/%LO_NAME%.h
    echo     #include ^<SFML/Window.h^>>> %TMPDIR%/src/%LO_NAME%.h
    echo     #include ^<SFML/Audio.h^>>> %TMPDIR%/src/%LO_NAME%.h
    echo     #include ^<stdlib.h^>>> %TMPDIR%/src/%LO_NAME%.h
    echo     #include ^<SFML/System/Time.h^>>> %TMPDIR%/src/%LO_NAME%.h
    echo     #include ^<unistd.h^>>> %TMPDIR%/src/%LO_NAME%.h
    echo     #include ^<time.h^>>> %TMPDIR%/src/%LO_NAME%.h
    echo. >> %TMPDIR%/src/%LO_NAME%.h
    echo sfIntRect create_rect^(int height, int width, int top, int left^);>> %TMPDIR%/src/%LO_NAME%.h
    echo sfVector2f create_vector2f^(float x, float y^);>> %TMPDIR%/src/%LO_NAME%.h
    call :close_header_file
    call :makefile_header
    if "%ignore_lib%"=="" (
        type %CURPATH%\templates\csfml\makefile_template >> %TMPDIR%/Makefile
    ) else (
        type %CURPATH%\templates\csfml\makefile_template_wthout_lib >> %TMPDIR%/Makefile
    )
    echo /*> %TMPDIR%/src/csfml_tools.c
    echo ** EPITECH PROJECT, 2022>> %TMPDIR%/src/csfml_tools.c
    echo ** %STATIC_NAME%>> %TMPDIR%/src/csfml_tools.c
    echo ** File description:>> %TMPDIR%/src/csfml_tools.c
    echo ** CSFML tools>> %TMPDIR%/src/csfml_tools.c
    echo */>> %TMPDIR%/src/csfml_tools.c
    echo.>> %TMPDIR%/src/csfml_tools.c
    echo #include "%LO_NAME%.h">> %TMPDIR%/src/csfml_tools.c
    echo.>> %TMPDIR%/src/csfml_tools.c
    type %CURPATH%\templates\csfml\csfml_tools >> %TMPDIR%/src/csfml_tools.c
    call :main_file
    mkdir %TMPDIR%/sounds
    mkdir %TMPDIR%/musics
    mkdir %TMPDIR%/fonts
    mkdir %TMPDIR%/img
    goto clean_exit

:generate_basic
    call :add_gitignore
    call :import_lib
    call :makefile_header
    echo %CURPATH%/templates/basic/makefile_template
    if "%ignore_lib%"=="" (
        type %CURPATH%\templates\basic\makefile_template >> %TMPDIR%/Makefile
    ) else (
        type %CURPATH%\templates\basic\makefile_template_wthout_lib >> %TMPDIR%/Makefile
    )
    call :header_file
    call :close_header_file
    call :main_file
    goto clean_exit

:generate_python
    echo #!/bin/python> %TMPDIR%/%LO_NAME%
    echo.>> %TMPDIR%/%LO_NAME%
    echo.>> %TMPDIR%/%LO_NAME%
    goto clean_exit

:define_project
    if "%csfml_project%"=="y" goto generate_csfml
    if "%python_project%"=="y" goto generate_python
    goto generate_basic

:clean_exit
    @robocopy %TMPDIR% %cd% /E
    rd /s /q "C:\temp\Epigen"
